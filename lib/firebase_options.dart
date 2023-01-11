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
    apiKey: 'AIzaSyAliFun08TBPoRWvdp5mBKtM1cTzMM-I-w',
    appId: '1:497859891495:web:ef86541216bfcf39ea9902',
    messagingSenderId: '497859891495',
    projectId: 'chattapp-fitrayana',
    authDomain: 'chattapp-fitrayana.firebaseapp.com',
    storageBucket: 'chattapp-fitrayana.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCKjMXJ7OGvj2A2ozo3dHoPUzeAv71kzBg',
    appId: '1:497859891495:android:f1405a9ec08715caea9902',
    messagingSenderId: '497859891495',
    projectId: 'chattapp-fitrayana',
    storageBucket: 'chattapp-fitrayana.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyA0P7VwsKpsWPvbIW41pJy29n84-ijw2sU',
    appId: '1:497859891495:ios:a03757105b6ff12cea9902',
    messagingSenderId: '497859891495',
    projectId: 'chattapp-fitrayana',
    storageBucket: 'chattapp-fitrayana.appspot.com',
    androidClientId: '497859891495-u7abtkb00lfefr2i103sg6v5t15j2t08.apps.googleusercontent.com',
    iosClientId: '497859891495-6k6i46flgkg49uongqmogsr08i15c3na.apps.googleusercontent.com',
    iosBundleId: 'com.fitrayanaf15.appchat',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyA0P7VwsKpsWPvbIW41pJy29n84-ijw2sU',
    appId: '1:497859891495:ios:a03757105b6ff12cea9902',
    messagingSenderId: '497859891495',
    projectId: 'chattapp-fitrayana',
    storageBucket: 'chattapp-fitrayana.appspot.com',
    androidClientId: '497859891495-u7abtkb00lfefr2i103sg6v5t15j2t08.apps.googleusercontent.com',
    iosClientId: '497859891495-6k6i46flgkg49uongqmogsr08i15c3na.apps.googleusercontent.com',
    iosBundleId: 'com.fitrayanaf15.appchat',
  );
}
