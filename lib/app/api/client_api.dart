import 'dart:io';

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

  Future<dynamic> login(String username, String password) async {
    try {
      Response response = await _dio.post(
        'https://realtor.azurewebsites.net/api/Authenticate/login',
        data: {
          'username': username,
          'password': password,
        },
        // queryParameters: {'apikey': ApiSecret.apiKey},
      );
      return response.data;
    } on DioError catch (e) {
      return e.response!.data;
    }
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

  Future<dynamic> logout(String accessToken) async {
    try {
      Response response = await _dio.get(
        'https://api.loginradius.com/identity/v2/auth/access_token/InValidate',
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
}

Future<void> uploadPhotos(String _jwtToken, BuildContext context) async {
  AppartDetailsListener profileDetailsListener =
      Provider.of<AppartDetailsListener>(context, listen: false);

  List<String> images = [];
  for (var x = 0; x < profileDetailsListener.getXfileList.length; x++) {
    File imageFile = File(profileDetailsListener.getXfileList[x].path);
    images.add(imageFile.path);
  }

  try {
    Dio dio = Dio();
    FormData formData = FormData();

    formData = FormData.fromMap({
      'id': 'uif',
      'contactPerson': "ddefefefefe",
    });

    for (String file in images) {
      formData.files
          .addAll([MapEntry("images[]", MultipartFile.fromString(file))]);
    }

    Response response = await dio.post(
      'https://realtor.azurewebsites.net/api/Files',
      data: formData,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $_jwtToken',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    if (response.statusCode == 200) {
      List<String> photoReferences = List<String>.from(response.data);

      print('Photo references: $photoReferences');
    } else {
      print('Failed to upload images. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading images: $e');
  }
}
