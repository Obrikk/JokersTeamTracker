import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/user/auth_provider.dart';

import '../../services/user/joueur_service.dart';
import '../../services/mesures/wellness_service.dart';
import '../../models/mesures/wellness_model.dart';

import '../../widgets/common/app_bar_widget.dart';

import '../../core/constants/supabase_constants.dart';

class JoueurDashboardScreen extends ConsumerStatefulWidget {
  const JoueurDashboardScreen({super.key});

  @override
  ConsumerState<JoueurDashboardScreen> createState() =>
      _JoueurDashboardScreenState();
}

class _JoueurDashboardScreenState extends ConsumerState<JoueurDashboardScreen> {
  final WellnessService _wellnessService = WellnessService();
  final JoueurService _joueurService = JoueurService();
  late Future<WellnessModel?> _wellnessFuture;

  final userId = supabase.auth.currentUser!.id;

  @override
  void initState() {
    super.initState();
    _wellnessFuture = _loadWellness();
  }

  Future<WellnessModel?> _loadWellness() async {
    final joueurId = await _joueurService.getPlayerId(userId);
    final wellness = await _wellnessService.getTodayWellness(joueurId);

    return wellness;
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
          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Carte Planing
              SizedBox(
                width: double.infinity,
                child: Card.filled(
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Planning :',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Text("Bouton"),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Carte Wellness
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Wellness :',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          Text(
                            'Etat de forme | 0 - 5',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.nights_stay),
                          Icon(Icons.mood),
                          Icon(Icons.battery_charging_full),
                          Icon(Icons.accessible),
                          Icon(Icons.cached),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _buildWellnessSection(),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/wellness-form');
                        },
                        child: const Text('Remplir mon wellness'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Carte RPE
              SizedBox(
                width: double.infinity,
                child: Card.filled(
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'RPE :',
                              style: Theme.of(context).textTheme.displayLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Indicateur de difficulté : 1 - 10',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'RPE Musculaire',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '7/10',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  'RPE Cardio',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                                Text(
                                  '6/10',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Text("Bouton"),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
              // Double Carte
              SizedBox(
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Carte Poids
                    Expanded(
                      child: Card.filled(
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Poids :',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.displayLarge,
                                  ),
                                  Text(
                                    'Poids du jour',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              const Text("Bouton"),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Carte Poids
                    Expanded(
                      child: Card.filled(
                        color: Theme.of(context).colorScheme.surface,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Grip :',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.displayLarge,
                                  ),
                                  Text(
                                    'Force du Grip',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 32),
                              const Text("Bouton"),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
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

  Widget _buildWellnessSection() {
    return FutureBuilder<WellnessModel?>(
      future: _wellnessFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Erreur : ${snapshot.error}');
        }

        final wellness = snapshot.data;
        if (wellness == null) {
          return _buildNoWellnessCard();
        }

        return _buildWellnessCard(wellness);
      },
    );
  }

  Widget _buildWellnessCard(WellnessModel wellness) {
    final selections = [
      wellness.sommeil,
      wellness.humeur,
      wellness.humeur,
      wellness.courbatures,
      wellness.stress,
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        int? value = selections[index];
        Color squareColor = _getGradientColor(value);
        return Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: squareColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNoWellnessCard() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (index) {
        Color squareColor = Color(0xFFA9A9A9);

        return Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
            color: squareColor,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(
            child: Text(
              '?',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      }),
    );
  }

  Color _getGradientColor(int index) {
    const colors = [
      Color(0xFFB71C1C), // rouge foncé
      Color(0xFFC65911), // orange-rouge foncé
      Color(0xFFF57F17), // orange foncé
      Color(0xFFA08C00), // orange-jaune foncé
      Color(0xFF558B2F), // vert-jaune foncé
      Color(0xFF1B5E20), // vert foncé
    ];
    return colors[index];
  }
}
