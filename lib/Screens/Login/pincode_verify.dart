import 'dart:async';
import 'dart:developer';

import 'package:autoassist/Utils/loading_dialogs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

String result = "";
String enteredOtp = "";

class PincodeVerify extends StatefulWidget {
  final phone;
  final username;

  const PincodeVerify({Key? key, this.phone, this.username}) : super(key: key);

  @override
  _PincodeVerifyState createState() => _PincodeVerifyState();
}

class _PincodeVerifyState extends State<PincodeVerify> {
  String smsCode = "";
  String verificationId = "";
  late SharedPreferences initiateLogin;

  bool isObscure = true;

  var onTapRecognizer;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  // final phoneNum;

  // bool isLoading = false;

  @override
  void initState() {
    // verifyPhone();
    // _setUserData();
    super.initState();
  }

  // _setUserData() async {

  //    initiateLogin = await SharedPreferences.getInstance();
  //    final phoneNum =  initiateLogin.getString("phoneNumber");
  //    print(phoneNum);

  // }

  Future<bool> _onBackPressed() async {
    Navigator.of(context).pop();
    Navigator.of(context).pop();
    return false;
  }

  Future<void> verifyPhone() async {
    // setState(() {
    //   isLoading = true;
    // });
    autoRetrieve(String verID) {
      verificationId = verID;
      // setState(() {
      //   isLoading = false;
      // });
    }

    smsCodeSent(String verId, [int? forceCodeResend]) {
      verificationId = verId;
      print('sent');

      // setState(() {
      //   isLoading = false;
      // });
    }

    verifiedSuccess(AuthCredential phoneAuthCredential) {
      navigate();
      print('verified');
      // setState(() {
      //   isLoading = false;
      // });
    }

    verifyFailed(FirebaseAuthException exception) {
      print('${exception.message}');
      // setState(() {
      //   isLoading = false;
      // });
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.phone,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verifiedSuccess,
        verificationFailed: verifyFailed,
        codeSent: smsCodeSent,
        codeAutoRetrievalTimeout: autoRetrieve);

    log("OTP sent");
  }

  navigate() async {
    if (enteredOtp != "") {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const VerifyingScreen(),
        ),
      );
    } else {
      Alert(context: context, title: "Error", desc: "Empty OTP").show();
    }
  }

  signIn() {
    if (enteredOtp != "") {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: enteredOtp,
      );
      FirebaseAuth.instance.signInWithCredential(credential).then((user) {
        navigate();
      }).catchError((e) {
        print(e.toString());
        Alert(context: context, title: "Error", desc: "Empty or invalid OTP")
            .show();
        log("Invalid OTP");
      });
    } else {
      Alert(context: context, title: "Error", desc: "Empty OTP").show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView(
              children: <Widget>[
                const SizedBox(height: 30),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.black,
                      iconSize: 38,
                      onPressed: () {
                        log('Clikced on back btn');
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Enter the code',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: 22),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                  child: RichText(
                    text: TextSpan(
                        text: "A verification code has been sent to ",
                        children: [
                          TextSpan(
                              text: widget.phone,
                              style: const TextStyle(
                                  color: Color(0xFFf45d27),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15)),
                        ],
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 18)),
                    textAlign: TextAlign.left,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: formKey,
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 0,
                      ),
                      child: PinCodeTextField(
                        appContext: context,
                        pastedTextStyle: const TextStyle(
                          // color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.transparent,
                        ),
                        length: 6,
                        obscureText: false,
                        obscuringCharacter: '*',
                        // animationType: AnimationType.fade,
                        validator: (v) {
                          if (v!.length < 5) {
                            return "Enter your otp code";
                          } else {
                            return null;
                          }
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(5),
                          fieldHeight: 54,
                          fieldWidth: 54,
                          inactiveColor: Colors.grey,
                          selectedColor: Colors.purple,
                          selectedFillColor: Colors.white,
                          inactiveFillColor: Colors.white,
                          activeFillColor:
                              hasError ? Colors.white : Colors.white,
                        ),
                        cursorColor: Colors.black,
                        animationDuration: const Duration(milliseconds: 300),
                        textStyle: const TextStyle(fontSize: 20, height: 1.6),
                        // backgroundColor: kwhite.withOpacity(.4),
                        enableActiveFill: true,
                        errorAnimationController: errorController,
                        controller: textEditingController,
                        keyboardType: TextInputType.number,
                        boxShadows: const [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                        onCompleted: (v) {
                          print("Completed $v");
                          setState(() {
                            currentText = v;
                          });
                        },
                        // onTap: () {
                        //   print("Pressed");
                        // },
                        onChanged: (value) {
                          print(value);
                          setState(() {
                            // currentText = value;
                            enteredOtp = value;
                          });
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      )),
                ),
                // Padding(
                //     padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 7.0),
                //     child: PinCodeTextField(
                //       length: 6,
                //       obsecureText: false,
                //       shape: PinCodeFieldShape.box,
                //       fieldHeight: 50,
                //       backgroundColor: Colors.white,
                //       fieldWidth: 50,
                //       onCompleted: (v) {
                //         print("Completed");
                //       },
                //       onChanged: (val) {
                //         enteredOtp = val;
                //       },
                //     )),
                InkWell(
                  onTap: () {
                    // signIn();
                    navigate();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 32),
                    child: Center(
                      child: Container(
                        height: 51,
                        width: MediaQuery.of(context).size.width / 1.12,
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, 1),
                              ],
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        child: Center(
                          child: Text(
                            'Continue'.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(top: 30),
                ),
                InkWell(
                  onTap: () {
                    verifyPhone();
                  },
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                        text: "I didn't get a code",
                        style: TextStyle(
                            color: Color.fromRGBO(143, 148, 251, 1),
                            fontSize: 17.5,
                            fontFamily: 'Montserrat'),
                        children: [
                          TextSpan(
                              text:
                                  " \n Tap Continue to accept Facebook's Terms",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                  fontFamily: 'Montserrat'))
                        ]),
                  ),
                ),
                const SizedBox(
                  height: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Future<bool> navigateToHome() {
  //   return showDialog(
  //     builder: (context) => CupertinoAlertDialog(
  //       title: Text(AppLocalizations.of(context).translate('already_have')),
  //       content: Column(
  //         children: <Widget>[
  //           Text(AppLocalizations.of(context).translate('click_ok_to')),
  //         ],
  //       ),
  //       actions: <Widget>[
  //         FlatButton(
  //           color: Colors.orange,
  //           onPressed: () {
  //             navigateToVerifyingScreen();
  //           },
  //           child: Text(
  //             AppLocalizations.of(context).translate('txt_ok'),
  //             style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 14,
  //                 fontFamily: 'Montserrat',
  //                 fontWeight: FontWeight.bold),
  //           ),
  //         )
  //       ],
  //     ),
  //     context: context,
  //   );
  // }

}
