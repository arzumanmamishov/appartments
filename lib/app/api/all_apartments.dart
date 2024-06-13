import 'package:apartments/app/models/get_all_appart_model.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:dio/dio.dart';

class RemoteApi {
  final Dio _dio = Dio();

  Future<ApartmentModelList> fetchDataFromAzure(int page, int limit,
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

  Future<bool> deleteApartDataFromAzure(
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
}







// workingremote api
// Future<ApartmentModelList> fetchDataFromAzureHttp() async {
//     var url = 'https://realtor.azurewebsites.net/api/RentObjects';

//     late ApartmentModelList appartmentList;

//     try {
//       var response = await http.get(Uri.parse(url));
//       print(response);
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         appartmentList = ApartmentModelList.fromJson(data);
//         print("photos " + appartmentList.apartmentModel[0].city.toString());
//       }
//     } catch (exception) {
//       print(exception);
//     }
//     return appartmentList;
//   }


// Future addProduct(File imageFile) async {
// // ignore: deprecated_member_use
//   var stream =
//       new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
//   var length = await imageFile.length();
//   var uri = Uri.parse("http://10.0.2.2/foodsystem/uploadg.php");

//   var request = new http.MultipartRequest("POST", uri);

//   var multipartFile = new http.MultipartFile("image", stream, length,
//       filename: basename(imageFile.path));

//   request.files.add(multipartFile);
//   request.fields['productname'] = controllerName.text;
//   request.fields['productprice'] = controllerPrice.text;
//   request.fields['producttype'] = controllerType.text;
//   request.fields['product_owner'] = globals.restaurantId;

//   var respond = await request.send();
//   if (respond.statusCode == 200) {
//     print("Image Uploaded");
//   } else {
//     print("Upload Failed");
//   }
// }

// Future add(name, desc, address, images) async {
//   final dynamic adData;
//   var formData = FormData.fromMap({
//     'name': name,
//     'desc': desc,
//     'address': address,
//     'files': [
//       for (var item in images)
//         {await MultipartFile.fromFile(item.path, filename: basename(item.path))}
//             .toList()
//     ],
//   });

//   await _dio.post("${host}/add", data: formData).then((data) {
//     adData = data.data;
//   });
//   return ad_data;
// }
