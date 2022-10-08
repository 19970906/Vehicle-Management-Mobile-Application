import 'package:flutter/material.dart';

class JobLoader extends StatelessWidget {
  const JobLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 2,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/macha.gif'), fit: BoxFit.cover))),
    );
  }
}
