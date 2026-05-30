import 'package:flutter/material.dart';
import '../../../../providers/mesures/data_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/colors.dart';

class GripFillRate extends ConsumerStatefulWidget {
  @override
  ConsumerState<GripFillRate> createState() => _GripFillRateState();

  const GripFillRate({super.key});
}

class _GripFillRateState extends ConsumerState<GripFillRate> {
  @override
  Widget build(BuildContext context) {
    final dataState = ref.watch(dataProvider);

    if (dataState.isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final stats = dataState.gripFillRate;
    if (stats == null) return const SizedBox.shrink();

    final percentage = stats.percentage;
    final color = _getColor(percentage);
    final missing = stats.missingPlayers;

    final displayedList = missing.toList();

    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Grip :', style: Theme.of(context).textTheme.displayLarge),
                IconButton(
                  icon: const Icon(Icons.refresh, color: AppColors.ice),
                  onPressed: () => ref.read(dataProvider.notifier).refreshRpe(),
                ),
              ],
            ),
            const SizedBox(height: 32),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: percentage / 100,
                          strokeWidth: 10,
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                        ),
                        Center(
                          child: Text(
                            '${percentage.toStringAsFixed(0)}%',
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  SizedBox(
                    child: stats.missingPlayers.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.only(top: 24),
                            child: Text(
                              'Tous les joueurs ont remplis !',
                              style: TextStyle(color: AppColors.ice),
                            ),
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${stats.missing} joueur(s) manquant(s) :',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 4),
                              ...displayedList.map(
                                (name) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.circle,
                                        size: 6,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        name,
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(double percentage) {
    if (percentage <= 40) return const Color(0xFFB71C1C);
    if (percentage <= 70) return const Color(0xFFF57F17);
    return const Color(0xFF1B5E20);
  }
}
