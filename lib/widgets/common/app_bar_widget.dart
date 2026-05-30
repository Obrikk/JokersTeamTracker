import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/theme_provider.dart';

import '../../providers/user/auth_provider.dart';
import '../../models/user/profiles_model.dart';

class AppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  final UserProfile? profil;

  const AppBarWidget({super.key, required this.profil});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      automaticallyImplyLeading: true,
      title: Text(
        "Dashboard | ${profil?.nom ?? 'rien'} ${profil?.prenom ?? 'du tout'} ",
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      actions: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
          child: Row(
            children: [
              IconButton(
                onPressed: () => ref.read(themeProvider.notifier).toggle(),
                icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              ),
              const SizedBox(width: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Déconnexion'),
                      content: const Text(
                        'Es-tu sûr de vouloir te déconnecter ?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: const Text('Annuler'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: const Text('Déconnexion'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await ref.read(authProvider.notifier).logout();
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'Se déconnecter',
                  style: TextStyle(color: Colors.red),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.all(14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
