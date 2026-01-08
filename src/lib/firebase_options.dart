import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCGCRXSPGjC128hpSNDWooEjSUio_tNMrc',
    appId: '1:70815717992:web:75a4fac689c1ec9b45f9dd',
    messagingSenderId: '70815717992',
    projectId: 'civic-snap-5a0ba',
    authDomain: 'civic-snap-5a0ba.firebaseapp.com',
    storageBucket: 'civic-snap-5a0ba.firebasestorage.app',
    measurementId: 'G-56P6J8JBPD',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB4UEwmTwXSoWvsn2UvI7u3RSy5Qn75znE',
    appId: '1:70815717992:android:e495dd8f9a1394b845f9dd',
    messagingSenderId: '70815717992',
    projectId: 'civic-snap-5a0ba',
    storageBucket: 'civic-snap-5a0ba.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyChV9OPfgWS779HiRvsqHy8Qcvm6wHPLy4',
    appId: '1:70815717992:ios:1b420b914fc58c7045f9dd',
    messagingSenderId: '70815717992',
    projectId: 'civic-snap-5a0ba',
    storageBucket: 'civic-snap-5a0ba.firebasestorage.app',
    iosBundleId: 'com.example.src',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyChV9OPfgWS779HiRvsqHy8Qcvm6wHPLy4',
    appId: '1:70815717992:ios:1b420b914fc58c7045f9dd',
    messagingSenderId: '70815717992',
    projectId: 'civic-snap-5a0ba',
    storageBucket: 'civic-snap-5a0ba.firebasestorage.app',
    iosBundleId: 'com.example.src',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCGCRXSPGjC128hpSNDWooEjSUio_tNMrc',
    appId: '1:70815717992:web:86e00cda69f3fc8245f9dd',
    messagingSenderId: '70815717992',
    projectId: 'civic-snap-5a0ba',
    authDomain: 'civic-snap-5a0ba.firebaseapp.com',
    storageBucket: 'civic-snap-5a0ba.firebasestorage.app',
    measurementId: 'G-3N5P2K6YZS',
  );
}
