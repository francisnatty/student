import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/extensions/account_extension.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/features/auth/providers/auth_provider.dart';
import 'package:student_centric_app/features/chats/models/chat_user.dart';
import 'package:student_centric_app/features/chats/providers/chat_provider.dart';
import 'package:student_centric_app/features/chats/screens/audio_call_screen.dart';
import 'package:student_centric_app/features/chats/screens/video_call_screen.dart';

import '../../../core/utils/bottom_sheets.dart';
import '../module/chat_option.dart';

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
              const CircleAvatar(
                backgroundImage: AssetImage(
                  'assets/images/avatar.png',
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chatUser.firstName ?? chatUser.email,
                    style: const TextStyle(
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
              decoration: const BoxDecoration(
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
                      receiverName: "${chatUser.firstName} ${chatUser.lastName}",
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
              onPressed: () {
                CustomBottomSheet.show(
                  context: context,
                  content: const ChatOption(),
                );
              },
            ),
          ],
        ),
        body: ChatBody(
          chatUser: chatUser,
        ),
      ),
    );
  }
}

class ChatBody extends StatelessWidget {
  const ChatBody({super.key, required this.chatUser});
  final ChatUser chatUser;

  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context, listen: false).user;
    String senderId = authProvider?.id.toString() ?? '0';
    debugPrint("sender id is => ${authProvider?.id.toString() ?? ''}");
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider viewModel, Widget? child) {
        if (viewModel.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (viewModel.errorMessage != null) {
          return Center(
            child: Text(
              viewModel.chatErrorMessage!,
              style: TextStyle(color: Colors.red, fontSize: 16.sp),
            ),
          );
        }
        // else if (viewModel.conversationData.isEmpty) {
        //   return Center(
        //     child: Text(
        //       'No chats available.',
        //       style: TextStyle(fontSize: 16.sp),
        //     ),
        //   );
        // }
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 4.h),
                  itemCount: viewModel.conversationData.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ChatBubble(
                      text: viewModel.conversationData[index].message ?? '',
                      isSender: (senderId ==
                              viewModel.conversationData[index].senderId)
                          ? true
                          : false,
                      time: '20:54',
                      backgroundColor: AppColors.primaryColor,
                      textColor: Colors.white,
                    );
                  },
                ),
              ),
              MessageInputField(
                chatUser: chatUser,
              ),
            ],
          ),
        );
      },
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
    super.key,
    required this.text,
    required this.isSender,
    required this.time,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.highlightedText,
  });

  @override
  Widget build(BuildContext context) {
    return isSender
        ? _senderChat(context: context)
        : _receiverChat(context: context);
  }

  Widget _senderChat({required BuildContext context}) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: const BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            highlightedText != null
                ? Text(
                    highlightedText!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.yellow),
                  )
                : const SizedBox.shrink(),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _receiverChat({required BuildContext context}) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            highlightedText != null
                ? Text(
                    highlightedText!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.yellow),
                  )
                : const SizedBox.shrink(),
            Text(
              text,
              style: const TextStyle(color: Colors.black, fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              time,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
            ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}

class ChatImageBubble extends StatelessWidget {
  final String imageUrl;
  final String time;

  const ChatImageBubble(
      {super.key, required this.imageUrl, required this.time});

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
          const SizedBox(height: 5),
          Text(
            time,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class MessageInputField extends StatelessWidget {
  const MessageInputField({super.key, required this.chatUser});
  final ChatUser chatUser;

  @override
  Widget build(BuildContext context) {
    var message = TextEditingController();
    var authProvider = Provider.of<AuthProvider>(context, listen: false).user;
    debugPrint("sender id is => ${authProvider?.id.toString() ?? ''}");
    return Consumer<ChatProvider>(
      builder: (BuildContext context, ChatProvider viewModel, _) {
        return Container(
          padding: const EdgeInsets.all(8),
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
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: message,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    hintStyle: TextStyle(color: Color(0xFF7E93A0)),
                    border: InputBorder.none,
                  ),
                ),
              ),
              // SvgPicture.asset(
              //   AppAssets.attachmentIcon,
              //   height: 20.h,
              // ),
              10.horizontalSpace,
              GestureDetector(
                onTap: () async {
                  await viewModel.sendMessage(
                      senderId: authProvider?.id.toString() ?? '',
                      receiverId: chatUser.id.toString(),
                      content: message.text,
                      context: context,
                      messageId: "${authProvider?.id}_${chatUser.id}");
                },
                child: (viewModel.sendMessageLoading)
                    ? const Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : SvgPicture.asset(
                        AppAssets.attachmentIcon,
                        height: 30.h,
                      ),
              )
            ],
          ),
        );
      },
    );
  }
}
