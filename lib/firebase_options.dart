import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAkCxgdgeQ-XloAWDH-QYPvyYjHbTML0iM',
    appId: '1:373334901454:android:fced9f7be43a619b57869f',
    messagingSenderId: '373334901454',
    projectId: 'fulttermedicine',
    storageBucket: 'fulttermedicine.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAkCxgdgeQ-XloAWDH-QYPvyYjHbTML0iM',
    appId: '1:373334901454:android:fced9f7be43a619b57869f',
    messagingSenderId: '373334901454',
    projectId: 'fulttermedicine',
    storageBucket: 'fulttermedicine.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAkCxgdgeQ-XloAWDH-QYPvyYjHbTML0iM',
    appId: '1:373334901454:android:fced9f7be43a619b57869f',
    messagingSenderId: '373334901454',
    projectId: 'fulttermedicine',
    storageBucket: 'fulttermedicine.appspot.com',
    iosBundleId: 'com.example.medicineProject',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAkCxgdgeQ-XloAWDH-QYPvyYjHbTML0iM',
    appId: '1:373334901454:android:fced9f7be43a619b57869f',
    messagingSenderId: '373334901454',
    projectId: 'fulttermedicine',
    storageBucket: 'fulttermedicine.appspot.com',
    iosBundleId: 'com.example.medicineProject',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAkCxgdgeQ-XloAWDH-QYPvyYjHbTML0iM',
    appId: '1:373334901454:android:fced9f7be43a619b57869f',
    messagingSenderId: '373334901454',
    projectId: 'fulttermedicine',
    storageBucket: 'fulttermedicine.appspot.com',
  );

}