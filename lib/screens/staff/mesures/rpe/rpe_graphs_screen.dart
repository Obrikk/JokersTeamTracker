import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:jokers_team_tracker/services/mesures/rpe_service.dart';

import '../../../../core/theme/colors.dart';

class RpeGraphs extends StatefulWidget {
  @override
  State<RpeGraphs> createState() => _RpeGraphsState();

  const RpeGraphs({super.key});
}

class _RpeGraphsState extends State<RpeGraphs> {
  final RpeService _rpeServices = RpeService();

  late Future<List<Map<String, dynamic>>> _avgFuture;

  int _timeGraph = 7;

  double _rpem = 0;
  double _rpec = 0;

  //Initialise les moyennes du rpe
  Future<Map<String, double>> _loadRpe() async {
    final rpe = await _rpeServices.getTodayRpeAverages();

    setState(() {
      _rpem = rpe['rpem']!;
      _rpec = rpe['rpec']!;
    });
    return rpe;
  }

  int initTimeGraph(int newTimeGraph) {
    _timeGraph = newTimeGraph;
    setState(() {
      _avgFuture = _rpeServices.getTeamRpeRangeAverage(days: _timeGraph);
    });
    return _timeGraph;
  }

  @override
  void initState() {
    super.initState();
    _loadRpe();
    _avgFuture = _rpeServices.getTeamRpeRangeAverage(days: 7);
  }

  @override
  Widget build(BuildContext context) {
    final labels = ['RPE M.', 'RPE C.'];
    final values = [_rpem, _rpec];
    final colors = [Colors.green, Colors.red];
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(title: const Text('Graphiques Rpe')),
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
                        child: Column(
                          children: [
                            SizedBox(
                              height: 300,
                              width: double.infinity,
                              child: LineChart(
                                LineChartData(
                                  minY: 0,
                                  maxY: 10,
                                  minX: 0,
                                  maxX: (avg.length - 1).toDouble(),
                                  gridData: FlGridData(
                                    show: true,
                                    drawVerticalLine: false,
                                    horizontalInterval: 1,
                                    getDrawingHorizontalLine: (value) => FlLine(
                                      color: Colors.grey,
                                      strokeWidth: 1,
                                    ),
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
                                          if (i % 2 != 0) {
                                            return const SizedBox();
                                          }

                                          final parts =
                                              (avg[i]['date'] as String).split(
                                                '-',
                                              );
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
                                      getTooltipColor: (_) =>
                                          AppColors.bgHoverDark,
                                      getTooltipItems: (touchedSpots) {
                                        return touchedSpots.map((spot) {
                                          final isRpem = spot.barIndex == 0;

                                          return LineTooltipItem(
                                            isRpem
                                                ? 'RPE M. : ${spot.y.toStringAsFixed(1)}'
                                                : 'RPE C. : ${spot.y.toStringAsFixed(1)}',
                                            TextStyle(
                                              color: isRpem
                                                  ? Colors.green
                                                  : Colors.red,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ),
                                  lineBarsData: [
                                    // ======================
                                    // COURBE RPE M.
                                    // ======================
                                    LineChartBarData(
                                      spots: avg.asMap().entries.map((entry) {
                                        return FlSpot(
                                          entry.key.toDouble(),
                                          entry.value['rpem'] as double,
                                        );
                                      }).toList(),
                                      isCurved: false,
                                      color: Colors.green,
                                      barWidth: 3,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter:
                                            (spot, percent, bar, index) =>
                                                FlDotCirclePainter(
                                                  radius: 3,
                                                  color: Colors.green,
                                                  strokeWidth: 2,
                                                  strokeColor: Colors.green,
                                                ),
                                      ),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: Colors.green.withOpacity(0.10),
                                      ),
                                    ),

                                    // ======================
                                    // COURBE RPE C.
                                    // ======================
                                    LineChartBarData(
                                      spots: avg.asMap().entries.map((entry) {
                                        return FlSpot(
                                          entry.key.toDouble(),
                                          entry.value['rpec'] as double,
                                        );
                                      }).toList(),
                                      isCurved: false,
                                      color: Colors.red,
                                      barWidth: 3,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter:
                                            (spot, percent, bar, index) =>
                                                FlDotCirclePainter(
                                                  radius: 3,
                                                  color: Colors.red,
                                                  strokeWidth: 2,
                                                  strokeColor: Colors.red,
                                                ),
                                      ),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: Colors.red.withOpacity(0.10),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 6),
                                    const Text('RPE M.'),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 6),
                                    const Text('RPE C.'),
                                  ],
                                ),
                              ],
                            ),
                          ],
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
                      height: 300,
                      width: 500,
                      child: BarChart(
                        BarChartData(
                          maxY: 10,
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
                                interval: 1,
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
                            horizontalInterval: 1,
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
                          barGroups: List.generate(2, (index) {
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
