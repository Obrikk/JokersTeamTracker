import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jokers_team_tracker/screens/joueur/profil/joueur_profil_screen.dart';

import '../../core/constants/supabase_constants.dart';
import '../../providers/theme_provider.dart';

import '../../models/user/profiles_model.dart';

class AppBarWidget extends ConsumerWidget implements PreferredSizeWidget {
  final String page;
  final UserProfile? profil;

  const AppBarWidget({super.key, required this.profil, required this.page});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = supabase.auth.currentUser;
    final String id = user!.id;
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    final bool isProfilPage = page == 'Profil';

    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      automaticallyImplyLeading: true,
      title: Text(
        "$page | ${profil?.nom ?? 'rien'} ${profil?.prenom ?? 'du tout'} ",
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
              IconButton(
                onPressed: isProfilPage
                    ? null
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                JoueurProfilScreen(joueurId: id),
                          ),
                        );
                      },
                icon: Icon(
                  Icons.person,
                  color: isProfilPage ? Theme.of(context).disabledColor : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
