// lib/main.dart
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

// Import the provider package
import 'package:provider/provider.dart';
import 'package:student_centric_app/core/network/api_service.dart';
import 'package:student_centric_app/core/utils/banners.dart';
import 'package:student_centric_app/core/utils/fcm.dart';
import 'package:student_centric_app/features/auth/providers/auth_provider.dart';
import 'package:student_centric_app/features/auth/providers/basic_information_provider.dart';
import 'package:student_centric_app/features/chats/providers/call_provider.dart';
import 'package:student_centric_app/features/chats/providers/chat_provider.dart';
import 'package:student_centric_app/features/chats/screens/incomming_call_screen.dart';
import 'package:student_centric_app/features/dashboard/providers/bottom_nav_provider.dart';
import 'package:student_centric_app/features/home/providers/post_provider.dart';

// Import your onboarding screen
import 'package:student_centric_app/features/onboarding/onboarding_screen.dart';
import 'package:student_centric_app/firebase_options.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize ApiService
  ApiService.instance.init(
    baseUrl: "https://typescript-boilerplate.onrender.com/api/v1",
  );

  await FCM.requestPermission();

  // Set callbacks for success and error
  ApiService.instance.setCallbacks(
    onSuccess: (message) {
      showAutoDismissBanner(
        message: message,
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3), // Adjust as needed
      );
    },
    onError: (message) {
      showAutoDismissBanner(
        message: message,
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3), // Adjust as needed
      );
    },
  );

  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      'resource://drawable/logo',
      [
        NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(0xFF9D50DD),
          ledColor: Colors.white,
        ),
      ],

      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);

  await FCM.listenForBackgroundMessages();

  runApp(
    // Wrap the entire app with MultiProvider
    MultiProvider(
      providers: [
        // Declare the BasicInformationProvider
        ChangeNotifierProvider(
          create: (_) => BasicInformationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),

        ChangeNotifierProvider(
          create: (_) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CallProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ChatProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostsProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
          393, 852), // Adjust based on your design reference screen size
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          scaffoldMessengerKey: scaffoldMessengerKey,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            textTheme: GoogleFonts.dmSansTextTheme(
              // Set your Google Font here
              Theme.of(context).textTheme,
            ),
            colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0E48FB)),
            useMaterial3: true,
          ),
          home: child,
        );
      },
      child: const OnboardingScreen(),
    );
  }
}
