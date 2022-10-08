import 'dart:convert';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/taskModel.dart';
import 'package:autoassist/Providers/JobProvider.dart';
import 'package:autoassist/Providers/taskProvider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class ChangeTaskStatus extends StatefulWidget {
  const ChangeTaskStatus({Key? key}) : super(key: key);

  @override
  _ChangeTaskStatusState createState() => _ChangeTaskStatusState();
}

class _ChangeTaskStatusState extends State<ChangeTaskStatus> {
  String status = "";
  String comTaskCount = "";
  late TaskModel taskmodel;
  late ProgressDialog pd;

  @override
  void initState() {
    super.initState();
    taskmodel = Provider.of<TaskProvider>(context, listen: false).taskModel;
    initStatus();
  }

  initStatus() {
    setState(() {
      status = taskmodel.status;
    });
  }

  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context: context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 20),
          child: Center(
              child: Text(
            "Update Task Status",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          )),
        ),
        GestureDetector(
          onTap: () {
            initFoodCats("on-Progress");
            print("status is $status");
          },
          child: taskStatus(
            'On-Progress',
            status == "on-Progress" ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          ),
        ),
        GestureDetector(
          onTap: () {
            initFoodCats("Completed");
            print("status is $status");
          },
          child: taskStatus(
            'Completed',
            status == "Completed" ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          ),
        ),
        GestureDetector(
          onTap: () {
            initFoodCats("Aborted");
            print("status is $status");
          },
          child: taskStatus(
            'Aborted',
            status == "Aborted" ? Icons.radio_button_checked : Icons.radio_button_unchecked,
          ),
        ),
        InkWell(
          onTap: () async {
            if (status != "" && status != taskmodel.status) {
              pd.show(max: 100, msg: 'saving data...');
              final body = {"_id": taskmodel.taskId, "status": status, "jobId": taskmodel.jobId};

              print(body);

              Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

              final response = await http.post(Uri.parse('${URLS.BASE_URL}/task/updateTaskStatus'), body: jsonEncode(body), headers: requestHeaders);
              print("workingggggggggggg");
              var data = response.body;
              // print(body);
              print(json.decode(data));

              Map<String, dynamic> resData = jsonDecode(data);

              try {
                if (response.statusCode == 200) {
                  setState(() {
                    taskmodel.status = status;
                    comTaskCount = resData['completeTaskCount'];
                  });
                  Provider.of<TaskProvider>(context, listen: false).updateTaskStatus(status);

                  Provider.of<JobProvider>(context, listen: false).updateComTaskCount(comTaskCount);
                  print("$status----$comTaskCount");

                  // Provider.of<JobProvider>(context, listen: false).startGetJobs();
                  Provider.of<JobProvider>(context, listen: false).startGetHomeJobss();
                  Provider.of<TaskProvider>(context, listen: false).startGetTasks(taskmodel.jobId);
                  pd.close();
                  successDialog("Done", "Status Updated succefully");
                } else {
                  // Dialogs.errorDialog(context, "F", "Something went wrong !");
                  pd.close();
                  print("job coudlnt create !");
                }
              } catch (e) {
                print(e);
              }
            } else {
              print("doesnt hve to update");
              // Dialogs.errorDialog(context, "Error", "select services & products first !");
              Navigator.of(context).pop();
            }
          },
          child: Container(
            height: MediaQuery.of(context).size.width / 10,
            width: MediaQuery.of(context).size.width / 2,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8E8CD8), Color(0xFF8E8CD8)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(50))),
            child: Center(
              child: Text(
                'Update Status'.toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 15,
        ),
      ],
    );
  }

  initFoodCats(String val) {
    setState(() {
      status = val;
    });
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
          Navigator.pop(context, taskmodel);
        }).show();
  }

  Widget taskStatus(String task, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, bottom: 24.0),
      child: Row(children: <Widget>[
        Icon(
          iconData,
          color: const Color(0xFFef5350),
          size: 20,
        ),
        const SizedBox(
          width: 28,
        ),
        Text(
          task,
          style: const TextStyle(
            fontSize: 17,
          ),
        )
      ]),
    );
  }
}
