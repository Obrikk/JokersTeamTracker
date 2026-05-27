import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jokers_team_tracker/providers/user/auth_provider.dart';

import '../../widgets/common/app_bar_widget.dart';
import './mesures/wellness_consult_screen.dart';
import './mesures/rpe_consult_screen.dart';
import './mesures/grip_consult_screen.dart';
import './mesures/poids_consult_screen.dart';

class CoachDashboardScreen extends ConsumerStatefulWidget {
  const CoachDashboardScreen({super.key});

  @override
  ConsumerState<CoachDashboardScreen> createState() =>
      _CoachDashboardScreenState();
}

class _CoachDashboardScreenState extends ConsumerState<CoachDashboardScreen> {
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
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              WellnessConsult(),
              const SizedBox(height: 32),
              RpeConsult(),
              const SizedBox(height: 32),
              PoidsConsult(),
              const SizedBox(height: 32),
              GripConsult(),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text('Liste des Joueurs'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
