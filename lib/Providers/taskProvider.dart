import 'dart:convert';
import 'dart:convert' as convert;

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/taskModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TaskProvider with ChangeNotifier {
  late TaskModel _taskModel;
  List<TaskModel> _taskList = [];

  // ignore: unnecessary_getters_setters
  TaskModel get taskModel => _taskModel;

  List<TaskModel> get listTasks => _taskList;

  // ignore: unnecessary_getters_setters
  set taskModel(TaskModel value) {
    _taskModel = value;
  }

  Future<void> startGetTasks(String jobId) async {
    _taskList = [];
    SharedPreferences initializeToken = await SharedPreferences.getInstance();

    final body = {'jobId': jobId, "token": initializeToken.getString("authtoken")};

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    String url = "${URLS.BASE_URL}/task/getTaskByJobId";
    return http.post(Uri.parse(url), body: jsonEncode(body), headers: requestHeaders).then((res) async {
      print("getting taksssssssssssssssss ");
      // print(res.body);
      var convertedData = convert.jsonDecode(res.body);
      // print(convertedData);
      List data = convertedData;
      print(data.length);

      _taskList = data.map((item) => TaskModel.fromJson(item)).toList();

      print("service lengthhhhhhhhhhh ${_taskList[0].services[0].serviceName}");

      notifyListeners();
    }).catchError((onError) {
      print(onError);
    });
  }

  void updateTaskStatus(String status) {
    _taskModel.status = status;
    print("job tot is ${_taskModel.status}");
    notifyListeners();
  }
}
