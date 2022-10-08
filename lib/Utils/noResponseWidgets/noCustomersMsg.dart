import 'package:autoassist/Screens/Customer/add_customer.dart';
import 'package:flutter/material.dart';

class NoCustomersMsg extends StatelessWidget {
  const NoCustomersMsg({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: MediaQuery.of(context).size.height / 4,
              //  width: MediaQuery.of(context).size.width /1.5,
              decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/nodatafound.png'), fit: BoxFit.fill))),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCustomer(),
                ),
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.width / 10,
              width: MediaQuery.of(context).size.width / 2.5,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8E8CD8), Color(0xFF8E8CD8)],
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: Center(
                child: Text(
                  'Try Add Some'.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
