import 'dart:convert';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/jobModel.dart';
import 'package:autoassist/Models/taskModel.dart';
import 'package:autoassist/Models/userModel.dart';
import 'package:autoassist/Providers/AuthProvider.dart';
import 'package:autoassist/Providers/JobProvider.dart';
import 'package:autoassist/Providers/taskProvider.dart';
import 'package:autoassist/Screens/HomePage/home.dart';
import 'package:autoassist/Screens/Jobs/Widgets/change_task_status_page.dart';
import 'package:autoassist/Screens/Jobs/Widgets/deleteTask_ModelBox.dart';
import 'package:autoassist/Screens/Jobs/Widgets/delete_job_model.dart';
import 'package:autoassist/Screens/Jobs/Widgets/finish_job_model.dart';
import 'package:autoassist/Screens/Jobs/Widgets/utils.dart';
import 'package:autoassist/Utils/jobCreatingLoader.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'additems.dart';

class ShowJob extends StatefulWidget {
  const ShowJob({Key? key}) : super(key: key);

  @override
  _ShowJobState createState() => _ShowJobState();
}

class _ShowJobState extends State<ShowJob> {
  //job section variables
  String currentDate = "";
  int jobval = 0;
  late UserModel userModel;
  late Job jobModel;
  late TaskModel taskmodel;
  bool isJobCreating = true;
  List<TaskModel> _listTasks = [];
  bool isfetched = true;
  bool isEmpty = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    currentDate = Utils.getDate();
    print(currentDate);
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    // startCreateJobbbbbb();

    jobModel = Provider.of<JobProvider>(context, listen: false).jobModel;
    setState(() {
      isJobCreating = false;
    });
    Provider.of<TaskProvider>(context, listen: false).startGetTasks(jobModel.jobId);
  }

  void updateInformation(Job jobb) {
    setState(() {
      jobModel.taskCount = jobb.taskCount;
      jobModel.total = jobb.total;
      jobModel.procerCharge = jobb.procerCharge;
      jobModel.labourCharge = jobb.labourCharge;
    });
    print(jobModel.total);
    startUpdateJobDetails(jobb.taskCount, jobb.total);
  }

  void updateJobModel(Job jobb) {
    setState(() {
      jobModel = jobb;
    });
    print(jobModel.total);
  }

  void startUpdateJobDetails(String taskCount, String total) async {
    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
    final body = {
      '_id': jobModel.jobId,
      'taskCount': jobModel.taskCount,
      'total': jobModel.total,
      'procerCharge': jobModel.procerCharge,
      'labourCharge': jobModel.labourCharge
    };

    await http.post(Uri.parse('${URLS.BASE_URL}/job/updateTaskCountAndTot'), body: jsonEncode(body), headers: requestHeaders).then((value) {
      Provider.of<JobProvider>(context, listen: false).updateTaskCountAndJobtot(taskCount, total);
      Provider.of<JobProvider>(context, listen: false).startGetHomeJobss();
      print("updateddddddddd ${jobModel.labourCharge}-----$total");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isJobCreating
          ? const JobLoader()
          : Stack(children: <Widget>[
              Container(
                height: 25,
                color: const Color(0xFFef5350),
              ),
              _mainContent(context),
            ]),
      floatingActionButton: jobModel.status == 'finished'
          ? Image(
              image: const AssetImage('assets/images/completed.png'),
              height: MediaQuery.of(context).size.height / 7,
              width: 120.0,
            )
          : FloatingActionButton.extended(
              backgroundColor: const Color(0xFF0D253F),
              onPressed: () {
                print(jobModel.jobno);
                gotoFinishJob(context);
              },
              label: const Text('Finish Job'),
              icon: const Icon(Icons.done_all),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildBottomAppBar(),
    );
  }

  Future gotoFinishJob(BuildContext context) async {
    if (jobModel.status == 'finished') {
      showFinishedDialog();
    } else {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return const Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))), child: FinishedJobBox());
          });
    }
  }

  Widget _mainContent(BuildContext context) {
    _listTasks = [];
    _listTasks = Provider.of<TaskProvider>(context).listTasks;
    if (_listTasks.isNotEmpty) {
      setState(() {
        isfetched = false;
        isEmpty = false;
      });
    } else {
      setState(() {
        isfetched = false;
        isEmpty = true;
      });
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height / 25,
        ),
        _jobDetails(),
        Padding(
          padding: const EdgeInsets.only(left: 24.0, right: 24.0, bottom: 24.0),
          child: _buttons(),
        ),
        Expanded(
            child: isfetched
                ? const Center(child: CircularProgressIndicator())
                : isEmpty
                    ? const Center(
                        child: Text(
                          "No Taks Added yet",
                          style: TextStyle(fontSize: 30),
                        ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height / 1.2,
                        child: ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(bottom: 30),
                          shrinkWrap: true,
                          itemCount: _listTasks.length,
                          itemBuilder: (context, index) {
                            var task = _listTasks[index];
                            return Padding(
                              padding: const EdgeInsets.only(left: 10.0, right: 10),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    decoration: CustomIconDecoration(
                                        iconSize: 20, lineWidth: 1, firstData: index == 0 ?? true, lastData: index == _listTasks.length - 1 ?? true),
                                    child: Container(
                                      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)), boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 3),
                                          color: Color(0x20000000),
                                          blurRadius: 5,
                                        )
                                      ]),
                                      child: Icon(
                                        task.status != "on-Progress" ? Icons.fiber_manual_record : Icons.radio_button_unchecked,
                                        size: 20,
                                        color: const Color(0xFFef5350),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      SizedBox(
                                          width: MediaQuery.of(context).size.width / 6.5,
                                          child: Padding(
                                            padding: const EdgeInsets.only(left: 5.0),
                                            child: Text(
                                              "Task ${index + 1} -",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () async {
                                        await gotoStatusPage(index, context);
                                      },
                                      onLongPress: () async {
                                        await gotoDeleteTaskPage(index, context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(bottom: 12.0),
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(14.0, 0, 14.0, 14.0),
                                          decoration: const BoxDecoration(
                                              color: Color(0xFFFFE4C7),
                                              borderRadius: BorderRadius.all(Radius.circular(12)),
                                              boxShadow: [BoxShadow(color: Color(0x20000000), blurRadius: 5, offset: Offset(0, 7))]),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(mainAxisAlignment: MainAxisAlignment.start,
                                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: ListView.builder(
                                                          controller: _scrollController,
                                                          shrinkWrap: true,
                                                          itemCount: task.services.length,
                                                          itemBuilder: (context, index2) {
                                                            var services = task.services[index2];
                                                            return Text(
                                                              "${services.serviceName} [ LC - Rs. ${services.labourCharge}]",
                                                              style: const TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                                fontFamily: 'Montserrat',
                                                              ),
                                                            );
                                                          }),
                                                    ),
                                                  ]),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                  "Products Cost [ Rs. ${task.procerCharge}0 ]",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: 'Montserrat',
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 35,
                                                // width: MediaQuery.of(context).size.width /2,
                                                child: ListView.builder(
                                                    controller: _scrollController,
                                                    scrollDirection: Axis.horizontal,
                                                    shrinkWrap: true,
                                                    itemCount: task.products.length,
                                                    itemBuilder: (context, index3) {
                                                      var products = task.products[index3];
                                                      return Wrap(
                                                        direction: Axis.vertical,
                                                        children: <Widget>[
                                                          buildProductChip(products),
                                                        ],
                                                      );
                                                    }),
                                              ),
                                              Container(
                                                margin: const EdgeInsets.only(bottom: 5),
                                                child: Text(
                                                  "Total Cost [ Rs. ${task.total}0 ]",
                                                  style: const TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: 'Montserrat',
                                                      backgroundColor: Colors.amber),
                                                ),
                                              ),
                                              Container(
                                                  padding: const EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: task.status == 'on-Progress' ? const Color(0xFF4CAF50) : const Color(0xFFef5350),
                                                      borderRadius: const BorderRadius.all(Radius.circular(12))),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        task.status == 'on-Progress' ? Icons.access_time : Icons.done_outline,
                                                        size: 18,
                                                        color: Colors.white,
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        task.status == 'on-Progress' ? "This Task is ${task.status}" : "Completed",
                                                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ))
            // AddJobTaskPage()
            )
      ],
    );
  }

  Future gotoStatusPage(int index, BuildContext context) async {
    if (jobModel.status == 'finished') {
      showFinishedDialog();
    } else {
      taskmodel = _listTasks[index];
      Provider.of<TaskProvider>(context, listen: false).taskModel = taskmodel;
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return const Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))), child: ChangeTaskStatus());
          });
    }
  }

  Future gotoDeleteTaskPage(int index, BuildContext context) async {
    if (jobModel.status == 'finished') {
      showFinishedDialog();
    } else {
      taskmodel = _listTasks[index];
      Provider.of<TaskProvider>(context, listen: false).taskModel = taskmodel;
      Job jobeka = await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return const Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))), child: DeleteTaskBox());
          });
      print("issssssssssss ${jobeka.procerCharge}");
      print("issssssssssss ${jobeka.total}");
      updateJobModel(jobeka);
    }
  }

  Widget buildProductChip(ProductModel products) {
    String initAmount() {
      if (int.parse(products.amount) > 1) {
        return 's';
      } else {
        return '';
      }
    }

    return Container(
        margin: const EdgeInsets.only(right: 2),
        padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
        decoration: const BoxDecoration(
          color: Color(0xFF34465d),
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Text(
          "${products.amount}  ${products.productName}${initAmount()}",
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ));
  }

  Widget _jobDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Job NO ${jobModel.jobno}",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
              _buildFields('Date - $currentDate'),
              _buildFields('Vehicle No - ${jobModel.vNumber}'),
              _buildFields('Vehicle Name - ${jobModel.vName}'),
              _buildFields('Customer Name - ${jobModel.cusName}'),
              _buildFields('Supervisor Name - ${userModel.userName}'),
              _buildFields('Service/Product Cost - Rs.${jobModel.procerCharge}0'),
              _buildFields('Labour Charge - Rs.${jobModel.labourCharge}0'),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                userModel.garageName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(5.0),
                // height: MediaQuery.of(context).size.height / 13,
                // width: MediaQuery.of(context).size.width / 4.5,
                decoration: BoxDecoration(color: const Color(0xFF34465d), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Task Count",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      jobModel.taskCount,
                      softWrap: true,
                      style: const TextStyle(color: Colors.white, fontFamily: 'OpenSans', fontSize: 14.0, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(color: const Color(0xFFef5350), borderRadius: BorderRadius.circular(12)),
                child: Column(
                  children: [
                    const Text(
                      "Job Total",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      "Rs.${jobModel.total}0",
                      style: const TextStyle(fontFamily: 'OpenSans', color: Colors.white, fontWeight: FontWeight.w800),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFields(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat',
      ),
    );
  }

  Widget _buttons() {
    return Row(children: <Widget>[
      Expanded(
        child: MaterialButton(
          color: const Color(0xFFef5350),
          textColor: Colors.white,
          onPressed: () async {
            if (jobModel.status == 'finished') {
              showFinishedDialog();
            } else {
              Job jobeka = await showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                        child: AddTasksModel(
                          vnumber: jobModel.vNumber,
                          vehicle_name: jobModel.vName,
                          cusId: jobModel.cusId,
                          customer_name: jobModel.cusName,
                          jobmodel: jobModel,
                        ));
                  });
              print("issssssssssss ${jobeka.procerCharge}");
              print("issssssssssss ${jobeka.total}");
              updateInformation(jobeka);
            }
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(14.0),
          child: const Text('Add Job Tasks'),
        ),
      ),
      const SizedBox(
        width: 32,
      ),
      Expanded(
        child: MaterialButton(
          color: Colors.white,
          textColor: const Color(0xFFef5350),
          onPressed: () async {
            // SharedPreferences job = await SharedPreferences.getInstance();
            // job.remove("jobno");
            // print("cleared");
            gotoDeleteJob(context);
          },
          shape: RoundedRectangleBorder(side: const BorderSide(color: Color(0xFFef5350)), borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(14.0),
          child: const Text('Cancel job'),
        ),
      )
    ]);
  }

  showFinishedDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sorry, You can't !"),
            content: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 12,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "This is already a finished job !",
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 40,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future gotoDeleteJob(BuildContext context) async {
    if (jobModel.status == 'finished') {
      showFinishedDialog();
    } else {
      await showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return const Dialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))), child: DeleteJobBox());
          });
    }
  }

  BottomAppBar buildBottomAppBar() {
    return BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
          IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.of(context)
                    .pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => const HomePage()), (Route<dynamic> route) => false);
              }),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {})
        ]));
  }
}

class CustomIconDecoration extends Decoration {
  final double iconSize;
  final double lineWidth;
  final bool firstData;
  final bool lastData;

  const CustomIconDecoration({
    required double iconSize,
    required double lineWidth,
    required bool firstData,
    required bool lastData,
  })  : iconSize = iconSize,
        lineWidth = lineWidth,
        firstData = firstData,
        lastData = lastData;

  @override
  BoxPainter createBoxPainter([Function()? onChanged]) {
    return IconLine(iconSize: iconSize, lineWidth: lineWidth, firstData: firstData, lastData: lastData);
  }
}

class IconLine extends BoxPainter {
  final double iconSize;
  final bool firstData;
  final bool lastData;

  final Paint paintLine;

  IconLine({
    required double iconSize,
    required double lineWidth,
    required bool firstData,
    required bool lastData,
  })  : iconSize = iconSize,
        firstData = firstData,
        lastData = lastData,
        paintLine = Paint()
          ..color = Colors.red
          ..strokeCap = StrokeCap.round
          ..strokeWidth = lineWidth
          ..style = PaintingStyle.stroke;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final leftOffset = Offset((iconSize / 2) + 10, offset.dy);
    final double iconSpace = iconSize / 1.8;

    final Offset top = configuration.size!.topLeft(Offset(leftOffset.dx, 0.0));
    final Offset centerTop = configuration.size!.centerLeft(Offset(leftOffset.dx, leftOffset.dy - iconSpace));

    final Offset centerBottom = configuration.size!.centerLeft(Offset(leftOffset.dx, leftOffset.dy + iconSpace));
    final Offset end = configuration.size!.bottomLeft(Offset(leftOffset.dx, leftOffset.dy * 2));

    if (!firstData) canvas.drawLine(top, centerTop, paintLine);
    if (!lastData) canvas.drawLine(centerBottom, end, paintLine);
  }
}
