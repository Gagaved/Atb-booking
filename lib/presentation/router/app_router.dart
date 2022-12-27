import 'package:atb_booking/logic/secure_storage_api.dart';
import 'package:atb_booking/presentation/interface/admin_role/adminHome.dart';
import 'package:atb_booking/presentation/interface/auth/auth_screen.dart';
import 'package:atb_booking/presentation/interface/user_role/home/home.dart';
import 'package:flutter/material.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/adminHome':
        return MaterialPageRoute(builder: (_) => const AdminHome());
      case '/home':
        return MaterialPageRoute(builder: (_) => const Home());
      case '/auth':
        return MaterialPageRoute(builder: (_) => const Auth());

      default:
        var type = SecurityStorage().getLastUserTypeCYNC();
        if (type == '') {
          return MaterialPageRoute(builder: (_) => const Auth());
        } else if (type == "ADMIN") {
          return MaterialPageRoute(builder: (_) => const AdminHome());
        } else if (type == "USER") {
          return MaterialPageRoute(builder: (_) => const Home());
        } else {
          throw Exception("unknown type: $type");
        }
    }
  }
}
