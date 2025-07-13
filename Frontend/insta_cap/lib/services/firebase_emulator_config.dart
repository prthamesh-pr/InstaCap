import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseEmulatorConfig {
  static bool _emulatorsConnected = false;

  static Future<void> connectToEmulators() async {
    if (kDebugMode && !_emulatorsConnected) {
      try {
        // Connect to Authentication emulator
        await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

        // Connect to Firestore emulator
        FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

        // Connect to Storage emulator
        await FirebaseStorage.instance.useStorageEmulator('localhost', 9199);

        _emulatorsConnected = true;
        print('🚀 Connected to Firebase emulators');
      } catch (e) {
        print('⚠️ Could not connect to Firebase emulators: $e');
        print('💡 Continuing with standard Firebase configuration');
        print('💡 To use emulators, run: firebase emulators:start --only auth,firestore,storage');
      }
    }
  }

  static bool get emulatorsConnected => _emulatorsConnected;
}
