import 'dart:convert';
import 'package:apartments/app/models/get_all_appart.dart';
import 'package:http/http.dart' as http;

Future<ApartmentModelList> fetchDataFromAzure() async {
  var url = 'https://realtor.azurewebsites.net/api/RentObjects';

  late ApartmentModelList appartmentList;

  try {
    var response = await http.get(Uri.parse(url));
    print(response);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      appartmentList = ApartmentModelList.fromJson(data);
      print("photos " + appartmentList.apartmentModel[0].city.toString());
    }
  } catch (exception) {
    print(exception);
  }
  return appartmentList;
}
