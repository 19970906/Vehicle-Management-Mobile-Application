import 'dart:io';

import 'package:autoassist/Providers/AuthProvider.dart';
import 'package:autoassist/Providers/CustomerProvider.dart';
import 'package:autoassist/Providers/JobProvider.dart';
import 'package:autoassist/Providers/VehicleProvider.dart';
import 'package:autoassist/Providers/taskProvider.dart';
import 'package:autoassist/Screens/Customer/add_customer.dart';
import 'package:autoassist/Screens/Customer/pre_cus_list.dart';
import 'package:autoassist/Screens/Customer/view_customer.dart';
import 'package:autoassist/Screens/HomePage/home.dart';
import 'package:autoassist/Screens/Jobs/create_job.dart';
import 'package:autoassist/Screens/Login/login_page.dart';
import 'package:autoassist/Screens/Login/pincode_verify.dart';
import 'package:autoassist/Screens/SplashScreen/splash_screen.dart';
import 'package:autoassist/Screens/Troublelogin/forgotPassword.dart';
import 'package:autoassist/Screens/Vehicle/addVehicle.dart';
import 'package:autoassist/Screens/Vehicle/view_vehicle.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    OverlaySupport(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => JobProvider()),
          ChangeNotifierProvider(create: (_) => TaskProvider()),
          ChangeNotifierProvider(create: (_) => VehicleProvider()),
          ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: SplashScreen(),
      routes: <String, WidgetBuilder>{
        "/login": (BuildContext context) => const LoginPage(),
        "/pincode": (BuildContext context) => const PincodeVerify(),
        "/home": (BuildContext context) => const HomePage(),
        "/forgotpw": (BuildContext context) => const ForgotPassword(),
        "/addCustomer": (BuildContext context) => const AddCustomer(),
        "/addVehicle": (BuildContext context) => const AddVehicle(),
        "/viewCustomer": (BuildContext context) => const ViewCustomer(),
        "/viewVehicle": (BuildContext context) => const ViewVehicle(),
        "/preCusList": (BuildContext context) => const PreCustomerList(),
        "/createJob": (BuildContext context) => const CreateJob(),
      },
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
