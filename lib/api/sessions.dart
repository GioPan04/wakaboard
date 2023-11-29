import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterwaka/models/local/account.dart';
import 'package:flutterwaka/models/local/session.dart';
import 'package:flutterwaka/models/user.dart';
import 'package:sqflite/sqflite.dart';

const String _kAccountsTable = 'accounts';

/// Utility used to access and manage accounts saved on the device
///
/// When the DB is opened `SessionsManager.migrate` should be called, so that
/// the necessary tables are created
class SessionsManager {
  final Database db;
  final FlutterSecureStorage tokensStorage;

  const SessionsManager({
    required this.db,
    required this.tokensStorage,
  });

  /// Should be executed when the db is created
  static Future<void> create(Database db) async {
    await db.execute(
      """CREATE TABLE $_kAccountsTable (
        id INTEGER PRIMARY KEY,
        server TEXT,
        username TEXT NOT NULL,
        full_name TEXT
      )""",
    );
  }

  Future<bool> hasAccounts() async {
    final res = await db.query(_kAccountsTable);

    return res.isNotEmpty;
  }

  /// Fetches all the local saved accounts.
  /// NOTE: This sessions don't contains the token
  Future<List<Account>> accounts() async {
    final res = await db.query(_kAccountsTable);

    return res.map<Account>((e) => Account.fromDb(e)).toList();
  }

  /// Fetch the session for a specific account
  Future<Session> session(Account account) async {
    final accessToken = await tokensStorage.read(
      key: 'auth.${account.id}.token',
    );
    final refreshToken = await tokensStorage.read(
      key: 'auth.${account.id}.refresh_token',
    );

    return Session(
      account: account,
      accessToken: accessToken!,
      refreshToken: refreshToken,
    );
  }

  Future<Account?> _defaultAccount() async {
    final res = await db.query(_kAccountsTable, orderBy: "id ASC");
    if (res.isEmpty) return null;

    return Account.fromDb(res.first);
  }

  /// Fetches the default account.
  ///
  /// It first try to get the user selected default account, if there isn't one
  /// it returns the first ever account available
  Future<Account?> defaultAccount() async {
    // This will fail if there is not a default user and the first one is deleted
    final id = await tokensStorage.read(key: 'auth.default');
    if (id == null) return _defaultAccount();

    final res = await db.query(
      _kAccountsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (res.isEmpty) return _defaultAccount();

    return Account.fromDb(res.first);
  }

  /// Saves a new user into the sessions manager
  Future<Session> save(
    User user,
    String? server,
    String accessToken,
    String? refreshToken,
  ) async {
    final id = await db.insert(_kAccountsTable, {
      'server': server,
      'username': user.username,
      'full_name': user.fullName
    });

    final account = Account(
      id: id,
      username: user.username,
      fullName: user.fullName,
      server: server,
    );

    await tokensStorage.write(
      key: 'auth.$id.token',
      value: accessToken,
    );
    await tokensStorage.write(
      key: 'auth.$id.refresh_token',
      value: refreshToken,
    );

    return Session(
      account: account,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
