import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/mesures/poids_service.dart';
import 'poids_graphs_screen.dart';

class PoidsConsult extends ConsumerStatefulWidget {
  @override
  ConsumerState<PoidsConsult> createState() => _PoidsConsultState();

  const PoidsConsult({super.key});
}

class _PoidsConsultState extends ConsumerState<PoidsConsult> {
  final PoidsService _poidsService = PoidsService();

  double _poidsMin = 0;
  double _poidsMoy = 0;
  double _poidsMax = 0;

  Future<Map<String, double>> _loadPoids() async {
    final poidsMinMax = await _poidsService.getTodayPoidsMinMax();
    final poidsMoyen = await _poidsService.getTodayPoidsAverages();

    setState(() {
      _poidsMin = poidsMinMax['poidsMin']!;
      _poidsMoy = poidsMoyen['poids']!;
      _poidsMax = poidsMinMax['poidsMax']!;
    });
    return poidsMoyen;
  }

  @override
  void initState() {
    super.initState();
    _loadPoids();
  }

  @override
  Widget build(BuildContext context) {
    _poidsMin = double.parse(_poidsMin.toStringAsFixed(2));
    _poidsMoy = double.parse(_poidsMoy.toStringAsFixed(2));
    _poidsMax = double.parse(_poidsMax.toStringAsFixed(2));

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
                            'Poids Min:',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(width: 32),
                          Text(
                            '$_poidsMin kg',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Poids Moyen:',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(width: 32),
                          Text(
                            '$_poidsMoy kg',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Poids Max:',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(width: 32),
                          Text(
                            '$_poidsMax kg',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PoidsGraphs(),
                      ),
                    );
                  },
                  child: Text('Afficher Graphiques'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
