import 'package:autoassist/Controllers/ApiServices/Customer_Services/addCustomer_Service.dart';
import 'package:autoassist/Models/userModel.dart';
import 'package:autoassist/Providers/AuthProvider.dart';
import 'package:autoassist/Screens/Customer/view_customer.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key? key}) : super(key: key);

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final _fname = TextEditingController();
  final _lname = TextEditingController();
  final _email = TextEditingController();
  final _tel = TextEditingController();
  final _mobile = TextEditingController();
  get _role => _currentRole;
  final _p_code = TextEditingController();
  final _street = TextEditingController();
  final _city = TextEditingController();
  final _cLimit = TextEditingController();

  final List __role = ["Owner", "Driver"];
  List<DropdownMenuItem<String>> _dropDownMenuItems = [];
  String _currentRole = "";
  final String _errorTxt = '';
  late UserModel userModel;

  @override
  void initState() {
    _dropDownMenuItems = getDropDownMenuItems();
    _currentRole = _dropDownMenuItems[0].value!;
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    super.initState();
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String role in __role) {
      items.add(DropdownMenuItem(value: role, child: Text(role)));
    }
    return items;
  }

  late ProgressDialog pd;

  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context: context);
    // pr.style(
    //     message: 'Saving Info...',
    //     borderRadius: 10.0,
    //     progressWidget: Container(
    //         height: 30,
    //         width: 30,
    //         decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/loading2.gif'), fit: BoxFit.cover))),
    //     elevation: 10.0,
    //     insetAnimCurve: Curves.easeInOut,
    //     progressTextStyle: const TextStyle(fontFamily: 'Montserrat'));

    return Scaffold(
        // this avoids the overflow error
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: _buildTopAppbar(context),
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SingleChildScrollView(child: _buildTextfields(context)),
              ],
            ),
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context));
  }

  Widget _buildTopAppbar(BuildContext context) {
    return Container(
      color: Colors.transparent,
      height: 130.0,
      alignment: Alignment.center,
      child: _buildStack(context),
    );
  }

  Widget _buildStack(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Container(
            height: MediaQuery.of(context).size.height / 4.0,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(75.0), bottomRight: Radius.circular(75.0)),
            ),
          ),
        ),
        Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height / 25.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Center(
                    child: Image.asset(
                  "assets/images/add_cus.png",
                  width: 150,
                  height: 100,
                )),
                const Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Center(
                    child: Text(
                      'Customer\n     Registration.. ',
                      style: TextStyle(
                          textBaseline: TextBaseline.alphabetic,
                          fontFamily: 'Montserrat',
                          fontSize: 20.0,
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

  Widget _buildTextfields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Container(
          //height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 4),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                child: TextField(
                  controller: _fname,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.recent_actors,
                      color: Colors.grey,
                    ),
                    hintText: 'First Name',
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 2),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                child: TextField(
                  controller: _lname,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.recent_actors,
                      color: Colors.grey,
                    ),
                    hintText: 'Last Name',
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 2),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                child: TextField(
                  controller: _email,
                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.email,
                      color: Colors.grey,
                    ),
                    hintText: 'Email',
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 2),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _tel,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.phone,
                      color: Colors.grey,
                    ),
                    hintText: 'Telephone Number',
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 2),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _mobile,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.phone_android,
                      color: Colors.grey,
                    ),
                    hintText: 'Mobile Number',
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 2),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                child: TextField(
                  controller: _cLimit,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.credit_card,
                      color: Colors.grey,
                    ),
                    hintText: 'Credit Limit',
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 15,
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: const Text(
                  "Select The Role :",
                  style: TextStyle(
                    color: Color.fromRGBO(143, 148, 251, 1),
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 1.2,
                  height: 40,
                  margin: const EdgeInsets.only(top: 25),
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      color: Colors.white,
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                  child: DropdownButton(
                    value: _currentRole,
                    items: _dropDownMenuItems,
                    onChanged: changedDropDownItem,
                  )),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 15,
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.only(left: 16, right: 16),
                child: const Text(
                  "Enter The Address :",
                  style: TextStyle(
                    color: Color.fromRGBO(143, 148, 251, 1),
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                margin: const EdgeInsets.only(top: 25),
                padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 2),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                child: TextField(
                  controller: _p_code,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.code,
                      color: Colors.grey,
                    ),
                    hintText: 'Postal Code',
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                margin: const EdgeInsets.only(top: 25),
                padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 2),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                child: TextField(
                  controller: _street,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.streetview,
                      color: Colors.grey,
                    ),
                    hintText: 'Street',
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 45,
                margin: const EdgeInsets.only(top: 25),
                padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 2),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                child: TextField(
                  controller: _city,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.location_city,
                      color: Colors.grey,
                    ),
                    hintText: 'City',
                  ),
                ),
              ),
              const Divider(),
              const Divider(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(85.0),
      child: Container(
        color: Colors.transparent,
        height: 85.0,
        alignment: Alignment.center,
        child: _buildSubmitBtn(context),
      ),
    );
  }

  Widget _buildSubmitBtn(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (checkNull()) {
          if (validateEmail()) {
            if (validatephone()) {
              postUserData();
            }
          } else {
            errorDialog('ERROR', 'This is not a valid Email !');
          }
        } else {
          errorDialog('ERROR', 'You should fill all the fields !');
          print("empty fields");
        }
      },
      child: Container(
        height: 45,
        width: MediaQuery.of(context).size.width / 1.2,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8E8CD8), Color(0xFF8E8CD8)],
            ),
            borderRadius: BorderRadius.all(Radius.circular(50))),
        child: Center(
          child: Text(
            'Submit'.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<dynamic> errorDialog(String title, String dec) {
    return AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.TOPSLIDE,
            title: title,
            desc: dec,
            // btnCancelOnPress: () {},
            btnOkOnPress: () {})
        .show();
  }

  Future<dynamic> successDialog(String title, String dec) {
    return AwesomeDialog(
        context: context,
        dialogType: DialogType.SUCCES,
        animType: AnimType.TOPSLIDE,
        title: title,
        desc: dec,
        btnOkText: 'ShowList !',
        btnCancelText: 'Regsiter!',
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewCustomer()));
        }).show();
  }

  bool validateEmail() {
    String email = _email.text;
    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    if (emailValid) {
      print("Valid email !");

      return true;
    } else {
      return false;
    }
  }

  bool validatephone() {
    if (_tel.text.length < 10) {
      errorDialog('ERROR', 'Telephone should \nlong 10 digits !');
      return false;
    } else if (_mobile.text.length < 10) {
      errorDialog('ERROR', 'Mobile number should \nlong 10 digits !');
      return false;
    } else {
      print("valid phone");
      return true;
    }
  }

  postUserData() {
    pd.show(max: 100, msg: 'saving data...');
    final body = {
      "fname": _fname.text,
      "lname": _lname.text,
      "email": _email.text,
      "telephone": _tel.text,
      "mobile": _mobile.text,
      "credit_limit": _cLimit.text,
      "role": _role,
      "ad_l1": _p_code.text,
      "ad_l2": _street.text,
      "ad_l3": _city.text,
      "garageId": userModel.garageId,
      "garageName": userModel.garageName,
      "supervisorName": userModel.userName,
    };
    RegisterCustomerService.RegisterCustomer(body).then((success) {
      print(success);
      final result = success;
      if (result == "success") {
        pd.close();
        clearcontrollers();
        successDialog('Customer Registration successfull', 'Click Ok to see !');
      } else {
        pd.close();
        errorDialog('ERROR', result);
      }
    });
  }

  void changedDropDownItem(String? selectedRole) {
    setState(() {
      _currentRole = selectedRole!;
    });
  }

  void clearcontrollers() {
    _fname.text = '';
    _lname.text = '';
    _email.text = '';
    _tel.text = '';
    _mobile.text = '';
    _p_code.text = '';
    _street.text = '';
    _city.text = '';
    _cLimit.text = '';
  }

  bool checkNull() {
    if (_fname.text == '' ||
        _lname.text == '' ||
        _email.text == '' ||
        _tel.text == '' ||
        _mobile.text == '' ||
        _currentRole == '' ||
        _p_code.text == '' ||
        _street.text == '' ||
        _city.text == '' ||
        _cLimit.text == '') {
      return false;
    } else {
      return true;
    }
  }
}
