import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_airpods/models/device_motion_data.dart';
import 'package:rxdart/subjects.dart';

/// API for accessing information about the currently connected airpods.
class FlutterAirpods {
  // this is the way
  // ignore: prefer_void_to_null
  static Null _nil;

  bool _initialized = false;
  static final FlutterAirpods _instance = FlutterAirpods._();
  factory FlutterAirpods() => _instance;
  final ValueNotifier worn = ValueNotifier(false);

  final deviceMotion = BehaviorSubject<DeviceMotionData?>.seeded(null);

  FlutterAirpods._() {
    _constructor();
  }

  _constructor() {
    if (_initialized) return;
    _initialized = true;

    deviceMotion.addStream(const EventChannel("flutter_airpods.motion")
        .receiveBroadcastStream()
        .map((event) {
      worn.value = true;
      return DeviceMotionData.fromJson(jsonDecode(event));
    }).timeout(const Duration(milliseconds: 500), onTimeout: (_) {
      deviceMotion.add(_nil);
      worn.value = false;
    }));
  }
}
