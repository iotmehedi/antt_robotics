import 'package:flutter/material.dart';
import 'package:interective_cares_task/core/routes/route_name.dart';
import 'package:interective_cares_task/features/features/course_details_play/course_details_play_tutorial.dart';
import 'package:interective_cares_task/features/features/signup_page/presentation/signup_page.dart';
import '../../features/features/forgot_password_screen/forgot_password_screen.dart';
import '../../features/features/signin_page.dart';
import '../../features/features/splash_screen/splash_screen.dart';
import '../../main.dart';

class RouteGenerator {
  static pushNamed(BuildContext context, String pageName) {
    return Navigator.pushNamed(context, pageName);
  }

  static pushReplacement(BuildContext context, String pageName) {
    return Navigator.of(context).pushReplacementNamed(pageName);
  }

  static pushNamedAndRemoveAll(BuildContext context, String pageName) {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil(pageName, (Route<dynamic> route) => false);
  }

  static pushNamedWithArguments(BuildContext context, String pageName,
      {List arguments = const []}) {
    return Navigator.pushNamed(context, pageName, arguments: arguments);
  }

  static pushNamedforAdvanceSearch(
      BuildContext context, String pageName, Function filterActionEvent) {
    return Navigator.of(context).pushNamed(pageName);
  }

  static pushReplacementNamed(BuildContext context, String pageName,
      {List arguments = const []}) {
    return Navigator.pushReplacementNamed(context, pageName,
        arguments: arguments);
  }

  static pop(BuildContext context) {
    return Navigator.of(context).pop();
  }

  static popAndPushNamed(BuildContext context, String pageName,
      {List arguments = const []}) {
    return Navigator.popAndPushNamed(context, pageName, arguments: arguments);
  }

  static popAll(BuildContext context) {
    return Navigator.of(context).popUntil((route) => false);
  }

  static popUntil(BuildContext context, String pageName) {
    return Navigator.of(context).popUntil(ModalRoute.withName(pageName));
  }

  // ================================== Routing =============================================

  static Route<dynamic>? onRouteGenerate(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.splashScreenRouteName:
        return MaterialPageRoute(
          builder: (context) => const SplashScreen(),
        );
      case Routes.signInScreen:
        return MaterialPageRoute(
          builder: (context) => const SigninScreen(),
        );
      case Routes.signupScreen:
        return MaterialPageRoute(
          builder: (context) => SignupScreen(),
        );
      case Routes.forgotPasswordScreen:
        return MaterialPageRoute(
          builder: (context) => ForgotPasswordScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${routeSettings.name}'),
            ),
          ),
        );
    }
    return null;
  }
}
