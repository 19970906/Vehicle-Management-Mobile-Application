import 'dart:convert';
import 'dart:convert' as convert;

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/jobModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class JobProvider with ChangeNotifier {
  late Job _jobModel;
  List<Job> _jobList = [];
  List<Job> _jobListHome = [];
  List<Job> _jobListFinished = [];
  List<Job> _jobListByCusId = [];
  List<Job> _jobListByVehiNo = [];

  // ignore: unnecessary_getters_setters
  Job get jobModel => _jobModel;

  List<Job> get listJobs => _jobList;
  List<Job> get listJobsHome => _jobListHome;
  List<Job> get listJobsFinished => _jobListFinished;

  // ignore: unnecessary_getters_setters
  set jobModel(Job value) {
    _jobModel = value;
  }

  Future<List<Job>> startGetJobs() async {
    _jobList = [];
    SharedPreferences initializeToken = await SharedPreferences.getInstance();

    final body = {"token": initializeToken.getString("authtoken")};

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    String url = "${URLS.BASE_URL}/job/getOngoingJobs";
    return http.post(Uri.parse(url), body: jsonEncode(body), headers: requestHeaders).then((res) async {
      print("getting jobssssssssssssssss ");
      // print(res.body);
      var convertedData = convert.jsonDecode(res.body);
      // print(convertedData);
      List data = convertedData;

      _jobList = data.map((item) => Job.fromJson(item)).toList();

      notifyListeners();
      return _jobList;
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<void> startGetHomeJobss() async {
    _jobListHome = [];
    SharedPreferences initializeToken = await SharedPreferences.getInstance();

    final body = {"token": initializeToken.getString("authtoken")};

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    String url = "${URLS.BASE_URL}/job/getOngoingJobs";
    return http.post(Uri.parse(url), body: jsonEncode(body), headers: requestHeaders).then((res) async {
      print("getting jobssssssssssssssss ");
      // print(res.body);
      var convertedData = convert.jsonDecode(res.body);
      // print(convertedData);
      List data = convertedData;

      _jobListHome = data.map((item) => Job.fromJson(item)).toList();

      notifyListeners();
    }).catchError((onError) {
      print(onError);
    });
  }

  void updateTaskCountAndJobtot(String taskCount, String jobTot) {
    _jobModel.taskCount = taskCount;
    _jobModel.total = jobTot;
    print("job tot is ${_jobModel.total}");
    notifyListeners();
  }

  void updateComTaskCount(String taskCount) {
    _jobModel.completeTaskCount = taskCount;
    print("job tot is ${_jobModel.completeTaskCount}");
    notifyListeners();
  }

  Future<List<Job>> startGetFinishedJobs() async {
    _jobListFinished = [];
    SharedPreferences initializeToken = await SharedPreferences.getInstance();

    final body = {"token": initializeToken.getString("authtoken")};

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    String url = "${URLS.BASE_URL}/job/getFinishedJobs";
    return http.post(Uri.parse(url), body: jsonEncode(body), headers: requestHeaders).then((res) async {
      print("getting finished jobssssssssssssssss ");
      // print(res.body);
      var convertedData = convert.jsonDecode(res.body);
      // print(convertedData);
      List data = convertedData;

      _jobListFinished = data.map((item) => Job.fromJson(item)).toList();

      notifyListeners();
      return _jobListFinished;
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<List<Job>> getJobsByCusId(String cusId) async {
    _jobListByCusId = [];
    SharedPreferences initializeToken = await SharedPreferences.getInstance();

    final body = {"cusId": cusId, "token": initializeToken.getString("authtoken")};

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    String url = "${URLS.BASE_URL}/job/getJobsByCusId";
    return http.post(Uri.parse(url), body: jsonEncode(body), headers: requestHeaders).then((res) async {
      print("getting finished jobssssssssssssssss ");
      // print(res.body);
      var convertedData = convert.jsonDecode(res.body);
      // print(convertedData);
      List data = convertedData;

      _jobListByCusId = data.map((item) => Job.fromJson(item)).toList();

      notifyListeners();
      return _jobListByCusId;
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<List<Job>> getJobsByVehiNum(String vehiNo) async {
    _jobListByVehiNo = [];
    SharedPreferences initializeToken = await SharedPreferences.getInstance();

    final body = {"vnumber": vehiNo, "token": initializeToken.getString("authtoken")};

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    String url = "${URLS.BASE_URL}/job/getJobsByVehicleNo";
    return http.post(Uri.parse(url), body: jsonEncode(body), headers: requestHeaders).then((res) async {
      print("getting finished jobssssssssssssssss ");
      // print(res.body);
      var convertedData = convert.jsonDecode(res.body);
      // print(convertedData);
      List data = convertedData;

      _jobListByVehiNo = data.map((item) => Job.fromJson(item)).toList();

      notifyListeners();
      return _jobListByVehiNo;
    }).catchError((onError) {
      print(onError);
    });
  }
}
