// lib/features/chats/screens/chat_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
// Removed the SVG import since it's no longer needed for the avatar
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/chats/models/chat_user.dart';
import 'package:student_centric_app/features/chats/module/chat_option.dart';
import 'package:student_centric_app/features/chats/providers/chat_provider.dart';
import 'package:student_centric_app/features/chats/screens/individual_chat_screen.dart';
import 'package:student_centric_app/features/chats/screens/status.dart';
import 'package:student_centric_app/features/home/bloc/home_bloc.dart';
import 'package:student_centric_app/widgets/app_textfield.dart';

import '../../../core/utils/bottom_sheets.dart';
import '../../auth/providers/auth_provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch chats when the screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().add(GetStatus());
      // Provider.of<ChatProvider>(context, listen: false).fetchChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Chats',
          style: TextStyle(
            color: AppColors.blackFour,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            AppTextfield.regular(
              hintText: 'Search',
              prefixIcon: IconButton(
                icon: SvgPicture.asset(AppAssets.inactiveSearchIcon),
                onPressed: () {},
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              "Status",
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.blackThree,
              ),
            ),
            SizedBox(height: 15.h),
            // Status section
            SizedBox(
              height: 90.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  StatusView()
                  // _StatusAvatar(
                  //   name: "Samuel Salami",
                  //   imageUrl: "assets/images/avatar.png",
                  //   statusCount: 3,
                  // ),
                ],
              ),
            ),
            SizedBox(height: 16.h),

            // Chat list
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  // if (chatProvider.isLoading) {
                  //   return const Center(child: CircularProgressIndicator());
                  // }
                  if (chatProvider.errorMessage != null) {
                    return Center(
                      child: Text(
                        chatProvider.errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 16.sp),
                      ),
                    );
                  } else if (chatProvider.chats.isEmpty) {
                    return Center(
                      child: Text(
                        'No chats available.',
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    );
                  } else {
                    return Skeletonizer(
                      enabled: chatProvider.isLoading,
                      ignoreContainers: true,
                      child: ListView.builder(
                        itemCount: chatProvider.chats.length,
                        itemBuilder: (context, index) {
                          final ChatUser chatUser = chatProvider.chats[index];
                          return GestureDetector(
                            onTap: () {
                              var authProvider = Provider.of<AuthProvider>(
                                      context,
                                      listen: false)
                                  .user;
                              var receiverId = chatUser.id;
                              print("receiver id => $receiverId");
                              int senderId = authProvider?.id ?? 0;
                              Provider.of<ChatProvider>(context, listen: false)
                                  .fetchConversation(
                                      messageId: "${senderId}_${chatUser.id}");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => IndividualChatScreen(
                                    chatUser: chatUser,
                                  ),
                                ),
                              );
                            },
                            child: ChatListTile(
                              name: _getUserName(chatUser),
                              message:
                                  "Hello!", // Placeholder, replace with actual data
                              time:
                                  "Now", // Placeholder, replace with actual data
                              // Removed imageUrl since we're not using it
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getUserName(ChatUser user) {
    if (user.firstName != null && user.lastName != null) {
      return '${user.firstName} ${user.lastName}';
    } else {
      return user.email;
    }
  }
}

class ChatListTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  // Removed imageUrl parameter
  // final String imageUrl;

  const ChatListTile({
    super.key,
    required this.name,
    required this.message,
    required this.time,
    // this.imageUrl, // Removed
  });

  // Method to generate initials from the name
  String _getInitials(String name) {
    List<String> names = name.trim().split(' ');
    String initials = '';
    if (names.length >= 2) {
      initials = names[0][0] + names[1][0];
    } else if (names.length == 1) {
      initials = names[0][0];
    }
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final String initials = _getInitials(name);

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 1.w),
      leading: CircleAvatar(
        radius: 24.r,
        backgroundColor: AppColors.primaryThree, // Fixed color for all avatars
        child: Text(
          initials,
          style: TextStyle(
            color: Colors.white, // Text color
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
          ),
        ),
      ),
      title: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
      ),
      subtitle: Text(
        message,
        style: TextStyle(
          fontSize: 12.sp,
          color: AppColors.blackFour,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          GestureDetector(
              onTap: () {
                CustomBottomSheet.show(
                  context: context,
                  content: const ChatOption(),
                );
              },
              child: SvgPicture.asset(AppAssets.moreHoriz)),
          Text(
            time,
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.blackFour,
            ),
          ),
        ],
      ),
    );
  }
}

// Existing widgets (_StatusAvatar and ChatListTile) remain unchanged

// Custom Painter to draw the segmented border
class StatusBorderPainter extends CustomPainter {
  final int statusCount;
  final Color color;
  final double strokeWidth;

  StatusBorderPainter({
    required this.statusCount,
    required this.color,
    this.strokeWidth = 4, // Increased from 2 to 4
  });

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    Offset center = Offset(radius, radius);
    Rect rect =
        Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    double gapSize = 12; // Increased from 2 to 4 degrees
    double totalGaps = statusCount * gapSize;
    double sweepAngle = (360 - totalGaps) / statusCount;
    double startAngle = -90; // Starting from the top

    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < statusCount; i++) {
      double currentStartAngle = startAngle + i * (sweepAngle + gapSize);
      canvas.drawArc(
        rect,
        _degreesToRadians(currentStartAngle),
        _degreesToRadians(sweepAngle),
        false,
        paint,
      );
    }
  }

  double _degreesToRadians(double degrees) {
    return degrees * (3.1415926535 / 180);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
