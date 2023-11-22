import 'package:flutterwaka/models/project.dart';
import 'package:flutterwaka/models/summary.dart';

class SummaryDTO {
  final Summary summary;
  final List<SummaryItem<Project>> projects;

  const SummaryDTO({
    required this.summary,
    required this.projects,
  });

  factory SummaryDTO.fromSummary(Summary summary) {
    final List<SummaryItem<Project>> projects = [];

    // Sum all durations and percents
    for (final day in summary.days) {
      if (day.projects == null) break;
      for (final project in day.projects!) {
        final i = projects.indexWhere((e) => e.name == project.name);
        if (i != -1) {
          projects[i] = SummaryItem(
            name: project.name,
            percent: projects[i].percent + project.percent,
            duration: Duration(
              seconds:
                  projects[i].duration.inSeconds + project.duration.inSeconds,
            ),
          );
        } else {
          projects.add(project);
        }
      }
    }

    // Recalculate percent per day
    for (int i = 0; i < projects.length; i++) {
      projects[i] = SummaryItem(
        name: projects[i].name,
        percent: projects[i].percent / summary.days.length,
        duration: projects[i].duration,
      );
    }

    // Sort by percent
    projects.sort((p, s) => s.percent.compareTo(p.percent));

    return SummaryDTO(summary: summary, projects: projects);
  }
}
