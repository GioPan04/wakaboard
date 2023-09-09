import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/models/summary.dart';
import 'package:flutterwaka/providers/client.dart';

final _summaryProvider = FutureProvider.autoDispose<Summary>((ref) async {
  final dio = ref.watch(clientProvider);
  final res = await dio!.get('/users/current/summary');

  return Summary.fromJson(res.data);
});

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(_summaryProvider);
    return Scaffold(
      body: summary.when(
        data: (s) => LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: s.days
                    .map(
                      (e) => FlSpot(
                        e.range.start.millisecondsSinceEpoch.toDouble(),
                        e.grandTotal.totalSeconds,
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        ),
        error: (_, __) => const SizedBox(),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
