import 'dart:io';

import 'package:autoassist/Models/userModel.dart';
import 'package:autoassist/Providers/AuthProvider.dart';
import 'package:autoassist/Screens/HomePage/homeWidgets/customer_cards.dart';
import 'package:autoassist/Screens/HomePage/homeWidgets/project_card_tile.dart';
import 'package:autoassist/Screens/HomePage/homeWidgets/service_cards.dart';
import 'package:autoassist/Screens/HomePage/homeWidgets/utils.dart';
import 'package:autoassist/Screens/HomePage/homeWidgets/vehicle_cards.dart';
import 'package:autoassist/Utils/loading_dialogs.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.title = ""}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late TabController tabController;
  // String welcome_msg = "";
  late String username;
  late UserModel userModel;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    tabController = TabController(vsync: this, length: 4);
    // welcome_msg = Utils.getWelcomeMessage();
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: screenHeight / 14),
            Container(width: MediaQuery.of(context).size.width, padding: const EdgeInsets.only(right: 10.0), child: _buildHeader(context)),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 60,
                      height: 60,
                    ),
                  ),
                  const Text(
                    'AutoAssit',
                    style: TextStyle(fontFamily: 'Montserrat', fontSize: 40.0, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: _buildTabBar(context),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: SizedBox(
                  // color: Colors.amber,
                  // height: MediaQuery.of(context).size.height - 430.0,
                  height: MediaQuery.of(context).size.height / 3.4,
                  child: _buildTabView(context)),
            ),
            _buildExpansionTile(context)
          ],
        ),
      )),
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: tabController,
      indicatorColor: Colors.amber,
      labelColor: Colors.black,
      unselectedLabelColor: Colors.grey.withOpacity(0.5),
      isScrollable: true,
      tabs: <Widget>[
        Tab(
          child: Row(
            children: const <Widget>[
              FaIcon(
                FontAwesomeIcons.user,
                size: 14.5,
              ),
              Text(
                'Customers',
                style: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Tab(
          child: Row(
            children: const <Widget>[
              FaIcon(
                FontAwesomeIcons.car,
                size: 18,
              ),
              Text(
                'Vehicles',
                style: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Tab(
          child: Row(
            children: const <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 3.0),
                child: FaIcon(
                  FontAwesomeIcons.tags,
                  size: 15,
                ),
              ),
              Text(
                'Services',
                style: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        Tab(
          child: Row(
            children: const <Widget>[
              FaIcon(
                FontAwesomeIcons.history,
                size: 15,
              ),
              Text(
                'Sales History',
                style: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildTabView(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        CustomerList(),
        const VehicleCards(),
        const ServicesList(),
        CustomerList(),
      ],
    );
  }

  Widget _buildExpansionTile(BuildContext context) {
    return ExpansionTile(
      title: Container(
        child: Row(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 25.0),
              child: Text("In-Progress jobs", style: TextStyle(fontSize: 16.0, fontFamily: 'Montserrat', fontWeight: FontWeight.w900)),
            )
          ],
        ),
      ),
      initiallyExpanded: true,
      children: <Widget>[
        Container(
          child: SingleChildScrollView(controller: _scrollController, child: ProjectCardTile()),
        )
      ],
    );
  }

  Widget _buildWelcomeMsg(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.only(left: 20.0),
      padding: const EdgeInsets.all(5.0),
      child: Text(
        "${Utils.getWelcomeMessage()}\n${userModel.userName} / ${userModel.garageName}",
        style: const TextStyle(fontFamily: 'Montserrat', fontSize: 13.0, fontWeight: FontWeight.w900),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _buildWelcomeMsg(context),
        FloatingActionButton(
            onPressed: () {
              logOut();
            },
            backgroundColor: Colors.grey.withOpacity(0.3),
            mini: true,
            elevation: 0.0,
            child: Image.asset(
              'assets/images/logout.png',
              fit: BoxFit.contain,
            )),
      ],
    );
  }

  logOut() async {
    SharedPreferences initializeToken = await SharedPreferences.getInstance();
    initializeToken.remove("authtoken").then((value) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext ctx) => const LoggingOut()));
    });
  }

  Future<bool> _onBackPressed() async {
    AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        // customHeader: Image.asset("assets/images/macha.gif"),
        animType: AnimType.topSlide,
        btnOkText: "yes",
        btnCancelText: "Hell No..",
        title: 'Are you sure ?',
        desc: 'Do you want to exit an App',
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          exit(0);
        }).show();

    return false;
  }
}
