import 'package:flutter/material.dart';

class PreLoader extends StatelessWidget {
  const PreLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 3,
          decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/loading4.gif'), fit: BoxFit.cover))),
    );
  }
}
