Local autenticación, Face ID/Fingerprint
Esto agregará una línea como esta al pubspec.yaml de su paquete:

    dependencies:
      local_auth: ^2.1.6

Ahora en su código Dart, puede usar:

    import 'package:local_auth/local_auth.dart';

Este complemento de Flutter proporciona medios para realizar la autenticación local del usuario en el dispositivo.
En los dispositivos compatibles, esto incluye la autenticación con datos biométricos, como la huella dactilar o el reconocimiento facial.

| Android | iOS      | Windows |             |
| ------- | -------- | ------- | ----------- |
| Support | SDK 16+* | 11.0+   | Windows 10+ |

Integración de iOS
 

Tenga en cuenta que este complemento funciona tanto con Touch ID como con Face ID. Sin embargo, para usar este último, también debe agregar:


    <key>NSFaceIDUsageDescription</key>
    <string>Necesito permiso para poder autenticarte mediante FACE-ID</string>

a su archivo Info.plist. Si no lo hace, aparece un cuadro de diálogo que le dice al usuario que su aplicación no se ha actualizado para usar Face ID.



Integración de Android

El complemento se compilará y ejecutará en SDK 16+, pero `isDeviceSupported()`siempre devolverá falso antes de SDK 23 (Android 6.0).


    <manifest xmlns:android="http://schemas.android.com/apk/res/android"
              package="com.example.app">
      <uses-permission android:name="android.permission.USE_BIOMETRIC"/>
    <manifest>

Compatibiliad

En Android, solo puede verificar la existencia de hardware de huellas dactilares antes de API 29 (Android Q). Por lo tanto, si desea admitir otros tipos de datos biométricos (como el escaneo facial) y desea admitir SDK inferiores a Q, no llame al `getAvailableBiometrics`. Simplemente llame `authenticate`con `biometricOnly: true`. Esto devolverá un error si no hay hardware disponible.


Soluciones frente a la implementación en Android

Tenga en cuenta que el complemento local_auth requiere el uso de FragmentActivity en lugar de Activity. Esto se puede hacer fácilmente cambiando para usar FlutterFragmentActivity en lugar de FlutterActivity en su manifiesto (o su propia clase de actividad si está ampliando la clase base).

Cambien el FlutterActivity a FlutterFragmentActivity

Si recibe este error: `Exception has occurred. PlatformException (PlatformException(no_fragment_activity, local_auth plugin requires activity to be a FragmentActivity., null))`
Entonces tienes que hacer este paso. Cambiar `FlutterActivity`a `FlutterFragmentActivity`en `MainActivity.kt`.


    package com.[your.package]
    
    import androidx.annotation.NonNull;
    import io.flutter.embedding.android.FlutterFragmentActivity
    import io.flutter.embedding.engine.FlutterEngine
    import io.flutter.plugins.GeneratedPluginRegistrant
    
    class MainActivity: FlutterFragmentActivity() {
        override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
            GeneratedPluginRegistrant.registerWith(flutterEngine);
        }
    }


Problema Theme.AppCompat
    Si recibe este error: Exception has occurred. PlatformException (PlatformException(error, You need to use a Theme.AppCompat theme (or descendant) with this activity., null)) Entonces debe hacer esto:
            1. Ir aandroid>app>src>main>res>values>style.xml
            2. cambiar el <style name="LaunchTheme" parent="@android:style/Theme.Black.NoTitleBar">a<style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
