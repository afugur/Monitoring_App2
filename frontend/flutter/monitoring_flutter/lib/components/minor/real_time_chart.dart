import 'dart:collection';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/data_bloc.dart';
import '../../blocs/data_state.dart';
import '../../models/data_model.dart';

class AppColors {
  static const Color contentColorBlue = Color(0xFF007AFF);
  static const Color contentColorPink = Color(0xFFC2185B);
  static const Color contentColorGreen = Color(0xFF00FF00);
  static const Color mainTextColor2 = Color(0xFF333333);
}

class LineChartSample10 extends StatelessWidget {
  final int chartNumber;

  const LineChartSample10({super.key, required this.chartNumber});

  Color getChartColor() {
    switch (chartNumber) {
      case 1:
        return AppColors.contentColorBlue;
      case 2:
        return AppColors.contentColorPink;
      case 3:
        return AppColors.contentColorGreen;
      default:
        return AppColors.contentColorBlue;
    }
  }

  String getChartTitle() {
    switch (chartNumber) {
      case 1:
        return 'X Value';
      case 2:
        return 'Y Value';
      case 3:
        return 'Z Value';
      default:
        return 'X Value';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DataBloc, DataState>(
      builder: (context, state) {
        Queue<TimeSeriesData> dataQueue;
        if (chartNumber == 1) {
          dataQueue = state.dataQueue1;
        } else if (chartNumber == 2) {
          dataQueue = state.dataQueue2;
        } else {
          dataQueue = state.dataQueue3;
        }

        return dataQueue.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Time: ${dataQueue.last.time.toString().substring(0, 19)}',
                        style: const TextStyle(
                          color: AppColors.mainTextColor2,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${getChartTitle()}: ${dataQueue.last.data.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: getChartColor(),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  AspectRatio(
                    aspectRatio: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: LineChart(
                        LineChartData(
                          minY: -1,
                          maxY: 1,
                          minX: dataQueue.first.time.millisecondsSinceEpoch
                              .toDouble(),
                          maxX: dataQueue.last.time.millisecondsSinceEpoch
                              .toDouble(),
                          lineTouchData: const LineTouchData(enabled: false),
                          clipData: const FlClipData.all(),
                          gridData: const FlGridData(
                            show: true,
                            drawVerticalLine: false,
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            sinLine(dataQueue
                                .toList()
                                .map((e) => FlSpot(
                                    e.time.millisecondsSinceEpoch.toDouble(),
                                    e.data))
                                .toList()),
                          ],
                          titlesData: const FlTitlesData(
                            show: false,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : Container();
      },
    );
  }

  LineChartBarData sinLine(List<FlSpot> points) {
    return LineChartBarData(
      spots: points,
      dotData: const FlDotData(
        show: false,
      ),
      gradient: LinearGradient(
        colors: [getChartColor().withOpacity(0.7), getChartColor()],
        stops: const [0.1, 1.0],
      ),
      barWidth: 4,
      isCurved: false,
    );
  }
}
