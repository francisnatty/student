import 'dart:async';
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

class IncomingVideoCallScreen extends StatefulWidget {
  final String callerId;
  final String channelName;

  const IncomingVideoCallScreen({
    super.key,
    required this.callerId,
    required this.channelName,
  });

  @override
  State<IncomingVideoCallScreen> createState() =>
      _IncomingVideoCallScreenState();
}

class _IncomingVideoCallScreenState extends State<IncomingVideoCallScreen> {
  RtcEngine? _engine;
  bool _isJoined = false;
  int? _remoteUid;
  String? _agoraToken;
  final String appId =
      "f3a253ad35d54872921cc964a0ca7cf2"; // Replace with your Agora App ID

  @override
  void initState() {
    super.initState();
    _fetchToken();
  }

  Future<void> _fetchToken() async {
    final callProvider = Provider.of<CallProvider>(context, listen: false);
    int userId = context.account.user!.id;

    await callProvider.fetchAgoraToken(userId, widget.channelName);

    if (callProvider.agoraToken != null) {
      _agoraToken = callProvider.agoraToken;
    } else {
      // Handle error
      print("Failed to get Agora token");
    }
  }

  Future<void> _initAgoraEngine(String token) async {
    await [Permission.microphone, Permission.camera].request();

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
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          print('Remote user $remoteUid left channel');
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    int userId = context.account.user!.id;

    await _engine!.startPreview();

    await _engine!.joinChannel(
      token: token,
      channelId: widget.channelName,
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
              connection: RtcConnection(channelId: widget.channelName),
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
    // Implement audio mute functionality
  }

  void _onToggleMuteVideo() {
    // Implement video mute functionality
  }

  void _onSwitchCamera() {
    _engine?.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Similar UI to VideoCallScreen with adjustments
      body: Stack(
        children: [
          // Main video view
          _renderLocalPreview(),
          // Remote video view
          _renderRemoteVideo(),
          // Accept call and controls
          if (!_isJoined)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Container(
                  height: 188.h,
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
                      // Decline button
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 42.r,
                              backgroundColor: AppColors.phoneRed,
                              child: Center(
                                child: SvgPicture.asset(
                                  AppAssets.phoneBold,
                                  height: 28.h,
                                ),
                              ),
                            ),
                            5.verticalSpace,
                            Text(
                              "Decline",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      // Accept button
                      GestureDetector(
                        onTap: () {
                          if (_agoraToken != null) {
                            _initAgoraEngine(_agoraToken!);
                          } else {
                            // Show loading or error
                            print("Token not ready");
                          }
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50.r,
                              backgroundColor: Color(0xFF27AE60),
                              child: Center(
                                child: Transform.rotate(
                                  angle: -90,
                                  child: SvgPicture.asset(
                                    AppAssets.phoneBold,
                                    height: 38.h,
                                  ),
                                ),
                              ),
                            ),
                            5.verticalSpace,
                            Text(
                              "Tap to accept",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      // Message button
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 42.r,
                            backgroundColor: AppColors.blackThree,
                            child: Center(
                              child: SvgPicture.asset(
                                AppAssets.messageBold,
                                height: 28.h,
                              ),
                            ),
                          ),
                          5.verticalSpace,
                          Text(
                            "Message",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          // Control panel when call is active
          if (_isJoined)
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
                        backgroundColor: AppColors.blackThree,
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
                        backgroundColor: AppColors.blackThree,
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
