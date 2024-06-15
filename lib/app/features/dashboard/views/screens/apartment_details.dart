import 'package:apartments/app/features/dashboard/views/screens/sub%20screens%20of%20apartments/apt_details_sub_screen.dart';
import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:flutter/material.dart';

class ApartmentDetail extends StatefulWidget {
  const ApartmentDetail({Key? key}) : super(key: key);

  @override
  State<ApartmentDetail> createState() => _ApartmentDetailState();
}

class _ApartmentDetailState extends State<ApartmentDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ResponsiveBuilder(mobileBuilder: (context, constraints) {
      return SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Center(
          child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.only(top: 10),
              child: const ApartmentDetailsSubScreen()),
        ),
      ));
    }, tabletBuilder: (context, constraints) {
      return SingleChildScrollView(
          controller: ScrollController(),
          child: Center(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.only(top: 10),
                child: const ApartmentDetailsSubScreen()),
          ));
    }, desktopBuilder: (context, constraints) {
      return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          controller: ScrollController(),
          child: Center(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 1000),
                padding: const EdgeInsets.only(top: 10),
                child: const ApartmentDetailsSubScreen()),
          ));
    })));
  }
}
