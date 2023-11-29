import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/models/stats.dart';
import 'package:flutterwaka/models/user.dart';
import 'package:flutterwaka/providers/client.dart';

final loggedUserProvider = StateProvider<AuthUser?>((ref) => null);
final profilePicProvider = FutureProvider<dynamic>((ref) async {
  final user = ref.watch(loggedUserProvider)!.user;
  final dio = ref.read(clientProvider)!;

  if (user.photo == null) return null;

  final res = await dio.get(
    "${user.photo}?s=420",
    options: Options(responseType: ResponseType.bytes),
  );

  final contentType = res.headers[Headers.contentTypeHeader]?.first;

  if (contentType == null || !contentType.startsWith('image/')) {
    throw Exception('Unsupported image');
  } else if (contentType == 'image/svg+xml') {
    return utf8.decode(res.data);
  } else {
    return res.data;
  }
});

final statsProvider = FutureProvider<Duration>((ref) async {
  final api = ref.watch(apiProvider)!;
  final stats = await api.getStats(StatsRange.allTime);

  return stats.total;
});
