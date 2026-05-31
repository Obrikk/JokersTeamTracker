import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jokers_team_tracker/services/mesures/grip_service.dart';

import '../../../../core/theme/colors.dart';

class GripGraphs extends StatefulWidget {
  @override
  State<GripGraphs> createState() => _GripGraphsState();

  const GripGraphs({super.key});
}

class _GripGraphsState extends State<GripGraphs> {
  final GripService _gripService = GripService();

  late Future<List<Map<String, dynamic>>> _avgFuture;

  int _timeGraph = 7;

  double _gripMin = 0;
  double _gripMoy = 0;
  double _gripMax = 0;

  Future<Map<String, double>> _loadGrip() async {
    final gripMinMax = await _gripService.getTodayGripMinMax();
    final gripMoyen = await _gripService.getTodayGripAverages();

    setState(() {
      _gripMin = gripMinMax['gripMin']!;
      _gripMoy = gripMoyen['grip']!;
      _gripMax = gripMinMax['gripMax']!;
    });
    return gripMoyen;
  }

  int initTimeGraph(int newTimeGraph) {
    _timeGraph = newTimeGraph;
    setState(() {
      _avgFuture = _gripService.getTeamGripRangeAverage(days: _timeGraph);
    });
    return _timeGraph;
  }

  @override
  void initState() {
    super.initState();
    _loadGrip();
    _avgFuture = _gripService.getTeamGripRangeAverage(days: 7);
  }

  @override
  Widget build(BuildContext context) {
    final labels = ['Grip Min.', 'Grip Moy.', 'Grip Max.'];
    final values = [
      double.parse(_gripMin.toStringAsFixed(2)),
      double.parse(_gripMoy.toStringAsFixed(2)),
      double.parse(_gripMax.toStringAsFixed(2)),
    ];
    final colors = [Colors.blue, Colors.green, Colors.red];

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Graphiques Grip')),
      body: SafeArea(
        top: true,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      initTimeGraph(1);
                    },
                    child: const Text('Aujourd\'hui'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      initTimeGraph(7);
                    },
                    child: const Text('7 jours'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      initTimeGraph(14);
                    },
                    child: const Text('14 jours'),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () {
                      initTimeGraph(30);
                    },
                    child: const Text('1 mois'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              if (_timeGraph != 1)
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
                          width: double.infinity,
                          child: LineChart(
                            LineChartData(
                              minY: 0,
                              maxY: 100,
                              minX: 0,
                              maxX: (avg.length - 1).toDouble(),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: 10,
                                getDrawingHorizontalLine: (value) =>
                                    FlLine(color: Colors.grey, strokeWidth: 1),
                              ),
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
                                    interval: 10,
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
                                      if (i % 2 != 0) {
                                        return const SizedBox();
                                      }

                                      final parts = (avg[i]['date'] as String)
                                          .split('-');
                                      return Text(
                                        '${parts[2]}/${parts[1]}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                  left: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1,
                                  ),
                                ),
                              ),
                              lineTouchData: LineTouchData(
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipColor: (_) => Colors.black87,
                                  getTooltipItems: (touchedSpots) =>
                                      touchedSpots.map((spot) {
                                        return LineTooltipItem(
                                          spot.y.toStringAsFixed(1),
                                          const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: avg.asMap().entries.map((entry) {
                                    return FlSpot(
                                      entry.key.toDouble(),
                                      entry.value['grip'] as double,
                                    );
                                  }).toList(),
                                  isCurved: false,
                                  color: AppColors.ice,
                                  barWidth: 3,
                                  dotData: FlDotData(
                                    show: true,
                                    getDotPainter:
                                        (spot, percent, bar, index) =>
                                            FlDotCirclePainter(
                                              radius: 3,
                                              color: AppColors.ice,
                                              strokeWidth: 2,
                                              strokeColor: AppColors.ice,
                                            ),
                                  ),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: AppColors.ice.withOpacity(0.15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              else
                Card(
                  color: Theme.of(context).colorScheme.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: SizedBox(
                      height: 400,
                      width: 500,
                      child: BarChart(
                        BarChartData(
                          maxY: 100,
                          minY: 0,
                          barTouchData: BarTouchData(
                            enabled: true,
                            touchTooltipData: BarTouchTooltipData(
                              getTooltipColor: (group) => AppColors.bgHoverDark,
                              getTooltipItem:
                                  (group, groupIndex, rod, rodIndex) {
                                    return BarTooltipItem(
                                      rod.toY.toString(),
                                      const TextStyle(
                                        color: AppColors.ice,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                            ),
                          ),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 20,
                                reservedSize: 28,
                                getTitlesWidget: (value, meta) => Text(
                                  value.toInt().toString(),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 40,
                                getTitlesWidget: (value, meta) {
                                  final index = value.toInt();
                                  if (index < 0 || index >= labels.length) {
                                    return SizedBox();
                                  }
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      labels[index],
                                      style: const TextStyle(fontSize: 10),
                                      textAlign: TextAlign.center,
                                    ),
                                  );
                                },
                              ),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          gridData: FlGridData(
                            show: true,
                            horizontalInterval: 20,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) =>
                                FlLine(color: Colors.grey, strokeWidth: 1),
                          ),
                          borderData: FlBorderData(
                            show: true,
                            border: const Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),
                            ),
                          ),
                          barGroups: List.generate(3, (index) {
                            return BarChartGroupData(
                              x: index,
                              barRods: [
                                BarChartRodData(
                                  toY: values[index],
                                  color: colors[index],
                                  width: 30,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
