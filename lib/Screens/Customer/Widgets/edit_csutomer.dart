import 'dart:convert';

import 'package:autoassist/Controllers/ApiServices/variables.dart';
import 'package:autoassist/Models/customerModel.dart';
import 'package:autoassist/Providers/CustomerProvider.dart';
import 'package:autoassist/Screens/Customer/Widgets/custom_modal_action_button.dart';
import 'package:autoassist/Screens/Customer/Widgets/custom_textfield.dart';
import 'package:autoassist/Utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class EditCustomer extends StatefulWidget {
  const EditCustomer({Key? key}) : super(key: key);

  @override
  _EditCustomerState createState() => _EditCustomerState();
}

class _EditCustomerState extends State<EditCustomer> {
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
  late ProgressDialog pd;

  late Customer customerModel;

  @override
  void initState() {
    super.initState();
    customerModel = Provider.of<CustomerProvider>(context, listen: false).customerModel;
    assignValues();
    _dropDownMenuItems = getDropDownMenuItems();
    _currentRole = customerModel.role;
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = [];
    for (String role in __role) {
      items.add(DropdownMenuItem(value: role, child: Text(role)));
    }
    return items;
  }

  assignValues() {
    _fname.text = customerModel.fName;
    _lname.text = customerModel.lName;
    _email.text = customerModel.email;
    _tel.text = customerModel.telephone;
    _mobile.text = customerModel.mobile;
    _p_code.text = customerModel.adL1;
    _street.text = customerModel.adL2;
    _city.text = customerModel.adL3;
    _cLimit.text = customerModel.cLimit;
    print("Values set");
  }

  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context: context);

    return Container(
      height: MediaQuery.of(context).size.height / 0.2,
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Center(
                child: Text(
              "Update Customer",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(labelText: 'Edit First name', controller: _fname),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(labelText: 'Edit First name', controller: _lname),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(labelText: 'Edit First Email', controller: _email),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(labelText: 'Edit Telephone', controller: _tel),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(labelText: 'Edit Mobile', controller: _mobile),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(labelText: 'Edit Credit Limit', controller: _cLimit),
            const SizedBox(
              height: 10,
            ),
            Container(
                width: MediaQuery.of(context).size.width / 1.2,
                height: 40,
                margin: const EdgeInsets.only(bottom: 15),
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
            const SizedBox(
              height: 10,
            ),
            CustomTextField(labelText: 'Edit Adress Line 1', controller: _p_code),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(labelText: 'Edit Adress Line 2', controller: _street),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(labelText: 'Edit Adress Line 3', controller: _city),
            const SizedBox(
              height: 10,
            ),
            CustomModalActionButton(
              onClose: () {
                Navigator.of(context).pop();
              },
              onSave: () async {
                pd.show(max: 100, msg: 'saving data...');
                final body = {
                  "_id": customerModel.cusid,
                  "fname": _fname.text,
                  "lname": _lname.text,
                  "email": _email.text,
                  "telephone": _tel.text,
                  "mobile": _mobile.text,
                  "credit_limit": _cLimit.text,
                  "role": _role,
                  "ad_l1": _p_code.text,
                  "ad_l2": _street.text,
                  "ad_l3": _city.text
                };

                Map<String, String> requestHeaders = {'Content-Type': 'application/json'};
                final response =
                    await http.post(Uri.parse('${URLS.BASE_URL}/customer/updateCustomer'), body: jsonEncode(body), headers: requestHeaders);
                print("workingggggggggggg");
                var data = response.body;
                // print(body);
                print(json.decode(data));

                Map<String, dynamic> resData = jsonDecode(data);
                try {
                  if (response.statusCode == 200) {
                    setState(() {
                      customerModel.fName = _fname.text;
                      customerModel.lName = _lname.text;
                      customerModel.email = _email.text;
                      customerModel.telephone = _tel.text;
                      customerModel.mobile = _mobile.text;
                      customerModel.cLimit = _cLimit.text;
                      customerModel.role = _role;
                      customerModel.adL1 = _p_code.text;
                      customerModel.adL2 = _street.text;
                      customerModel.adL3 = _city.text;
                    });
                    // Provider.of<VehicleProvider>(context, listen: false)
                    //     .updateODO("${milage.text}");

                    // print("${vehicleModel.odo}}");
                    pd.close();
                    Dialogs.successDialog(context, "Done", "details Updated succefully");
                  } else {
                    // Dialogs.errorDialog(context, "F", "Something went wrong !");
                    pd.close();
                    print("ODO coudlnt update !");
                  }
                } catch (e) {
                  print(e);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  void changedDropDownItem(String? selectedRole) {
    setState(() {
      _currentRole = selectedRole!;
    });
  }
}
