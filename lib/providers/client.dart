import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwaka/api/wakatime.dart';
import 'package:flutterwaka/providers/logged_user.dart';
import 'package:flutterwaka/providers/logger.dart';
import 'package:logger/logger.dart';

final clientProvider = StateProvider<Dio?>((ref) {
  final auth = ref.watch(loggedUserProvider);

  if (auth == null) return null;

  final dio = Dio(auth.dioBaseOptions);
  dio.interceptors.add(_LogInterceptor(logger: ref.read(loggerProvider)));

  return dio;
});

final apiProvider = StateProvider<WakaTimeApi?>((ref) {
  final dio = ref.watch(clientProvider);
  if (dio == null) return null;

  return WakaTimeApi(client: dio);
});

class _LogInterceptor extends Interceptor {
  final Logger logger;

  const _LogInterceptor({required this.logger});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e(
        '[Dio]: $err\n${err.requestOptions.queryParameters}\n${err.response?.data}');
    super.onError(err, handler);
  }
}
