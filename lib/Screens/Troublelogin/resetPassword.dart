import 'dart:developer';

import 'package:autoassist/Controllers/ApiServices/trouble_login/VerifyEmailService.dart';
import 'package:autoassist/Screens/HomePage/home.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ResetPassword extends StatefulWidget {
  final resetEmail;
  const ResetPassword({Key? key, this.resetEmail}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _resetCode = TextEditingController();
  String _errorTxt = '';
  late ProgressDialog pd;

  @override
  void initState() {
    setState(() {
      _errorTxt = "";
    });
    log(widget.resetEmail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context: context);
    // pr.style(message: 'Sending Email..');

    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() {
            _errorTxt = "";
          });
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 14),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.black,
                    iconSize: 38,
                    onPressed: () {
                      log('Clikced on back btn');
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: Text(
                  'Reset Password',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(64, 75, 105, 1), fontFamily: 'Montserrat', fontSize: 22),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: const TextSpan(
                      text: "Reset code was sent your email. Please \n"
                          "enter ther code and create new password.",
                      style: TextStyle(color: Color.fromRGBO(64, 75, 105, 1), fontSize: 16)),
                  textAlign: TextAlign.left,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 7.0, horizontal: 25),
                child: TextField(
                  controller: _resetCode,
                  maxLength: 6,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))),
                      labelText: 'Reset Code',
                      errorText: _errorTxt,
                      errorBorder: _errorTxt.isEmpty ? const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))) : null,
                      focusedBorder: _errorTxt.isNotEmpty ? const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))) : null),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 32),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      if (checkNull()) {
                        setState(() {
                          _errorTxt = "";
                        });

                        if (validatePhone()) {
                          pd.show(max: 100, msg: 'reseting...');
                          log('clicked on reset btn');

                          final body = {"email": widget.resetEmail, "code": _resetCode.text};

                          VerifyEmailService.VerifyEmail(body, context).then((success) {
                            print("result is $success");
                            if (success) {
                              log('account verified');

                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
                            } else {
                              pd.close();
                              setState(() {
                                _errorTxt = "Invalid Code! Check Again";
                              });
                            }
                          });
                        }

                        // Navigator.of(context).pushNamed("/resetpw");
                      } else {
                        pd.close();
                        setState(() {
                          _errorTxt = "You should fill out this field !";
                        });
                      }
                    },
                    child: Container(
                      height: 51,
                      width: MediaQuery.of(context).size.width / 1.12,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Center(
                        child: Text(
                          'Change Phone number'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool checkNull() {
    if (_resetCode.text == '') {
      return false;
    } else {
      return true;
    }
  }

  bool validatePhone() {
    if (_resetCode.text.length >= 5) {
      print("valid code");
      return true;
    } else {
      setState(() {
        _errorTxt = "The reset code must contain 6 digits !";
      });
      return false;
    }
  }
}
