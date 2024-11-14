import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:yescabank/models/account_activity.dart';

class AccountActivityChart extends StatelessWidget {
  final List<AccountActivity> activityList;

  const AccountActivityChart({super.key, required this.activityList});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
        ),
        borderData: FlBorderData(show: true, border: Border.all(color: Colors.black)),
        minX: 0,
        maxX: (activityList.length - 1).toDouble(),
        minY: activityList.map((e) => e.balance).reduce((a, b) => a < b ? a : b),
        maxY: activityList.map((e) => e.balance).reduce((a, b) => a > b ? a : b),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (int i = 0; i < activityList.length; i++)
                FlSpot(i.toDouble(), activityList[i].balance),
            ],
            isCurved: true,
            barWidth: 2,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
