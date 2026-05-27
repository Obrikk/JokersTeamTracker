import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jokers_team_tracker/services/mesures/wellness_service.dart';

import '../../../core/theme/colors.dart';
import '../../../models/graphs/wellness_graphs.dart';
import '../../../models/mesures/wellness_model.dart';

class WellnessGraphs extends StatefulWidget {
  @override
  State<WellnessGraphs> createState() => _WellnessGraphsState();

  const WellnessGraphs({super.key});
}

class _WellnessGraphsState extends State<WellnessGraphs> {
  //final WellnessGraphsModel = _wellnessGraphsModel();
  final WellnessService _wellnessServices = WellnessService();

  late Future<List<Map<String, dynamic>>> _avgFuture;

  @override
  void initState() {
    super.initState();
    _avgFuture = _wellnessServices.getTeamWellnessRangeAverage(days: 30);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Graphiques Wellness')),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text('Aujourd\'hui'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(onPressed: () {}, child: const Text('7 jours')),
                  const SizedBox(width: 8),
                  TextButton(onPressed: () {}, child: const Text('14 jours')),
                  const SizedBox(width: 8),
                  TextButton(onPressed: () {}, child: const Text('1 mois')),
                ],
              ),
              const SizedBox(height: 32),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _avgFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Erreur : ${snapshot.error}');
                  }

                  final avg = snapshot.data!;

                  return Card(
                    color: Theme.of(context).colorScheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SizedBox(
                        height: 300,
                        width: 500,
                        child: LineChart(
                          LineChartData(
                            minY: 0,
                            maxY: 6,
                            minX: 0,
                            maxX: (avg.length - 1).toDouble(),
                            gridData: const FlGridData(show: true),
                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  interval: 1,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  interval: 1,
                                  getTitlesWidget: (value, meta) {
                                    final i = value.toInt();
                                    if (i < 0 || i >= avg.length) {
                                      return const SizedBox();
                                    }
                                    final parts = (avg[i]['date'] as String)
                                        .split('-');
                                    return Text(
                                      '${parts[2]}/${parts[1]}',
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                // ✅ Corrigé : .map() directement sur avg
                                spots: avg.asMap().entries.map((entry) {
                                  return FlSpot(
                                    entry.key.toDouble(),
                                    entry.value['score_total'] as double,
                                  );
                                }).toList(),
                                isCurved: false,
                                color: AppColors.ice,
                                barWidth: 3,
                                dotData: const FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
