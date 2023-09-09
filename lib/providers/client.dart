import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:flutterwaka/providers/logger.dart';
import 'package:logger/logger.dart';

final clientProvider = StateProvider<Dio?>((ref) {
  final auth = ref.watch(loggedUserProvider);

  if (auth == null) return null;

  final options = BaseOptions(
    baseUrl: 'https://wakatime.com/api/v1',
    headers: {
      'Authorization': 'Bearer ${auth.token}',
    },
  );

  final dio = Dio(options);
  dio.interceptors.add(_LogInterceptor(logger: ref.read(loggerProvider)));

  return dio;
});

class _LogInterceptor extends Interceptor {
  final Logger logger;

  const _LogInterceptor({required this.logger});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e('[Dio]: $err');
    super.onError(err, handler);
  }
}
