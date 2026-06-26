import 'package:firebase_core/firebase_core.dart';
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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCvnfSDAwZKqjBSvaqdNN0j4u4DBNLag80',
    appId: '1:328881203269:web:5a096f9e8a76377554db2c',
    messagingSenderId: '328881203269',
    projectId: 'fit-axis-web',
    authDomain: 'fit-axis-web.firebaseapp.com',
    storageBucket: 'fit-axis-web.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCvnfSDAwZKqjBSvaqdNN0j4u4DBNLag80',
    appId: '1:328881203269:android:ac72ebba30dd066554db2c',
    messagingSenderId: '328881203269',
    projectId: 'fit-axis-web',
    storageBucket: 'fit-axis-web.firebasestorage.app',
  );
}
