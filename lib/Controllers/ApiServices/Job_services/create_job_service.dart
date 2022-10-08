import 'dart:convert';
import 'dart:developer';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/jobModel.dart';
import 'package:autoassist/Providers/JobProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class CreateJobService {
  static Future<bool> createJob(body, context) async {
    print(body);

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    final response = await http.post(Uri.parse('${URLS.BASE_URL}/job/newjob'), body: jsonEncode(body), headers: requestHeaders);

    var data = response.body;
    // print(body);
    print(json.decode(data));

    Map<String, dynamic> resData = jsonDecode(data);
    log(resData.toString());

    try {
      if (response.statusCode == 200) {
        Job model = Job.fromJson(resData);
        Provider.of<JobProvider>(context, listen: false).jobModel = model;

        return true;
      } else {
        final result = resData['messege'];
        print(result);
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
    // return true;
  }
}
