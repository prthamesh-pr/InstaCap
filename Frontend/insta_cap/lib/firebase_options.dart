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
    apiKey: 'demo-key-web-development',
    appId: '1:123456789:web:demo123456',
    messagingSenderId: '123456789',
    projectId: 'demo-autotext-project',
    authDomain: 'demo-autotext-project.firebaseapp.com',
    storageBucket: 'demo-autotext-project.appspot.com',
    measurementId: 'G-DEMO123456',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'demo-key-android-development',
    appId: '1:123456789:android:demo123456',
    messagingSenderId: '123456789',
    projectId: 'demo-autotext-project',
    storageBucket: 'demo-autotext-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'demo-key-ios-development',
    appId: '1:123456789:ios:demo123456',
    messagingSenderId: '123456789',
    projectId: 'demo-autotext-project',
    storageBucket: 'demo-autotext-project.appspot.com',
    iosBundleId: 'com.autotext.instaCap',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'demo-key-macos-development',
    appId: '1:123456789:ios:demo123456',
    messagingSenderId: '123456789',
    projectId: 'demo-autotext-project',
    storageBucket: 'demo-autotext-project.appspot.com',
    iosBundleId: 'com.autotext.instaCap',
  );
}

