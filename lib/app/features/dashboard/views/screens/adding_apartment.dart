import 'dart:convert';

import 'dart:typed_data';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:apartments/app/utils/services/apartment_image_service.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddingNewApartment extends StatefulWidget {
  const AddingNewApartment({Key? key}) : super(key: key);

  @override
  State<AddingNewApartment> createState() => _AddingNewApartmentState();
}

class _AddingNewApartmentState extends State<AddingNewApartment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ResponsiveBuilder(mobileBuilder: (context, constraints) {
      return const SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Column(
          children: [
            FormsList(),
            TextFormForAddingNewApt(),
          ],
        ),
      ));
    }, tabletBuilder: (context, constraints) {
      return SingleChildScrollView(
          controller: ScrollController(),
          child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: const Column(
                children: [
                  FormsList(),
                  TextFormForAddingNewApt(),
                ],
              )));
    }, desktopBuilder: (context, constraints) {
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: ScrollController(),
          child: Center(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.symmetric(vertical: 55),
                child: const Column(
                  children: [
                    FormsList(),
                    TextFormForAddingNewApt(),
                  ],
                )),
          ));
    })));
  }
}

class FormsList extends StatelessWidget {
  const FormsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adding new appartment',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        Text(
          'Please fill the form',
          style: TextStyle(fontSize: 15),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class TextFormForAddingNewApt extends StatefulWidget {
  const TextFormForAddingNewApt({Key? key}) : super(key: key);

  @override
  State<TextFormForAddingNewApt> createState() =>
      _TextFormForAddingNewAptState();
}

class _TextFormForAddingNewAptState extends State<TextFormForAddingNewApt> {
  final String apiUrl = 'https://realtor.azurewebsites.net/api/RentObjects';
  final TextEditingController contactPerson = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController city = TextEditingController();
  final TextEditingController region = TextEditingController();
  final TextEditingController postalCode = TextEditingController();
  final TextEditingController price = TextEditingController();
  final TextEditingController type = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController floor = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController comments = TextEditingController();

  String result = ''; //
  List<String> imagesDownloadedList = [];
  Future<void> postData() async {
    try {
      print('started');
      String uuid = const Uuid().v4();
      await uploadImages();
      // final response = await http.post(
      //   Uri.parse(apiUrl),
      //   headers: <String, String>{
      //     'Content-Type': 'application/json; charset=UTF-8',
      //   },
      //   body: jsonEncode(<String, dynamic>{
      //     'id': uuid,
      //     'contactPerson': contactPerson.text,
      //     'city': city.text,
      //     'region': region.text,
      //     "address": address.text,
      //     "postalCode": postalCode.text,
      //     "price": price.text,
      //     "type": type.text,
      //     "description": description.text,
      //     "comment": comments.text,
      //     "phone": phone.text,
      //     "floor": floor.text,
      //     "photos": ['dddd'],
      //   }),
      // );

      // if (response.statusCode == 201) {
      //   // Successful POST request, handle the response here

      //   print(response.statusCode);
      //   final responseData = jsonDecode(response.body);
      //   setState(() {
      //     result =
      //         'ID: ${responseData['id']}\nName: ${responseData['name']}\nEmail: ${responseData['email']}';
      //   });
      // } else {
      //   // If the server returns an error response, throw an exception
      //   throw Exception('Failed to post data');
      // }
    } catch (e) {
      print(e);
    }
  }

  //   uploadFile() async {
  //     AppartDetailsListener profileDetailsListener =
  //         Provider.of<AppartDetailsListener>(context, listen: false);
  //     var postUri = Uri.parse("https://realtor.azurewebsites.net/api/Files");

  //     print('upload images started');

  //     http.MultipartRequest request = http.MultipartRequest("POST", postUri);
  //     for (var img in profileDetailsListener.getXfileList) {
  //       File image = File(img.path);

  //       var bytes = await image.readAsBytes();
  //       var base64img = base64Encode(bytes);
  //       print(bytes);

  //     // http.MultipartFile multipartFile = await http.MultipartFile.fromPath(
  //     //   'image',
  //     //   base64img,
  //     // );
  //     // request.files.add(multipartFile);
  //   }
  //   // http.StreamedResponse response = await request.send();
  //   // request.files
  //   //     .add(await http.MultipartFile.fromPath('image', 'path/to/image.png'));
  //   // print(response.statusCode);
  // }

  Future<void> addProduct(String id) async {
    AppartDetailsListener profileDetailsListener =
        Provider.of<AppartDetailsListener>(context, listen: false);
    if (profileDetailsListener.getXfileList.isEmpty) {
      print("No images selected.");
      return;
    }
    final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
    print(id);
    var uri = Uri.parse("https://realtor.azurewebsites.net/api/Files");
    var request = http.MultipartRequest('POST', uri);

    // request.fields['id'] = id;

    for (var image in profileDetailsListener.getXfileList) {
      print(image);
      // var stream = http.ByteStream(image.openRead());
      var stream = http.ByteStream(Stream.castFrom(image.openRead()));
      var length = await image.length();
      var multipartFile =
          http.MultipartFile(id, stream, length, filename: image.name);
      request.files.add(multipartFile);
    }
    request.headers.addAll({
      "Content-Type": "multipart/form-data",
      "Authorization": "Bearer $accessToken",
    });

    try {
      var response = await request.send();

      var responseDataa = await http.Response.fromStream(response);
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        List<dynamic> photoReferences = json.decode(responseData);
        print(photoReferences);
      } else {
        print("Failed to upload images. Status code: ${response.statusCode}");
        print("Response: ${responseDataa.body}");
      }
    } catch (e) {
      print("Error uploading images: $e");
    }
  }

  Future<void> uploadImages() async {
    try {
      var uri = Uri.parse('https://realtor.azurewebsites.net/api/Files');
      var request = http.MultipartRequest('POST', uri);
      AppartDetailsListener profileDetailsListener =
          Provider.of<AppartDetailsListener>(context, listen: false);
      if (profileDetailsListener.getXfileList.isEmpty) {
        print("No images selected.");
        return;
      }

      final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
      // Add images to form data
      for (int i = 0; i < profileDetailsListener.getXfileList.length; i++) {
        var byteStream = profileDetailsListener.getXfileList[i].openRead();
        var length = await profileDetailsListener.getXfileList[i].length();
        print(profileDetailsListener.getXfileList.length);
        var multipartFile = http.MultipartFile(
          'photos',
          byteStream,
          length,
        );

        request.headers.addAll({
          "Content-Type": "multipart/form-data",
          "Authorization": "Bearer $accessToken",
        });
        print(multipartFile.length);

        request.files.add(multipartFile);
      }

      // Send the request
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        List<dynamic> photoReferences = json.decode(responseData);

        // Handle the references returned by the server
        print('Photo references: $photoReferences');
      } else {
        // Handle error
        print('Failed to upload images. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Handle error
      print('Error uploading images: $e');
    }
  }

  @override
  void dispose() {
    city.dispose();
    region.dispose();
    contactPerson.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: decorationForTextFormField('Contact Person'),
          onChanged: (val) {
            contactPerson.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: decorationForTextFormField('Address'),
          onChanged: (val) {
            address.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500),
          decoration: decorationForTextFormField('City'),
          onChanged: (val) {
            city.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Region'),
          onChanged: (val) {
            region.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.number,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Postal Code'),
          onChanged: (val) {
            postalCode.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.number,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Price',
              icon: const FaIcon(
                FontAwesomeIcons.dollarSign,
                color: Colors.grey,
              )),
          onChanged: (val) {
            price.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Type'),
          onChanged: (val) {
            type.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLines: 5,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Description'),
          onChanged: (val) {
            description.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Floor'),
          onChanged: (val) {
            floor.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Phone'),
          onChanged: (val) {
            phone.text = val;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          maxLines: 3,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Comments'),
          onChanged: (val) {
            comments.text = val;
          },
        ),
        const SizedBox(
          height: 55,
        ),
        const ChooseImageForAppartment(null),
        const SizedBox(
          height: 55,
        ),
        // ignore: sized_box_for_whitespace
        Container(
          width: 250,
          height: 40,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 188, 2),
              ),
              onPressed: () {
                postData();
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              )),
        )
      ],
    );
  }
}
