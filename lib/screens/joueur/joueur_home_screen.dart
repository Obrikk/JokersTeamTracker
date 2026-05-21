import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/colors.dart';

import '../../providers/user/auth_provider.dart';

import '../../widgets/common/app_bar_widget.dart';

class JoueurDashboardScreen extends ConsumerStatefulWidget {
  const JoueurDashboardScreen({super.key});

  @override
  ConsumerState<JoueurDashboardScreen> createState() =>
      _JoueurDashboardScreenState();
}

class _JoueurDashboardScreenState extends ConsumerState<JoueurDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final profile = authState.profile;

    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBarWidget(profil: profile),
      body: SafeArea(
        top: true,
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
                        'Dashboard Joueur',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.green,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 32),
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
