import 'dart:async';

import 'package:autoassist/Screens/HomePage/home.dart';
import 'package:autoassist/Screens/Login/login_page.dart';
import 'package:autoassist/Screens/Login/pincode_verify.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggingOut extends StatefulWidget {
  const LoggingOut({Key? key}) : super(key: key);

  @override
  _LoggingOutState createState() => _LoggingOutState();
}

class _LoggingOutState extends State<LoggingOut> {
  @override
  void initState() {
    super.initState();
    // log(widget.fbName);
    navigate();
  }

  navigate() {
    Future.delayed(
      const Duration(seconds: 5),
      () {
        // Navigator.pop(context)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/macha.gif'), fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                child: const Text("Logging You Out..",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SentScreen extends StatefulWidget {
  final phone;
  final username;

  const SentScreen({Key? key, this.phone, this.username}) : super(key: key);

  @override
  _SentScreenState createState() => _SentScreenState();
}

class _SentScreenState extends State<SentScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(seconds: 4),
      () {
        // Navigator.pop(context);
        final phoneNum = widget.phone;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PincodeVerify(phone: phoneNum, username: widget.username),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/sent.gif'), fit: BoxFit.cover)),
            ),
            Container(
                child: const Text("Otp Sent !",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                    )))
          ],
        ),
      ),
    );
  }
}

class VerifyingScreen extends StatefulWidget {
  const VerifyingScreen({Key? key}) : super(key: key);

  @override
  _VerifyingScreenState createState() => _VerifyingScreenState();
}

class _VerifyingScreenState extends State<VerifyingScreen> {
  late SharedPreferences login;

  @override
  void initState() {
    super.initState();
    initializeAuth();
  }

  navigateToHome() async {
    Future.delayed(
      const Duration(seconds: 6),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      },
    );
  }

  void initializeAuth() async {
    SharedPreferences login = await SharedPreferences.getInstance();
    final token = login.getString("gettoken");
    print("token = $token");

    SharedPreferences initializeToken = await SharedPreferences.getInstance();
    initializeToken.setString("authtoken", token!);

    navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/macha.gif'), fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                child: const Text("Verifying Your Account !",
                    style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 15,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({Key? key}) : super(key: key);

  @override
  _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  @override
  void initState() {
    // log(widget.fbName);
    navigate();
    super.initState();
  }

  navigate() {
    Future.delayed(
      const Duration(seconds: 5),
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SentScreen(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 200,
              width: 200,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/sending.gif'), fit: BoxFit.cover)),
            ),
            Container(
              child: const Text('Verifying Phone Number..!',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 15,
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
