import 'package:dio/dio.dart';
import 'package:flutterwaka/models/commit.dart';
import 'package:flutterwaka/models/config/wakatime_config.dart';
import 'package:flutterwaka/models/duration.dart';
import 'package:flutterwaka/models/heartbeat.dart';
import 'package:flutterwaka/models/local/account.dart';
import 'package:flutterwaka/models/project.dart';
import 'package:flutterwaka/models/stats.dart';
import 'package:flutterwaka/models/summary.dart';
import 'package:intl/intl.dart';

class WakaTimeApi {
  final Dio client;

  WakaTimeApi({required this.client});

  final _dateFormat = DateFormat('y-MM-dd');

  static Future<Account> getToken(String code) async {
    final res = await Dio().post(
      'https://wakatime.com/oauth/token',
      options: Options(
        contentType: Headers.jsonContentType,
        headers: {
          Headers.acceptHeader: Headers.jsonContentType,
        },
      ),
      data: {
        'client_id': WakaTimeConfig.appId,
        'client_secret': WakaTimeConfig.appSecret,
        'redirect_uri': WakaTimeConfig.redirect,
        'grant_type': 'authorization_code',
        'code': code
      },
    );

    return Account.wakatime(
      accessToken: res.data['access_token'],
      refreshToken: res.data['refresh_token'],
      tokenExpire: DateTime.parse(res.data['expires_at']),
    );
  }

  /// Fetch the user's summary from a given range.
  Future<Summary> getSummary(
    DateTime start,
    DateTime end, {
    String? project,
  }) async {
    final res = await client.getUri(Uri(
      path: '/users/current/summaries',
      queryParameters: {
        'start': _dateFormat.format(start),
        'end': _dateFormat.format(end),
        'project': project
      },
    ));

    return Summary.fromJson(res.data);
  }

  /// Fetch the user's stats from a given `range`. It's recommended to use the
  /// ad hoc `StatsRange` class to get a list of available ranges or create a
  /// custom one
  Future<Stats> getStats([String? range = '']) async {
    final res = await client.get('/users/current/stats/$range');

    return Stats.fromJson(res.data['data']);
  }

  /// Fetch the user's projects
  Future<List<Project>> getProjects([String? q]) async {
    final res = await client.getUri(Uri(
      path: '/users/current/projects',
      queryParameters: {'q': q},
    ));

    return res.data['data'].map<Project>((p) => Project.fromJson(p)).toList();
  }

  /// Fetch a specific user's project from a given `id`
  /// The `id` can be either the project `id` or `name`
  Future<Project> getProject(String id) async {
    // Currently not supported by Wakapi, see: https://github.com/muety/wakapi/issues/562
    // final res = await client.get('/users/current/projects/$id');

    final projects = await getProjects(id);

    for (var project in projects) {
      if (project.id == id || project.name == id) return project;
    }

    throw Exception('Not found');
  }

  /// Fetch a specific user's project's commits from a given project `id`
  /// The `id` can be either the project `id` or `name`
  /// Currently not supported on Wakapi
  Future<List<Commit>> getProjectCommits(String id) async {
    final res = await client.get('/users/current/projects/$id/commits');

    return res.data['commits'].map<Commit>((c) => Commit.fromJson(c)).toList();
  }

  /// Fetch the user (or a specific project) total duration
  /// NOTE: On WakaTime sometimes returns a status code of 202 when it's
  /// calculating the stats. It could take even 5 or more minutes.
  /// In case of a 202 status code the function will fail
  Future<Duration> allTimeSinceToday([String? project]) async {
    final res = await client.getUri(Uri(
      path: '/users/current/all_time_since_today',
      queryParameters: {'project': project},
    ));

    return Duration(seconds: res.data['data']['total_seconds']);
  }

  /// Fetch the heartbeats for one day
  Future<List<Heartbeat>> heartbeats(DateTime date) async {
    final res = await client.getUri(Uri(
      path: '/users/current/heartbeats',
      queryParameters: {'date': _dateFormat.format(date)},
    ));

    return res.data['data']
        .map<Heartbeat>((h) => Heartbeat.fromJson(h))
        .toList();
  }

  /// Fetch the durations for one day
  /// NOTE: Works only in WakaTime (see muety/wakapi#500)
  Future<List<WakaDuration>> durations(DateTime date) async {
    final res = await client.getUri(Uri(
      path: '/users/current/durations',
      queryParameters: {'date': _dateFormat.format(date)},
    ));

    return res.data['data']
        .map<WakaDuration>((d) => WakaDuration.fromJson(d))
        .toList();
  }
}
