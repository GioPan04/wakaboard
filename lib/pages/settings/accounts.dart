import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/models/local/account.dart';
import 'package:flutterwaka/providers/auth.dart';
import 'package:flutterwaka/widgets/exception.dart';

final _accounts = FutureProvider<List<Account>>(
  (ref) => ref.read(sessionManagerProvider).accounts(),
);

class AccountsSettingsPage extends ConsumerWidget {
  const AccountsSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(_accounts);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      body: accounts.when(
        data: (a) => ListView.builder(
          itemCount: a.length,
          itemBuilder: (context, i) => ListTile(
            title: Text(a[i].username),
            subtitle: Text(a[i].server ?? 'WakaTime account'),
          ),
        ),
        error: (e, s) => Center(
          child: ExceptionButton(
            error: e,
            stacktrace: s,
          ),
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
