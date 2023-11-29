import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/extensions/duration.dart';
import 'package:flutterwaka/models/duration.dart';
import 'package:flutterwaka/providers/client.dart';
import 'package:flutterwaka/widgets/exception.dart';
import 'package:lucide_icons/lucide_icons.dart';

final _selectedDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);

final _timelineProvider = FutureProvider<List<WakaDuration>>(
  (ref) async {
    final api = ref.watch(apiProvider)!;
    final date = ref.watch(_selectedDateProvider);
    final data = await api.durations(date);

    // For some reason duration with 0 seconds are shown sometimes
    return data.where((element) => element.duration.inSeconds > 0).toList();
  },
);

class TimelinePage extends ConsumerWidget {
  const TimelinePage({super.key});

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final current = ref.read(_selectedDateProvider);
    final date = await showDatePicker(
      context: context,
      initialDate: current,
      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
      lastDate: DateTime.now(),
    );

    ref.read(_selectedDateProvider.notifier).state = date ?? current;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heartbeats = ref.watch(_timelineProvider);

    return heartbeats.when(
      data: (h) => ListView.separated(
        itemCount: h.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(h[i].project),
          subtitle: Text(h[i].duration.format),
        ),
        separatorBuilder: (context, i) {
          final previousEnd = h[i].time.add(h[i].duration);
          final pause = h[i + 1].time.difference(previousEnd);
          return ListTile(
            title: Text(pause.shortFormat),
            leading: const Icon(
              LucideIcons.watch,
            ),
          );
        },
      ),
      error: (e, s) => Center(
        child: ExceptionButton(error: e, stacktrace: s),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
