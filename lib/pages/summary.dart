import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/extensions/datetime.dart';
import 'package:flutterwaka/extensions/duration.dart';
import 'package:flutterwaka/models/dto/summary.dart';
import 'package:flutterwaka/providers/client.dart';
import 'package:flutterwaka/widgets/dashboard_widget.dart';
import 'package:flutterwaka/widgets/exception.dart';
import 'package:flutterwaka/widgets/charts/summary.dart';
import 'package:flutterwaka/widgets/scrollable_categories.dart';
import 'package:intl/intl.dart';

final summaryRangeProvider = StateProvider<DateTimeRange>((ref) {
  final today = DateTime.now();
  final start = today.subtract(const Duration(days: 6));

  return DateTimeRange(start: start, end: today);
});

final _summaryProvider = FutureProvider<SummaryDTO>((ref) async {
  final api = ref.watch(apiProvider)!;
  final range = ref.watch(summaryRangeProvider);
  final res = await api.getSummary(range.start, range.end);

  return SummaryDTO.fromSummary(res);
});

final _filterProvider = StateProvider<SummaryFilter>(
  (ref) => SummaryFilter.projects,
);

final format = DateFormat('dd/MM/yyyy');

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(summaryRangeProvider);
    final summary = ref.watch(_summaryProvider);
    final filter = ref.watch(_filterProvider);
    final theme = Theme.of(context);

    final data = {
      SummaryFilter.projects: summary.value?.projects,
      SummaryFilter.editors: summary.value?.editors,
      SummaryFilter.languages: summary.value?.languages,
      SummaryFilter.machines: summary.value?.computers,
      SummaryFilter.oses: summary.value?.oss,
    };

    return RefreshIndicator(
      onRefresh: () => ref.refresh(_summaryProvider.future),
      child: summary.when(
        data: (s) => ListView(
          children: [
            if (!range.start.isSameDay(range.end)) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: SizedBox(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        top: 18.0,
                        bottom: 14.0,
                      ),
                      child: SummaryChart(days: s.summary.days),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DashboardWidget(
                        label: 'Daily average',
                        color: theme.colorScheme.secondary,
                        value: s.summary.dailyAverage.text,
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: DashboardWidget(
                        label: 'Total',
                        color: theme.colorScheme.tertiary,
                        value: s.summary.comulativeTotal.format,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24,
              ),
            ],
            ScrollableCategories(
              items: SummaryFilter.values,
              getLabel: (v) => v.label,
              onItemPressed: (f) =>
                  ref.read(_filterProvider.notifier).state = f,
              selected: (f) => f == filter,
            ),
            ...data[filter]!
                .map(
                  (e) => ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            e.name,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          e.duration.shortFormat,
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    subtitle: LinearProgressIndicator(
                      value: e.percent / 100,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                )
                .toList(),
            // FAB space
            const SizedBox(
              height: 112,
            ),
          ],
        ),
        error: (e, s) => Center(
          child: ExceptionButton(
            error: e,
            stacktrace: s,
            retry: () => ref.invalidate(_summaryProvider),
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

enum SummaryFilter {
  projects,
  languages,
  editors,
  machines,
  oses;

  String get label {
    return switch (this) {
      projects => 'Projects',
      languages => 'Languages',
      editors => 'Editors',
      machines => 'Computers',
      oses => 'OSs'
    };
  }
}
