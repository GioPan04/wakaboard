import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutterwaka/api/auth.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => throw Exception('Not yet initialized'),
);

final authApiProvider = Provider<AuthApi>(
  (ref) => throw Exception('Not yet initialized'),
);
