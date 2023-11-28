// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutterwaka/models/editors.dart';
import 'package:flutterwaka/models/language.dart';
import 'package:flutterwaka/models/machine.dart';
import 'package:flutterwaka/models/operating_system.dart';
import 'package:flutterwaka/models/project.dart';
import 'package:flutterwaka/models/summary.dart';

class SummaryDTO {
  final Summary summary;
  final List<SummaryItem<Project>> projects;
  final List<SummaryItem<Language>> languages;
  final List<SummaryItem<Editor>> editors;
  final List<SummaryItem<Machine>> computers;
  final List<SummaryItem<OperatingSystem>> oss;

  const SummaryDTO({
    required this.summary,
    required this.projects,
    required this.languages,
    required this.editors,
    required this.computers,
    required this.oss,
  });

  factory SummaryDTO.fromSummary(Summary summary) {
    final List<SummaryItem<Project>> projects = [];
    final List<SummaryItem<Language>> languages = [];
    final List<SummaryItem<Editor>> editors = [];
    final List<SummaryItem<Machine>> computers = [];
    final List<SummaryItem<OperatingSystem>> oss = [];

    int productiveDays = 0;

    // Sum all durations and percents
    for (final day in summary.days) {
      // Calculate only days where there are heartbeats
      if (day.total.inSeconds > 0) productiveDays++;

      day.projects?.forEach((element) => _sum<Project>(element, projects));
      day.languages?.forEach((element) => _sum<Language>(element, languages));
      day.editors?.forEach((element) => _sum<Editor>(element, editors));
      day.machines?.forEach((element) => _sum<Machine>(element, computers));
      day.operatingSystems?.forEach(
        (element) => _sum<OperatingSystem>(element, oss),
      );
    }

    // Recalculate percent per day
    _average<Project>(projects, productiveDays);
    _average<Language>(languages, productiveDays);
    _average<Editor>(editors, productiveDays);
    _average<Machine>(computers, productiveDays);
    _average<OperatingSystem>(oss, productiveDays);

    // Sort by percent
    projects.sort((p, s) => s.percent.compareTo(p.percent));
    languages.sort((p, s) => s.percent.compareTo(p.percent));
    editors.sort((p, s) => s.percent.compareTo(p.percent));
    computers.sort((p, s) => s.percent.compareTo(p.percent));
    oss.sort((p, s) => s.percent.compareTo(p.percent));

    return SummaryDTO(
      summary: summary,
      projects: projects,
      computers: computers,
      editors: editors,
      languages: languages,
      oss: oss,
    );
  }

  static void _sum<T>(SummaryItem<T> item, List<SummaryItem<T>> out) {
    final i = out.indexWhere((e) => e.name == item.name);
    if (i != -1) {
      out[i] = SummaryItem<T>(
        name: item.name,
        percent: out[i].percent + item.percent,
        duration: Duration(
          seconds: out[i].duration.inSeconds + item.duration.inSeconds,
        ),
      );
    } else {
      out.add(item);
    }
  }

  static void _average<T>(List<SummaryItem<T>> items, int days) {
    for (int i = 0; i < items.length; i++) {
      items[i] = SummaryItem<T>(
        name: items[i].name,
        percent: items[i].percent / days,
        duration: items[i].duration,
      );
    }
  }
}
