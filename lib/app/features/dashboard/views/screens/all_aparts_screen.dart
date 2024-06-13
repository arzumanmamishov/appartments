import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/api/all_apartments.dart';
import 'package:apartments/app/models/get_all_appart_model.dart';
import 'package:apartments/app/shared_components/card_task.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:apartments/app/utils/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_pagination/flutter_web_pagination.dart';
import 'package:get/get.dart';

class AllApartmentsScreen extends StatefulWidget {
  const AllApartmentsScreen({Key? key}) : super(key: key);

  @override
  State<AllApartmentsScreen> createState() => AllApartmentsScreenState();
}

class AllApartmentsScreenState extends State<AllApartmentsScreen> {
  RemoteApi remoteApi = RemoteApi();

  final int _limit = 10; // Number of items per page
  int _currentPage = 1;
  late Future<ApartmentModelList> _futureApartmentModelList;

  @override
  void initState() {
    _futureApartmentModelList =
        remoteApi.fetchDataFromAzure(_currentPage, _limit);
    super.initState();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
      _futureApartmentModelList =
          remoteApi.fetchDataFromAzure(_currentPage, _limit);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius * 2),
      child: FutureBuilder<ApartmentModelList>(
          future: _futureApartmentModelList,
          builder: (BuildContext context,
              AsyncSnapshot<ApartmentModelList> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: SizedBox(
                      height: 35,
                      width: 35,
                      child: Padding(
                        padding: EdgeInsets.all(2.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )));
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  if (snapshot.data!.apartmentModel.length <= 1) ...[
                    const Text('No Kvartira found'),
                  ] else ...[
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data!.apartmentModel.length,
                      itemBuilder: (context, index) => Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: kSpacing / 2),
                        child: ShowUp(
                          delay: 400,
                          child: InkWell(
                            onTap: () async {
                              await SPHelper.saveIDAptSharedPreference(snapshot
                                  .data!.apartmentModel[index].id
                                  .toString());

                              Get.toNamed("/apartmentdetail");
                            },
                            child: CardTask(
                              data: snapshot.data!.apartmentModel[index],
                              primary: const Color.fromARGB(255, 105, 188, 255),
                              onPrimary: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: WebPagination(
                      currentPage: _currentPage,
                      totalPage: 10, // Adjust according to your total pages
                      displayItemCount: 3, // Number of pages to display
                      onPageChanged: _onPageChanged,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No data found'));
            }
            // return Container();
          }),
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
