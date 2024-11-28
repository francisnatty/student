import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:student_centric_app/config/routes/navigation_routes.dart';
import 'package:student_centric_app/core/extensions/account_extension.dart';
import 'package:student_centric_app/core/utils/app_assets.dart';
import 'package:student_centric_app/core/utils/app_colors.dart';
import 'package:student_centric_app/core/utils/fcm.dart';
import 'package:student_centric_app/features/chats/screens/chat_screen.dart';
import 'package:student_centric_app/features/chats/screens/incomming_call_screen.dart';
import 'package:student_centric_app/features/chats/screens/incomming_video_call_screen.dart';
import 'package:student_centric_app/features/community/screens/community_page.dart';
import 'package:student_centric_app/features/dashboard/providers/bottom_nav_provider.dart';
import 'package:student_centric_app/features/home/home_screen.dart';
import 'package:student_centric_app/features/home/screens/add_post_screen.dart';
import 'package:student_centric_app/features/search/screens/search_page.dart';
import 'package:student_centric_app/features/tasks/screens/add_task_screen.dart';
import 'package:student_centric_app/features/tasks/screens/tasks_page.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    FCM.listenForForegroundMessages(context);
  }

  final List<Widget> _pages = [
    HomeScreen(),
    ChatScreen(),
    SearchPage(),
    TasksPage(),
    CommunityPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavigationProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: _pages[provider.selectedIndex],
          bottomNavigationBar: Container(
            height: 85.0.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22.r),
                topRight: Radius.circular(22.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                currentIndex: provider.selectedIndex,
                onTap: provider.setIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      provider.selectedIndex == 0
                          ? AppAssets.activeHomeIcon
                          : AppAssets.inactiveHomeIcon,
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      provider.selectedIndex == 1
                          ? AppAssets.activeChatIcon
                          : AppAssets.inactiveChatIcon,
                    ),
                    label: 'Chats',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      provider.selectedIndex == 2
                          ? AppAssets.activeSearchIcon
                          : AppAssets.inactiveSearchIcon,
                    ),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      provider.selectedIndex == 3
                          ? AppAssets.activeTasksIcon
                          : AppAssets.inactiveTasksIcon,
                    ),
                    label: 'Tasks',
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      provider.selectedIndex == 4
                          ? AppAssets.activeCommunityIcon
                          : AppAssets.inactiveCommunityIcon,
                    ),
                    label: 'Community',
                  ),
                ],
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.primaryColor,
                unselectedItemColor: Colors.grey,
                iconSize: 28.0.sp,
                selectedFontSize: 14.0.sp,
                unselectedFontSize: 12.0.sp,
              ),
            ),
          ),
          floatingActionButton: provider.selectedIndex == 0 ||
                  provider.selectedIndex == 1 ||
                  provider.selectedIndex == 3
              ? Container(
                  width: 60.w, // Set width to 60
                  height: 60.h, // Set height to 60
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor, // Starting color
                        AppColors
                            .primaryFour, // Ending color (define in AppColors)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: FloatingActionButton(
                    onPressed: () {
                      // Action for the FAB based on selected page
                      if (provider.selectedIndex == 1) {
                        final currentUserId =
                            context.account.user!.id.toString();
                        String generateChannelName(
                            String userId1, String userId2) {
                          // Sort the IDs to ensure the same channel name regardless of who calls who
                          final sortedIds = [userId1, userId2]..sort();
                          return 'call_${sortedIds[0]}_${sortedIds[1]}';
                        }

                        final channelName =
                            generateChannelName(currentUserId, "25");

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IncomingVideoCallScreen(
                              callerId: "Samuel Salami",
                              channelName: channelName,
                            ),
                          ),
                        );
                      } else if (provider.selectedIndex == 3) {
                        context.push(AddTaskScreen());
                      } else {
                        context.push(AddPostScreen());
                      }
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Builder(
                      builder: (context) {
                        if (provider.selectedIndex == 1) {
                          return SvgPicture.asset(
                            AppAssets.messageIconAlt,
                          );
                        } else if (provider.selectedIndex == 3) {
                          return SvgPicture.asset(
                            AppAssets.inactiveTasksIcon,
                            color: Colors.white,
                          );
                        } else {
                          return Icon(
                            Icons.add,
                            color: Colors.white,
                          );
                        }
                      },
                    ),
                  ),
                )
              : SizedBox.shrink(),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
