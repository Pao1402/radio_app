import 'all_programs_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';


import '../data/mock_data.dart';
import '../data/programs_data.dart' as programs_data;
import '../helpers/providers/audio_provider.dart';
import '../models/program_model.dart';
import '../models/station_model.dart';
import '../widgets/app_drawer.dart';
import 'player_screen.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color _yellow = Color(0xFFFFD500);

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioProvider>(
      builder: (context, audioProvider, child) {
        return Scaffold(
          drawer: const AppDrawer(),
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 28),
                    children: [
                      const SizedBox(height: 14),
                      const _RadioBanner(),
                      const SizedBox(height: 38),
                      const _TwoColorTitle(
                        first: 'Nuestras ',
                        second: 'Estaciones',
                      ),
                      const SizedBox(height: 18),
                      _StationsCarousel(audioProvider: audioProvider),
                      if (audioProvider.errorMessage != null) ...[
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: _ErrorMessage(
                            message: audioProvider.errorMessage!,
                          ),
                        ),
                      ],
                      const SizedBox(height: 38),
                 _ProgramsHeader(
  onViewAll: () {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'La pantalla de todos los programas será la siguiente etapa.',
        ),
      ),
    );
  },
),
                      const SizedBox(height: 18),
                      _ProgramsCarousel(
                        programs: programs_data.programs,
                      ),
                      const SizedBox(height: 42),
                      const _SocialTitle(),
                      const SizedBox(height: 24),
                      _SocialIcons(
                        station: audioProvider.currentStation ?? stations.first,
                      ),
                      const SizedBox(height: 26),
                    ],
                  ),
                ),
                if (audioProvider.currentStation != null)
                  _NowPlayingBar(audioProvider: audioProvider),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RadioBanner extends StatelessWidget {
  const _RadioBanner();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Builder(
        builder: (context) {
          return Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            elevation: 12,
            shadowColor: Colors.black.withValues(alpha: 0.25),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => Scaffold.of(context).openDrawer(),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AspectRatio(
                  aspectRatio: 4.05,
                  child: Image.asset(
                    'assets/images/banner_radioactiva.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: HomeScreen._yellow,
                        alignment: Alignment.center,
                        child: const Text(
                          'RTX',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 38,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TwoColorTitle extends StatelessWidget {
  const _TwoColorTitle({
    required this.first,
    required this.second,
  });

  final String first;
  final String second;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 31,
            height: 1.05,
            fontWeight: FontWeight.w800,
            color: onSurface,
          ),
          children: [
            TextSpan(text: first),
            TextSpan(
              text: second,
              style: const TextStyle(color: HomeScreen._yellow),
            ),
          ],
        ),
      ),
    );
  }
}

class _StationsCarousel extends StatefulWidget {
  const _StationsCarousel({required this.audioProvider});

  final AudioProvider audioProvider;

  @override
  State<_StationsCarousel> createState() => _StationsCarouselState();
}

class _StationsCarouselState extends State<_StationsCarousel> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.80);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 360,
          child: PageView.builder(
            controller: _controller,
            itemCount: stations.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return AnimatedPadding(
                duration: const Duration(milliseconds: 220),
                padding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: _currentPage == index ? 0 : 22,
                ),
                child: _StationPosterCard(
                  station: stations[index],
                  audioProvider: widget.audioProvider,
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            stations.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? HomeScreen._yellow
                    : Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.28),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _StationPosterCard extends StatelessWidget {
  const _StationPosterCard({
    required this.station,
    required this.audioProvider,
  });

  final StationModel station;
  final AudioProvider audioProvider;

  @override
  Widget build(BuildContext context) {
    final isCurrent = audioProvider.isCurrentStation(station);
    final isPlaying = isCurrent && audioProvider.isPlaying;
    final isLoading = isCurrent && audioProvider.isLoading;

    return Material(
      elevation: 12,
      shadowColor: Colors.black.withValues(alpha: 0.25),
      color: Colors.black,
      borderRadius: BorderRadius.circular(34),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => audioProvider.playStation(station),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: station.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => Center(
                child: Text(
                  station.acronym,
                  style: const TextStyle(
                    color: HomeScreen._yellow,
                    fontSize: 54,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0x33000000),
                    Color(0xEE000000),
                  ],
                  stops: [0.25, 0.55, 1],
                ),
              ),
            ),
            Positioned(
              left: 28,
              right: 24,
              bottom: 28,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          station.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 9),
                        Text(
                          station.slogan,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  SizedBox(
                    width: 68,
                    height: 68,
                    child: isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(18),
                            child: CircularProgressIndicator(
                              color: HomeScreen._yellow,
                              strokeWidth: 3,
                            ),
                          )
                        : IconButton(
                            tooltip: isPlaying ? 'Pausar' : 'Reproducir',
                            onPressed: () => audioProvider.playStation(station),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.black54,
                              foregroundColor: HomeScreen._yellow,
                              side: const BorderSide(
                                color: HomeScreen._yellow,
                                width: 2,
                              ),
                            ),
                            icon: Icon(
                              isPlaying
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 38,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgramsHeader extends StatelessWidget {
  const _ProgramsHeader({required this.onViewAll});

  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Expanded(
            child: _TwoToneInlineTitle(),
          ),
          TextButton(
            onPressed: () {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const AllProgramsScreen(),
    ),
  );
},
            
            child: const Text(
              'Ver Todos',
              style: TextStyle(
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _TwoToneInlineTitle extends StatelessWidget {
  const _TwoToneInlineTitle();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 29,
          height: 1.05,
          fontWeight: FontWeight.w800,
        ),
        children: const [
          TextSpan(text: 'Nuestros '),
          TextSpan(
            text: 'Programas',
            style: TextStyle(color: HomeScreen._yellow),
          ),
        ],
      ),
    );
  }
}

class _ProgramsCarousel extends StatefulWidget {
  const _ProgramsCarousel({required this.programs});

  final List<ProgramModel> programs;

  @override
  State<_ProgramsCarousel> createState() => _ProgramsCarouselState();
}

class _ProgramsCarouselState extends State<_ProgramsCarousel> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 0.88);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 420,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.programs.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              final program = widget.programs[index];

              return AnimatedPadding(
                duration: const Duration(milliseconds: 220),
                padding: EdgeInsets.fromLTRB(
                  7,
                  _currentPage == index ? 0 : 18,
                  7,
                  _currentPage == index ? 0 : 18,
                ),
                child: _ProgramPoster(program: program),
              );
            },
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.programs.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 22 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? HomeScreen._yellow
                    : Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProgramPoster extends StatelessWidget {
  const _ProgramPoster({required this.program});

  final ProgramModel program;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.22),
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: program.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => const Center(
              child: CircularProgressIndicator(),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.black,
              alignment: Alignment.center,
              child: const Icon(
                Icons.mic_external_on_rounded,
                color: HomeScreen._yellow,
                size: 72,
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color(0x11000000),
                  Color(0xDD000000),
                ],
                stops: [0.35, 0.55, 1],
              ),
            ),
          ),
          Positioned(
            left: 26,
            right: 26,
            bottom: 26,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  program.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    height: 1.05,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      color: Colors.white70,
                      size: 23,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        program.schedule,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 17,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialTitle extends StatelessWidget {
  const _SocialTitle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 29,
            fontWeight: FontWeight.w800,
          ),
          children: const [
            TextSpan(text: 'Síguenos por aquí '),
            TextSpan(
              text: 'también',
              style: TextStyle(color: HomeScreen._yellow),
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialIcons extends StatelessWidget {
  const _SocialIcons({required this.station});

  final StationModel station;

  @override
  Widget build(BuildContext context) {
    final items = <_SocialItem>[
      if (station.instagramUrl != null)
        _SocialItem(
          icon: Icons.camera_alt_rounded,
          colors: const [Color(0xFFF58529), Color(0xFFDD2A7B)],
          onTap: () => _openUrl(context, station.instagramUrl!),
        ),
      if (station.facebookUrl != null)
        _SocialItem(
          icon: Icons.facebook_rounded,
          colors: const [Color(0xFF1877F2), Color(0xFF6AA8FF)],
          onTap: () => _openUrl(context, station.facebookUrl!),
        ),
      _SocialItem(
        icon: Icons.close_rounded,
        colors: const [Colors.black, Color(0xFF151515)],
        onTap: () => _openUrl(context, 'https://x.com'),
      ),
      if (station.youtubeUrl != null)
        _SocialItem(
          icon: Icons.play_arrow_rounded,
          colors: const [Color(0xFFFF0000), Color(0xFFFF3030)],
          onTap: () => _openUrl(context, station.youtubeUrl!),
        ),
      _SocialItem(
        icon: Icons.music_note_rounded,
        colors: const [Color(0xFF13F2C0), Color(0xFFEC2A63)],
        onTap: () => _openUrl(context, 'https://www.tiktok.com'),
      ),
      _SocialItem(
        icon: Icons.phone_rounded,
        colors: const [Color(0xFF48C6EF), Color(0xFF1CA7D9)],
        onTap: () => _openUrl(context, 'tel:+520000000000'),
      ),
      if (station.websiteUrl != null)
        _SocialItem(
          icon: Icons.language_rounded,
          colors: const [Color(0xFFFF8A00), HomeScreen._yellow],
          onTap: () => _openUrl(context, station.websiteUrl!),
        ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42),
      child: Wrap(
        spacing: 22,
        runSpacing: 22,
        children: items
            .map((item) => _SocialSquare(item: item))
            .toList(growable: false),
      ),
    );
  }
}

class _SocialItem {
  const _SocialItem({
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;
}

class _SocialSquare extends StatelessWidget {
  const _SocialSquare({required this.item});

  final _SocialItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: item.onTap,
        child: Ink(
          width: 86,
          height: 76,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: item.colors),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: item.colors.first.withValues(alpha: 0.20),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Icon(
            item.icon,
            color: Colors.white,
            size: 34,
          ),
        ),
      ),
    );
  }
}

class _ErrorMessage extends StatelessWidget {
  const _ErrorMessage({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.redAccent.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.redAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}

class _NowPlayingBar extends StatelessWidget {
  const _NowPlayingBar({required this.audioProvider});

  final AudioProvider audioProvider;

  @override
  Widget build(BuildContext context) {
    final station = audioProvider.currentStation!;
    final colors = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.fromLTRB(18, 8, 18, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: HomeScreen._yellow.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.14),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            showPlayerBottomSheet(context);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    imageUrl: station.imageUrl,
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => Container(
                      width: 58,
                      height: 58,
                      color: Colors.black,
                      alignment: Alignment.center,
                      child: Text(
                        station.acronym,
                        style: const TextStyle(
                          color: HomeScreen._yellow,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'AHORA ESCUCHANDO',
                        style: TextStyle(
                          color: HomeScreen._yellow,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        audioProvider.displayTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        audioProvider.displayArtist,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colors.onSurface.withValues(alpha: 0.58),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
               IconButton.filled(
  tooltip: audioProvider.isPlaying ? 'Pausar' : 'Reproducir',
  onPressed: audioProvider.isLoading
      ? null
      : audioProvider.togglePlayPause,
  style: IconButton.styleFrom(
    backgroundColor: HomeScreen._yellow,
    foregroundColor: Colors.black,
  ),
  icon: audioProvider.isLoading
      ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.black,
          ),
        )
      : Icon(
          audioProvider.isPlaying
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
        ),
),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right_rounded),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> showPlayerBottomSheet(BuildContext context) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black54,
    builder: (_) {
      return FractionallySizedBox(
        heightFactor: 0.94,
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          child: const PlayerScreen(),
        ),
      );
    },
  );
}

Future<void> _openUrl(BuildContext context, String url) async {
  try {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No fue posible abrir el enlace.')),
      );
    }
  } catch (error) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ocurrió un error al abrir el enlace.')),
      );
    }
  }
}
