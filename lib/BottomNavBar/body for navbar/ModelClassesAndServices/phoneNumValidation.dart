import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:mallu_vendor/BottomNavBar/body%20for%20navbar/ModelClassesAndServices/phoneNumberModelClass.dart';

class PhoneNumValidation {
  Future<PhoneResponceModel> login(
      PhoneNumRequestModel data, BuildContext context) async {
    DataConnectionStatus status = await internetChecker();

    if (status == DataConnectionStatus.connected) {
      String url = "https://teleoappapi.com/api/auth/vendor/login";
      final response = await http.post(Uri.parse(url), body: data.toJson());
      if (response.statusCode == 200||response.statusCode == 400) {
        return PhoneResponceModel.fromJson(json.decode(response.body));
      }else{
        throw Exception(response.statusCode);
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("No InterNet Conection"),
                content: Text("check internet connection"),
              ));
    }
  }
}

class PhoneNumRequestModel {
  String phoneNumber;
  PhoneNumRequestModel({this.phoneNumber});
  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {"phonenumber": phoneNumber.toString()};
    return map;
  }
}

internetChecker() async {
  // Simple check to see if we have internet
  print("The statement 'this machine is connected to the Internet' is: ");
  print(await DataConnectionChecker().hasConnection);
  // returns a bool

  // We can also get an enum instead of a bool
  print("Current status: ${await DataConnectionChecker().connectionStatus}");
  // prints either DataConnectionStatus.connected
  // or DataConnectionStatus.disconnected

  // This returns the last results from the last call
  // to either hasConnection or connectionStatus
  print("Last results: ${DataConnectionChecker().lastTryResults}");

  // actively listen for status updates
  DataConnectionChecker().onStatusChange.listen((status) {
    switch (status) {
      case DataConnectionStatus.connected:
        print('Data connection is available.');
        break;
      case DataConnectionStatus.disconnected:
        print('You are disconnected from the internet.');
        break;
    }
  });

  // close listener after 30 seconds, so the program doesn't run forever

  return await DataConnectionChecker().connectionStatus;
}
