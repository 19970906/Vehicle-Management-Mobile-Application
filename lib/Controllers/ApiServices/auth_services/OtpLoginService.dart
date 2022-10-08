import 'dart:convert';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/userModel.dart';
import 'package:autoassist/Providers/AuthProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginwithOtpService {
  static Future<bool> LoginWithOtp(body, context) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    final response = await http.post(Uri.parse('${URLS.BASE_URL}/user/checkphonenumber'), body: jsonEncode(body), headers: requestHeaders);

    var data = response.body;
    print(body);
    print(json.decode(data));

    Map<String, dynamic> resData = jsonDecode(data);

    if (response.statusCode == 200) {
      print(resData['loginstatus']);
      final token = resData['token'];
      final name = resData['username'];
      print(token + name);
      SharedPreferences login = await SharedPreferences.getInstance();
      login.setString("gettoken", token);
      login.setString("username", name);

      UserModel myModel = UserModel.fromJson(resData);
      //make my model usable to all widgets
      Provider.of<AuthProvider>(context, listen: false).userModel = myModel;
      return true;
    } else {
      print(resData['error']);
      return false;
    }
    // return false;
  }
}
