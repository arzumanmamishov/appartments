import 'package:apartments/app/features/dashboard/views/screens/sub%20screens%20of%20apartments/edit_appartment_sub_screen.dart';
import 'package:apartments/app/shared_components/responsive_builder.dart';
import 'package:flutter/material.dart';

class ApartmentEditDetail extends StatefulWidget {
  const ApartmentEditDetail({Key? key}) : super(key: key);

  @override
  State<ApartmentEditDetail> createState() => _ApartmentEditDetailState();
}

class _ApartmentEditDetailState extends State<ApartmentEditDetail> {
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
              child: const TextFormForAddingEditingApt()),
        ),
      ));
    }, tabletBuilder: (context, constraints) {
      return SingleChildScrollView(
          controller: ScrollController(),
          child: Center(
            child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.only(top: 10),
                child: const TextFormForAddingEditingApt()),
          ));
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
                    FormsEditList(),
                    TextFormForAddingEditingApt(),
                  ],
                )),
          ));
    })));
  }
}

class FormsEditList extends StatelessWidget {
  const FormsEditList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edit appartment',
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
