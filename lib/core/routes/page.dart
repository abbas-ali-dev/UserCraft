import 'package:flutter/material.dart';
import 'package:usercraft/core/routes/routes.dart';
import 'package:usercraft/view/home_screen/home_screen.dart';
import 'package:usercraft/view/profile_screen/profile_screen.dart';
import 'package:usercraft/view/user_detail/user_detail_screen.dart';

class AppPages {
  static Map<String, WidgetBuilder> get routes {
    return {
      Routes.main: (context) => const HomeScreen(),
      Routes.profile: (context) => const ProfileScreen(),
      Routes.userDetail: (context) => const UserDetailScreen(),
    };
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }
}
