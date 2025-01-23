import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/pages/router/path.dart';

// import pages
import 'package:frontend/pages/login.dart';
// import 'package:frontend/pages/register.dart';
// import 'package:frontend/pages/OTP.dart';
// import 'package:frontend/pages/landing.dart';

// This key is used for navigation outside the normal widget tree hierarchy
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: '');

// This router manages app navigation based on the defined routes and paths in path.dart
final GoRouter router = GoRouter(
    // Set the initial route when the app starts
  initialLocation: Path.loginPage,

  // Assign the root navigator key to the router
  navigatorKey: _rootNavigatorKey, 

  routes: [
    /*
    GoRoute(
      path: Path.landingPage,
      builder: (context, state) => const LandingPage(),
    ),
    */

    // Login Page Route
    // Example for other route
    // TODO: waiting for another pages
    GoRoute(
      // Path defined in path.dart
      path: Path.loginPage,
      // Navigate -> LoginPage when the path matches
      builder: (context, state) => LoginPage(),
    ),

    /*
    GoRoute(
      path: Path.registerPage,
      builder: (context, state) => const RegisterPage(),
    ),
    */

    /*
    GoRoute(
      path: Path.otpPage,
      builder: (context, state) => const OTPPage(),
    ),
    */
  ],
);
