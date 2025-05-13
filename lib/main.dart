import 'package:atal_without_krishna/firebase_options.dart';
import 'package:atal_without_krishna/home_page.dart';
import 'package:atal_without_krishna/theme.dart'; // Import custom theme
import 'package:atal_without_krishna/user_data_manager.dart';
import 'package:atal_without_krishna/utils/email_verify.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'basics_page_partitions/kisckstart.dart';
import 'get_started_page.dart';
import 'splash.dart';
import 'login_page.dart';
import 'user_check.dart';
import 'register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set status bar to transparent and change icon brightness
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light, // Icons set to light
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()..fetchUserData()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: lightTheme, // Use theme from theme.dart
      // darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Use system theme
      initialRoute: '/',

      // Define Routes
      routes: {
        '/': (context) => SplashScreen(),
        '/getstarted': (context) => GetStartedPage(),
        '/login': (context) => LoginScreen(),
        '/usercheck': (context) => UserCheck(),
        '/email-verification': (context) => EmailVerificationPage(),
        '/home': (context) => HomePage(),
        '/register': (context) => RegisterScreen(),
        '/kickstart': (context) => KickstartCode(),
      },
    );
  }
}
