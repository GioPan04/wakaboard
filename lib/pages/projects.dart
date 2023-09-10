import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/models/project.dart';
import 'package:flutterwaka/providers/client.dart';
import 'package:intl/intl.dart';

final _projectsProvider = FutureProvider<List<Project>>((ref) async {
  final dio = ref.watch(clientProvider);
  final res = await dio!.get('/users/current/projects');

  return res.data['data'].map<Project>((p) => Project.fromJson(p)).toList();
});

final _lastHeartbeatFormat = DateFormat('dd/MM/y HH:mm');

class ProjectPage extends ConsumerWidget {
  const ProjectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(_projectsProvider);

    return projects.when(
      data: (p) => ListView.builder(
        itemCount: p.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(p[i].name),
          subtitle: (p[i].lastHeartbeat != null)
              ? Text(
                  'Last time worked on ${_lastHeartbeatFormat.format(p[i].lastHeartbeat!)}',
                )
              : null,
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
