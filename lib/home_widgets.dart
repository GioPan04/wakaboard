import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterwaka/api/auth.dart';
import 'package:flutterwaka/models/summary.dart';
import 'package:flutterwaka/models/user.dart';
import 'package:flutterwaka/widgets/charts/summary.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';

Future<Summary> _getData(AuthUser user) async {
  final client = Dio(user.dioBaseOptions);
  final end = DateTime.now();
  final start = end.subtract(const Duration(days: 6));

  final format = DateFormat('y-MM-dd');

  final res = await client.getUri(Uri(
    path: '/users/current/summaries',
    queryParameters: {
      'start': format.format(start),
      'end': format.format(end),
    },
  ));

  return Summary.fromJson(res.data);
}

@pragma("vm:entry-point")
void backgroundCallback(Uri? data) async {
  final auth = await AuthApi.loadUser().onError((error, stackTrace) => null);
  if (auth == null) return;

  final format = DateFormat('dd/MM/yyyy');

  final summary = await _getData(auth);
  await HomeWidget.renderFlutterWidget(
    MediaQuery(
      data: const MediaQueryData(platformBrightness: Brightness.dark),
      child: Theme(
        data: ThemeData.dark(),
        child: Column(
          children: [
            Text(
              'Week summary: ${format.format(summary.start)} - ${format.format(summary.end)}',
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 190,
              child: SummaryChart(days: summary.days),
            ),
          ],
        ),
      ),
    ),
    key: "weekSummaryChart",
    logicalSize: const Size(450, 250),
  );
}
