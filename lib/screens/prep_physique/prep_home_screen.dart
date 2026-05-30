import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jokers_team_tracker/providers/user/auth_provider.dart';
import 'package:jokers_team_tracker/screens/prep_physique/equipe/liste_joueur.dart';

import '../../widgets/common/app_bar_widget.dart';
import 'mesures/wellness/wellness_consult_screen.dart';
import 'mesures/wellness/wellness_fill_rate.dart';
import 'mesures/rpe/rpe_consult_screen.dart';
import 'mesures/rpe/rpe_fill_rate.dart';
import 'mesures/grip/grip_consult_screen.dart';
import 'mesures/grip/grip_fill_rate.dart';
import 'mesures/poids/poids_consult_screen.dart';
import 'mesures/poids/poids_fill_rate.dart';

class PrepDashboardScreen extends ConsumerStatefulWidget {
  const PrepDashboardScreen({super.key});

  @override
  ConsumerState<PrepDashboardScreen> createState() =>
      _PrepDashboardScreenState();
}

class _PrepDashboardScreenState extends ConsumerState<PrepDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final profile = authState.profile;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(profil: profile, page: 'Dashboard'),
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(32),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth >= 800;

              final pairs = [
                [WellnessConsult(), WellnessFillRate()],
                [RpeConsult(), RpeFillRate()],
                [PoidsConsult(), PoidsFillRate()],
                [GripConsult(), GripFillRate()],
              ];

              return Column(
                children: [
                  ...pairs.map((pair) {
                    if (isDesktop) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 48),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(child: pair[0]),
                              const SizedBox(width: 32),
                              Expanded(child: pair[1]),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return Column(
                        children: [
                          pair[0],
                          const SizedBox(height: 32),
                          pair[1],
                          const SizedBox(height: 24),
                          const Divider(
                            color: Colors.grey,
                            thickness: 2,
                            height: 20,
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    }
                  }),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ListeJoueur(),
                          ),
                        );
                      },
                      child: Text('Liste des Joueurs'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
