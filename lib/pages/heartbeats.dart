import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/models/heartbeat.dart';
import 'package:flutterwaka/providers/client.dart';
import 'package:flutterwaka/widgets/exception.dart';

final _selectedDateProvider = StateProvider.autoDispose<DateTime?>(
  (ref) => null,
);

final _heartbeatsProvider = FutureProvider.autoDispose<List<Heartbeat>>(
  (ref) async {
    final api = ref.watch(apiProvider)!;
    final date = ref.watch(_selectedDateProvider) ?? DateTime.now();
    final data = await api.heartbeats(date);

    return data;
  },
);

class HeartbeatsPage extends ConsumerWidget {
  const HeartbeatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heartbeats = ref.watch(_heartbeatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Heartbeats'),
      ),
      body: heartbeats.when(
        data: (h) => ListView.builder(
          itemCount: h.length,
          itemBuilder: (context, i) => ListTile(
            title: Text("${h[i].project} ${h[i].category}"),
            subtitle: Text(h[i].entity!),
          ),
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
