import 'package:flutter/material.dart';

import '../../../services/mesures/grip_service.dart';

class GripConsult extends StatefulWidget {
  @override
  State<GripConsult> createState() => _GripConsultState();

  const GripConsult({super.key});
}

class _GripConsultState extends State<GripConsult> {
  final GripService _gripService = GripService();

  double _gripMin = 0;
  double _gripMoy = 0;
  double _gripMax = 0;

  Future<Map<String, double>> _loadGrip() async {
    final gripMoyen = await _gripService.getTodayGripAverages();
    final gripMinMax = await _gripService.getTodayGripMinMax();

    setState(() {
      _gripMin = gripMinMax['gripMin']!;
      _gripMoy = gripMoyen['grip']!;
      _gripMax = gripMinMax['gripMax']!;
    });
    return gripMoyen;
  }

  @override
  void initState() {
    super.initState();
    _loadGrip();
  }

  @override
  Widget build(BuildContext context) {
    _gripMin = double.parse(_gripMin.toStringAsFixed(2));
    _gripMoy = double.parse(_gripMoy.toStringAsFixed(2));
    _gripMax = double.parse(_gripMax.toStringAsFixed(2));

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
                      'Grip :',
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
                            'Grip Min :',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(width: 32),
                          Text(
                            '$_gripMin kg',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grip Moyen:',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(width: 32),
                          Text(
                            '$_gripMoy kg',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grip Max :',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(width: 32),
                          Text(
                            '$_gripMax kg',
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
