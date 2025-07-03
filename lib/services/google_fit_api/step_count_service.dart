import 'dart:developer';

import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

class HealthService {
  final Health health = Health();
  final types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  Future<bool> requestPermissions() async {
    final activityStatus = await Permission.activityRecognition.request();
    final sensorsStatus = await Permission.sensors.request();

    if (activityStatus.isGranted && sensorsStatus.isGranted) {
      try {
        return await health.requestAuthorization(types);
      } catch (ex) {
        await Health().installHealthConnect();
        log(ex.toString());
        return false;
      }
    }
    return false;
  }

  Future<int> fetchTodaySteps() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    final authorized = await requestPermissions();

    if (!authorized) return 0;

    final steps = await health.getHealthDataFromTypes(
      types: [HealthDataType.STEPS],
      startTime: midnight,
      endTime: now,
    );

    final totalSteps = steps.fold<int>(
      0,
      (sum, dataPoint) => sum + (dataPoint.value as int),
    );

    return totalSteps;
  }
}
