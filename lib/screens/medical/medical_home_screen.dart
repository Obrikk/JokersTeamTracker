import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jokers_team_tracker/providers/user/auth_provider.dart';
import '../../core/theme/colors.dart';

class MedicalDashboardScreen extends ConsumerStatefulWidget {
  const MedicalDashboardScreen({super.key});

  @override
  ConsumerState<MedicalDashboardScreen> createState() =>
      _MedicalDashboardScreenState();
}

class _MedicalDashboardScreenState
    extends ConsumerState<MedicalDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card.filled(
                color: Color(0XFF1A1A1A),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),
                      const Text(
                        'Dashboard Staff Médical',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.green,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 32),
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
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
