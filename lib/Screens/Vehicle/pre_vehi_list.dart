import 'dart:async';

import 'package:autoassist/Controllers/ApiServices/vehicle_services/getVehicles_service.dart';
import 'package:autoassist/Models/vehicleModel.dart';
import 'package:autoassist/Screens/Jobs/create_job.dart';
import 'package:autoassist/Utils/noResponseWidgets/noVehiclesMsg.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreVehicleList extends StatefulWidget {
  const PreVehicleList({Key? key}) : super(key: key);

  @override
  _PreVehicleListState createState() => _PreVehicleListState();
}

class Debouncer {
  final int milliseconds;
  late VoidCallback action;
  late Timer _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _PreVehicleListState extends State<PreVehicleList> {
  final _debouncer = Debouncer(milliseconds: 500);
  List<Vehicle> vehicle = [];
  List<Vehicle> filteredVehicles = [];

  // List _selectedIndexs = [];
  final _search = TextEditingController();
  bool isSearchFocused = false;
  bool isfetched = true;
  bool isEmpty = false;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    GetVehicleService.getVehicles().then((vehiclesFromServer) {
      if (vehiclesFromServer.isNotEmpty) {
        setState(() {
          vehicle = vehiclesFromServer;
          filteredVehicles = vehicle;
          isfetched = false;
        });
      } else {
        setState(() {
          isEmpty = true;
          isfetched = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // this avoids the overflow error
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(150.0),
          child: _buildTopAppbar(context),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: isfetched
              ? const Center(child: CircularProgressIndicator())
              : isEmpty
                  ? const NoVehiclesMsg()
                  : _buildBody(context),
        ));
  }

  Widget _buildTopAppbar(BuildContext context) {
    return Container(
      color: Colors.transparent,
      // height: MediaQuery.of(context).size.height / 0.5,
      alignment: Alignment.center,
      child: _buildStack(context),
    );
  }

  Widget _buildStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            height: MediaQuery.of(context).size.height - 420.0,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color(0xFF8E8CD8),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(75.0), bottomRight: Radius.circular(75.0)),
            ),
          ),
        ),
        Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height / 20.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                    child: Image.asset(
                  "assets/images/view.png",
                  // width: 150,
                  height: MediaQuery.of(context).size.height / 8.0,
                )),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Center(
                    child: Text(
                      'Select a \nVehicle First',
                      style: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          fontFamily: 'Montserrat',
                          fontSize: 25.0,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            )),
        // Positioned(
        //     left: 20,
        //     top: MediaQuery.of(context).size.height / 4.8,
        //     child: Column(children: <Widget>[_buildSearchBar(context)]))
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: MediaQuery.of(context).size.height / 15,
      margin: const EdgeInsets.only(top: 15),
      // margin: EdgeInsets.only(top: 32),
      padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 2),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)), color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
      child: TextField(
        keyboardType: TextInputType.text,
        // controller: _search,
        onTap: () {
          setState(() {
            isSearchFocused = true;
          });
        },
        onChanged: (string) {
          _debouncer.run(() {
            setState(() {
              filteredVehicles = vehicle.where((u) => (u.vNumber.toLowerCase().contains(string.toLowerCase()))).toList();
            });
          });
        },
        decoration: const InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey,
            size: 30,
          ),
          hintText: 'search',
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildSearchBar(context),
          ListView.builder(
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                child: _getVehiclesList(index, 'assets/images/owned.png', "${filteredVehicles[index].make} ${filteredVehicles[index].model}",
                    filteredVehicles[index].vNumber, filteredVehicles),
              );
            },
            itemCount: filteredVehicles.length,
          ),
        ],
      ),
    );
  }

  Widget _getVehiclesList(index, String imgPath, vehiName, vNumber, filteredVehicles) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      child: GestureDetector(
        onTap: () {
          _navigateToJobScreen(index);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                child: Row(children: [
              Image.asset(
                imgPath,
                height: 60.0,
                width: 60.0,
              ),
              const SizedBox(width: 10.0),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child:
                      Text(vehiName, style: const TextStyle(fontFamily: 'Montserrat', fontSize: 17.0, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(vNumber,
                      style: const TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 15.0,
                        color: Colors.grey,
                      )),
                )
              ])
            ])),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              color: Colors.black,
              onPressed: () {
                _navigateToJobScreen(index);
              },
            )
          ],
        ),
      ),
    );
  }

  _navigateToJobScreen(index) async {
    final vnumber = filteredVehicles[index].vNumber;
    final vehicleName = "${filteredVehicles[index].make} ${filteredVehicles[index].model}";
    final customerName = filteredVehicles[index].cusName;
    final cusId = filteredVehicles[index].cusid;
    int jobno = 0;
    print("$vehicleName\n$vnumber\n$customerName\n$cusId\nhuttoooo");
    SharedPreferences job = await SharedPreferences.getInstance();
    print(job.getString("jobno"));

    if (job.getString("jobno") == null) {
      setState(() {
        jobno++;
      });
      job.setString("jobno", jobno.toString());
      print("job no $jobno");
    } else {
      print("eka his na oi");
      setState(() {
        jobno = int.parse(job.getString("jobno")!);
        // jobno++;
      });
      job.setString("jobno", jobno.toString());
      print("job no $jobno");
    }

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CreateJob(
              vnumber: vnumber,
              vehicle_name: vehicleName,
              customer_name: customerName,
              cusId: cusId,
            )));
  }
}
