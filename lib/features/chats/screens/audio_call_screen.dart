import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/extensions/account_extension.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/auth/providers/auth_provider.dart';
import 'package:student_centric_app/features/chats/providers/call_provider.dart';
import 'package:student_centric_app/widgets/padding_widget.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AudioCallScreen extends StatefulWidget {
  final String personToCallId;
  const AudioCallScreen({super.key, required this.personToCallId});

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  RtcEngine? _engine;
  bool _isJoined = false;
  int? _remoteUid;
  String? _agoraToken;
  bool _isCallActive = false; // To manage call status
  final String channelName = "Caller123"; // Default channel name
  final String appId =
      "f3a253ad35d54872921cc964a0ca7cf2"; // Replace with your Agora App ID

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
    await [Permission.microphone].request();

    final callProvider = Provider.of<CallProvider>(context, listen: false);
    int userId = context.account.user!.id;

    await callProvider.fetchAgoraToken(userId, channelName);
    await callProvider.initiateCall(
        callId: generateCallId(),
        senderId: context.account.user!.id,
        receiverId: int.parse(widget.personToCallId),
        type: "audio",
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

    await _engine!.joinChannel(
      token: token,
      channelId: channelName,
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
    // Your existing UI code with minor adjustments
    return Scaffold(
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
                _isCallActive
                    ? Container(
                        height: 50.h,
                        width: 113.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.r),
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: Center(
                          child: Text(
                            "In Call",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(),
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
            ).padHorizontal,
            Text(
              "Daenerys\nTargaryen",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 36.sp,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            _isCallActive
                ? SizedBox()
                : Text(
                    "Calling...",
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
                    // Mute button
                    CircleAvatar(
                      radius: 32.r,
                      backgroundColor: AppColors.blackThree,
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.microphoneBold,
                          height: 28.h,
                        ),
                      ),
                    ),
                    // Video button (optional)
                    CircleAvatar(
                      radius: 32.r,
                      backgroundColor: AppColors.blackThree,
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.videoBold,
                          height: 28.h,
                        ),
                      ),
                    ),
                    // Speaker button
                    CircleAvatar(
                      radius: 32.r,
                      backgroundColor: AppColors.blackThree,
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.speakerBold,
                          height: 28.h,
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


// lib/screens/home_screen.dart
// import 'package:agora_rtc_engine/agora_rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:student_centric_app/core/extensions/account_extension.dart';
// import '../providers/call_provider.dart';

// class AudioCallScreen extends StatefulWidget {
//   @override
//   _AudioCallScreenState createState() => _AudioCallScreenState();
// }

// class _AudioCallScreenState extends State<AudioCallScreen> {
//   final TextEditingController _channelController = TextEditingController();

//   void _startCall() async {
//     final int currentUserId =
//         context.account.user!.id; // Replace with actual user ID logic

//     final channelName = _channelController.text.trim();
//     if (channelName.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter a channel name')),
//       );
//       return;
//     }

//     final callProvider = Provider.of<CallProvider>(context, listen: false);
//     await callProvider.fetchAgoraToken(currentUserId, channelName);

//     if (callProvider.agoraToken != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => CallScreen(
//             channelName: channelName,
//             userId: currentUserId,
//           ),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//             content: Text(callProvider.errorMessage ?? 'Error fetching token')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final callProvider = Provider.of<CallProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Agora Voice Call'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _channelController,
//               decoration: InputDecoration(
//                 labelText: 'Channel Name',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             callProvider.isLoading
//                 ? CircularProgressIndicator()
//                 : ElevatedButton(
//                     onPressed: _startCall,
//                     child: Text('Start Call'),
//                   ),
//             if (callProvider.errorMessage != null) ...[
//               SizedBox(height: 20),
//               Text(
//                 callProvider.errorMessage!,
//                 style: TextStyle(color: Colors.red),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }
// }

// class CallScreen extends StatefulWidget {
//   final String channelName;
//   final int userId;

//   CallScreen({required this.channelName, required this.userId});

//   @override
//   _CallScreenState createState() => _CallScreenState();
// }

// class _CallScreenState extends State<CallScreen> {
//   late RtcEngine _engine;
//   int? _remoteUid;
//   bool _localUserJoined = false;
//   bool _isInitialized = false;

//   @override
//   void initState() {
//     super.initState();
//     initializeAgora();
//   }

//   Future<void> initializeAgora() async {
//     // Request microphone permission
//     await [Permission.microphone].request();

//     // Fetch token from CallProvider
//     final callProvider = Provider.of<CallProvider>(context, listen: false);
//     if (callProvider.agoraToken == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Token not available')),
//       );
//       Navigator.pop(context);
//       return;
//     }

//     // Initialize Agora SDK
//     _engine = createAgoraRtcEngine();
//     await _engine.initialize(RtcEngineContext(
//       appId: 'f3a253ad35d54872921cc964a0ca7cf2',
//       channelProfile: ChannelProfileType.channelProfileCommunication,
//     ));

//     // Register event handlers
//     _engine.registerEventHandler(
//       RtcEngineEventHandler(
//         onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
//           debugPrint('Local user ${connection.localUid} joined');
//           setState(() {
//             _localUserJoined = true;
//           });
//         },
//         onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
//           debugPrint('Remote user $remoteUid joined');
//           setState(() {
//             _remoteUid = remoteUid;
//           });
//         },
//         onUserOffline: (RtcConnection connection, int remoteUid,
//             UserOfflineReasonType reason) {
//           debugPrint('Remote user $remoteUid left channel');
//           setState(() {
//             _remoteUid = null;
//           });
//         },
//       ),
//     );

//     // Join the channel
//     await _engine.joinChannel(
//       token: callProvider.agoraToken!,
//       channelId: widget.channelName,
//       uid: widget.userId,
//       options: ChannelMediaOptions(
//         autoSubscribeAudio: true,
//         publishMicrophoneTrack: true,
//         clientRoleType: ClientRoleType.clientRoleBroadcaster,
//       ),
//     );

//     setState(() {
//       _isInitialized = true;
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _disposeAgora();
//   }

//   Future<void> _disposeAgora() async {
//     await _engine.leaveChannel();
//     await _engine.release();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Channel: ${widget.channelName}'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.call_end),
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: _isInitialized
//             ? Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                       _localUserJoined ? 'You are connected' : 'Connecting...'),
//                   SizedBox(height: 20),
//                   if (_remoteUid != null) Text('Remote User UID: $_remoteUid'),
//                 ],
//               )
//             : CircularProgressIndicator(),
//       ),
//     );
//   }
// }
