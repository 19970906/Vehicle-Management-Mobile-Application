import 'package:flutter/foundation.dart';

class Job with ChangeNotifier {
  String jobId;
  String jobno;
  String date;
  String vNumber;
  String vName;
  String cusId;
  String cusName;
  String taskCount;
  String completeTaskCount;
  String procerCharge;
  String labourCharge;
  String total;
  String status;
  String garageId;
  String garageName;
  String supervisorName;

  Job({
    required this.jobId,
    required this.jobno,
    required this.date,
    required this.vNumber,
    required this.vName,
    required this.cusId,
    required this.cusName,
    required this.taskCount,
    required this.completeTaskCount,
    required this.procerCharge,
    required this.labourCharge,
    required this.total,
    required this.status,
    required this.garageId,
    required this.garageName,
    required this.supervisorName,
  });

  Job.fromJson(Map<String, dynamic> map)
      : jobId = map["_id"],
        jobno = map["jobNo"],
        date = map["date"],
        vNumber = map["vnumber"],
        vName = map["vName"],
        cusId = map["cusId"],
        cusName = map["cusName"],
        taskCount = map["taskCount"],
        completeTaskCount = map["completeTaskCount"],
        total = map["total"],
        procerCharge = map["procerCharge"],
        labourCharge = map["labourCharge"],
        status = map["status"],
        garageId = map["garageId"],
        garageName = map["garageName"],
        supervisorName = map["supervisorName"];

  // factory Job.fromJson(Map<String, dynamic> json) {
  //   return Job(
  //     jobId: json["_id"] as String,
  //     jobno: json["jobNo"] as String,
  //     date: json["date"] as String,
  //     vNumber: json["vnumber"] as String,
  //     vName: json["vName"] as String,
  //     cusId: json["cusId"] as String,
  //     cusName: json["cusName"] as String,
  //     taskCount: json["taskCount"] as String,
  //     total: json["total"] as String,
  //     procerCharge: json["procerCharge"] as String,
  //     labourCharge: json["labourCharge"] as String,
  //     status: json["status"] as String,
  //     garageId: json["garageId"] as String,
  //     garageName: json["garageName"] as String,
  //     supervisorName: json["supervisorName"] as String,
  //   );
  // }
}

// class ServiceData {
//   String serviceName;
//   String serviceId;
//   String cost;

//   ServiceData({required this.serviceName, required this.serviceId, required this.cost});

//   ServiceData.fromJson(Map<String, dynamic> json) {
//     serviceName = json['serviceName'];
//     serviceId = json['_id'];
//     cost = json['serviceCost'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['serviceName'] = required this.serviceName;
//     data['_id'] = required this.serviceId;
//     data['serviceCost'] = required this.cost;
//     return data;
//   }
// }

// class ProductData {
//   String productName;
//   String productId;
//   String productAmount;
//   String productCost;

//   ProductData(
//       {required this.productName, required this.productId, required this.productAmount, required this.productCost});

//   ProductData.fromJson(Map<String, dynamic> json) {
//     productName = json['productName'];
//     productId = json['_id'];
//     productAmount = json['productAmount'];
//     productCost = json['productCost'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['productName'] = required this.productName;
//     data['_id'] = required this.productId;
//     data['productAmount'] = required this.productAmount;
//     data['productCost'] = required this.productCost;
//     return data;
//   }
// }
