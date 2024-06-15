// Future<void> addProduct(String id) async {
//     AppartDetailsListener profileDetailsListener =
//         Provider.of<AppartDetailsListener>(context, listen: false);
//     if (profileDetailsListener.getXfileList.isEmpty) {
//       print("No images selected.");
//       return;
//     }
//     final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
//     print(id);
//     var uri = Uri.parse("https://realtor.azurewebsites.net/api/Files");
//     var request = http.MultipartRequest('POST', uri);

//     // request.fields['id'] = id;

//     for (var image in profileDetailsListener.getXfileList) {
//       print(image);
//       // var stream = http.ByteStream(image.openRead());
//       var stream = http.ByteStream(Stream.castFrom(image.openRead()));
//       var length = await image.length();
//       var multipartFile =
//           http.MultipartFile(id, stream, length, filename: image.name);
//       request.files.add(multipartFile);
//     }
//     request.headers.addAll({
//       "Content-Type": "multipart/form-data",
//       "Authorization": "Bearer $accessToken",
//     });

//     try {
//       var response = await request.send();

//       var responseDataa = await http.Response.fromStream(response);
//       if (response.statusCode == 200) {
//         var responseData = await response.stream.bytesToString();
//         List<dynamic> photoReferences = json.decode(responseData);
//         print(photoReferences);
//       } else {
//         print("Failed to upload images. Status code: ${response.statusCode}");
//         print("Response: ${responseDataa.body}");
//       }
//     } catch (e) {
//       print("Error uploading images: $e");
//     }
//   }

//   Future postImageUpload() async {
//     AppartDetailsListener profileDetailsListener =
//         Provider.of<AppartDetailsListener>(context, listen: false);
//     try {
//       final accessToken = await SPHelper.getTokenSharedPreference() ?? '';

//       // var _request = http.MultipartRequest('PATCH', Uri.parse('\$baseUrl/post/upload-image/$postId/'));
//       var _request = http.MultipartRequest(
//           'POST', Uri.parse('https://realtor.azurewebsites.net/api/Files'));
//       _request.headers.addAll({
//         'Accept': '*/*',
//         "Content-Type": "multipart/form-data",
//         "Authorization": "Bearer $accessToken",
//       });
//       print('ok');

//       late XFile images;
//       for (var x = 0; x < profileDetailsListener.getXfileList.length; x++) {
//         images = profileDetailsListener.getXfileList[x];
//       }
//       _request.files.add(http.MultipartFile.fromBytes(
//           images.name,
//           await images.readAsBytes().then((value) {
//             return value.cast();
//           }),
//           filename: images.path.toString() + '/' + images.name));

//       try {
//         print(_request.files.first.filename);
//         var response = await _request.send();
//         if (response.statusCode == 200) {
//         } else {
//           print("Failed to upload images. Status code: ${response.statusCode}");
//         }
//       } catch (e) {
//         print("Error uploading images: $e");
//       }
//     } catch (e) {
//       return false;
//     }
//   }

// with DIO

// Future<void> uploadPhotos(String _jwtToken, BuildContext context) async {
//   AppartDetailsListener profileDetailsListener =
//       Provider.of<AppartDetailsListener>(context, listen: false);

//   List<String> images = [];
//   for (var x = 0; x < profileDetailsListener.getXfileList.length; x++) {
//     File imageFile = File(profileDetailsListener.getXfileList[x].path);
//     images.add(imageFile.path);
//   }

//   try {
//     Dio dio = Dio();
//     FormData formData = FormData();

//     // formData = FormData.fromMap({
//     //   'id': 'uif',
//     //   'contactPerson': "ddefefefefe",
//     // });

//     for (int i = 0; i < profileDetailsListener.getXfileList.length; i++) {
//       String fileName = 'photo_$i.jpg';
//       html.File htmlFile = html.File(
//           await profileDetailsListener.getXfileList[i].readAsBytes(), fileName);

//       final reader = html.FileReader();
//       reader.readAsArrayBuffer(htmlFile);

//       await reader.onLoadEnd.first;
//       final Uint8List bytes = reader.result as Uint8List;

//       formData.files.add(MapEntry(
//         'photos',
//         MultipartFile.fromBytes(bytes, filename: fileName),
//       ));
//     }

//     Response response = await dio.post(
//       'https://realtor.azurewebsites.net/api/Files',
//       data: formData,
//       options: Options(
//         headers: {
//           'Authorization': 'Bearer $_jwtToken',
//           'Content-Type': 'multipart/form-data',
//         },
//       ),
//     );
//     // Handle the response
//     if (response.statusCode == 200 || response.statusCode == 201) {
//       List<String> photoReferences = List<String>.from(response.data);
//       print('Photo references: $photoReferences');
//     } else if (response.statusCode == 204) {
//       print('Images uploaded successfully, but no content was returned.');
//     } else {
//       print('Failed to upload images. Status code: ${response.statusCode}');
//     }
//   } catch (e) {
//     print('Error uploading images: $e');
//   }
// }

// Future addImagesToDb(BuildContext context, String _jwtToken) async {
//   AppartDetailsListener profileDetailsListener =
//       Provider.of<AppartDetailsListener>(context, listen: false);
//   const url = 'https://realtor.azurewebsites.net/api/Files';

//   late XFile images;
//   for (var x = 0; x < profileDetailsListener.getXfileList.length; x++) {
//     images = profileDetailsListener.getXfileList[x];
//   }

//   File imageFile = File(images.path);
//   try {
//     var formData = FormData.fromMap({
//       'file': await MultipartFile.fromFile(imageFile.path,
//           filename: imageFile.path),
//     });
//     final response = await Dio().post(
//       url,
//       data: formData,
//       options: Options(
//         headers: {
//           'Authorization': 'Bearer $_jwtToken',
//           'Content-Type': 'multipart/form-data',
//         },
//       ),
//     );
//     if (response.statusCode == 200) {
//       var map = response.data as Map;
//       print('success');
//       if (map['status'] == 'Successfully registered') {
//         return true;
//       } else {
//         return false;
//       }
//     } else {
//       //BotToast is a package for toasts available on pub.dev
//       BotToast.showText(text: 'Error');
//       return false;
//     }
//   } on DioError catch (error) {
//     print(error.message);
//   } catch (_) {
//     print(_.toString());
//     throw 'Something Went Wrong';
//   }
// }





  // Future<void> postData() async {
  //   String url = 'https://realtor.azurewebsites.net/api/RentObjects';
  //   Dio dio = Dio();
  //   String uuid = const Uuid().v4();
  //   final accessToken = await SPHelper.getTokenSharedPreference() ?? '';

  //   final List<dynamic> listOfImages = await sendImages(context, accessToken);

  //   try {
  //     FormData formData = FormData.fromMap({
  //       "id": uuid,
  //       "contactPerson": contactPerson.text,
  //       "address": address.text,
  //       "city": city.text,
  //       "region": region.text,
  //       "postalCode": postalCode.text,
  //       "price": price.text,
  //       "type": type.text,
  //       "description": description.text,
  //       "comment": comments.text,
  //       "phone": phone.text,
  //       "floor": floor.text,
  //       "status": "string",
  //       "createdData": "string",
  //       "updatedUser": "string",
  //       "photos": listOfImages,
  //     });

  //     Response response = await dio.post(
  //       url,
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           'Authorization': 'Bearer $accessToken charset=UTF-8',
  //           'Content-Type': 'application/json'
  //         },
  //       ),
  //     );

  //     if (response.statusCode == 200) {
  //       print('Data upload successful: ${response.data}');
  //     } else {
  //       print('Data upload failed with status: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     if (e is DioError) {
  //       if (e.response != null) {
  //         // Server returned a response
  //         if (e.response!.headers['content-type']
  //                 ?.contains('application/json') ??
  //             false) {
  //           // Response is JSON
  //           print(
  //               'Server error: ${e.response?.statusCode} - ${e.response?.data}');
  //         } else {
  //           // Response is not JSON, handle as text or HTML
  //           print(
  //               'Server error: ${e.response?.statusCode} - ${e.response?.data}');
  //         }
  //       } else {
  //         // No response received (e.g., network error)
  //         print('Network error: $e');
  //       }
  //     } else {
  //       // Non-Dio error (e.g., format exception)
  //       print('Error: $e');
  //     }
  //   }
  // }