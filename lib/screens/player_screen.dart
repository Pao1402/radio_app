import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/mock_data.dart';
import '../helpers/providers/audio_provider.dart';
import '../models/station_model.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        final station = audioProvider.currentStation;

        if (station == null) {
          return Scaffold(
            backgroundColor: Theme.of(context).colorScheme.surface,
            body: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      tooltip: 'Cerrar',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No hay ninguna estación reproduciéndose.',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFF080808)
              : const Color(0xFFF8F8F6),
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: _PlayerHero(
                    station: station,
                    audioProvider: audioProvider,
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 26, 22, 12),
                  sliver: SliverToBoxAdapter(
                    child: _StationDetails(
                      station: station,
                      audioProvider: audioProvider,
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(22, 14, 22, 28),
                  sliver: SliverToBoxAdapter(
                    child: _SocialSection(station: station),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlayerHero extends StatelessWidget {
  const _PlayerHero({
    required this.station,
    required this.audioProvider,
  });

  final StationModel station;
  final AudioProvider audioProvider;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD523),
            Color(0xFFFFB800),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Volver',
                onPressed: () => Navigator.of(context).pop(),
                style: IconButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.black.withValues(alpha: 0.08),
                ),
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 9,
                      color: Color(0xFFFF3B4F),
                    ),
                    SizedBox(width: 7),
                    Text(
                      'EN VIVO',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Hero(
            tag: 'station-image-${station.id}',
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 360),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.28),
                    blurRadius: 26,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: AspectRatio(
                aspectRatio: 1,
                child: CachedNetworkImage(
                  imageUrl: station.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) {
                    return const ColoredBox(
                      color: Colors.black12,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return ColoredBox(
                      color: Colors.black,
                      child: Center(
                        child: Text(
                          station.acronym,
                          style: const TextStyle(
                            color: Color(0xFFFFD523),
                            fontSize: 54,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 26),
          Text(
            audioProvider.displayTitle,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 27,
              height: 1.12,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            audioProvider.displayArtist,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.black.withValues(alpha: 0.68),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 26),
          _PlaybackControls(audioProvider: audioProvider),
        ],
      ),
    );
  }
}

class _PlaybackControls extends StatelessWidget {
  const _PlaybackControls({required this.audioProvider});

  final AudioProvider audioProvider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _RoundControlButton(
          tooltip: 'Estación anterior',
          icon: Icons.skip_previous_rounded,
          size: 58,
          iconSize: 33,
          onPressed: audioProvider.isLoading
              ? null
              : () => audioProvider.playPreviousStation(stations),
        ),
        const SizedBox(width: 18),
        SizedBox(
          width: 84,
          height: 84,
          child: audioProvider.isLoading
              ? const Padding(
                  padding: EdgeInsets.all(23),
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 4,
                  ),
                )
              : IconButton.filled(
                  tooltip: audioProvider.isPlaying ? 'Pausar' : 'Reproducir',
                  onPressed: audioProvider.togglePlayPause,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: const Color(0xFFFFD523),
                  ),
                  icon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      audioProvider.isPlaying
                          ? Icons.pause_rounded
                          : Icons.play_arrow_rounded,
                      key: ValueKey(audioProvider.isPlaying),
                      size: 47,
                    ),
                  ),
                ),
        ),
        const SizedBox(width: 18),
        _RoundControlButton(
          tooltip: 'Siguiente estación',
          icon: Icons.skip_next_rounded,
          size: 58,
          iconSize: 33,
          onPressed: audioProvider.isLoading
              ? null
              : () => audioProvider.playNextStation(stations),
        ),
      ],
    );
  }
}

class _RoundControlButton extends StatelessWidget {
  const _RoundControlButton({
    required this.tooltip,
    required this.icon,
    required this.size,
    required this.iconSize,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final double size;
  final double iconSize;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: Colors.black.withValues(alpha: 0.10),
          foregroundColor: Colors.black,
          disabledForegroundColor: Colors.black38,
        ),
        icon: Icon(icon, size: iconSize),
      ),
    );
  }
}

class _StationDetails extends StatelessWidget {
  const _StationDetails({
    required this.station,
    required this.audioProvider,
  });

  final StationModel station;
  final AudioProvider audioProvider;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colors.outline.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD523),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.radio_rounded,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      station.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      station.slogan,
                      style: TextStyle(
                        color: colors.onSurface.withValues(alpha: 0.62),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: audioProvider.stop,
                  icon: const Icon(Icons.stop_circle_outlined),
                  label: const Text('Detener'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _shareStation(context, station),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD523),
                    foregroundColor: Colors.black,
                  ),
                  icon: const Icon(Icons.share_rounded),
                  label: const Text('Compartir'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SocialSection extends StatelessWidget {
  const _SocialSection({required this.station});

  final StationModel station;

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      if (station.instagramUrl != null)
        _SocialTile(
          label: 'Instagram',
          icon: Icons.camera_alt_rounded,
          backgroundColor: const Color(0xFFE1306C),
          onPressed: () => _openUrl(context, station.instagramUrl!),
        ),
      if (station.facebookUrl != null)
        _SocialTile(
          label: 'Facebook',
          icon: Icons.facebook_rounded,
          backgroundColor: const Color(0xFF1877F2),
          onPressed: () => _openUrl(context, station.facebookUrl!),
        ),
      if (station.youtubeUrl != null)
        _SocialTile(
          label: 'YouTube',
          icon: Icons.ondemand_video_rounded,
          backgroundColor: const Color(0xFFFF0000),
          onPressed: () => _openUrl(context, station.youtubeUrl!),
        ),
      if (station.websiteUrl != null)
        _SocialTile(
          label: 'Web',
          icon: Icons.language_rounded,
          backgroundColor: const Color(0xFFFFA300),
          onPressed: () => _openUrl(context, station.websiteUrl!),
        ),
    ];

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              const TextSpan(text: 'Síguenos por aquí '),
              TextSpan(
                text: 'también',
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFFFFD523)
                      : const Color(0xFFE2B600),
                ),
              ),
            ],
          ),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.4,
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          children: items,
        ),
      ],
    );
  }
}

class _SocialTile extends StatelessWidget {
  const _SocialTile({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: 74,
          height: 68,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.24),
                blurRadius: 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 31,
          ),
        ),
      ),
    );
  }
}

Future<void> _shareStation(
  BuildContext context,
  StationModel station,
) async {
  final url = station.websiteUrl;

  if (url == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Esta estación no tiene un enlace para compartir.'),
      ),
    );
    return;
  }

  await _openUrl(context, url);
}

Future<void> _openUrl(
  BuildContext context,
  String url,
) async {
  try {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No fue posible abrir el enlace.'),
        ),
      );
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error al abrir el enlace.'),
        ),
      );
    }
  }
}
