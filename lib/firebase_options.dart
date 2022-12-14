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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCecPq9ddjAO3zDcaIG47tjHa2rzak6qp0',
    appId: '1:1078746363948:android:c57c1998196b913d06f989',
    messagingSenderId: '1078746363948',
    projectId: 'auto-assist-f2416',
    storageBucket: 'auto-assist-f2416.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD_6Aq64shIfXnLf7k6qIWB8B1hOtq2gbA',
    appId: '1:1078746363948:ios:4d8ed028716fcc0f06f989',
    messagingSenderId: '1078746363948',
    projectId: 'auto-assist-f2416',
    storageBucket: 'auto-assist-f2416.appspot.com',
    androidClientId: '1078746363948-etgvmm3ak0p4brbtqtl3g0n87unvd23v.apps.googleusercontent.com',
    iosClientId: '1078746363948-lm3sq24fsvu2a3a524om02uqgeh964ln.apps.googleusercontent.com',
    iosBundleId: 'com.autoassist.autoassist',
  );
}
