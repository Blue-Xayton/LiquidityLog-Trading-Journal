/*import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WinrateChart extends StatelessWidget {
  final List<String> outcomes;

  const WinrateChart({super.key, required this.outcomes, required List<Map<String, String>> trades});

  @override
  Widget build(BuildContext context) {
    List<FlSpot> cumulativePoints = [];
    double cumulativeValue = 0;

    for (int i = 0; i < outcomes.length; i++) {
      if (outcomes[i].toLowerCase() == 'win') {
        cumulativeValue += 1;
      } else {
        cumulativeValue -= 1;
      }
      cumulativePoints.add(FlSpot(i.toDouble(), cumulativeValue));
    }

    return AspectRatio(
      aspectRatio: 1.7,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 10, top: 20, bottom: 10),
        child: LineChart(
          LineChartData(
            minY: cumulativePoints.map((e) => e.y).reduce((a, b) => a < b ? a : b) - 1,
            maxY: cumulativePoints.map((e) => e.y).reduce((a, b) => a > b ? a : b) + 1,
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.black54,
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              getDrawingHorizontalLine: (_) => FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
              ),
              getDrawingVerticalLine: (_) => FlLine(
                color: Colors.grey.withOpacity(0.3),
                strokeWidth: 1,
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 22,
                  getTitlesWidget: (value, _) {
                    return Text('${value.toInt() + 1}',
                        style: TextStyle(fontSize: 10));
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 28,
                  getTitlesWidget: (value, _) => Text(
                    value.toInt().toString(),
                    style: TextStyle(fontSize: 10),
                  ),
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: Colors.black26),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: cumulativePoints,
                isCurved: true,
                color: Colors.green,
                barWidth: 2,
                isStrokeCapRound: true,
                dotData: FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: Colors.green.withOpacity(0.2),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}*/
