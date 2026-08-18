import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

import '../../models/station_model.dart';

class AudioProvider extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  StationModel? _currentStation;

  bool _isChangingStation = false;
  String? _errorMessage;

  int _playRequestId = 0;

  StationModel? get currentStation => _currentStation;

  String? get errorMessage => _errorMessage;

  ProcessingState get processingState => _player.processingState;

  bool get isLoading {
    return _isChangingStation ||
        processingState == ProcessingState.loading ||
        processingState == ProcessingState.buffering;
  }

  bool get isPlaying {
    return _player.playing &&
        processingState != ProcessingState.completed;
  }

  bool get isPaused {
    return _currentStation != null &&
        !isPlaying &&
        !isLoading;
  }

  bool isCurrentStation(StationModel station) {
    return _currentStation?.id == station.id;
  }

  String get displayTitle {
    final sequenceState = _player.sequenceState;
    final tag = sequenceState.currentSource?.tag;

    if (tag is MediaItem && tag.title.trim().isNotEmpty) {
      return tag.title;
    }

    return _currentStation?.name ?? 'Radio Freepi';
  }

  String get displayArtist {
    final sequenceState = _player.sequenceState;
    final tag = sequenceState.currentSource?.tag;

    if (tag is MediaItem &&
        tag.artist != null &&
        tag.artist!.trim().isNotEmpty) {
      return tag.artist!;
    }

    return _currentStation?.slogan ?? 'Radio en vivo';
  }

  AudioProvider() {
    _player.playerStateStream.listen(
      (playerState) {
        notifyListeners();
      },
      onError: (Object error, StackTrace stackTrace) {
        _setPlaybackError('Error durante la reproducción.');
      },
    );

    _player.sequenceStateStream.listen(
      (sequenceState) {
        notifyListeners();
      },
      onError: (Object error, StackTrace stackTrace) {
        _setPlaybackError(
          'No fue posible obtener la información de la estación.',
        );
      },
    );

    _player.playbackEventStream.listen(
      (event) {
        notifyListeners();
      },
      onError: (Object error, StackTrace stackTrace) {
        _setPlaybackError('Error durante la reproducción.');
      },
    );
  }

  Future<void> playStation(StationModel station) async {
    if (isCurrentStation(station)) {
      if (isLoading) {
        return;
      }

      await togglePlayPause();
      return;
    }

    final requestId = ++_playRequestId;

    try {
      _errorMessage = null;
      _isChangingStation = true;
      _currentStation = station;

      notifyListeners();

      await _player.stop();

      if (requestId != _playRequestId) {
        return;
      }

      final audioSource = AudioSource.uri(
        Uri.parse(station.streamUrl),
        tag: MediaItem(
          id: station.id,
          title: station.name,
          artist: station.slogan,
          artUri: Uri.tryParse(station.imageUrl),
          album: 'Radio Freepi',
        ),
      );

      await _player.setAudioSource(audioSource);

      if (requestId != _playRequestId) {
        return;
      }

      _isChangingStation = false;
      notifyListeners();

      _startPlayback();
    } catch (error) {
      if (requestId == _playRequestId) {
        _errorMessage =
            'No fue posible reproducir la estación.';
      }
    } finally {
      if (requestId == _playRequestId) {
        _isChangingStation = false;
        notifyListeners();
      }
    }
  }

  Future<void> togglePlayPause() async {
    if (_currentStation == null || isLoading) {
      return;
    }

    try {
      _errorMessage = null;

      if (_player.playing) {
        await _player.pause();
      } else {
        if (processingState == ProcessingState.completed) {
          await _player.seek(Duration.zero);
        }

        _startPlayback();
      }
    } catch (error) {
      _errorMessage =
          'No fue posible cambiar la reproducción.';
    } finally {
      notifyListeners();
    }
  }

  Future<void> stop() async {
    try {
      _errorMessage = null;

      ++_playRequestId;
      _isChangingStation = false;

      await _player.stop();
    } catch (error) {
      _errorMessage =
          'No fue posible detener la reproducción.';
    } finally {
      notifyListeners();
    }
  }

  Future<void> playNextStation(
    List<StationModel> stations,
  ) async {
    if (stations.isEmpty || isLoading) {
      return;
    }

    if (_currentStation == null) {
      await playStation(stations.first);
      return;
    }

    final currentIndex = stations.indexWhere(
      (station) => station.id == _currentStation!.id,
    );

    if (currentIndex == -1) {
      await playStation(stations.first);
      return;
    }

    final nextIndex = (currentIndex + 1) % stations.length;

    await playStation(stations[nextIndex]);
  }

  Future<void> playPreviousStation(
    List<StationModel> stations,
  ) async {
    if (stations.isEmpty || isLoading) {
      return;
    }

    if (_currentStation == null) {
      await playStation(stations.first);
      return;
    }

    final currentIndex = stations.indexWhere(
      (station) => station.id == _currentStation!.id,
    );

    if (currentIndex == -1) {
      await playStation(stations.first);
      return;
    }

    final previousIndex =
        (currentIndex - 1 + stations.length) %
            stations.length;

    await playStation(stations[previousIndex]);
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _startPlayback() {
    unawaited(
      _player.play().catchError(
        (Object error, StackTrace stackTrace) {
          _setPlaybackError(
            'No fue posible iniciar la reproducción.',
          );
        },
      ),
    );

    notifyListeners();
  }

  void _setPlaybackError(String message) {
    _isChangingStation = false;
    _errorMessage = message;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_player.dispose());
    super.dispose();
  }
}