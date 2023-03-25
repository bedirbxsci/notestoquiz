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
    apiKey: 'AIzaSyCQwF94MDhRnsplLjTcfUmjUF0_qSeuFdA',
    appId: '1:1021096788999:web:20e8dfd06724f58b49d6a2',
    messagingSenderId: '1021096788999',
    projectId: 'startup-9d293',
    authDomain: 'startup-9d293.firebaseapp.com',
    storageBucket: 'startup-9d293.appspot.com',
    measurementId: 'G-YM1S3B7SMK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDimVntBMU0-ilf7-0ehthzBfsepagIK7E',
    appId: '1:1021096788999:android:b56d26a93b3cf26e49d6a2',
    messagingSenderId: '1021096788999',
    projectId: 'startup-9d293',
    storageBucket: 'startup-9d293.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC6hSaOAT6rKxQ9awwFYc-U33b5iV5gmuo',
    appId: '1:1021096788999:ios:74ced115664b19da49d6a2',
    messagingSenderId: '1021096788999',
    projectId: 'startup-9d293',
    storageBucket: 'startup-9d293.appspot.com',
    iosClientId: '1021096788999-schde40c4gt66ob730h7oc0li2q6o4td.apps.googleusercontent.com',
    iosBundleId: 'com.example.startup',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC6hSaOAT6rKxQ9awwFYc-U33b5iV5gmuo',
    appId: '1:1021096788999:ios:74ced115664b19da49d6a2',
    messagingSenderId: '1021096788999',
    projectId: 'startup-9d293',
    storageBucket: 'startup-9d293.appspot.com',
    iosClientId: '1021096788999-schde40c4gt66ob730h7oc0li2q6o4td.apps.googleusercontent.com',
    iosBundleId: 'com.example.startup',
  );
}
