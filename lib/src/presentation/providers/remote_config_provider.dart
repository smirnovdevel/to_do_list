import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../utils/core/logging.dart';

final Logging log = Logging('StreamProvider');

final _remoteConfig = FirebaseRemoteConfig.instance;

// FutureProvider<FirebaseRemoteConfig> remoteConfigProvider = FutureProvider(
//   (ref) async => await initRemoteConfig(),
// );

// Future<FirebaseRemoteConfig> initRemoteConfig() async {
//   log.debug('init');
//   await _remoteConfig.setConfigSettings(
//     RemoteConfigSettings(
//       fetchTimeout: const Duration(minutes: 1),
//       minimumFetchInterval: const Duration(minutes: 5),
//     ),
//   );
//   _remoteConfig.setDefaults({ConfigFields.customRed: ''});
//   await _remoteConfig.fetchAndActivate();
//   return _remoteConfig;
//   // String customRed = _remoteConfig.getString(_ConfigFields.customRed);
//   // log.debug('Color : $customRed');
//   // return Color(int.parse(customRed));
// }

final remoteConfigProvider = StreamProvider<Color?>((ref) async* {
  log.debug('init');

  _remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ),
  );

  // _remoteConfig.setDefaults({_ConfigFields.customRed: ''});
  await _remoteConfig.fetchAndActivate();
  String customRed = _remoteConfig.getString(ConfigFields.customRed);
  log.debug('Color : $customRed');
  yield HexColor(customRed);
});

/// Parameter name (key)
///
abstract class ConfigFields {
  static const customRed = 'custom_red';
}
