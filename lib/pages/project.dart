import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/models/commit.dart';
import 'package:flutterwaka/models/project.dart';
import 'package:flutterwaka/models/repository.dart';
import 'package:flutterwaka/providers/client.dart';
import 'package:flutterwaka/widgets/commit_history.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

final _projectProvider = FutureProvider.autoDispose.family<Project?, String>(
  (ref, q) async {
    final dio = ref.watch(clientProvider)!;
    final res = await dio.get('/users/current/projects?q=$q');

    if (res.data['data'][0] != null) {
      return Project.fromJson(res.data['data'][0]);
    }

    return null;
  },
);

final _commitsProvider =
    FutureProvider.autoDispose.family<List<Commit>?, String>(
  (ref, q) async {
    final dio = ref.watch(clientProvider)!;
    final project = await ref.watch(_projectProvider(q).future);
    if (project == null) return null;

    final res = await dio.get('/users/current/projects/${project.id}/commits');

    return res.data['commits'].map<Commit>((c) => Commit.fromJson(c)).toList();
  },
);

class ProjectPage extends ConsumerWidget {
  final String q;

  const ProjectPage({
    required this.q,
    super.key,
  });

  Future<void> _openRepo(Repository r) async {
    if (await canLaunchUrlString(r.htmlUrl)) {
      launchUrlString(r.htmlUrl, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final project = ref.watch(_projectProvider(q));
    final commits = ref.watch(_commitsProvider(q));

    return Scaffold(
      appBar: AppBar(
        title: Text(q),
        actions: [
          if (project.hasValue && project.value!.repository != null)
            IconButton(
              onPressed: () => _openRepo(project.value!.repository!),
              tooltip: 'Open repository',
              icon: const Icon(LucideIcons.folderGit2),
            ),
        ],
      ),
      body: project.when(
        data: (p) => ListView(
          children: [
            if (commits.hasValue && commits.value != null)
              CommitHistory(commits: commits.value!.take(5)),
          ],
        ),
        error: (_, __) => const SizedBox.shrink(),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
