import 'dart:convert';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/jobModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetJobsController {
  static const String url = '${URLS.BASE_URL}/job/getOngoingJobs';

  static Future<List<Job>> getJobs() async {
    SharedPreferences initializeToken = await SharedPreferences.getInstance();
    final body = {"token": initializeToken.getString("authtoken")};
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    try {
      final response = await http.post(Uri.parse(url), body: jsonEncode(body), headers: requestHeaders);
      if (response.statusCode == 200) {
        List<Job> list = parseJobs(response.body);
        return list;
      } else {
        throw Exception("Error");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<Job> parseJobs(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Job>((json) => Job.fromJson(json)).toList();
  }
}
