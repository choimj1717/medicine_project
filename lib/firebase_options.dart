import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import '../config/api_keys.dart';

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
    apiKey: Forebase_Key.firebaseApiKey,
    appId: Forebase_Key.firebaseAppId,
    messagingSenderId: Forebase_Key.firebaseMessagingSenderId,
    projectId: Forebase_Key.firebaseProjectId,
    storageBucket: Forebase_Key.firebaseStorageBucket,
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: Forebase_Key.firebaseApiKey,
    appId: Forebase_Key.firebaseAppId,
    messagingSenderId: Forebase_Key.firebaseMessagingSenderId,
    projectId: Forebase_Key.firebaseProjectId,
    storageBucket: Forebase_Key.firebaseStorageBucket,
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: Forebase_Key.firebaseApiKey,
    appId: Forebase_Key.firebaseAppId,
    messagingSenderId: Forebase_Key.firebaseMessagingSenderId,
    projectId: Forebase_Key.firebaseProjectId,
    storageBucket: Forebase_Key.firebaseStorageBucket,
    iosBundleId: Forebase_Key.iosBundleId,
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: Forebase_Key.firebaseApiKey,
    appId: Forebase_Key.firebaseAppId,
    messagingSenderId: Forebase_Key.firebaseMessagingSenderId,
    projectId: Forebase_Key.firebaseProjectId,
    storageBucket: Forebase_Key.firebaseStorageBucket,
    iosBundleId: Forebase_Key.iosBundleId,
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: Forebase_Key.firebaseApiKey,
    appId: Forebase_Key.firebaseAppId,
    messagingSenderId: Forebase_Key.firebaseMessagingSenderId,
    projectId: Forebase_Key.firebaseProjectId,
    storageBucket: Forebase_Key.firebaseStorageBucket,
  );

}