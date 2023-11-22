import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/extensions/datetimerange.dart';
import 'package:flutterwaka/models/dto/summary.dart';
import 'package:flutterwaka/models/summary.dart';
import 'package:flutterwaka/providers/client.dart';
import 'package:flutterwaka/widgets/charts/bar.dart';
import 'package:flutterwaka/widgets/exception.dart';
import 'package:flutterwaka/widgets/charts/summary.dart';
import 'package:flutterwaka/widgets/summary_counter.dart';
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

final _previousSummary = FutureProvider<Summary>((ref) {
  final api = ref.watch(apiProvider)!;
  final range = ref.watch(summaryRangeProvider).previusPeriod;

  return api.getSummary(range.start, range.end);
});

final format = DateFormat('dd/MM/yyyy');

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(_summaryProvider);
    final previous = ref.watch(_previousSummary).unwrapPrevious().valueOrNull;
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
                  summary: s.summary,
                  previuosSummary: previous,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 30, top: 10),
              child: SizedBox(
                height: 120,
                child: SummaryChart(days: s.summary.days),
              ),
            ),
            Text(
              'Projects',
              style: theme.textTheme.labelLarge,
              textAlign: TextAlign.center,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: BarChart(items: s.projects),
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
