// lib/services/permission_service.dart
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestAudioPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  static Future<bool> checkAudioPermission() async {
    return await Permission.microphone.status.isGranted;
  }
}
