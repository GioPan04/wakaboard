import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/extensions/datetimerange.dart';
import 'package:flutterwaka/models/stats.dart';
import 'package:flutterwaka/models/summary.dart';
import 'package:flutterwaka/providers/client.dart';
import 'package:flutterwaka/widgets/charts/bar.dart';
import 'package:flutterwaka/widgets/exception.dart';
import 'package:flutterwaka/widgets/charts/summary.dart';
import 'package:flutterwaka/widgets/summary_counter.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';

final summaryRangeProvider = StateProvider<DateTimeRange>((ref) {
  final today = DateTime.now();
  final start = today.subtract(const Duration(days: 6));

  return DateTimeRange(start: start, end: today);
});

final _summaryProvider = FutureProvider<Summary>((ref) async {
  final api = ref.watch(apiProvider)!;
  final range = ref.watch(summaryRangeProvider);

  return api.getSummary(range.start, range.end);
});

final _previousSummary = FutureProvider<Summary>((ref) {
  final api = ref.watch(apiProvider)!;
  final range = ref.watch(summaryRangeProvider).previusPeriod;

  return api.getSummary(range.start, range.end);
});

final _statsProvider = FutureProvider<Stats>((ref) async {
  final api = ref.watch(apiProvider)!;
  ref.watch(_summaryProvider);

  return api.getStats(StatsRange.last30Days);
});

final format = DateFormat('dd/MM/yyyy');

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(_summaryProvider);
    final previous = ref.watch(_previousSummary).unwrapPrevious().valueOrNull;
    final stats = ref.watch(_statsProvider);
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(_summaryProvider.future),
      child: summary.when(
        data: (s) => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SummaryCounter(
                  summary: s,
                  previuosSummary: previous,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              child: SizedBox(
                height: 120,
                child: SummaryChart(days: s.days),
              ),
            ),
            ...stats.whenOrNull<List<Widget>>(
                  skipLoadingOnReload: true,
                  error: (e, s) => [ExceptionButton(error: e, stacktrace: s)],
                  data: (s) => [
                    if (s.bestDay != null)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.trophy,
                                color: Colors.green,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Best day: ${format.format(s.bestDay!.date)}'),
                                  Text(
                                    '${s.bestDay!.total.inHours} hrs ${s.bestDay!.total.inMinutes.remainder(60)} mins and ${s.bestDay!.total.inSeconds.remainder(60)} secs',
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    if (s.projects != null) ...[
                      Text(
                        'Projects',
                        style: theme.textTheme.labelLarge,
                        textAlign: TextAlign.center,
                      ),
                      Container(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: BarChart(items: s.projects!),
                      ),
                    ]
                  ],
                ) ??
                [],
          ],
        ),
        error: (e, s) => Center(
          child: ExceptionButton(error: e, stacktrace: s),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
