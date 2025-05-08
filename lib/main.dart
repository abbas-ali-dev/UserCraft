import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usercraft/core/navigation/bottom_tabs.dart';
import 'package:usercraft/core/provider/home_screen_provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'User Craft',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
          ),
          useMaterial3: true,
        ),
        home: EasySplashScreen(
          logo: Image.asset(
            "assets/images/logo.png",
            fit: BoxFit.fill,
          ),
          logoWidth: 80,
          title: Text(
            'User Craft',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Color(0XFFffd21f),
          showLoader: true,
          loaderColor: Colors.white,
          loadingText: Text(
            'Developed by Analytica...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              fontFamily: 'Courier',
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          ),
          durationInSeconds: 3,
          navigator: BottomTabs(),
        ),
      ),
    );
  }
}
