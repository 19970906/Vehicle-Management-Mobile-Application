import 'dart:async';

import 'package:autoassist/Controllers/ApiServices/Customer_Services/getCustomers_Service.dart';
import 'package:autoassist/Models/customerModel.dart';
import 'package:autoassist/Providers/CustomerProvider.dart';
import 'package:autoassist/Screens/Customer/Widgets/delete_customer.dart';
import 'package:autoassist/Screens/Customer/Widgets/edit_csutomer.dart';
import 'package:autoassist/Screens/Customer/owned_vehicles.dart';
import 'package:autoassist/Screens/Vehicle/addVehicle.dart';
import 'package:autoassist/Utils/noResponseWidgets/noCustomersMsg.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:folding_cell/folding_cell/widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewCustomer extends StatefulWidget {
  const ViewCustomer({Key? key}) : super(key: key);

  @override
  _ViewCustomerState createState() => _ViewCustomerState();
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

class _ViewCustomerState extends State<ViewCustomer> {
  final _debouncer = Debouncer(milliseconds: 500);
  List<Customer> customer = [];
  List<Customer> filteredCustomers = [];
  final _foldingCellKey = GlobalKey<SimpleFoldingCellState>();

  // List _selectedIndexs = [];
  final _search = TextEditingController();

  bool isClicked = false;
  bool isSearchFocused = false;
  bool isfetched = true;
  bool isEmpty = false;
  String isExpanded = "";
  late Customer customerModel;
  int total = 0;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    GetCustomerService.getCustomers().then((customersFromServer) {
      if (customersFromServer.isNotEmpty) {
        setState(() {
          customer = customersFromServer;
          filteredCustomers = customer;
          total = filteredCustomers.length;
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

  void removeCustomer(bool isRemove, int index) {
    if (isRemove) {
      print("isremove is $isRemove");
      setState(() {
        filteredCustomers.removeAt(index);
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
                  ? const NoCustomersMsg()
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
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(75.0),
                  bottomRight: Radius.circular(75.0)),
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
                  "assets/images/personas.png",
                  // width: 150,
                  height: MediaQuery.of(context).size.height / 8.0,
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customer List.. ',
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
                            "Total Customers - $total",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 15),
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
      padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 2),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
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
              filteredCustomers = customer
                  .where((u) =>
                      (u.fName.toLowerCase().contains(string.toLowerCase())) ||
                      (u.mobile.toLowerCase().contains(string.toLowerCase())))
                  .toList();
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
                margin: const EdgeInsets.only(left: 8, right: 8, bottom: 0),
                child: SimpleFoldingCell.create(
                    key: _foldingCellKey,
                    frontWidget: _buildFrontWidget(index),
                    innerWidget: _buildInnerTopWidget(index),
                    // innerBottomWidget: _buildInnerBottomWidget(index),
                    cellSize: Size(MediaQuery.of(context).size.width / 0.4,
                        MediaQuery.of(context).size.height / 3.8),
                    // padding: EdgeInsets.only(left:25,top: 25,right: 25),
                    animationDuration: const Duration(milliseconds: 300),
                    borderRadius: 30,
                    onOpen: () => print('$index cell opened'),
                    onClose: () => print('$index cell closed')),
              );
            },
            itemCount: filteredCustomers.length,
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
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Container(
                              height: 80,
                              width: 80,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/cus_avatar.png'),
                                      fit: BoxFit.cover)),
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
                                child: Text(
                                    "${filteredCustomers[index].fName} ${filteredCustomers[index].lName}",
                                    // overflow: TextOverflow.clip,
                                    softWrap: true,
                                    style: const TextStyle(
                                        color: Color(0xFF2e282a),
                                        fontFamily: 'Montserrat',
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w900)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    const Icon(Icons.phone_iphone,
                                        size: 16, color: Color(0xFFf44336)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                          filteredCustomers[index].mobile,
                                          style: const TextStyle(
                                              color: Color(0xFF2e282a),
                                              fontFamily: 'OpenSans',
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: <Widget>[
                                    const Icon(Icons.email,
                                        size: 16, color: Color(0xFFf44336)),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.4,
                                        child: Text(
                                            filteredCustomers[index].email,
                                            softWrap: true,
                                            style: const TextStyle(
                                                color: Color(0xFF2e282a),
                                                fontFamily: 'OpenSans',
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w400)),
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
                    padding: const EdgeInsets.only(
                        top: 10.0, bottom: 10, left: 3, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              print("clicked on attach btn");
                              final cusId = filteredCustomers[index].cusid;
                              final cusName =
                                  "${filteredCustomers[index].fName} ${filteredCustomers[index].lName}";

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AddVehicle(
                                        customer_id: cusId,
                                        customer_name: cusName,
                                      )));
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(color: Colors.white),
                              backgroundColor: Colors.indigoAccent,
                            ),
                            child: const Text(
                              "Attach Vehicle",
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
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/arrowdown.png'),
                                      fit: BoxFit.cover))),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: ElevatedButton(
                            onPressed: () async {
                              final cusId = filteredCustomers[index].cusid;
                              final cusName =
                                  "${filteredCustomers[index].fName} ${filteredCustomers[index].lName}";

                              SharedPreferences ownedVehi =
                                  await SharedPreferences.getInstance();
                              ownedVehi.setString("cusId", cusId);

                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => OwnedVehicles(
                                        customer_id: cusId,
                                        customer_name: cusName,
                                      )));
                            },
                            style: ElevatedButton.styleFrom(
                              textStyle: const TextStyle(color: Colors.white),
                              backgroundColor: Colors.indigoAccent,
                            ),
                            child: const Text(
                              "Owned Vehicles",
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
                    buildInnerFields(index, Icons.phone, "Telephone :",
                        filteredCustomers[index].telephone),
                    buildInnerFields(index, Icons.code, "Adress L1 :",
                        filteredCustomers[index].adL1),
                    buildInnerFields(index, Icons.streetview, "Adress L2 :",
                        filteredCustomers[index].adL2),
                    buildInnerFields(index, Icons.location_city, "Adress L3 :",
                        filteredCustomers[index].adL3),
                    buildInnerFields(index, Icons.supervised_user_circle,
                        "User Role :", filteredCustomers[index].role),
                  ],
                ),
              ),
            ],
          ),
          _buildInnerBottomWidget(index),
          Padding(
            padding: const EdgeInsets.only(bottom: 0.0),
            child: Container(
              margin: const EdgeInsets.only(right: 5),
              height: MediaQuery.of(context).size.height / 7,
              width: MediaQuery.of(context).size.width / 6.3,
              decoration: const BoxDecoration(
                  color: Color(0xFF81C784), shape: BoxShape.circle),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Credit Limit",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    filteredCustomers[index].cLimit,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFef5350),
                      fontFamily: 'OpenSans',
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
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
            child: Text(data,
                style: const TextStyle(
                    color: Color(0xFF2e282a),
                    fontFamily: 'OpenSans',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildInnerBottomWidget(index) {
    return Builder(builder: (context) {
      return Container(
        margin: const EdgeInsets.only(bottom: 0),
        color: const Color(0xFFe57373),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  goToEditDetails(index, context);
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(color: Colors.white),
                  backgroundColor: Colors.indigoAccent,
                ),
                child: const Text(
                  "Update Details",
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
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
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  print("clicked delete btn");
                  goToDelCustomer(index, context);
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(color: Colors.white),
                  backgroundColor: Colors.indigoAccent,
                ),
                child: const Text(
                  "Delete Customer",
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void goToEditDetails(index, BuildContext context) {
    print("clicked edit btn");
    customerModel = filteredCustomers[index];
    Provider.of<CustomerProvider>(context, listen: false).customerModel =
        customerModel;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: EditCustomer(),
          );
        });
  }

  Future<void> goToDelCustomer(index, BuildContext context) async {
    print("clicked edit btn");
    customerModel = filteredCustomers[index];
    Provider.of<CustomerProvider>(context, listen: false).customerModel =
        customerModel;
    bool remove = await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            child: DeleteCustomer(),
          );
        });
    print("issssssssssss $remove");
    removeCustomer(remove, index);
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
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ViewCustomer()));
        }).show();
  }
}
