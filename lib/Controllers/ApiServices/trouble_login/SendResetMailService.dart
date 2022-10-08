import 'dart:convert';
import 'dart:developer';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:http/http.dart' as http;

class SendResetMailService {
  static Future<bool> SendResetEmail(body) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    final response = await http.post(Uri.parse('${URLS.BASE_URL}/mail/sendresetmail'), body: jsonEncode(body), headers: requestHeaders);

    var data = response.body;
    // print(body);
    print(json.decode(data));

    Map<String, dynamic> resData = jsonDecode(data);
    log(resData['status']);

    if (resData['status'] == 'sent') {
      return true;
    } else {
      return false;
    }
    // return false;
  }
}
