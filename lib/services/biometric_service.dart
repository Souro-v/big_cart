import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  // Biometric available check
  Future<bool> isAvailable() async {
    try {
      return await _auth.canCheckBiometrics &&
          await _auth.isDeviceSupported();
    } catch (e) {
      return false;
    }
  }

  // Authenticate
  Future<bool> authenticate() async {
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate to login to Big Cart',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}