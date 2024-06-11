import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/api/all_apartments.dart';
import 'package:apartments/app/models/get_all_appart.dart';
import 'package:apartments/app/shared_components/card_task.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class AllApartmentsScreen extends StatefulWidget {
  const AllApartmentsScreen({Key? key}) : super(key: key);

  @override
  State<AllApartmentsScreen> createState() => AllApartmentsScreenState();
}

class AllApartmentsScreenState extends State<AllApartmentsScreen> {
  final int _pageSize = 20;
  RemoteApi remoteApi = RemoteApi();

  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  // Future<void> _fetchPage(int pageKey) async {
  //   try {
  //     // get api /beers list from pages
  //     final newItems = await remoteApi.fetchDataFromAzure();
  //     // Check if it is last page
  //     final isLastPage = newItems!.length < _pageSize;
  //     // If it is last page then append
  //     // last page else append new page
  //     if (isLastPage) {
  //       _pagingController.appendLastPage(newItems);
  //     } else {
  //       // Appending new page when it is not last page
  //       final nextPageKey = pageKey + 1;
  //       _pagingController.appendPage(newItems, nextPageKey);
  //     }
  //   }
  //   // Handle error in catch
  //   catch (error) {
  //     print(_pagingController.error);
  //     // Sets the error in controller
  //     _pagingController.error = error;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius * 2),
      child: SizedBox(
        child: FutureBuilder<ApartmentModelList>(
            future: remoteApi.fetchDataFromAzure(),
            builder: (BuildContext context,
                AsyncSnapshot<ApartmentModelList> snapshot) {
              if (!snapshot.hasData) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 80.0),
                    child: SizedBox(
                      height: 40,
                      width: 40,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
              }
              return ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.apartmentModel.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: kSpacing / 2),
                  child: ShowUp(
                    delay: 400,
                    child: CardTask(
                      data: snapshot.data!.apartmentModel[index],
                      primary: const Color.fromARGB(255, 105, 188, 255),
                      onPrimary: Colors.white,
                    ),
                  ),
                ),
              );

              // return Container();
            }),
      ),
    );
  }

  // Color _getSequenceColor(int index) {
  //   int val = index % 4;
  //   if (val == 3) {
  //     return Colors.indigo;
  //   } else if (val == 2) {
  //     return Colors.grey;
  //   } else if (val == 1) {
  //     return Colors.redAccent;
  //   } else {
  //     return Colors.lightBlue;
  //   }
  // }
}
