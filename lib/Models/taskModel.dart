import 'package:flutter/foundation.dart';

class TaskModel with ChangeNotifier {
  String taskId;
  String jobId;
  String jobno;
  String date;
  String vNumber;
  String vName;
  String cusId;
  String cusName;
  String procerCharge;
  String labourCharge;
  String total;
  String status;
  List<ServiceModel> services;
  List<ProductModel> products;
  String garageId;
  String garageName;
  String supervisorName;

  TaskModel({
    required this.taskId,
    required this.jobId,
    required this.jobno,
    required this.date,
    required this.vNumber,
    required this.vName,
    required this.cusId,
    required this.cusName,
    required this.procerCharge,
    required this.labourCharge,
    required this.total,
    required this.status,
    required this.services,
    required this.products,
    required this.garageId,
    required this.garageName,
    required this.supervisorName,
  });

  TaskModel.fromJson(Map<String, dynamic> map)
      : taskId = map["_id"],
        jobId = map["jobId"],
        jobno = map["jobNo"],
        date = map["date"],
        vNumber = map["vnumber"],
        vName = map["vName"],
        cusId = map["cusId"],
        cusName = map["cusName"],
        total = map["total"],
        procerCharge = map["procerCharge"],
        labourCharge = map["labourCharge"],
        status = map["status"],
        services = (map['services'] as List).map((i) => ServiceModel.fromJson(i)).toList(),
        products = (map['products'] as List).map((i) => ProductModel.fromJson(i)).toList(),
        garageId = map["garageId"],
        garageName = map["garageName"],
        supervisorName = map["supervisorName"];
}

class ServiceModel {
  late String serviceId;
  late String serviceName;
  late String price;
  late String labourCharge;

  ServiceModel({required this.serviceId, required this.serviceName, required this.price, required this.labourCharge});

  // factory ServiceModel.fromJson(Map<String, dynamic> json) {
  //   return ServiceModel(

  //     serviceId: json["_id"] as String,
  //     serviceName: json["proserName"] as String,
  //     price: json["proserCost"] as String,
  //   );
  // }

  ServiceModel.fromJson(Map<String, dynamic> json) {
    serviceId = json['_id'];
    serviceName = json['serviceName'];
    price = json['serviceCost'];
    labourCharge = json['labourCharge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = serviceId;
    data['serviceName'] = serviceName;
    data['serviceCost'] = price;
    data['labourCharge'] = labourCharge;
    return data;
  }
}

class ProductModel {
  late String productId;
  late String productName;
  late String price;
  late String amount;

  ProductModel({required this.productId, required this.productName, required this.price, required this.amount});

  // factory ProductModel.fromJson(Map<String, dynamic> json) {
  //   return ProductModel(

  //     productId: json["_id"] as String,
  //     productName: json["proserName"] as String,
  //     price: json["proserCost"] as String,
  //   );
  // }
  ProductModel.fromJson(Map<String, dynamic> json) {
    productId = json['_id'];
    productName = json['productName'];
    price = json['productCost'];
    amount = json['productAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = productId;
    data['productName'] = productName;
    data['productCost'] = price;
    data['productAmount'] = amount;
    return data;
  }
}
