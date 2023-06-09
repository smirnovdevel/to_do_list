// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAQmgyN6suafjytBCK5UWJjY0NhdMvmkgY',
    appId: '1:286928751292:web:c36edd11e0bad381aedeb9',
    messagingSenderId: '286928751292',
    projectId: 'todo-list-ce737',
    authDomain: 'todo-list-ce737.firebaseapp.com',
    storageBucket: 'todo-list-ce737.appspot.com',
    measurementId: 'G-9C7R8DEQ5H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWUOSsrvGkFH7XPpaKW1um0g5ifkfo50w',
    appId: '1:286928751292:android:cb251992b9615066aedeb9',
    messagingSenderId: '286928751292',
    projectId: 'todo-list-ce737',
    storageBucket: 'todo-list-ce737.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAoTMMumQDgAprmXR4x1JgedNOoHogwnQM',
    appId: '1:286928751292:ios:ea87b23bb9619863aedeb9',
    messagingSenderId: '286928751292',
    projectId: 'todo-list-ce737',
    storageBucket: 'todo-list-ce737.appspot.com',
    iosClientId: '286928751292-7sf8usi59arnrta12iv6rgp6vd3fag0l.apps.googleusercontent.com',
    iosBundleId: 'five.live.toDoList',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAoTMMumQDgAprmXR4x1JgedNOoHogwnQM',
    appId: '1:286928751292:ios:0d38945c9eb1f80eaedeb9',
    messagingSenderId: '286928751292',
    projectId: 'todo-list-ce737',
    storageBucket: 'todo-list-ce737.appspot.com',
    iosClientId: '286928751292-1ng9toh9nrp90slvglei9jp77ukgbnn7.apps.googleusercontent.com',
    iosBundleId: 'com.example.toDoList.RunnerTests',
  );
}
