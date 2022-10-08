import 'dart:convert';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/jobModel.dart';
import 'package:autoassist/Providers/JobProvider.dart';
import 'package:autoassist/Screens/HomePage/home.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class DeleteJobBox extends StatefulWidget {
  const DeleteJobBox({Key? key}) : super(key: key);

  @override
  _DeleteJobBoxState createState() => _DeleteJobBoxState();
}

class _DeleteJobBoxState extends State<DeleteJobBox> {
  late Job jobModel;
  late ProgressDialog pd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    jobModel = Provider.of<JobProvider>(context, listen: false).jobModel;
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
          child: Text(
            "Delete ?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
          ),
        ),
        Text("Are you sure you want to delete Job ${jobModel.jobno} ?"),
        const SizedBox(
          height: 15,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
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
                startDeleteJob();
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
    );
  }

  Future<void> startDeleteJob() async {
    pd.show(max: 100, msg: 'deleting data...');
    final body = {"_id": jobModel.jobId};

    print(body);

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    final response = await http.post(Uri.parse('${URLS.BASE_URL}/job/deleteJob'), body: jsonEncode(body), headers: requestHeaders);
    print("workingggggggggggg");
    var data = response.body;
    // print(body);
    print(json.decode(data));

    Map<String, dynamic> resData = jsonDecode(data);

    try {
      if (response.statusCode == 200) {
        Provider.of<JobProvider>(context, listen: false).startGetJobs();
        Provider.of<JobProvider>(context, listen: false).startGetHomeJobss();
        pd.close();
        Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const HomePage()), (Route<dynamic> route) => false);
        // successDialog("Done", "Job Deleted !");
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
          Navigator.pop(context);
        }).show();
  }
}
