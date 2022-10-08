class Service {
  String serviceId = "";
  String serviceName = "";
  String price = "";
  String labourCharge = "";

  Service({
    required this.serviceId,
    required this.serviceName,
    required this.price,
    required this.labourCharge,
  });

  // factory Service.fromJson(Map<String, dynamic> json) {
  //   return Service(

  //     serviceId: json["_id"] as String,
  //     serviceName: json["proserName"] as String,
  //     price: json["proserCost"] as String,
  //   );
  // }

  Service.fromJson(Map<String, dynamic> json) {
    serviceId = json['_id'];
    serviceName = json['proserName'];
    price = json['proserCost'];
    labourCharge = json['labourCharge'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = serviceId;
    data['proserName'] = serviceName;
    data['proserCost'] = price;
    data['labourCharge'] = labourCharge;
    return data;
  }
}
