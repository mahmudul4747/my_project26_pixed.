import 'package:firebase_core/firebase_core.dart';
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC6KVAvzWElABA0eVHTMbYllRbvhrdwn6o',
    appId: '1:371474641591:web:41958c13bbe38a43911332',
    messagingSenderId: '371474641591',
    projectId: 'android19m',
    authDomain: 'android19m.firebaseapp.com',
    storageBucket: 'android19m.firebasestorage.app',
    measurementId: 'G-HQF5EV0292',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDDMUHBUGRbdbOE-1WS27_Vqz3uWssf3q0',
    appId: '1:371474641591:android:027445a65554cf27911332',
    messagingSenderId: '371474641591',
    projectId: 'android19m',
    storageBucket: 'android19m.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCOqtbcgCycNb1QfV-DWSKaBj7KE8nZMBE',
    appId: '1:371474641591:ios:f98b92e4b6345518911332',
    messagingSenderId: '371474641591',
    projectId: 'android19m',
    storageBucket: 'android19m.firebasestorage.app',
    iosBundleId: 'com.example.myProject26',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCOqtbcgCycNb1QfV-DWSKaBj7KE8nZMBE',
    appId: '1:371474641591:ios:f98b92e4b6345518911332',
    messagingSenderId: '371474641591',
    projectId: 'android19m',
    storageBucket: 'android19m.firebasestorage.app',
    iosBundleId: 'com.example.myProject26',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyC6KVAvzWElABA0eVHTMbYllRbvhrdwn6o',
    appId: '1:371474641591:web:17b441341df809a4911332',
    messagingSenderId: '371474641591',
    projectId: 'android19m',
    authDomain: 'android19m.firebaseapp.com',
    storageBucket: 'android19m.firebasestorage.app',
    measurementId: 'G-MP2M8V0WDC',
  );
}
