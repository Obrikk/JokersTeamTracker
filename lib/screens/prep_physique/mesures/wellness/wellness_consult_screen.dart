import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'wellness_graphs_screen.dart';

import '../../../../services/mesures/wellness_service.dart';

class WellnessConsult extends ConsumerStatefulWidget {
  @override
  ConsumerState<WellnessConsult> createState() => _WellnessConsultState();

  const WellnessConsult({super.key});
}

class _WellnessConsultState extends ConsumerState<WellnessConsult> {
  final WellnessService _wellnessService = WellnessService();

  double _wellnessTotal = 0;

  double _sommeil = 0;
  double _humeur = 0;
  double _energie = 0;
  double _courbatures = 0;
  double _stress = 0;

  //Initialise les moyennes du wellness
  Future<Map<String, double>> _loadWellness() async {
    final wellness = await _wellnessService.getTodayWellnessAverages();

    setState(() {
      _sommeil = wellness['sommeil']!;
      _humeur = wellness['humeur']!;
      _energie = wellness['energie']!;
      _courbatures = wellness['courbatures']!;
      _stress = wellness['stress']!;
      _wellnessTotal =
          wellness['sommeil']! +
          wellness['humeur']! +
          wellness['energie']! +
          wellness['courbatures']! +
          wellness['stress']!;
    });
    return wellness;
  }

  @override
  void initState() {
    super.initState();
    _loadWellness();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(_wellnessTotal * 4);
    _wellnessTotal = double.parse(_wellnessTotal.toStringAsFixed(2));

    return Column(
      children: [
        SizedBox(
          child: Card(
            color: Theme.of(context).colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // En tête
                      Text(
                        'Wellness :',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                        'Moyennes du jour',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWellnessRow('Sommeil', _sommeil),
                        _buildWellnessRow('Humeur', _humeur),
                        _buildWellnessRow('Energie', _energie),
                        _buildWellnessRow('Courbatures', _courbatures),
                        _buildWellnessRow('Stress', _stress),
                        const Divider(
                          color: Colors.grey,
                          thickness: 1,
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total :',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            const SizedBox(width: 32),
                            Column(
                              children: [
                                Text(
                                  '$_wellnessTotal / 25',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SizedBox(
                          width: 80,
                          height: 80,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              // Cercle de Progression
                              CircularProgressIndicator(
                                value: _wellnessTotal / 20,
                                strokeWidth: 6,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  color,
                                ),
                              ),

                              // Pourcentage de progression
                              Center(
                                child: Text(
                                  '${_wellnessTotal * 4}%',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.displaySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WellnessGraphs(),
                            ),
                          );
                        },
                        child: Text('Afficher Graphiques'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getColor(double percentage) {
    if (percentage <= 40) return const Color(0xFFB71C1C);
    if (percentage <= 70) return const Color(0xFFF57F17);
    return const Color(0xFF1B5E20);
  }

  Column _buildWellnessRow(String title, double value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$title :', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(width: 32),
            Text(
              '$value / 5',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
