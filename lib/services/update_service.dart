import 'package:package_info_plus/package_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateService {
  Future<Map<String, dynamic>?> checkUpdate() async {
    try {
      final info = await PackageInfo.fromPlatform();
      final currentVersion = info.version;

      final doc = await FirebaseFirestore.instance
          .collection('app_config')
          .doc('version')
          .get();

      if (!doc.exists) return null;

      final latestVersion = doc.data()?['latest_version'] as String?;
      final isForced = doc.data()?['force_update'] as bool? ?? false;
      final updateUrl = doc.data()?['update_url'] as String? ?? '';

      if (latestVersion != null && latestVersion != currentVersion) {
        return {
          'hasUpdate': true,
          'latestVersion': latestVersion,
          'currentVersion': currentVersion,
          'isForced': isForced,
          'updateUrl': updateUrl,
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}