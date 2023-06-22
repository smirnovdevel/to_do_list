import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';

final Logger log = Logger('getDeviceID');

Future<String> getDeviceID() async {
  final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

  try {
    if (kIsWeb) {
      final WebBrowserInfo deviceData = await deviceInfoPlugin.webBrowserInfo;
      return deviceData.appCodeName.toString();
    } else {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          {
            final AndroidDeviceInfo deviceData =
                await deviceInfoPlugin.androidInfo;
            return deviceData.id;
          }
        case TargetPlatform.iOS:
          {
            final IosDeviceInfo deviceData = await deviceInfoPlugin.iosInfo;
            return deviceData.identifierForVendor ?? 'Unknown device ID';
          }

        case TargetPlatform.linux:
          {
            final LinuxDeviceInfo deviceData = await deviceInfoPlugin.linuxInfo;
            return deviceData.machineId ?? 'Unknown device ID';
          }

        case TargetPlatform.windows:
          {
            final WindowsDeviceInfo deviceData =
                await deviceInfoPlugin.windowsInfo;
            return deviceData.deviceId;
          }
        case TargetPlatform.macOS:
          {
            final MacOsDeviceInfo deviceData = await deviceInfoPlugin.macOsInfo;
            return deviceData.systemGUID ?? 'Unknown device ID';
          }
        default:
          return 'Unknown device ID';
      }
    }
  } on PlatformException {
    log.warning('Unknown device ID');
    return 'Unknown device ID';
  }
}
