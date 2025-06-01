import 'package:atal_without_krishna/firebase_options.dart';
import 'package:atal_without_krishna/home_page.dart';
import 'package:atal_without_krishna/user_data_manager.dart';
import 'package:atal_without_krishna/utils/email_verify.dart';
import 'package:atal_without_krishna/utils/theme_provider.dart';
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

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserDataProvider()..fetchUserData()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  void _updateSystemOverlay(bool isDark) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark ? Color(0xFF1A1A1A) : Color(0xFFFCFDFD),
        systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        // Update system overlay based on theme
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _updateSystemOverlay(themeProvider.isDarkMode);
        });

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ATL Blog',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
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
      },
    );
  }
}