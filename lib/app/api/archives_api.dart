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