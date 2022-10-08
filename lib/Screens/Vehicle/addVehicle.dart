import 'package:autoassist/Controllers/ApiServices/Vehicle_Services/addVehicle_Service.dart';
import 'package:autoassist/Models/userModel.dart';
import 'package:autoassist/Providers/AuthProvider.dart';
import 'package:autoassist/Screens/Vehicle/view_vehicle.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class AddVehicle extends StatefulWidget {
  final customer_id;
  final customer_name;
  const AddVehicle({Key? key, this.customer_id, this.customer_name}) : super(key: key);

  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  final _vNumber = TextEditingController();
  final _vMake = TextEditingController();
  final _vModel = TextEditingController();
  final _vMyear = TextEditingController();
  final _vCapacity = TextEditingController();
  final _vODO = TextEditingController();
  final _vDescription = TextEditingController();

  late UserModel userModel;
  late ProgressDialog pd;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userModel = Provider.of<AuthProvider>(context, listen: false).userModel;
    print("customer id = " + widget.customer_id);
    print("customer name = " + widget.customer_name);
  }

  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context: context);

    return Scaffold(
        // this avoids the overflow error
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(130.0),
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
      height: MediaQuery.of(context).size.height / 6.0,
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
              color: Color(0xFF81C784),
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
                  "assets/images/add_vehi.png",
                  width: 150,
                  height: 100,
                )),
                const Padding(
                  padding: EdgeInsets.only(left: 30.0),
                  child: Center(
                    child: Text(
                      'Vehicle\n     Registration.. ',
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
      children: <Widget>[
        Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(10.0),
            ),
            margin: const EdgeInsets.only(top: 15),
            padding: const EdgeInsets.all(5.0),
            child: Text(
              "Customer Name - " + widget.customer_name,
              style: const TextStyle(fontFamily: 'Montserrat', fontSize: 15.0, fontWeight: FontWeight.w900),
            )),
        SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // padding: EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              buildTextfield(context, 'Vehicle Number', Icons.code, _vNumber),
              buildTextfield(context, 'Make', Icons.branding_watermark, _vMake),
              buildTextfield(context, 'Model', Icons.view_module, _vModel),
              buildTextfield(context, 'Manufactured Year', Icons.calendar_view_day, _vMyear),
              buildTextfield(context, 'ODO (Milage)', Icons.timer, _vODO),
              buildTextfield(context, 'Engine Capacity', Icons.tonality, _vCapacity),

              Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 70,
                margin: const EdgeInsets.only(top: 32),
                padding: const EdgeInsets.only(top: 4, left: 16, right: 16, bottom: 2),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
                child: TextField(
                  controller: _vDescription,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(
                      Icons.details,
                      color: Colors.grey,
                    ),
                    labelText: 'Discription',
                  ),
                ),
              ),
              // Divider(),
            ],
          ),
        )
      ],
    );
  }

  Widget buildTextfield(BuildContext context, String title, IconData icon, TextEditingController controller) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: 45,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 4),
      margin: const EdgeInsets.only(top: 32),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)), color: Colors.white, boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)]),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: Icon(
            icon,
            color: Colors.grey,
          ),
          hintText: title,
        ),
      ),
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
          postVehicleData();
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
        btnOkText: 'VehicleList !',
        btnCancelText: 'Regsiter !',
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ViewVehicle()));
        }).show();
  }

  postVehicleData() async {
    pd.show(max: 100, msg: 'saving data...');
    SharedPreferences initializeToken = await SharedPreferences.getInstance();
    final body = {
      "vnumber": _vNumber.text,
      "make": _vMake.text,
      "model": _vModel.text,
      "m_year": _vMyear.text,
      "odo": _vODO.text,
      "capacity": _vCapacity.text,
      "description": _vDescription.text,
      "cusID": widget.customer_id,
      "cusName": widget.customer_name,
      "token": initializeToken.getString("authtoken")
    };
    RegisterVehicleService.RegisterVehicle(body).then((success) {
      print(success);
      final result = success;
      if (result == "success") {
        pd.close();
        clearcontrollers();
        successDialog('Vehicle Registration successfull', 'Click Ok to see !');
      } else {
        pd.close();
        errorDialog('ERROR', result);
      }
    });
  }

  void clearcontrollers() {
    _vNumber.text = '';
    _vMake.text = '';
    _vModel.text = '';
    _vMyear.text = '';
    _vODO.text = '';
    _vCapacity.text = '';
    _vDescription.text = '';
  }

  bool checkNull() {
    if (_vNumber.text == '' ||
        _vMake.text == '' ||
        _vModel.text == '' ||
        _vMyear.text == '' ||
        _vODO.text == '' ||
        _vCapacity.text == '' ||
        _vDescription.text == '') {
      return false;
    } else {
      return true;
    }
  }
}
