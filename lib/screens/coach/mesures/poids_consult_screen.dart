import 'package:flutter/material.dart';

import '../../../services/mesures/poids_service.dart';

class PoidsConsult extends StatefulWidget {
  @override
  State<PoidsConsult> createState() => _PoidsConsultState();

  const PoidsConsult({super.key});
}

class _PoidsConsultState extends State<PoidsConsult> {
  final PoidsService _poidsService = PoidsService();

  double _poids = 0;

  Future<Map<String, double>> _loadPoids() async {
    final poids = await _poidsService.getTodayPoidsAverages();

    setState(() {
      _poids = poids['poids']!;
    });
    return poids;
  }

  @override
  void initState() {
    super.initState();
    _loadPoids();
  }

  @override
  Widget build(BuildContext context) {
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
                      'Poids :',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    Text(
                      'Moyenne du jour',
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Poids :',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(width: 32),
                          Text(
                            '$_poids kg',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Afficher Graphiques'),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
