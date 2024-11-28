import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/extensions/account_extension.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/chats/providers/call_provider.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class VideoCallScreen extends StatefulWidget {
  final String personToCallId;
  const VideoCallScreen({super.key, required this.personToCallId});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  RtcEngine? _engine;
  bool _isJoined = false;
  int? _remoteUid;
  String? _agoraToken;
  bool _isCallActive = false; // To manage call status
  final String channelName = "Caller123"; // Default channel name
  final String appId =
      "f3a253ad35d54872921cc964a0ca7cf2"; // Replace with your Agora App ID

  bool _isLocalVideoMuted = false;
  bool _isLocalAudioMuted = false;
  bool _isSpeakerEnabled = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  int generateCallId() {
    final random = Random();
    bool isFiveDigits = random.nextBool();

    if (isFiveDigits) {
      return 10000 + random.nextInt(90000); // 10000 to 99999
    } else {
      return 1000 + random.nextInt(9000); // 1000 to 9999
    }
  }

  Future<void> _init() async {
    await [Permission.microphone, Permission.camera].request();

    final callProvider = Provider.of<CallProvider>(context, listen: false);
    int userId = context.account.user!.id;

    await callProvider.fetchAgoraToken(userId, channelName);
    await callProvider.initiateCall(
        callId: generateCallId(),
        senderId: context.account.user!.id,
        receiverId: int.parse(widget.personToCallId),
        type: "video",
        channelName: channelName);

    if (callProvider.agoraToken != null) {
      _agoraToken = callProvider.agoraToken;
      _initAgoraEngine(_agoraToken!);
    } else {
      // Handle error
      print("Failed to get Agora token");
    }
  }

  Future<void> _initAgoraEngine(String token) async {
    _engine = await createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    // Enable video
    await _engine!.enableVideo();

    // Set up event handlers
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          print('Local user ${connection.localUid} joined');
          setState(() {
            _isJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          print('Remote user $remoteUid joined');
          setState(() {
            _remoteUid = remoteUid;
            _isCallActive = true;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          print('Remote user $remoteUid left channel');
          setState(() {
            _remoteUid = null;
            _isCallActive = false;
          });
        },
      ),
    );

    int userId = context.account.user!.id;

    await _engine!.startPreview();

    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
      options: ChannelMediaOptions(
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
      uid: userId,
    );
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }

  Widget _renderLocalPreview() {
    if (_isJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine!,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return Center(
        child: Text(
          'Joining call...',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Widget _renderRemoteVideo() {
    if (_remoteUid != null) {
      return Positioned(
        top: 50,
        right: 20,
        width: 120,
        height: 160,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
          ),
          child: AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: _engine!,
              canvas: VideoCanvas(uid: _remoteUid),
              connection: RtcConnection(channelId: channelName),
            ),
          ),
        ),
      );
    } else {
      return Positioned(
        top: 50,
        right: 20,
        width: 120,
        height: 160,
        child: Container(
          color: Colors.black54,
          child: Center(
            child: Text(
              'Waiting for user...',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      );
    }
  }

  void _onToggleMuteAudio() {
    setState(() {
      _isLocalAudioMuted = !_isLocalAudioMuted;
    });
    _engine?.muteLocalAudioStream(_isLocalAudioMuted);
  }

  void _onToggleMuteVideo() {
    setState(() {
      _isLocalVideoMuted = !_isLocalVideoMuted;
    });
    _engine?.muteLocalVideoStream(_isLocalVideoMuted);
  }

  void _onSwitchCamera() {
    _engine?.switchCamera();
  }

  void _onToggleSpeaker() {
    setState(() {
      _isSpeakerEnabled = !_isSpeakerEnabled;
    });
    _engine?.setEnableSpeakerphone(_isSpeakerEnabled);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main video view (local or remote)
          _renderLocalPreview(),
          // Remote video view (small window)
          _renderRemoteVideo(),
          // Top bar with minimize and add participant buttons
          Positioned(
            top: 50.h,
            left: 20.w,
            right: 20.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Minimize button
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.greyTwo,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.minimizeIcon,
                      height: 30.h,
                    ),
                  ),
                ),
                // Add participant button
                Container(
                  width: 50.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.greyTwo,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.profileAdd,
                      height: 30.h,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bottom control panel
          Positioned(
            bottom: 30.h,
            left: 20.w,
            right: 20.w,
            child: Container(
              height: 112.h,
              padding: EdgeInsets.symmetric(
                horizontal: 25.w,
              ),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(50.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Mute audio button
                  GestureDetector(
                    onTap: _onToggleMuteAudio,
                    child: CircleAvatar(
                      radius: 32.r,
                      backgroundColor: _isLocalAudioMuted
                          ? Colors.red
                          : AppColors.blackThree,
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.microphoneBold,
                          height: 28.h,
                        ),
                      ),
                    ),
                  ),
                  // Mute video button
                  GestureDetector(
                    onTap: _onToggleMuteVideo,
                    child: CircleAvatar(
                      radius: 32.r,
                      backgroundColor: _isLocalVideoMuted
                          ? Colors.red
                          : AppColors.blackThree,
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.videoBold,
                          height: 28.h,
                        ),
                      ),
                    ),
                  ),
                  // Switch camera button
                  GestureDetector(
                    onTap: _onSwitchCamera,
                    child: CircleAvatar(
                      radius: 32.r,
                      backgroundColor: AppColors.blackThree,
                      child: Center(
                        child: Icon(
                          Icons.cameraswitch,
                          color: Colors.white,
                          size: 28.h,
                        ),
                      ),
                    ),
                  ),
                  // End call button
                  GestureDetector(
                    onTap: () {
                      _engine?.leaveChannel();
                      Navigator.pop(context);
                    },
                    child: CircleAvatar(
                      radius: 32.r,
                      backgroundColor: AppColors.phoneRed,
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.phoneBold,
                          height: 28.h,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
