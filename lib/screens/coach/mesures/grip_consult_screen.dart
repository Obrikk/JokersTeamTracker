import 'package:flutter/material.dart';

import '../../../services/mesures/grip_service.dart';

class GripConsult extends StatefulWidget {
  @override
  State<GripConsult> createState() => _GripConsultState();

  const GripConsult({super.key});
}

class _GripConsultState extends State<GripConsult> {
  final GripService _gripService = GripService();

  double _grip = 0;

  Future<Map<String, double>> _loadGrip() async {
    final grip = await _gripService.getTodayGripAverages();

    setState(() {
      _grip = grip['grip']!;
    });
    return grip;
  }

  @override
  void initState() {
    super.initState();
    _loadGrip();
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
                            'Grip :',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(width: 32),
                          Text(
                            '$_grip kg',
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
