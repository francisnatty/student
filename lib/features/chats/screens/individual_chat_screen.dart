import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/extensions/account_extension.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/chats/models/chat_user.dart';
import 'package:student_centric_app/features/chats/screens/audio_call_screen.dart';
import 'package:student_centric_app/features/chats/screens/video_call_screen.dart';

class IndividualChatScreen extends StatelessWidget {
  final ChatUser chatUser;
  const IndividualChatScreen({
    super.key,
    required this.chatUser,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: AppColors.primaryFive,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/avatar.png',
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatUser.firstName ?? chatUser.email,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
          leading: IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Container(
              width: 55.w,
              height: 55.h,
              decoration: BoxDecoration(
                color: AppColors.greyTwo,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.back,
                size: 18.h,
                color: Colors.black,
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: SvgPicture.asset(
                AppAssets.phoneIcon,
                height: 20.h,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AudioCallScreen(
                      personToCallId: chatUser.id.toString(),
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                AppAssets.videoIcon,
                height: 20.h,
              ),
              onPressed: () {
                context.push(VideoCallScreen(
                  personToCallId: chatUser.id.toString(),
                ));
              },
            ),
            IconButton(
              icon: SvgPicture.asset(
                AppAssets.moreHoriz,
                height: 20.h,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: ChatBody(),
      ),
    );
  }
}

class ChatBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 20),
            children: [
              ChatBubble(
                text:
                    "You should visit Lake Jaisalmer it's amazing place ever!!! 😍",
                isSender: false,
                time: '20:53',
              ),
              ChatBubble(
                text: "Thank you!!! 🙌",
                isSender: true,
                time: '20:54',
                backgroundColor: AppColors.primaryColor,
                textColor: Colors.white,
              ),
              ChatImageBubble(
                imageUrl:
                    'assets/images/test_post_image.png', // Replace with actual image path
                time: '21:03',
              ),
              ChatBubble(
                text: "What do you use specifically to take the drone shots?",
                isSender: true,
                time: '21:05',
                backgroundColor: AppColors.primaryColor,
                textColor: Colors.white,
              ),
              ChatBubble(
                text: "I would done the same thing when i won the lottery ;))",
                isSender: false,
                time: '20:53',
              ),
              ChatBubble(
                text:
                    "I would done the same thing when i won the lottery ;))\nLol",
                isSender: true,
                time: '21:05',
                backgroundColor: AppColors.primaryColor,
                textColor: Colors.white,
                highlightedText: 'Tyrion Lannister',
              ),
            ],
          ),
        ),
        MessageInputField(),
      ],
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isSender;
  final String time;
  final Color backgroundColor;
  final Color textColor;
  final String? highlightedText;

  const ChatBubble({
    required this.text,
    required this.isSender,
    required this.time,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.highlightedText,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        padding: EdgeInsets.all(12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            highlightedText != null
                ? Text(
                    highlightedText!,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.yellow),
                  )
                : SizedBox.shrink(),
            Text(
              text,
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            SizedBox(height: 5),
            Text(
              time,
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatImageBubble extends StatelessWidget {
  final String imageUrl;
  final String time;

  ChatImageBubble({required this.imageUrl, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              imageUrl,
              width: MediaQuery.of(context).size.width * 0.7,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5),
          Text(
            time,
            style: TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class MessageInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 30.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          50.r,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.emoji_emotions_outlined,
            color: AppColors.blackFour,
            size: 30.h,
          ),
          SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
            ),
          ),
          SvgPicture.asset(
            AppAssets.attachmentIcon,
            height: 20.h,
          ),
          10.horizontalSpace,
          SvgPicture.asset(
            AppAssets.microphoneIcon,
            height: 20.h,
          )
        ],
      ),
    );
  }
}
