import 'package:flutter/material.dart';
import 'package:flutterwaka/models/commit.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommitHistory extends StatelessWidget {
  final Iterable<Commit> commits;

  const CommitHistory({
    required this.commits,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0.0),
        child: Column(
          children: [
            const Text('Last commits'),
            ...commits
                .map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            maxRadius: 16,
                            backgroundImage: NetworkImage(e.committerAvatarUrl),
                          ),
                          const SizedBox(
                            width: 4.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.message),
                              Text(e.committerUsername)
                            ],
                          ),
                          const Spacer(),
                          Text(timeago.format(e.createdAt)),
                        ],
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
    );
  }
}
