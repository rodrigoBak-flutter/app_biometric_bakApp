import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/error_codes.dart' as error_code;
import 'package:local_auth/local_auth.dart';
import 'package:local_auth_android/local_auth_android.dart';
import 'package:local_auth_ios/local_auth_ios.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isDeviceSupport = false;
  List<BiometricType>? availableBiometrics;
  LocalAuthentication? auth;

  @override
  void initState() {
    super.initState();

    auth = LocalAuthentication();

    deviceCapability();
    _getAvailableBiometrics();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }

  Future<void> _getAvailableBiometrics() async {
    try {
      availableBiometrics = await auth?.getAvailableBiometrics();
      print("bioMetric: $availableBiometrics");

      if (availableBiometrics!.contains(BiometricType.strong) ||
          availableBiometrics!.contains(BiometricType.fingerprint)) {
        final bool didAuthenticate = await auth!.authenticate(
            localizedReason:
                'Desbloquee su pantalla con su huella digital',
            options: const AuthenticationOptions(
                biometricOnly: true, stickyAuth: true),
            authMessages: <AuthMessages>[
              AndroidAuthMessages(
                signInTitle: 'Desbloquear',
                cancelButton: 'No gracias',
              ),
              IOSAuthMessages(
                cancelButton: 'No gracias',
              ),
            ]);
        if (!didAuthenticate) {
          exit(0);
        }
      } else if (availableBiometrics!.contains(BiometricType.weak) ||
          availableBiometrics!.contains(BiometricType.face)) {
        final bool didAuthenticate = await auth!.authenticate(
            localizedReason:
                'Desbloquee su pantalla con su huella digital',
            options: const AuthenticationOptions(stickyAuth: true),
            authMessages: <AuthMessages>[
              AndroidAuthMessages(
                signInTitle: 'Desbloquear',
                cancelButton: 'No gracias',
              ),
              IOSAuthMessages(
                cancelButton: 'No gracias',
              ),
            ]);
        if (!didAuthenticate) {
          exit(0);
        }
      }
    } on PlatformException catch (e) {
      // availableBiometrics = <BiometricType>[];
      if (e.code == error_code.passcodeNotSet) {
        exit(0);
      }
      print("error: $e");
    }
  }

  void deviceCapability() async {
    final bool isCapable = await auth!.canCheckBiometrics;
    isDeviceSupport = isCapable || await auth!.isDeviceSupported();
  }
}
