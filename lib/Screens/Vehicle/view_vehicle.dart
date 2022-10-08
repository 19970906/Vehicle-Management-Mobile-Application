import 'dart:async';

import 'package:autoassist/Controllers/ApiServices/Vehicle_Services/getVehicles_Service.dart';
import 'package:autoassist/Models/vehicleModel.dart';
import 'package:autoassist/Providers/VehicleProvider.dart';
import 'package:autoassist/Screens/Jobs/create_job.dart';
import 'package:autoassist/Screens/Vehicle/Widgets/deleteVehicle_model.dart';
import 'package:autoassist/Screens/Vehicle/Widgets/update_milage.dart';
import 'package:autoassist/Screens/Vehicle/joblist_by_vehiNo.dart';
import 'package:autoassist/Utils/noResponseWidgets/noVehiclesMsg.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewVehicle extends StatefulWidget {
  const ViewVehicle({Key? key}) : super(key: key);

  @override
  _ViewVehicleState createState() => _ViewVehicleState();
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

class _ViewVehicleState extends State<ViewVehicle> {
  final _debouncer = Debouncer(milliseconds: 500);
  List<Vehicle> vehicle = [];
  List<Vehicle> filteredVehicles = [];

  // List _selectedIndexs = [];
  final _search = TextEditingController();

  bool isClicked = false;
  bool isSearchFocused = false;
  String isExpanded = "";
  bool isfetched = true;
  bool isEmpty = false;
  late Vehicle vehicleModel;
  int total = 0;
  late ScrollController _scrollController;

  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    GetVehicleService.getVehicles().then((vehiclesFromServer) {
      if (vehiclesFromServer.isNotEmpty) {
        setState(() {
          vehicle = vehiclesFromServer;
          filteredVehicles = vehicle;
          total = filteredVehicles.length;
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

  void removeVehicle(bool isRemove, int index) {
    if (isRemove) {
      print("isremove is $isRemove");
      setState(() {
        filteredVehicles.removeAt(index);
      });
    } else {
      print("doesnt hve to update");
    }
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
      // height: MediaQuery.of(context).size.height/0.5,
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
              color: Color(0xFF81C784),
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
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Vehicles List.. ',
                          style: TextStyle(
                              textBaseline: TextBaseline.alphabetic,
                              fontFamily: 'Montserrat',
                              fontSize: 25.0,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w900,
                              color: Colors.white),
                        ),
                        Container(
                          //  margin: EdgeInsets.only(right: 20),
                          child: Text(
                            "Total Vehicles - $total",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
        // Positioned(
        //     left: 20,
        //     top: MediaQuery.of(context).size.height / 5,
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
            controller: _scrollController,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
                child: SimpleFoldingCell.create(
                    key: _foldingCellKey,
                    frontWidget: _buildFrontWidget(index),
                    innerWidget: _buildInnerTopWidget(index),
                    // innerBottomWidget: _buildInnerBottomWidget(index),
                    cellSize: Size(MediaQuery.of(context).size.width / 0.4, MediaQuery.of(context).size.height / 3.8),
                    // padding: EdgeInsets.only(left:25,top: 25,right: 25),
                    animationDuration: const Duration(milliseconds: 300),
                    borderRadius: 30,
                    onOpen: () => print('$index cell opened'),
                    onClose: () => print('$index cell closed')),
              );
            },
            itemCount: filteredVehicles.length,
          ),
        ],
      ),
    );
  }

  Widget _buildFrontWidget(index) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
            color: const Color(0xFFffcd3c),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              height: 50,
                              width: 80,
                              decoration:
                                  const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/owned.png'), fit: BoxFit.cover)),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2,
                                child: Text("${filteredVehicles[index].make} ${filteredVehicles[index].model}",
                                    // overflow: TextOverflow.clip,
                                    softWrap: true,
                                    style: const TextStyle(
                                        color: Color(0xFF2e282a), fontFamily: 'Montserrat', fontSize: 20.0, fontWeight: FontWeight.w900)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    const Icon(Icons.shutter_speed, size: 16, color: Color(0xFFf44336)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text("Milage is ${filteredVehicles[index].odo} Km",
                                          style: const TextStyle(
                                              color: Color(0xFF2e282a), fontFamily: 'OpenSans', fontSize: 15.0, fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    const Icon(Icons.person, size: 18, color: Color(0xFFf44336)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: SizedBox(
                                        width: MediaQuery.of(context).size.width / 2.4,
                                        child: Text("Mr. ${filteredVehicles[index].cusName}",
                                            softWrap: true,
                                            style: const TextStyle(
                                                color: Color(0xFF2e282a), fontFamily: 'OpenSans', fontSize: 15.0, fontWeight: FontWeight.w400)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10, left: 3, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              print("clicked on history btn");
                              int jobno = 0;
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
                                  jobno++;
                                });
                                job.setString("jobno", jobno.toString());
                                print("job no $jobno");
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => CreateJob(
                                        vnumber: filteredVehicles[index].vNumber,
                                        vehicle_name: "${filteredVehicles[index].make} ${filteredVehicles[index].model}",
                                        customer_name: filteredVehicles[index].cusName,
                                        cusId: filteredVehicles[index].cusid,
                                      )));
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(color: Colors.white),
                              backgroundColor: Colors.indigoAccent,
                            ),
                            child: const Text(
                              "Assign Job",
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _foldingCellKey.currentState?.toggleFold();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              margin: const EdgeInsets.only(top: 5),
                              decoration:
                                  const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/arrowdown.png'), fit: BoxFit.cover))),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              vehicleModel = filteredVehicles[index];
                              Provider.of<VehicleProvider>(context, listen: false).vehicleModel = vehicleModel;

                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobListByVehiId()));
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(color: Colors.white),
                              backgroundColor: Colors.indigoAccent,
                            ),
                            child: const Text(
                              "Job History",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildInnerTopWidget(index) {
    return Container(
      color: const Color(0xFFffcd3c),
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 7.0, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildInnerFields(index, Icons.phone, "Manufactured Year :", filteredVehicles[index].mYear),
                    buildInnerFields(index, Icons.streetview, "Engine Capacity :", "${filteredVehicles[index].eCapacity} cc"),
                    buildInnerFields(index, Icons.location_city, "Description :", filteredVehicles[index].desc),
                    // buildInnerFields(index, Icons.supervised_user_circle,
                    //     "Milage :", filteredVehicles[index].odo),
                  ],
                ),
              ),
            ],
          ),
          _buildInnerBottomWidget(index)
        ],
      ),
    );
  }

  Padding buildInnerFields(index, IconData icon, String title, String data) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, left: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(icon, size: 18, color: const Color(0xFFf44336)),
          Text(
            title,
            style: const TextStyle(
                // color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Text(
                data,
                style: const TextStyle(color: Color(0xFF2e282a), fontFamily: 'OpenSans', fontSize: 16.0, fontWeight: FontWeight.w600),
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerBottomWidget(index) {
    return Builder(builder: (context) {
      return Container(
        color: const Color(0xFFef9a9a),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      print("clicked edit btn");
                      goToUpdateOdo(index, context);
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.white),
                    ),
                    child: const Text(
                      "Update Milage",
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      _foldingCellKey.currentState?.toggleFold();
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.white),
                      backgroundColor: Colors.indigoAccent,
                    ),
                    child: const Text(
                      "Close Card",
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      print("clicked delete btn");
                      goToDelVehicle(index, context);
                    },
                    style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(color: Colors.white),
                      backgroundColor: Colors.indigoAccent,
                    ),
                    child: const Text(
                      "Delete Vehicle",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void goToUpdateOdo(index, BuildContext context) {
    print("clicked edit btn");
    vehicleModel = filteredVehicles[index];
    Provider.of<VehicleProvider>(context, listen: false).vehicleModel = vehicleModel;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            child: UpdateMilage(),
          );
        });
  }

  Future goToDelVehicle(index, BuildContext context) async {
    print("clicked edit btn");
    vehicleModel = filteredVehicles[index];
    Provider.of<VehicleProvider>(context, listen: false).vehicleModel = vehicleModel;
    bool remove = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
            child: DeleteVehicle(),
          );
        });
    print("issssssssssss $remove");
    removeVehicle(remove, index);
  }
}
