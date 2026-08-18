import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../models/program_model.dart';

class ProgramsCarousel extends StatelessWidget {
  const ProgramsCarousel({
    super.key,
    required this.programs,
  });

  final List<ProgramModel> programs;

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: programs.length,
      itemBuilder: (context, index, realIndex) {
        final program = programs[index];

        return _ProgramCard(
          program: program,
        );
      },
      options: CarouselOptions(
        height: 250,
        viewportFraction: 0.88,
        enlargeCenterPage: true,
        enableInfiniteScroll: programs.length > 1,
        autoPlay: programs.length > 1,
        autoPlayInterval: const Duration(seconds: 5),
      ),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  const _ProgramCard({
    required this.program,
  });

  final ProgramModel program;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showProgramDetails(
          context,
          program,
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: program.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return Container(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.radio_rounded,
                    size: 60,
                  ),
                );
              },
            ),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black87,
                  ],
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.schedule_rounded,
                        size: 17,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          program.schedule,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white70,
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
      ),
    );
  }
}

Future<void> _showProgramDetails(
  BuildContext context,
  ProgramModel program,
) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: program.imageUrl,
                width: double.infinity,
                height: 190,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return const SizedBox(
                    height: 190,
                    child: Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Container(
                    width: double.infinity,
                    height: 190,
                    alignment: Alignment.center,
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    child: const Icon(
                      Icons.radio_rounded,
                      size: 64,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  8,
                ),
                child: Text(
                  program.title,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      size: 19,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        program.schedule,
                      ),
                    ),
                  ],
                ),
              ),
              if (program.host != null) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.mic_rounded,
                        size: 19,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Conduce: ${program.host}',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Text(
                  program.description,
                  style: const TextStyle(
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    },
  );
}