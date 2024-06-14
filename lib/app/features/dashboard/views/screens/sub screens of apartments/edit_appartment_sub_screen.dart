import 'package:apartments/app/api/client_api.dart';
import 'package:apartments/app/features/dashboard/views/components/text_form_fiel_decoration.dart';
import 'package:apartments/app/models/get_all_appart_model.dart';
import 'package:apartments/app/utils/services/apartment_image_service.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
  
class TextFormForAddingEditingApt extends StatefulWidget {
  const TextFormForAddingEditingApt({Key? key}) : super(key: key);

  @override
  State<TextFormForAddingEditingApt> createState() =>
      _TextFormForAddingEditingAptState();
}

class _TextFormForAddingEditingAptState
    extends State<TextFormForAddingEditingApt> {
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
  DateTime now = DateTime.now();
  ApartmentModel apartmentModel = ApartmentModel();
  ApiClient apiClient = ApiClient();

  Future<bool> postData() async {
    final Dio _dio = Dio();
    final id = await SPHelper.getIDAptSharedPreference() ?? '';

    String url = 'https://realtor.azurewebsites.net/api/RentObjects/$id';

    try {
      final accessToken = await SPHelper.getTokenSharedPreference() ?? '';
      final listOfImages = await ApiClient().sendImages(context, accessToken);

      Map<String, dynamic> data = {
        "id": "uuid",
        "contactPerson": contactPerson.text,
        "address": address.text,
        "city": city.text,
        "region": region.text,
        "postalCode": postalCode.text,
        "price": price.text,
        "type": type.text,
        "description": description.text,
        "comment": comments.text,
        "phone": phone.text,
        "floor": floor.text,
        "status": "string",
        "createdData": now.toString(),
        "updatedUser": now.toString(),
        "photos": listOfImages,
      };

      final response = await _dio.put(
        url,
        data: data,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
 List <dynamic>?apartmentPhotos;
  getApartmentDetails() async {

    apartmentModel = await apiClient.fetchApartmentDetails();
    contactPerson.text = apartmentModel.contactPerson.toString();
    address.text = apartmentModel.address.toString();
    region.text = apartmentModel.region.toString();
    city.text = apartmentModel.city.toString();
    postalCode.text = apartmentModel.postalCode.toString();
    price.text = apartmentModel.price.toString();
    type.text = apartmentModel.type.toString();
    description.text = apartmentModel.description.toString();
    comments.text = apartmentModel.comment.toString();
    phone.text = apartmentModel.phone.toString();
    floor.text = apartmentModel.floor.toString();
    apartmentPhotos = apartmentModel.photos;

  }

  @override
  void initState() {
    getApartmentDetails();
    super.initState();
  }

  @override
  void dispose() {
    city.dispose();
    region.dispose();
    contactPerson.dispose();
    postalCode.dispose();
    address.dispose();
    price.dispose();
    type.dispose();
    description.dispose();
    comments.dispose();
    phone.dispose();
    floor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: contactPerson,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Contact Person'),
          // onChanged: (val) {
          //   contactPerson.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: address,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Address'),
          // onChanged: (val) {
          //   address.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: city,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('City'),
          // onChanged: (val) {
          //   city.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: region,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Region'),
          // onChanged: (val) {
          //   region.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller:postalCode ,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.number,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Postal Code'),
          // onChanged: (val) {
          //   postalCode.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller:price ,
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
          // onChanged: (val) {
          //   price.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller:type ,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Type'),
          // onChanged: (val) {
          //   type.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: description,
          maxLines: 5,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Description'),
          // onChanged: (val) {
          //   description.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: floor,
          autovalidateMode: AutovalidateMode.always,
          textCapitalization: TextCapitalization.sentences,
          autofocus: false,
          keyboardType: TextInputType.multiline,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
          decoration: decorationForTextFormField('Floor'),
          // onChanged: (val) {
          //   floor.text = val;
          // },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          controller: phone,
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
          controller: comments,
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
         ChooseImageForAppartment(apartmentPhotos),
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
              onPressed: () async {
                var cancel = BotToast.showLoading();
                final done = await postData();
                if (done == true) {
                  cancel();
                  Navigator.of(context).pop();
                }
              },
              child: const Text(
                'Submit',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w600),
              )),
        ),
      ],
    );
  }
}
