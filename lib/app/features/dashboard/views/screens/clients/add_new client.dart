import 'package:apartments/app/models/get_all_appart_model.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:dio/dio.dart';

class RemoteClientApi {
  final Dio _dio = Dio();

  Future<ApartmentModelList> fetchClientDataFromDB(int page, int limit,
      {String? filter}) async {
    var url = 'https://realtor.azurewebsites.net/api/RentObjects/pagination';
    late ApartmentModelList apartmentModelList;
    print('started');
    try {
      final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
      Map<String, dynamic> queryParameters = {
        'page': page,
        'count': limit,
      };
      // if (filter != null && filter.isNotEmpty) {
      //   queryParameters['filter'] = filter;
      // }
      Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      final data = response.data;
      print(data);
      apartmentModelList = ApartmentModelList.fromJson(data);

      return apartmentModelList;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<bool> deleteClientDataFromDB(
    String apartmentId,
  ) async {
    var url = 'https://realtor.azurewebsites.net/api/RentObjects/$apartmentId';
    print('started');
    try {
      final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
      print(accessToken);

      Response response = await _dio.delete(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      final data = response.data;
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Apartment deleted successfully');
      } else {
        print('Failed to delete the apartment');
      }
      print(data);
      return true;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<void> updateField(String id, String newContactPerson) async {
    Dio dio = Dio();

    try {
      // Define the URL for the PATCH request
      String url = 'https://api.example.com/data/$id';

      // Define the data to be sent in the request body
      Map<String, dynamic> data = {
        'contactPerson': newContactPerson,
      };

      // Send the PATCH request
      Response response = await dio.patch(url, data: data);

      if (response.statusCode == 200) {
        print('Field updated successfully.');
      } else {
        print('Failed to update field: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating field: $e');
    }
  }
}
