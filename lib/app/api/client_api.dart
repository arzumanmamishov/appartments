import 'dart:io';
import 'dart:typed_data';
import 'package:bot_toast/bot_toast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_html/html.dart' as html;

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

    // formData = FormData.fromMap({
    //   'id': 'uif',
    //   'contactPerson': "ddefefefefe",
    // });

    for (int i = 0; i < profileDetailsListener.getXfileList.length; i++) {
      String fileName = 'photo_$i.jpg';
      html.File htmlFile = html.File(
          await profileDetailsListener.getXfileList[i].readAsBytes(), fileName);

      final reader = html.FileReader();
      reader.readAsArrayBuffer(htmlFile);

      await reader.onLoadEnd.first;
      final Uint8List bytes = reader.result as Uint8List;

      formData.files.add(MapEntry(
        'photos',
        MultipartFile.fromBytes(bytes, filename: fileName),
      ));
    }

    Response response = await dio.post(
      'https://realtor.azurewebsites.net/api/Files',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $_jwtToken',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    // Handle the response
    if (response.statusCode == 200 || response.statusCode == 201) {
      List<String> photoReferences = List<String>.from(response.data);
      print('Photo references: $photoReferences');
    } else if (response.statusCode == 204) {
      print('Images uploaded successfully, but no content was returned.');
    } else {
      print('Failed to upload images. Status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Error uploading images: $e');
  }
}

Future addImagesToDb(BuildContext context, String _jwtToken) async {
  AppartDetailsListener profileDetailsListener =
      Provider.of<AppartDetailsListener>(context, listen: false);
  const url = 'https://realtor.azurewebsites.net/api/Files';

  late XFile images;
  for (var x = 0; x < profileDetailsListener.getXfileList.length; x++) {
    images = profileDetailsListener.getXfileList[x];
  }

  File imageFile = File(images.path);
  try {
    var formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imageFile.path,
          filename: imageFile.path),
    });
    final response = await Dio().post(
      url,
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer $_jwtToken',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
    if (response.statusCode == 200) {
      var map = response.data as Map;
      print('success');
      if (map['status'] == 'Successfully registered') {
        return true;
      } else {
        return false;
      }
    } else {
      //BotToast is a package for toasts available on pub.dev
      BotToast.showText(text: 'Error');
      return false;
    }
  } on DioError catch (error) {
    print(error.message);
  } catch (_) {
    print(_.toString());
    throw 'Something Went Wrong';
  }
}
