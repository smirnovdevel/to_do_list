import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

Future<String> getDeviceID() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  try {
    if (kIsWeb) {
      var deviceData = await deviceInfoPlugin.webBrowserInfo;
      return deviceData.appCodeName.toString();
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          {
            var deviceData = await deviceInfoPlugin.androidInfo;
            return deviceData.id;
          }
        case TargetPlatform.iOS:
          {
            var deviceData = await deviceInfoPlugin.iosInfo;
            return deviceData.identifierForVendor ?? 'Unknown device ID';
          }

        case TargetPlatform.linux:
          {
            var deviceData = await deviceInfoPlugin.linuxInfo;
            return deviceData.machineId ?? 'Unknown device ID';
          }

        case TargetPlatform.windows:
          {
            var deviceData = await deviceInfoPlugin.windowsInfo;
            return deviceData.deviceId;
          }
        case TargetPlatform.macOS:
          {
            var deviceData = await deviceInfoPlugin.macOsInfo;
            return deviceData.systemGUID ?? 'Unknown device ID';
          }
        default:
          return '';
      }
    }
  } on PlatformException {
    var deviceData = <String, dynamic>{
      'Error:': 'Failed to get platform version.'
    };
  }

  return 'Unknown device ID';
}
