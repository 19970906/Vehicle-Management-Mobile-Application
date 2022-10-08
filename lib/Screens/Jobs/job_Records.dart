import 'package:autoassist/Screens/Jobs/Widgets/finished_jobList.dart';
import 'package:autoassist/Screens/Jobs/Widgets/ongoing_jobList.dart';
import 'package:flutter/material.dart';

class JobRecords extends StatefulWidget {
  @override
  _JobRecordsState createState() => _JobRecordsState();
}

class _JobRecordsState extends State<JobRecords> with SingleTickerProviderStateMixin {
  late TabController tabController;
  String state = "Followers";

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // this avoids the overflow error
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey[100],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120.0),
        child: _buildTopAppbar(context),
      ),

      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Center(child: _buildTabBar(context)),
              ),
              Flexible(
                child: _buildTabView(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopAppbar(BuildContext context) {
    return Container(
      color: Colors.transparent,
      // height: MediaQuery.of(context).size.height / 2,
      alignment: Alignment.center,
      child: _buildStack(context),
    );
  }

  Widget _buildStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            height: MediaQuery.of(context).size.height / 4,
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
                  "assets/images/jobrecords.png",
                  width: MediaQuery.of(context).size.height / 10.0,
                  height: MediaQuery.of(context).size.height / 10.0,
                )),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Center(
                    child: Text(
                      'Jobs List',
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
        //     top: MediaQuery.of(context).size.height / 5,
        //     child: Column(children: <Widget>[_buildSearchBar(context)]))
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 30.0),
      width: MediaQuery.of(context).size.width / 1.4,
      height: 45,
      // margin: EdgeInsets.only(top: 32),
      padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 2),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)), color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
      child: TextField(
        keyboardType: TextInputType.text,
        // controller: _search,
        onTap: () {
          //   setState(() {
          //     isSearchFocused = true;
          //   });
          // },
          // onChanged: (string) {
          //   _debouncer.run(() {
          //     setState(() {
          //       filteredVehicles = vehicle
          //           .where((u) =>
          //               (u.vNumber.toLowerCase().contains(string.toLowerCase())))
          //           .toList();
          //     });
          //   });
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

  Widget _buildTabView(BuildContext context) {
    return TabBarView(
      controller: tabController,
      children: <Widget>[
        SingleChildScrollView(child: OngoingJobsContent()),
        SingleChildScrollView(child: FinishedJobContent()),
      ],
    );
  }

  Widget _buildTabBar(BuildContext context) {
    return TabBar(
      controller: tabController,
      indicatorColor: Colors.transparent,
      labelColor: const Color(0xFFFF6038),
      labelStyle: const TextStyle(fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
      unselectedLabelColor: const Color(0xFF020433),
      isScrollable: true,
      tabs: <Widget>[
        getTabs('On-Going'),
        getTabs('Completed'),
      ],
    );
  }

  getTabs(String title) {
    return Tab(
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20.0,
          fontFamily: 'Montserrat',
        ),
      ),
    );
  }
}

class OngoingJobsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: OngoingJobList());
  }
}

class FinishedJobContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        child: FinishedJobList());
  }
}

// class UserCardItem extends StatelessWidget {
//   final bool isFollowed;
//   final bool withBorder;
//   UserCardItem({
//     this.isFollowed = false,
//     this.withBorder = false,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return UserCard(
//       (!isFollowed)
//           ? RoundedBorderButton(
//               "FOLLOW",
//               color1: Color.fromRGBO(255, 94, 58, 1),
//               color2: Color.fromRGBO(255, 149, 0, 1),
//               textColor: Colors.white,
//               width: 100,
//               shadowColor: Colors.transparent,
//             )
//           : RoundedBorderButton(
//               "MESSAGE",
//               color1: Colors.grey[100],
//               color2: Colors.grey[100],
//               textColor: Colors.blueGrey[800],
//               width: 100,
//               shadowColor: Colors.transparent,
//             ),
//       withBorder: withBorder,
//     );
//   }
// }
