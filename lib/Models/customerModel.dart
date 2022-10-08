class Customer {
  String cusid;
  String fName;
  String lName;
  String email;
  String telephone;
  String mobile;
  String cLimit;
  String role;
  String adL1;
  String adL2;
  String adL3;

  Customer({
    required this.cusid,
    required this.fName,
    required this.lName,
    required this.email,
    required this.telephone,
    required this.mobile,
    required this.cLimit,
    required this.role,
    required this.adL1,
    required this.adL2,
    required this.adL3,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      cusid: json["_id"] as String,
      fName: json["fname"] as String,
      lName: json["lname"] as String,
      email: json["email"] as String,
      telephone: json["telephone"] as String,
      mobile: json["mobile"] as String,
      cLimit: json["credit_limit"] as String,
      role: json["role"] as String,
      adL1: json["ad_l1"] as String,
      adL2: json["ad_l2"] as String,
      adL3: json["ad_l3"] as String,
    );
  }
}
