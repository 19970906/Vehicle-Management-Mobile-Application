import 'package:autoassist/Controllers/ApiServices/Customer_Services/getCustomer_vehicles.dart';
import 'package:autoassist/Models/vehicleModel.dart';
import 'package:autoassist/Providers/VehicleProvider.dart';
import 'package:autoassist/Screens/Jobs/create_job.dart';
import 'package:autoassist/Screens/Vehicle/Widgets/deleteVehicle_model.dart';
import 'package:autoassist/Screens/Vehicle/Widgets/update_milage.dart';
import 'package:autoassist/Screens/Vehicle/joblist_by_vehiNo.dart';
import 'package:autoassist/Utils/pre_loader.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OwnedVehicles extends StatefulWidget {
  final customer_id;
  final customer_name;
  const OwnedVehicles({Key? key, this.customer_id, this.customer_name}) : super(key: key);

  @override
  _OwnedVehiclesState createState() => _OwnedVehiclesState();
}

class _OwnedVehiclesState extends State<OwnedVehicles> {
  late SharedPreferences ownedVehi;
  List<Vehicle> vehicle = [];
  bool isfetched = true;
  late Vehicle vehicleModel;
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();

  @override
  void initState() {
    super.initState();

    print("customer id = " + widget.customer_id);
    print("customer name = " + widget.customer_name);
    getCusVehicles();
  }

  void removeVehicle(bool isRemove, int index) {
    if (isRemove) {
      print("isremove is $isRemove");
      setState(() {
        vehicle.removeAt(index);
      });
    } else {
      print("doesnt hve to update");
    }
  }

  getCusVehicles() async {
    SharedPreferences ownedVehi = await SharedPreferences.getInstance();
    SharedPreferences initializeToken = await SharedPreferences.getInstance();
    final body = {"cusID": ownedVehi.getString("cusId"), "token": initializeToken.getString("authtoken")};

    GetCustomerVehicles.getVehicles(body).then((vehiclesfromserver) {
      setState(() {
        vehicle = vehiclesfromserver;
        isfetched = false;
      });
      print("vehicles fetched");
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
          child: isfetched ? const PreLoader() : _buildBody(context),
        ));
  }

  Widget _buildTopAppbar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(150.0),
      child: Container(
        color: Colors.transparent,
        height: MediaQuery.of(context).size.height / 5.6,
        alignment: Alignment.center,
        child: _buildStack(context),
      ),
    );
  }

  Widget _buildStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            height: MediaQuery.of(context).size.height / 3.8,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Color(0xFF81C784),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(75.0), bottomRight: Radius.circular(75.0)),
            ),
          ),
        ),
        Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height / 22.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                    child: Image.asset(
                  "assets/images/owned.png",
                  // width: 150,
                  height: MediaQuery.of(context).size.height / 10.0,
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, top: 10),
                  child: Center(
                    child: Text(
                      widget.customer_name + "'s\n    Vehicles List. . . . ",
                      style: const TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          fontFamily: 'Montserrat',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Center(
      child: ListView.builder(
        scrollDirection: Axis.vertical,
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
        itemCount: vehicle.length,
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
                                child: Text("${vehicle[index].make} ${vehicle[index].model}",
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
                                      child: Text("Milage is ${vehicle[index].odo} Km",
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
                                        child: Text("Mr. ${vehicle[index].cusName}",
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
                                        vnumber: vehicle[index].vNumber,
                                        vehicle_name: "${vehicle[index].make} ${vehicle[index].model}",
                                        customer_name: vehicle[index].cusName,
                                        cusId: vehicle[index].cusid,
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
                            // SimpleFoldingCellState foldingCellState = context.findAncestorStateOfType<SimpleFoldingCellState>();
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
                              vehicleModel = vehicle[index];
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
                    buildInnerFields(index, Icons.phone, "Manufactured Year :", vehicle[index].mYear),
                    buildInnerFields(index, Icons.streetview, "Engine Capacity :", "${vehicle[index].eCapacity} cc"),
                    buildInnerFields(index, Icons.location_city, "Description :", vehicle[index].desc),
                    // buildInnerFields(index, Icons.supervised_user_circle,
                    //     "Milage :", vehicle[index].odo),
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
                      backgroundColor: Colors.indigoAccent,
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
                      // SimpleFoldingCellState foldingCellState = context.findAncestorStateOfType<SimpleFoldingCellState>();
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
    vehicleModel = vehicle[index];
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
    vehicleModel = vehicle[index];
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
