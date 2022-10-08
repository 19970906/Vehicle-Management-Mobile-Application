import 'dart:async';

import 'package:autoassist/Controllers/ApiServices/auth_services/OtpLoginService.dart';
import 'package:autoassist/Models/userModel.dart';
import 'package:autoassist/Providers/AuthProvider.dart';
import 'package:autoassist/Screens/HomePage/home.dart';
import 'package:autoassist/Screens/Login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SharedPreferences initializeToken;
  late UserModel userModel;

  @override
  void initState() {
    super.initState();

    checkLoginStatus();
  }

  navigateToHome() async {
    SharedPreferences login = await SharedPreferences.getInstance();
    final usrename = login.getString("username");

    startLogin();
  }

  navigateToLogin() {
    Future.delayed(
      const Duration(seconds: 5),
      () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
    );
  }

  checkLoginStatus() async {
    initializeToken = await SharedPreferences.getInstance();
    if (initializeToken.getString("authtoken") == null) {
      navigateToLogin();
    } else {
      initializeToken = await SharedPreferences.getInstance();
      final token = initializeToken.getString("authtoken");
      Logger().i(token);
      navigateToHome();
    }
  }

  startLogin() async {
    SharedPreferences login = await SharedPreferences.getInstance();
    final phonenum = login.getString("phonenum");
    print("got phone num $phonenum");
    final body = {"phone": "$phonenum"};

    await LoginwithOtpService.LoginWithOtp(body, context).then((success) async {
      print(success);
      if (success) {
        final token = login.getString("gettoken");
        userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
        print("garage name isssssssssss ${userModel.garageName}");

        initializeToken.setString("authtoken", token!);
        print("login success");
        Future.delayed(
          const Duration(seconds: 3),
          () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
          },
        );
      } else {
        print("login failed");
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
