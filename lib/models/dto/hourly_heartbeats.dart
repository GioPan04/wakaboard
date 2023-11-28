import 'package:flutterwaka/models/heartbeat.dart';

class HourlyHeartbeats {
  final List<List<Heartbeat>> hours;

  const HourlyHeartbeats(this.hours);

  factory HourlyHeartbeats.fromHeartbeats(List<Heartbeat> h) {
    h.sort((p, n) => p.time.compareTo(n.time));

    final hours = DateTime.fromMillisecondsSinceEpoch(
          (h.last.time * 1000).toInt(),
        ).hour +
        1;

    final res = List.generate(hours, (index) => <Heartbeat>[]);

    for (final hb in h) {
      final time = DateTime.fromMillisecondsSinceEpoch(
        (hb.time * 1000).toInt(),
      );

      res[time.hour].add(hb);
    }

    return HourlyHeartbeats(res);
  }
}
