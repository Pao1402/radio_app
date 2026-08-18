import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../data/programs_data.dart' as programs_data;
import '../models/program_model.dart';
import 'program_detail_screen.dart';

class AllProgramsScreen extends StatelessWidget {
  const AllProgramsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final programs = programs_data.programs;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nuestros programas',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 28),
          itemCount: programs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.70,
          ),
          itemBuilder: (context, index) {
            return _ProgramGridCard(program: programs[index]);
          },
        ),
      ),
    );
  }
}

class _ProgramGridCard extends StatelessWidget {
  const _ProgramGridCard({required this.program});

  final ProgramModel program;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ProgramDetailScreen(program: program),
            ),
          );
        },
        child: Ink(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.14),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Hero(
                  tag: 'program-image-${program.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(22),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: program.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: colorScheme.surfaceContainerHighest,
                        alignment: Alignment.center,
                        child: const Icon(Icons.radio_rounded, size: 42),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      program.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            program.schedule,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall,
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
      ),
    );
  }
}
