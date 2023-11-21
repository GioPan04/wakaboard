import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/models/project.dart';
import 'package:flutterwaka/providers/client.dart';
import 'package:flutterwaka/widgets/exception.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

final _projectsProvider = FutureProvider<List<Project>>((ref) {
  final api = ref.watch(apiProvider)!;
  return api.getProjects();
});

final _lastHeartbeatFormat = DateFormat('dd/MM/y HH:mm');

class ProjectsPage extends ConsumerWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(_projectsProvider);

    return projects.when(
      data: (p) => ListView.builder(
        itemCount: p.length,
        itemBuilder: (context, i) => ListTile(
          onTap: () => context.push('/home/projects/${p[i].name}'),
          title: Text(p[i].name),
          subtitle: (p[i].lastHeartbeat != null)
              ? Text(
                  'Last heartbeat on ${_lastHeartbeatFormat.format(p[i].lastHeartbeat!)}',
                )
              : null,
        ),
      ),
      error: (e, s) => Center(child: ExceptionButton(error: e, stacktrace: s)),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
