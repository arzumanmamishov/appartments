import 'dart:convert';
import 'package:apartments/app/models/get_all_appart.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

// Future<ApartmentModelList> fetchDataFromAzure() async {
//   var url = 'https://realtor.azurewebsites.net/api/RentObjects';

//   late ApartmentModelList appartmentList;

//   try {
//     var response = await http.get(Uri.parse(url));
//     print(response);
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);

//       appartmentList = ApartmentModelList.fromJson(data);
//       print("photos " + appartmentList.apartmentModel[0].city.toString());
//     }
//   } catch (exception) {
//     print(exception);
//   }
//   return appartmentList;
// }

final Dio _dio = Dio();

Future<ApartmentModelList> fetchDataFromAzure() async {
  var url = 'https://realtor.azurewebsites.net/api/RentObjects';
  late ApartmentModelList appartmentList;

  try {
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';

    Response response = await _dio.get(
      url,
      // queryParameters: {'apikey': ApiSecret.apiKey},
      options: Options(
        headers: {'Authorization': 'Bearer $accessToken'},
      ),
    );
    final data = response.data;
    appartmentList = ApartmentModelList.fromJson(data);
    print(appartmentList);
    return appartmentList;
  } on DioError catch (e) {
    return e.response!.data;
  }
}
