import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/models/commit.dart';
import 'package:flutterwaka/models/project.dart';
import 'package:flutterwaka/models/repository.dart';
import 'package:flutterwaka/providers/client.dart';
import 'package:flutterwaka/widgets/commit_history.dart';
import 'package:flutterwaka/widgets/exception.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher_string.dart';

final _projectProvider = FutureProvider.autoDispose.family<Project, String>(
  (ref, q) {
    final api = ref.watch(apiProvider)!;
    return api.getProject(q);
  },
);

final _commitsProvider =
    FutureProvider.autoDispose.family<List<Commit>?, String>(
  (ref, q) {
    final api = ref.watch(apiProvider)!;
    return api.getProjectCommits(q);
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
