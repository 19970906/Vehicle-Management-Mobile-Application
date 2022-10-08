import 'dart:convert';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/jobModel.dart';
import 'package:autoassist/Models/taskModel.dart';
import 'package:autoassist/Providers/JobProvider.dart';
import 'package:autoassist/Providers/taskProvider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class DeleteTaskBox extends StatefulWidget {
  const DeleteTaskBox({Key? key}) : super(key: key);

  @override
  _DeleteTaskBoxState createState() => _DeleteTaskBoxState();
}

class _DeleteTaskBoxState extends State<DeleteTaskBox> {
  String status = "";
  late TaskModel taskmodel;
  late Job jobModel;
  late ProgressDialog pd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskmodel = Provider.of<TaskProvider>(context, listen: false).taskModel;
    jobModel = Provider.of<JobProvider>(context, listen: false).jobModel;
  }

  Future<bool> onbackpress() async {
    Navigator.pop(context, jobModel);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context: context);

    return WillPopScope(
      onWillPop: onbackpress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 20.0, bottom: 20),
            child: Text(
              "Delete ?",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
          ),
          const Text("Are you sure you want to delete this Task ?"),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context, jobModel);
                },
                child: Container(
                  height: MediaQuery.of(context).size.width / 10,
                  width: MediaQuery.of(context).size.width / 4,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8E8CD8), Color(0xFF8E8CD8)],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: Center(
                    child: Text(
                      'No'.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  startDeleteTask();
                },
                child: Container(
                  height: MediaQuery.of(context).size.width / 10,
                  width: MediaQuery.of(context).size.width / 4,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF8E8CD8), Color(0xFF8E8CD8)],
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(50))),
                  child: Center(
                    child: Text(
                      'Yes'.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Future<void> startDeleteTask() async {
    pd.show(max: 100, msg: 'deleting data...');
    final body = {
      "_id": taskmodel.taskId,
      "jobId": taskmodel.jobId,
      "procerCharge": taskmodel.procerCharge,
      "labourCharge": taskmodel.labourCharge,
      "total": taskmodel.total
    };

    print(body);

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    final response = await http.post(Uri.parse('${URLS.BASE_URL}/task/deleteTask'), body: jsonEncode(body), headers: requestHeaders);
    print("workingggggggggggg");
    var data = response.body;
    // print(body);
    print(json.decode(data));

    Map<String, dynamic> resData = jsonDecode(data);

    try {
      if (response.statusCode == 200) {
        jobModel = Job.fromJson(resData);
        Provider.of<JobProvider>(context, listen: false).jobModel = jobModel;
        Provider.of<JobProvider>(context, listen: false).startGetHomeJobss();
        Provider.of<TaskProvider>(context, listen: false).startGetTasks(jobModel.jobId);
        pd.close();
        successDialog("Done", "Task Deleted succefully");
      } else {
        // Dialogs.errorDialog(context, "F", "Something went wrong !");
        pd.close();
        Navigator.of(context).pop();
        print("job coudlnt create !");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> successDialog(String title, String dec) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.TOPSLIDE,
        title: title,
        desc: dec,
        // btnCancelOnPress: () {},
        btnOkOnPress: () {
          Navigator.pop(context, jobModel);
        }).show();
  }
}
