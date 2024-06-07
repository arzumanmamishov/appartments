// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ApartmentModel {
  final String id;
  final String contactPerson;
  final String city;
  final String region;
  final String postalCode;
  final String price;
  final String type;
  final String description;
  final String comment;
  final String phone;
  final String floor;
  final List photos;
  ApartmentModel({
    required this.id,
    required this.contactPerson,
    required this.city,
    required this.region,
    required this.postalCode,
    required this.price,
    required this.type,
    required this.description,
    required this.comment,
    required this.phone,
    required this.floor,
    required this.photos,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'contactPerson': contactPerson,
      'city': city,
      'region': region,
      'postalCode': postalCode,
      'price': price,
      'type': type,
      'description': description,
      'comment': comment,
      'phone': phone,
      'floor': floor,
      'photos': photos,
    };
  }

  factory ApartmentModel.fromMap(Map<String, dynamic> map) {
    return ApartmentModel(
      id: map['id'] as String,
      contactPerson: map['contactPerson'] as String,
      city: map['city'] as String,
      region: map['region'] as String,
      postalCode: map['postalCode'] as String,
      price: map['price'] as String,
      type: map['type'] as String,
      description: map['description'] as String,
      comment: map['comment'] as String,
      phone: map['phone'] as String,
      floor: map['floor'] as String,
      photos: List.from((map['photos'] as List)),
    );
  }

  String toJson() => json.encode(toMap());

  factory ApartmentModel.fromJson(String source) =>
      ApartmentModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  factory ApartmentModel.fromJsonToMap(Map<String, dynamic> map) {
    return ApartmentModel.fromMap(map);
  }
}

// List<ApartmentModel> apartFromJson(String str) => List<ApartmentModel>.from(
//     json.decode(str).map((x) => ApartmentModel.fromJson(x)));

class ApartmentModelList {
  final List<ApartmentModel> apartmentModel;

  ApartmentModelList({
    required this.apartmentModel,
  });

  factory ApartmentModelList.fromJson(List<dynamic> parsedJson) {
    List<ApartmentModel> listOfApp = [];

    listOfApp = parsedJson.map((i) => ApartmentModel.fromMap(i)).toList();
    return ApartmentModelList(apartmentModel: listOfApp);
  }
}
