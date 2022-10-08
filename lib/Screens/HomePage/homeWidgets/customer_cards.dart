import 'package:flutter/material.dart';

class CustomerList extends StatefulWidget {
  @override
  _CustomerListState createState() => _CustomerListState();
}

class _CustomerListState extends State<CustomerList> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: ListView(
            padding: EdgeInsets.only(left: 25.0),
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              getCustomerCard('assets/images/add_cus.png', '     Add \nCustomer', onTap: () {
                Navigator.of(context).pushNamed("/addCustomer");
              }),
              SizedBox(width: 15.0),
              getCustomerCard('assets/images/personas.png', '     View \nCustomers', onTap: () {
                Navigator.of(context).pushNamed("/viewCustomer");
              }),
              SizedBox(width: 15.0),
              getCustomerCard('assets/images/cus_history.png', 'Customer\nHistory', onTap: () {
                print("Go to customer history screen !");
              }),
              SizedBox(width: 15.0),
            ],
          ),
        ),
      ],
    );
  }

  getCustomerCard(String imgPath, String cardTitle, {Function()? onTap}) {
    return Stack(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height / 4,
          width: 140.0,
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: Color(0xFF8E8CD8)),
            height: 225.0,
            width: 200.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: AssetImage(imgPath),
                  height: 100.0,
                  width: 120.0,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      cardTitle,
                      style: TextStyle(fontFamily: 'Montserrat', fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: 45.0,
            top: MediaQuery.of(context).size.height / 4.5,
          ),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(25.0), color: Color(0xFFef9a9a)),
              child: Center(
                  child: Icon(
                Icons.add_circle,
                color: Colors.white,
                size: 30,
              )),
            ),
          ),
        )
      ],
    );
  }
}
