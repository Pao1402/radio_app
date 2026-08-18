import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/program_model.dart';

class ProgramDetailScreen extends StatelessWidget {
  const ProgramDetailScreen({
    super.key,
    required this.program,
  });

  final ProgramModel program;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 360,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'program-image-${program.id}',
                child: CachedNetworkImage(
                  imageUrl: program.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: colorScheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: const Icon(Icons.radio_rounded, size: 72),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 36),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Text(
                    program.title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: Icons.schedule_rounded,
                    text: program.schedule,
                  ),
                 if (program.host != null &&
    program.host!.trim().isNotEmpty) ...[
  const SizedBox(height: 10),
  _InfoRow(
    icon: Icons.mic_rounded,
    text: 'Conduce: ${program.host}',
  ),
],
                  const SizedBox(height: 26),
                  Text(
                    'Acerca del programa',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    program.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.55,
                        ),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.live_tv_rounded,
                          color: colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Escúchalo en Radio Freepi durante su horario de transmisión.',
                            style: TextStyle(
                              color: colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 21, color: colorScheme.primary),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}
