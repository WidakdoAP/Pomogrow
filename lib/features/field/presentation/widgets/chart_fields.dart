import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomogrow/core/theme/palette.dart';
import 'package:pomogrow/features/field/presentation/providers/field_provider.dart';

class BarChartFields extends ConsumerWidget {
  const BarChartFields({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(focusStatsProvider);
    final labels = ['25', '50', '75', '100'];

    return statsAsync.when(

        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        error: (e, _) => Center(
          child: Text("Error: $e"),
        ),

        data: (stats) {
          final values = [
            stats['0'] ?? 0,
            stats['1'] ?? 0,
            stats['2'] ?? 0,
            stats['3'] ?? 0,
          ];

          final maxValue =
          values.reduce((a, b) => a > b ? a : b);


          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppPalette.backgroundColor,
            ),
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              height: 300,
              child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        "Statistik Fokus",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppPalette.textBlack,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: 25,
                        minY: 0,
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          drawVerticalLine: false,
                          drawHorizontalLine: true,
                          horizontalInterval: 5,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: AppPalette.grey,
                              strokeWidth: 1,
                              dashArray: null,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                              interval: 5,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Text(
                                    value.toInt().toString(),
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              },
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                return Text(labels[value.toInt()]);
                              },
                            ),
                          ),
                        ),

                        barGroups: List.generate(values.length, (index) {
                          final isMax = values[index] == maxValue;

                          return BarChartGroupData(
                            x: index,
                            barRods: [
                              BarChartRodData(
                                toY: values[index].toDouble(),
                                width: 40,
                                color: isMax
                                    ? AppPalette.barColor
                                    : AppPalette.barColorTransparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
