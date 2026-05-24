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
  int _wellnessTotal = 0;

  int _sommeil = 0;
  int _humeur = 0;
  int _energie = 0;
  int _courbatures = 0;
  int _stress = 0;

  @override
  void initState() {
    super.initState();
    _wellnessFuture = _loadWellness();
  }

  Future<WellnessModel?> _loadWellness() async {
    final joueurId = await _joueurService.getPlayerId(userId);
    final wellness = await _wellnessService.getTodayWellness(joueurId);

    if (wellness != null) {
      setState(() {
        _sommeil = wellness.sommeil;
        _humeur = wellness.humeur;
        _energie = wellness.energie;
        _courbatures = wellness.courbatures;
        _stress = wellness.stress;
        _wellnessTotal =
            wellness.sommeil +
            wellness.humeur +
            wellness.energie +
            wellness.courbatures +
            wellness.stress;
      });
    }

    return wellness;
  }

  Future<void> _saveWellness() async {
    final joueurId = await _joueurService.getPlayerId(userId);

    final model = WellnessModel(
      joueurId: joueurId,
      date: DateTime.now(),
      sommeil: _sommeil,
      humeur: _humeur,
      energie: _energie,
      courbatures: _courbatures,
      stress: _stress,
    );

    await _wellnessService.saveToday(model);
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

              // Carte Wellness 1
              Card(
                color: Theme.of(context).colorScheme.surface,

                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Wellness 1 :',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          Text(
                            'Etat de forme | 0 - 5',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      _buildWellnessSection1(),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: const Text('Remplir mon wellness'),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Carte Wellness 2
              Card(
                color: Theme.of(context).colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Wellness 2 :',
                            style: Theme.of(context).textTheme.displayLarge,
                          ),
                          Text(
                            'Etat de forme | 0 - 5',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),
                      _buildWellnessSection2(),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _saveWellness();
                            _wellnessFuture = _loadWellness();
                          },
                          child: const Text('Enregistrer Wellness'),
                        ),
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

  Widget _buildWellnessSection1() {
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
          return _buildNoWellnessCard1();
        }

        return _buildWellnessCard1(wellness, _wellnessTotal);
      },
    );
  }

  Widget _buildWellnessCard1(WellnessModel wellness, wellnessTotal) {
    final color = _getColor(_wellnessTotal * 4);

    final selections = [
      wellness.sommeil,
      wellness.humeur,
      wellness.energie,
      wellness.courbatures,
      wellness.stress,
    ];
    final iconSelection = [
      Icon(Icons.nights_stay),
      Icon(Icons.mood),
      Icon(Icons.bolt),
      Icon(Icons.fitness_center),
      Icon(Icons.cached),
    ];
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: wellnessTotal / 25,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                Center(
                  child: Text(
                    '${wellnessTotal * 4}%',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              int? value = selections[index];
              Color squareColor = _getGradientColor(value);
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  iconSelection[index],
                  const SizedBox(height: 8),
                  Container(
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
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildNoWellnessCard1() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 0 / 25,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
                Center(
                  child: Text(
                    '0%',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Row(
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
          ),
        ),
      ],
    );
  }

  Widget _buildWellnessSection2() {
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
          return _buildNoWellnessCard2();
        }

        return _buildWellnessCard2(wellness, _wellnessTotal);
      },
    );
  }

  Widget _buildWellnessCard2(WellnessModel wellness, wellnessTotal) {
    final color = _getColor(_wellnessTotal * 4);
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: wellnessTotal / 25,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
                Center(
                  child: Text(
                    '${wellnessTotal * 4}%',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              MetricRow(
                label: 'Sommeil',
                icon: Icons.nights_stay,
                initialValue: _sommeil,
                onChanged: (val) {
                  setState(() => _sommeil = val);
                },
              ),
              MetricRow(
                label: 'Humeur',
                icon: Icons.mood,
                initialValue: _humeur,
                onChanged: (val) {
                  setState(() => _humeur = val);
                },
              ),
              MetricRow(
                label: 'Énergie',
                icon: Icons.bolt,
                initialValue: wellness.energie,
                onChanged: (val) {
                  setState(() => _energie = val);
                },
              ),
              MetricRow(
                label: 'Courbatures',
                icon: Icons.fitness_center,
                initialValue: wellness.courbatures,
                onChanged: (val) {
                  setState(() => _courbatures = val);
                },
              ),
              MetricRow(
                label: 'Stress',
                icon: Icons.cached,
                initialValue: wellness.stress,
                onChanged: (val) {
                  setState(() => _stress = val);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNoWellnessCard2() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: 0 / 25,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                ),
                Center(
                  child: Text(
                    '0%',
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              _buildMetricRow('Sommeil', 0, Icons.nights_stay),
              _buildMetricRow('Humeur', 0, Icons.mood),
              _buildMetricRow('Énergie', 0, Icons.bolt),
              _buildMetricRow('Courbatures', 0, Icons.fitness_center),
              _buildMetricRow('Stress', 0, Icons.cached),

              MetricRow(
                label: 'Sommeil',
                icon: Icons.nights_stay,
                initialValue: _sommeil,
                onChanged: (val) => setState(() => _sommeil = val),
              ),
              MetricRow(
                label: 'Humeur',
                icon: Icons.mood,
                initialValue: _humeur,
                onChanged: (val) => setState(() => _humeur = val),
              ),
              MetricRow(
                label: 'Énergie',
                icon: Icons.bolt,
                initialValue: _energie,
                onChanged: (val) => setState(() => _energie = val),
              ),
              MetricRow(
                label: 'Courbatures',
                icon: Icons.fitness_center,
                initialValue: _courbatures,
                onChanged: (val) => setState(() => _courbatures = val),
              ),
              MetricRow(
                label: 'Stress',
                icon: Icons.cached,
                initialValue: _stress,
                onChanged: (val) => setState(() => _stress = val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricRow(String label, int value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          SizedBox(width: 100, child: Text(label)),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 5,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 8),
          Text('$value/5'),
        ],
      ),
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

  Color _getColor(double percentage) {
    if (percentage <= 40) return const Color(0xFFB71C1C);
    if (percentage <= 70) return const Color(0xFFF57F17);
    return const Color(0xFF1B5E20);
  }
}

class MetricRow extends StatefulWidget {
  final String label;
  final int initialValue;
  final IconData icon;
  final ValueChanged<int> onChanged;

  const MetricRow({
    super.key,
    required this.label,
    required this.initialValue,
    required this.icon,
    required this.onChanged,
  });

  @override
  State<MetricRow> createState() => _MetricRowState();
}

class _MetricRowState extends State<MetricRow> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _decrement() {
    if (_value > 0) {
      setState(() => _value--);
      widget.onChanged(_value);
    }
  }

  void _increment() {
    if (_value < 5) {
      setState(() => _value++);
      widget.onChanged(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(widget.icon, size: 20),
          const SizedBox(width: 8),
          SizedBox(width: 100, child: Text(widget.label)),
          Expanded(
            child: LinearProgressIndicator(
              value: _value / 5,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 16),
          Text('$_value/5'),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline),
            onPressed: _value > 0 ? _decrement : null,
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _value < 5 ? _increment : null,
            iconSize: 20,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
