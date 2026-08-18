import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../helpers/providers/audio_provider.dart';
import '../helpers/providers/theme_provider.dart';
import '../screens/player_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  static const String _websiteUrl = 'https://radioactivatx.org';
  static const String _privacyUrl = 'https://freepi.io';
  static const String _shareText =
      'Escucha Radioactiva Tx desde la app Radio Freepi.\n'
      'https://radioactivatx.org';

  @override
  Widget build(BuildContext context) {
    final audioProvider = context.watch<AudioProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final station = audioProvider.currentStation;

    return Drawer(
      width: MediaQuery.sizeOf(context).width * 0.84,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(34),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            _DrawerHeader(
              stationName: station?.name ?? 'Radioactiva Tx',
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 12),
                children: [
                  const _SectionLabel('AJUSTES'),
                  _DrawerBox(
                    children: [
                      SwitchListTile(
                        secondary: const _DrawerIcon(
                          icon: Icons.dark_mode_rounded,
                          color: Colors.deepPurple,
                        ),
                        title: const Text(
                          'Modo oscuro',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        value: themeProvider.isDarkMode,
                        onChanged: themeProvider.setDarkMode,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('CONTENIDO'),
                  _DrawerBox(
                    children: [
                      _DrawerTile(
                        icon: Icons.radio_rounded,
                        color: Colors.redAccent,
                        title: 'Escúchanos en',
                        enabled: station != null,
                        onTap: station == null
                            ? null
                            : () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const PlayerScreen(),
                                  ),
                                );
                              },
                      ),
                      const Divider(height: 1, indent: 72),
                      _DrawerTile(
                        icon: Icons.share_rounded,
                        color: Colors.pinkAccent,
                        title: 'Comparte con un amigo',
                        onTap: () async {
                          Navigator.of(context).pop();
                          await SharePlus.instance.share(
                            ShareParams(text: _shareText),
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 72),
                      _DrawerTile(
                        icon: Icons.star_rounded,
                        color: Colors.amber,
                        title: '¡Califica nuestra app!',
                        onTap: () {
                          _openUrl(
                            context,
                            'https://play.google.com/store/apps/details?id=com.radioactivatx.radio',
                          );
                        },
                      ),
                      const Divider(height: 1, indent: 72),
                      _DrawerTile(
                        icon: Icons.language_rounded,
                        color: Colors.teal,
                        title: 'Sitio oficial',
                        onTap: () {
                          _openUrl(context, _websiteUrl);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const _SectionLabel('NOSOTROS'),
                  _DrawerBox(
                    children: [
                      _DrawerTile(
                        icon: Icons.groups_rounded,
                        color: Colors.lightBlue,
                        title: 'Nuestra Misión',
                        onTap: () {
                          Navigator.of(context).pop();
                          _showMission(context);
                        },
                      ),
                      const Divider(height: 1, indent: 72),
                      _DrawerTile(
                        icon: Icons.description_rounded,
                        color: Colors.indigoAccent,
                        title: 'Política de Privacidad',
                        onTap: () {
                          _openUrl(context, _privacyUrl);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const _VersionLabel(),
          ],
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    required this.stationName,
  });

  final String stationName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/banner_radioactiva.png',
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(42),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.58),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            const Icon(
              Icons.radio_rounded,
              color: Color(0xFFFFD500),
              size: 52,
            ),
            const SizedBox(height: 10),
            Text(
              stationName,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 14,
        bottom: 10,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w800,
          color: Theme.of(context)
              .colorScheme
              .onSurface
              .withValues(alpha: 0.52),
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _DrawerBox extends StatelessWidget {
  const _DrawerBox({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(27),
        border: Border.all(
          color: Theme.of(context)
              .dividerColor
              .withValues(alpha: 0.28),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.color,
    required this.title,
    this.onTap,
    this.enabled = true,
  });

  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback? onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 2,
      ),
      leading: _DrawerIcon(
        icon: icon,
        color: color,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
      ),
      enabled: enabled,
      onTap: enabled ? onTap : null,
    );
  }
}

class _DrawerIcon extends StatelessWidget {
  const _DrawerIcon({
    required this.icon,
    required this.color,
  });

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(16),
      ),
      alignment: Alignment.center,
      child: Icon(
        icon,
        color: color,
      ),
    );
  }
}

class _VersionLabel extends StatelessWidget {
  const _VersionLabel();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.data?.version ?? '1.0.0';
        final buildNumber = snapshot.data?.buildNumber ?? '1';

        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 18),
          child: Text(
            'Versión $version ($buildNumber)',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.48),
            ),
          ),
        );
      },
    );
  }
}

void _showMission(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.groups_rounded,
                size: 52,
                color: Colors.lightBlue,
              ),
              const SizedBox(height: 14),
              Text(
                'Nuestra Misión',
                style: Theme.of(sheetContext)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Conectar a la audiencia con contenidos musicales, '
                'culturales y de entretenimiento de calidad, fortaleciendo '
                'la identidad y la comunidad de Radioactiva Tx.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                },
                child: const Text('Cerrar'),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _openUrl(
  BuildContext context,
  String url,
) async {
  Navigator.of(context).maybePop();

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
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ocurrió un error al abrir el enlace.'),
        ),
      );
    }
  }
}
