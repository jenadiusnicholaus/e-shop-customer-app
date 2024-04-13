class ContactInfosModel {
  int? user;
  String? address;
  String? city;
  String? country;
  String? phoneNumber;
  String? zipCode;
  double? latitude;
  double? longitude;
  String? createdAt;

  ContactInfosModel(
      {this.user,
      this.address,
      this.city,
      this.country,
      this.phoneNumber,
      this.zipCode,
      this.latitude,
      this.longitude,
      this.createdAt});

  ContactInfosModel.fromJson(Map<String, dynamic> json) {
    user = json['user'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    phoneNumber = json['phone_number'];
    zipCode = json['zip_code'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user'] = this.user;
    data['address'] = this.address;
    data['city'] = this.city;
    data['country'] = this.country;
    data['phone_number'] = this.phoneNumber;
    data['zip_code'] = this.zipCode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['created_at'] = this.createdAt;
    return data;
  }
}
