import 'dart:convert';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/vehicleModel.dart';
import 'package:autoassist/Providers/VehicleProvider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class DeleteVehicle extends StatefulWidget {
  const DeleteVehicle({Key? key}) : super(key: key);

  @override
  _DeleteVehicleState createState() => _DeleteVehicleState();
}

class _DeleteVehicleState extends State<DeleteVehicle> {
  late Vehicle vehicleModel;
  bool remove = false;
  late ProgressDialog pd;

  @override
  void initState() {
    super.initState();
    vehicleModel = Provider.of<VehicleProvider>(context, listen: false).vehicleModel;
  }

  Future<bool> onbackpress() async {
    Navigator.pop(context, remove);
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
          Text(
            "Are you sure you want to remove ${vehicleModel.make} ${vehicleModel.model} ?",
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context, remove);
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
                  startDeleteVehicle();
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

  Future<void> startDeleteVehicle() async {
    pd.show(max: 100, msg: 'Deleting data...');
    final body = {"_id": vehicleModel.vID, "vnumber": vehicleModel.vNumber};

    print(body);

    Map<String, String> requestHeaders = {'Content-Type': 'application/json'};

    final response = await http.post(Uri.parse('${URLS.BASE_URL}/vehicle/removeVehicle'), body: jsonEncode(body), headers: requestHeaders);
    print("workingggggggggggg");
    var data = response.body;
    // print(body);
    print(json.decode(data));

    Map<String, dynamic> resData = jsonDecode(data);

    try {
      if (response.statusCode == 200) {
        setState(() {
          remove = true;
        });
        pd.close();
        successDialog("Done", "Vehicle removed succefully");
      } else {
        // Dialogs.errorDialog(context, "F", "Something went wrong !");
        pd.close();
        Navigator.pop(context, remove);
        print("vehicle coudlnt remove !");
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
          Navigator.pop(context, remove);
        }).show();
  }
}
