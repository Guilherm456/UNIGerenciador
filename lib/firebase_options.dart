// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
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
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBb4ywym1dWKfOQ0DW3liXWKmzPF17voXk',
    appId: '1:983132221268:web:0719d8670ae6a98b5d22c1',
    messagingSenderId: '983132221268',
    projectId: 'unigerenciador-c9bea',
    authDomain: 'unigerenciador-c9bea.firebaseapp.com',
    databaseURL: 'https://unigerenciador-c9bea-default-rtdb.firebaseio.com',
    storageBucket: 'unigerenciador-c9bea.appspot.com',
    measurementId: 'G-H3YWSNY5F2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDuLRuMDPS3C4MejV4TUDpxIvgavqK6d4I',
    appId: '1:983132221268:android:a2e2c8e33232137d5d22c1',
    messagingSenderId: '983132221268',
    projectId: 'unigerenciador-c9bea',
    databaseURL: 'https://unigerenciador-c9bea-default-rtdb.firebaseio.com',
    storageBucket: 'unigerenciador-c9bea.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAYaIsZ5dFvPosoagU3snWGwTCwYvmb3U0',
    appId: '1:983132221268:ios:0f4b843682845bd05d22c1',
    messagingSenderId: '983132221268',
    projectId: 'unigerenciador-c9bea',
    databaseURL: 'https://unigerenciador-c9bea-default-rtdb.firebaseio.com',
    storageBucket: 'unigerenciador-c9bea.appspot.com',
    iosClientId:
        '983132221268-p13nqdlsgsusr1tqkb03duvhs1gblau9.apps.googleusercontent.com',
    iosBundleId: 'com.unigerenciador.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAYaIsZ5dFvPosoagU3snWGwTCwYvmb3U0',
    appId: '1:983132221268:ios:0f4b843682845bd05d22c1',
    messagingSenderId: '983132221268',
    projectId: 'unigerenciador-c9bea',
    databaseURL: 'https://unigerenciador-c9bea-default-rtdb.firebaseio.com',
    storageBucket: 'unigerenciador-c9bea.appspot.com',
    iosClientId:
        '983132221268-p13nqdlsgsusr1tqkb03duvhs1gblau9.apps.googleusercontent.com',
    iosBundleId: 'com.unigerenciador.app',
  );
}
