import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/models/stats.dart';
import 'package:flutterwaka/models/summary.dart';
import 'package:flutterwaka/providers/client.dart';
import 'package:flutterwaka/widgets/charts/projects.dart';
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
  final dio = ref.watch(clientProvider);
  final range = ref.watch(summaryRangeProvider);

  final format = DateFormat('y-MM-dd');

  final res = await dio!.getUri(Uri(
    path: '/users/current/summaries',
    queryParameters: {
      'start': format.format(range.start),
      'end': format.format(range.end),
    },
  ));

  return Summary.fromJson(res.data);
});

final _statsProvider = FutureProvider<Stats>((ref) async {
  final dio = ref.watch(clientProvider)!;
  ref.watch(_summaryProvider);
  final res = await dio.get('/users/current/stats/last_7_days');

  return Stats.fromJson(res.data['data']);
});

final format = DateFormat('dd/MM/yyyy');

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(_summaryProvider);
    final stats = ref.watch(_statsProvider);

    return RefreshIndicator(
      onRefresh: () => ref.refresh(_summaryProvider.future),
      child: summary.when(
        data: (s) => ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: SummaryCounter(summary: s),
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
                    if (s.projects != null)
                      Container(
                        padding: const EdgeInsets.only(bottom: 10, top: 10),
                        child: ProjectsChart(projects: s.projects!),
                      ),
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
