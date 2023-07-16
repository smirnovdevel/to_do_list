import 'dart:async';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';

import 'src/config/themes/dark_theme.dart';
import 'src/config/themes/light_theme.dart';
import 'src/presentation/core/localization/app_localization.dart';
import 'src/presentation/navigation/route_information_parser.dart';
import 'src/presentation/providers/navigation_provider.dart';
import 'src/presentation/providers/remote_config_provider.dart';
import 'src/utils/core/logging.dart';

final Logging log = Logging('App');

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;
  RemoteConfigUpdate? update;

  Future<void> remoteConfigUpdate() async {
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 10),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.fetchAndActivate();

      setState(() {
        update = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    remoteConfigUpdate();

    String stringColor = remoteConfig.getString(ConfigFields.customRed);
    log.debug('Color : $stringColor');
    Color? customRed;
    try {
      customRed = HexColor(stringColor);
    } catch (e) {
      log.warning('Bad color : $stringColor');
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TODO лист',
      theme: lightTheme(customRed),
      darkTheme: darkTheme(customRed),
      localizationsDelegates: AppLocalization.localizationsDelegates,
      supportedLocales: AppLocalization.supportedLocales,
      // Navigator 2.0
      routerDelegate: ref.watch(navigationProvider),
      routeInformationParser: TodoRouteInformationParser(ref),
    );
  }
}
