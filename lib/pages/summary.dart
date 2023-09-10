import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/models/summary.dart';
import 'package:flutterwaka/providers/client.dart';
import 'package:flutterwaka/widgets/summary_chart.dart';
import 'package:intl/intl.dart';

final _summaryProvider = FutureProvider<Summary>((ref) async {
  final dio = ref.watch(clientProvider);
  final today = DateTime.now();
  final start = today.subtract(const Duration(days: 7));
  final format = DateFormat.yMd();

  final res = await dio!.getUri(Uri(
    path: '/users/current/summaries',
    queryParameters: {
      'start': format.format(start),
      'end': format.format(today),
    },
  ));

  return Summary.fromJson(res.data);
});

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(_summaryProvider);

    return summary.when(
      data: (s) => SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          children: [
            const Text('This week summary'),
            Text(
              '${s.total.inHours} hours and ${s.total.inMinutes.remainder(60)} minutes',
            ),
            SizedBox(
              height: 100,
              child: SummaryChart(days: s.days),
            ),
          ],
        ),
      ),
      error: (e, __) => Text(__.toString()),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
