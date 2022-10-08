class Vehicle {
  String vID;
  String vNumber;
  String make;
  String model;
  String mYear;
  String odo;
  String eCapacity;
  String desc;
  String cusid;
  String cusName;

  Vehicle({
    required this.vID,
    required this.vNumber,
    required this.make,
    required this.model,
    required this.mYear,
    required this.odo,
    required this.eCapacity,
    required this.desc,
    required this.cusid,
    required this.cusName,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vID: json["_id"] as String,
      vNumber: json["vnumber"] as String,
      make: json["make"] as String,
      model: json["model"] as String,
      mYear: json["m_year"] as String,
      odo: json["odo"] as String,
      eCapacity: json["capacity"] as String,
      desc: json["description"] as String,
      cusid: json["cusID"] as String,
      cusName: json["cusName"] as String,
    );
  }
}
