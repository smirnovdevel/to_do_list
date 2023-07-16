import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import '../../utils/core/logging.dart';

final Logging log = Logging('ConfigRepository');

class ConfigRepository {
  final FirebaseRemoteConfig _remoteConfig;

  ConfigRepository(this._remoteConfig);

  Color? get replaceColor {
    String customRed = _remoteConfig.getString(_ConfigFields.customRed);
    log.debug('Color :hexColor');
    return Color(int.parse(customRed));
  }

  Future<void> init() async {
    _remoteConfig.setDefaults({
      _ConfigFields.customRed: null,
    });
    await _remoteConfig.fetchAndActivate();
  }
}

/// Parameter name (key)
///
abstract class _ConfigFields {
  static const customRed = 'custom_red';
}
