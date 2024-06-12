import 'package:apartments/app/api/client_api.dart';
import 'package:apartments/app/models/get_all_appart.dart';
import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ApartmentDetailsSubScreen extends StatefulWidget {
  const ApartmentDetailsSubScreen({super.key});

  @override
  State<ApartmentDetailsSubScreen> createState() =>
      _ApartmentDetailsSubScreenState();
}

class _ApartmentDetailsSubScreenState extends State<ApartmentDetailsSubScreen> {
  @override
  void initState() {
    super.initState();
  }

  ApiClient apiClient = ApiClient();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: apiClient.fetchApartmentDetails(),
        builder: (context, AsyncSnapshot<ApartmentModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            ApartmentModel apartment = snapshot.data!;
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CarouselSlider.builder(
                    itemCount: apartment.photos!.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      return Container(
                        margin: const EdgeInsets.all(5.0),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10.0)),
                          child: Image.network(
                            apartment.photos![index],
                            fit: BoxFit.cover,
                            width: 1000.0,
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: 400.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: false,
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Text(apartment.city.toString()),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        });
  }
}
