import 'package:flutter/material.dart';

import '../../../../services/mesures/rpe_service.dart';
import 'rpe_graphs_screen.dart';

class RpeConsult extends StatefulWidget {
  @override
  State<RpeConsult> createState() => _RpeConsultState();

  const RpeConsult({super.key});
}

class _RpeConsultState extends State<RpeConsult> {
  final RpeService _rpeService = RpeService();

  double _rpeTotal = 0;

  double _rpem = 0;
  double _rpec = 0;

  Future<Map<String, double>> _loadRpe() async {
    final rpe = await _rpeService.getTodayRpeAverages();

    setState(() {
      _rpem = rpe['rpem']!;
      _rpec = rpe['rpec']!;
      _rpeTotal = (rpe['rpem']! + rpe['rpec']!) / 2;
    });
    return rpe;
  }

  @override
  void initState() {
    super.initState();
    _loadRpe();
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor(_rpeTotal * 5);
    _rpeTotal = double.parse(_rpeTotal.toStringAsFixed(2));

    return Column(
      children: [
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
                    // En tête
                    Text(
                      'Rpe :',
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
                      _buildRpeRow('RPE Musculaire', _rpem),
                      _buildRpeRow('RPE Cardio', _rpec),
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
                                '$_rpeTotal / 10',
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
                              value: _rpeTotal / 20,
                              strokeWidth: 6,
                              backgroundColor: Colors.white24,
                              valueColor: AlwaysStoppedAnimation<Color>(color),
                            ),

                            // Pourcentage de progression
                            Center(
                              child: Text(
                                '${_rpeTotal * 10}%',
                                style: Theme.of(context).textTheme.displaySmall,
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
                            builder: (context) => const RpeGraphs(),
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
      ],
    );
  }

  Color _getColor(double percentage) {
    if (percentage <= 40) return const Color(0xFFF57F17);
    if (percentage >= 70) return const Color(0xFFB71C1C);
    return const Color(0xFF1B5E20);
  }

  Column _buildRpeRow(String title, double value) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$title :', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(width: 32),
            Text(
              '$value / 10',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
