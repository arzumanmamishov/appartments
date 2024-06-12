import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
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

  @override
  Widget build(BuildContext context) {
    AppartDetailsListener profileDetailsListener =
        Provider.of<AppartDetailsListener>(context, listen: true);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CarouselSlider.builder(
            itemCount: profileDetailsListener.getApartModel!.photos!.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return Container(
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: Image.network(
                    profileDetailsListener.getApartModel!.photos![index],
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
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
