import 'dart:convert';
import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
      return const SingleChildScrollView(child: TextFormForAddingNewApt());
    }, tabletBuilder: (context, constraints) {
      return SingleChildScrollView(
          controller: ScrollController(),
          child: const TextFormForAddingNewApt());
    }, desktopBuilder: (context, constraints) {
      return Center(
        child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            controller: ScrollController(),
            child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                child: const FormsList())),
      );
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
        TextFormForAddingNewApt(),
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
  final TextEditingController city = TextEditingController();
  final TextEditingController region = TextEditingController();
  String result = ''; //

  Future<void> postData() async {
    try {
      print('started');
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'id': '343434',
          'contactPerson': contactPerson.text,
          'city': city.text,
          'region': region.text,
          "address": "ef",
          "postalCode": "ef",
          "price": "ef",
          "type": "ef",
          "description": "ef",
          "comment": "ef",
          "phone": "ef",
          "floor": "ef",
          "photos": ["string"],
        }),
      );

      if (response.statusCode == 201) {
        // Successful POST request, handle the response here

        print(response.statusCode);
        final responseData = jsonDecode(response.body);
        setState(() {
          result =
              'ID: ${responseData['id']}\nName: ${responseData['name']}\nEmail: ${responseData['email']}';
        });
      } else {
        // If the server returns an error response, throw an exception
        throw Exception('Failed to post data');
      }
    } catch (e) {
      print(e);
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
          decoration: InputDecoration(
              isDense: true,
              alignLabelWithHint: true,
              filled: true,
              fillColor: Colors.white,
              focusedBorder: outlineMainInputFocusedBorder,
              enabledBorder: outlineMainInputFocusedBorder,
              contentPadding:
                  // ignore: prefer_const_constructors
                  EdgeInsets.only(top: 24, bottom: 5, left: 15, right: 15),
              hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 112, 112, 112),
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              border: InputBorder.none,
              hintText: 'Add short information about yourself '),
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
          decoration: InputDecoration(
              isDense: true,
              alignLabelWithHint: true,
              filled: true,
              fillColor: Colors.white,
              focusedBorder: outlineMainInputFocusedBorder,
              enabledBorder: outlineMainInputFocusedBorder,
              contentPadding:
                  // ignore: prefer_const_constructors
                  EdgeInsets.only(top: 24, bottom: 5, left: 15, right: 15),
              hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 112, 112, 112),
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              border: InputBorder.none,
              hintText: 'Add short information about yourself '),
          onChanged: (val) {
            city.text = val;
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
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
              isDense: true,
              alignLabelWithHint: true,
              filled: true,
              fillColor: Colors.white,
              focusedBorder: outlineMainInputFocusedBorder,
              enabledBorder: outlineMainInputFocusedBorder,
              contentPadding:
                  // ignore: prefer_const_constructors
                  EdgeInsets.only(top: 24, bottom: 5, left: 15, right: 15),
              hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 112, 112, 112),
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
              border: InputBorder.none,
              hintText: 'Add short'),
          onChanged: (val) {
            region.text = val;
          },
        ),
        const SizedBox(
          height: 55,
        ),
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

final outlineMainInputFocusedBorder = OutlineInputBorder(
  borderRadius: BorderRadius.circular(8.0),
  borderSide:
      const BorderSide(color: Color.fromARGB(255, 171, 107, 255), width: 1.5),
);
