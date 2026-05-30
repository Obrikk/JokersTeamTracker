import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/user/auth_provider.dart';

import '../../widgets/common/app_bar_widget.dart';
import './mesures/wellness_form_screen.dart';
import './mesures/rpe_form_screen.dart';
import './mesures/grip_form_screen.dart';
import './mesures/poids_form_screen.dart';

class JoueurDashboardScreen extends ConsumerStatefulWidget {
  const JoueurDashboardScreen({super.key});

  @override
  ConsumerState<JoueurDashboardScreen> createState() =>
      _JoueurDashboardScreenState();
}

class _JoueurDashboardScreenState extends ConsumerState<JoueurDashboardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final profile = authState.profile;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(profil: profile),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cartes Wellness TEST
              // ./mesures/wellness_form_screen.dart
              WellnessForm(),
              const SizedBox(height: 32),

              // Carte RPE Test
              RpeForm(),
              const SizedBox(height: 32),

              // Double Carte TEST
              // ./mesures/rpe_form_screen.dart
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Carte Poids
                    // ./mesures/poids_form_screen.dart
                    Expanded(child: PoidsForm()),

                    const SizedBox(width: 16),

                    // Carte Grip
                    // ./mesures/grip_form_screen.dart
                    Expanded(child: GripForm()),
                    const SizedBox(width: 16),
                  ],
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
