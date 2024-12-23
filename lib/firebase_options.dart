// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjrs6_iAM8CwvCq0YOXtlnK2A_eCXVQo4',
    appId: '1:408620663344:android:1e857a2bd502212eee63f5',
    messagingSenderId: '408620663344',
    projectId: 'snapwise-2aa6a',
    storageBucket: 'snapwise-2aa6a.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCeJ7RJt9_93lFqe4iocrN9O9SFvCVIKSo',
    appId: '1:408620663344:web:65f4a44690ebca20ee63f5',
    messagingSenderId: '408620663344',
    projectId: 'snapwise-2aa6a',
    authDomain: 'snapwise-2aa6a.firebaseapp.com',
    storageBucket: 'snapwise-2aa6a.firebasestorage.app',
    measurementId: 'G-F82Q82F48K',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD_53pql5_MlfFqflnAy4mba-HAcIFRYKc',
    appId: '1:408620663344:ios:6a3bd6d4594719d8ee63f5',
    messagingSenderId: '408620663344',
    projectId: 'snapwise-2aa6a',
    storageBucket: 'snapwise-2aa6a.firebasestorage.app',
    iosBundleId: 'com.example.snapwise',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD_53pql5_MlfFqflnAy4mba-HAcIFRYKc',
    appId: '1:408620663344:ios:6a3bd6d4594719d8ee63f5',
    messagingSenderId: '408620663344',
    projectId: 'snapwise-2aa6a',
    storageBucket: 'snapwise-2aa6a.firebasestorage.app',
    iosBundleId: 'com.example.snapwise',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCeJ7RJt9_93lFqe4iocrN9O9SFvCVIKSo',
    appId: '1:408620663344:web:ff58c73cd220f940ee63f5',
    messagingSenderId: '408620663344',
    projectId: 'snapwise-2aa6a',
    authDomain: 'snapwise-2aa6a.firebaseapp.com',
    storageBucket: 'snapwise-2aa6a.firebasestorage.app',
    measurementId: 'G-V7B2L9F3F1',
  );

}