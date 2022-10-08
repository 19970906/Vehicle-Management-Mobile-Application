import 'package:autoassist/Controllers/ApiServices/trouble_login/SendResetMailService.dart';
import 'package:autoassist/Screens/Troublelogin/resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _email = TextEditingController();
  String _errorTxt = '';
  bool isLoaidng = false;
  late ProgressDialog pd;

  @override
  void initState() {
    setState(() {
      _errorTxt = "";
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context: context);

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
              // SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(top: 50.0, left: 14),
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    color: Colors.black,
                    iconSize: 38,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: Text(
                  'Trouble Login in?',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(64, 75, 105, 1), fontFamily: 'Montserrat', fontSize: 22),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: const TextSpan(
                      text: "Pleace enter your email below to receive your \nAccount reset instructions.",
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
                  controller: _email,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))),
                      labelText: 'Email',
                      errorText: _errorTxt,
                      errorBorder: _errorTxt.isEmpty ? const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0))) : null,
                      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFE0E0E0)))),
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
                          isLoaidng = true;
                        });

                        if (validateEmail()) {
                          pd.show(max: 100, msg: 'checking email...');

                          final body = {"email": _email.text};

                          SendResetMailService.SendResetEmail(body).then((success) {
                            if (success) {
                              pd.close();

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ResetPassword(
                                        resetEmail: _email.text,
                                      )));
                            } else {
                              pd.close();
                              _errorTxt = "This Email doesnt blongs to an account !";
                            }
                          });

                          // Navigator.of(context).push(MaterialPageRoute(
                          //         builder: (context) => ResetPassword(
                          //               resetEmail: _email.text,
                          //             )));
                        }
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
                          'Send An Email'.toUpperCase(),
                          style: const TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
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
    if (_email.text == '') {
      return false;
    } else {
      return true;
    }
  }

  ///function tht validate the email
  bool validateEmail() {
    String email = _email.text;
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if (emailValid) {
      print("Valid email !");

      return true;
    } else {
      setState(() {
        _errorTxt = "This is not a valid email !";
      });
      return false;
    }
  }
}
