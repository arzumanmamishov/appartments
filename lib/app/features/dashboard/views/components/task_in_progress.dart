import 'package:apartments/app/constans/app_constants.dart';
import 'package:apartments/app/api/all_apartments.dart';
import 'package:apartments/app/models/get_all_appart.dart';
import 'package:apartments/app/shared_components/card_task.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:flutter/material.dart';

class TaskInProgress extends StatefulWidget {
  const TaskInProgress({Key? key}) : super(key: key);

  @override
  State<TaskInProgress> createState() => TaskInProgressState();
}

class TaskInProgressState extends State<TaskInProgress> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kBorderRadius * 2),
      child: SizedBox(
        child: FutureBuilder<ApartmentModelList>(
            future: fetchDataFromAzure(),
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
