// lib/services/call_service.dart
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

class CallService {
  static const String appId = "f3a253ad35d54872921cc964a0ca7cf2";
  static RtcEngine? _engine;

  static Future<bool> initializeAgora() async {
    try {
      if (_engine != null) return true;

      _engine = createAgoraRtcEngine();
      await _engine!.initialize(const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ));

      await _engine!.enableAudio();
      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      return true;
    } catch (e) {
      print('Error initializing Agora: $e');
      return false;
    }
  }

  static Future<bool> joinCall(
      String token, String channelName, int uid) async {
    try {
      if (_engine == null) {
        bool initialized = await initializeAgora();
        if (!initialized) return false;
      }

      await _engine!.joinChannel(
        token: token,
        channelId: channelName,
        uid: uid,
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
        ),
      );

      return true;
    } catch (e) {
      print('Error joining call: $e');
      return false;
    }
  }

  static Future<void> leaveCall() async {
    await _engine?.leaveChannel();
  }

  static void toggleMute(bool muted) {
    _engine?.muteLocalAudioStream(muted);
  }

  static void toggleSpeakerphone(bool enabled) {
    _engine?.setEnableSpeakerphone(enabled);
  }
}
