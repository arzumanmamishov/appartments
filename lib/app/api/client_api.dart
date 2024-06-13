import 'dart:convert';
import 'dart:typed_data';
import 'package:apartments/app/models/get_all_appart_model.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApiClient {
  final Dio _dio = Dio();

  // Future<dynamic> registerUser(Map<String, dynamic>? data) async {
  //   try {
  //     Response response = await _dio.post(
  //         'auth/register',
  //         data: data,
  //         // queryParameters: {'apikey': ApiSecret.apiKey},
  //         options: Options(headers: {'X-LoginRadius-Sott': ApiSecret.sott}));
  //     return response.data;
  //   } on DioError catch (e) {
  //     return e.response!.data;
  //   }
  // }

  Future<String> getToken() async {
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    return accessToken;
  }

  Future<dynamic> getUserProfileData(String accessToken) async {
    try {
      Response response = await _dio.get(
        'https://realtor.azurewebsites.net/api/CustomerCards',
        // queryParameters: {'apikey': ApiSecret.apiKey},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> updateUserProfile({
    required String accessToken,
    required Map<String, dynamic> data,
  }) async {
    try {
      Response response = await _dio.put(
        'https://api.loginradius.com/identity/v2/auth/account',
        data: data,
        // queryParameters: {'apikey': ApiSecret.apiKey},
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
  }

  Future<dynamic> logout() async {
    final accessToken = await SPHelper.removeTokenSharedPreference();

    return accessToken;

    //   try {
    //     Response response = await _dio.get(
    //       'https://api.loginradius.com/identity/v2/auth/access_token/InValidate',
    //       // queryParameters: {'apikey': ApiSecret.apiKey},
    //       options: Options(
    //         headers: {'Authorization': 'Bearer $accessToken'},
    //       ),
    //     );
    //     return response.data;
    //   } on DioError catch (e) {
    //     return e.response!.data;
    //   }
    // }
  }

  Future<ApartmentModel> fetchApartmentDetails() async {
    String apartmentId = await SPHelper.getIDAptSharedPreference() ?? '';
    var url = 'https://realtor.azurewebsites.net/api/RentObjects/$apartmentId';
    late ApartmentModel apartmentModel;

    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    try {
      Response response = await _dio.get(
        url,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      print(response.data);
      final data = response.data;
      apartmentModel = ApartmentModel.fromJsonToMap(data);
      print(apartmentModel);
      return apartmentModel;
    } on DioError catch (e) {
      print(e);
      return e.response!.data;
    }
  }

// Working code
  Future<List<dynamic>> sendImages(
      BuildContext context, String _jwtToken) async {
    AppartDetailsListener profileDetailsListener =
        Provider.of<AppartDetailsListener>(context, listen: false);
    late List<dynamic> photoReferences;
    String url =
        'https://realtor.azurewebsites.net/api/Files'; // Replace with your API endpoint

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url));
      request.headers['Authorization'] = 'Bearer $_jwtToken';

      for (XFile file in profileDetailsListener.getXfileList) {
        Uint8List fileBytes = await file.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'files',
          fileBytes,
          filename: basename(file.path),
        );
        print("file name is: ${multipartFile.filename}");

        request.files.add(multipartFile);
      }

      final response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        photoReferences = json.decode(responseData);
        print(photoReferences);
        print('Upload successful: ${response.statusCode}');
      } else {
        print('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Upload error: $e');
    }
    return photoReferences;
  }
}
