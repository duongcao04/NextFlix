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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCWxi009ybetDAyrTTyw5Sel4OtzgXVti4',
    appId: '1:216107978984:android:3fbc81aa0ef8e5641a795d',
    messagingSenderId: '216107978984',
    projectId: 'nextflix-1b121',
    storageBucket: 'nextflix-1b121.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyABi263e9v3p7WNH5LllzmZYaC7mUaCS4g',
    appId: '1:216107978984:ios:a9a2acd9d8e5ba1b1a795d',
    messagingSenderId: '216107978984',
    projectId: 'nextflix-1b121',
    storageBucket: 'nextflix-1b121.firebasestorage.app',
    iosBundleId: 'com.example.nextflit',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCU0PcgMNtoBjLKYWHPC9sMF3Vap9-Yb8Y',
    appId: '1:216107978984:web:2d8910c57ae490f11a795d',
    messagingSenderId: '216107978984',
    projectId: 'nextflix-1b121',
    authDomain: 'nextflix-1b121.firebaseapp.com',
    storageBucket: 'nextflix-1b121.firebasestorage.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyABi263e9v3p7WNH5LllzmZYaC7mUaCS4g',
    appId: '1:216107978984:ios:a9a2acd9d8e5ba1b1a795d',
    messagingSenderId: '216107978984',
    projectId: 'nextflix-1b121',
    storageBucket: 'nextflix-1b121.firebasestorage.app',
    iosBundleId: 'com.example.nextflit',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCU0PcgMNtoBjLKYWHPC9sMF3Vap9-Yb8Y',
    appId: '1:216107978984:web:4b41d10275a1720a1a795d',
    messagingSenderId: '216107978984',
    projectId: 'nextflix-1b121',
    authDomain: 'nextflix-1b121.firebaseapp.com',
    storageBucket: 'nextflix-1b121.firebasestorage.app',
  );
}
