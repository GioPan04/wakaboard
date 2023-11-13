import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutterwaka/models/project.dart';
import 'package:flutterwaka/models/summary.dart';

class ProjectsChart extends StatefulWidget {
  final List<SummaryItem<Project>> projects;

  const ProjectsChart({
    required this.projects,
    super.key,
  });

  @override
  State<ProjectsChart> createState() => _ProjectsChartState();
}

class _ProjectsChartState extends State<ProjectsChart> {
  int? _touched;

  void _onTap(FlTouchEvent event, PieTouchResponse? response) {
    if (!event.isInterestedForInteractions ||
        response == null ||
        response.touchedSection == null) {
      setState(() {
        _touched = null;
      });
    } else {
      setState(() {
        _touched = response.touchedSection!.touchedSectionIndex;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 140,
          width: 140,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(touchCallback: _onTap),
              sectionsSpace: 2,
              centerSpaceRadius: 0,
              sections: widget.projects
                  .asMap()
                  .map(
                    (key, p) => MapEntry(
                      key,
                      PieChartSectionData(
                        value: max(1, p.percent),
                        showTitle: false,
                        // title: p.percent.toStringAsFixed(0),
                        radius: _touched == key ? 75 : 65,
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widget.projects
              .map(
                (e) => Text(
                  '${e.name}: ${e.percent.toStringAsFixed(2)}%',
                  overflow: TextOverflow.ellipsis,
                ),
              )
              .toList(),
        )
      ],
    );
  }
}
