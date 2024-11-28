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

class IncomingCallScreen extends StatefulWidget {
  final String callerId;
  final String channelName;

  const IncomingCallScreen({
    super.key,
    required this.callerId,
    required this.channelName,
  });

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
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
    await [Permission.microphone].request();

    _engine = await createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

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

    await _engine!.joinChannel(
      token: token,
      channelId: widget.channelName,
      options: ChannelMediaOptions(
        autoSubscribeAudio: true,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Your existing UI code with minor adjustments
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppAssets.callBackground),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Column(
          children: [
            50.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: AppColors.greyTwo,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_back,
                        size: 24.h,
                      ),
                    ),
                  ),
                ),
              ],
            ).padHorizontal,
            Text(
              "Samuel\nSalami",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Text(
              "Incoming...",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                color: Colors.white,
              ),
            ),
            40.verticalSpace,
            CircleAvatar(
              radius: 95.r,
              backgroundImage: AssetImage("assets/images/avatar.png"),
            ),
            Spacer(),
            Padding(
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
                          ),
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
                          ),
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
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ).padHorizontal,
          ],
        ),
      ),
    );
  }
}
