import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/models/local/account.dart';
import 'package:flutterwaka/providers/auth.dart';
import 'package:flutterwaka/widgets/exception.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

final _default = FutureProvider.autoDispose<int?>(
  (ref) => ref.read(sessionManagerProvider).savedDefaultAccount(),
);

final _accounts = FutureProvider.autoDispose<List<Account>>(
  (ref) => ref.read(sessionManagerProvider).accounts(),
);

class AccountsSettingsPage extends ConsumerWidget {
  const AccountsSettingsPage({super.key});

  Future<void> _delete(Account account, WidgetRef ref) async {
    final sessionsManager = ref.read(sessionManagerProvider);
    await sessionsManager.deleteAccount(account);
    ref.invalidate(_accounts);
  }

  Future<void> _setDefault(Account account, WidgetRef ref) async {
    final sessionsManager = ref.read(sessionManagerProvider);
    sessionsManager.setDefault(account);
    ref.invalidate(_default);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(_accounts);
    final defaultA = ref.watch(_default).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/login'),
        child: const Icon(LucideIcons.plus),
      ),
      body: accounts.when(
        data: (a) => ListView.builder(
          itemCount: a.length,
          itemBuilder: (context, i) => ListTile(
            contentPadding: const EdgeInsets.only(left: 16, right: 8),
            title: Text(a[i].username),
            subtitle: Text(a[i].server ?? 'WakaTime account'),
            onTap: defaultA != a[i].id ? () => _setDefault(a[i], ref) : null,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (defaultA == a[i].id)
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(
                      LucideIcons.check,
                      color: Colors.green,
                    ),
                  ),
                IconButton(
                  onPressed: () => _delete(a[i], ref),
                  icon: const Icon(LucideIcons.trash),
                ),
              ],
            ),
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
