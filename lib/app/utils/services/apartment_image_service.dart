// ignore_for_file: avoid_unnecessary_containers

import 'dart:io';

import 'package:apartments/app/providers/appartment_provider.dart';
import 'package:apartments/app/utils/animations/show_up_animation.dart';
import 'package:apartments/app/utils/services/cached_image_services.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ChooseImageForAppartment extends StatefulWidget {
  final List? imagesFromJobEdit;
  const ChooseImageForAppartment(this.imagesFromJobEdit, {Key? key})
      : super(key: key);

  @override
  State<ChooseImageForAppartment> createState() =>
      _ChooseImageForPortfolioState();
}

class _ChooseImageForPortfolioState extends State<ChooseImageForAppartment> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile> imageFileList = [];
  bool iconEnabled = false;
  List<dynamic>? allPortfolioImagesWothNotifier = [];
  bool loading = false;
  @override
  void initState() {
    AppartDetailsListener profileDetailsListener =
        Provider.of<AppartDetailsListener>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      profileDetailsListener.setAllPortfolioImagesWithNotifier =
          allPortfolioImagesWothNotifier;
      if (widget.imagesFromJobEdit != null) {
        allPortfolioImagesWothNotifier = widget.imagesFromJobEdit;
      } else {
        // allPortfolioImagesWothNotifier!
        //     .addAll(profileDetailsListener.getPortfolioModel.photos);
      }
    });
    super.initState();
  }

  void selectImage() async {
    AppartDetailsListener profileDetailsListener =
        Provider.of<AppartDetailsListener>(context, listen: false);
    print('select image ');
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();

    // Future.delayed(const Duration(seconds: 3));

    if (selectedImages!.isNotEmpty) {
      // if (selectedImages.length > 10) {
      //   selectedImages.removeRange(10, selectedImages.length);
      // }

      print(selectedImages);
      profileDetailsListener.setXfileList(selectedImages);
    }
  }

  deleteImageFromBottomSheet(dynamic index) {
    AppartDetailsListener profileDetailsListener =
        Provider.of<AppartDetailsListener>(context, listen: false);
    allPortfolioImagesWothNotifier!.removeWhere((element) => element == index);
    profileDetailsListener.setAllPortfolioImagesWithNotifier =
        allPortfolioImagesWothNotifier;
    setState(() {});
  }

  deleteXFileFromBottomSheet(dynamic index) {
    AppartDetailsListener profileDetailsListener =
        Provider.of<AppartDetailsListener>(context, listen: false);
    profileDetailsListener.getXfileList
        .removeWhere((element) => element == index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppartDetailsListener profileDetailsListener =
        Provider.of<AppartDetailsListener>(context, listen: true);

    return Column(
      children: [
        if (profileDetailsListener.getUseDifferentFormat == true &&
            allPortfolioImagesWothNotifier!.isNotEmpty) ...[
          Container(
            child: ImagesListToSend(
              imageFileList: allPortfolioImagesWothNotifier,
              deleteImage: deleteImageFromBottomSheet,
            ),
          ),
        ],
        if (profileDetailsListener.getXfileList.isNotEmpty) ...[
          Container(
            child: ImagesXFileListToSend(
              imageXFileList: profileDetailsListener.getXfileList,
              deleteImage: deleteXFileFromBottomSheet,
            ),
          ),
        ],
        const SizedBox(
          height: 10,
        ),
        DottedBorder(
          dashPattern: const [6],
          strokeWidth: 1.5,
          borderType: BorderType.RRect,
          radius: const Radius.circular(15),
          color: Colors.grey.shade300,
          child: InkWell(
            onTap: () async {
              FocusScope.of(context).unfocus();
              selectImage();
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.grey.shade100),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Add Images',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        Text(
                          'Jpg,gif and other image formats',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        )
                      ],
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class ImagesListToSend extends StatelessWidget {
  final List? imageFileList;

  final Function deleteImage;
  const ImagesListToSend(
      {required this.imageFileList, required this.deleteImage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 10, top: 4),
        itemCount: imageFileList!.length,
        addAutomaticKeepAlives: true,
        itemBuilder: (BuildContext context, int index) {
          return ShowUp2(
            delay: 200,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 65,
                  width: 65,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200)),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: CachedNetworImageWidget(
                          imageUrl: imageFileList![index])),
                ),
                Positioned(
                  left: 42,
                  bottom: 40,
                  child: InkWell(
                    onTap: () {
                      deleteImage(imageFileList![index]);
                    },
                    child: Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.5, color: Colors.white),
                          shape: BoxShape.circle,
                          color: Colors.black),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: SvgPicture.asset(
                          'assets/icons/closes.svg',
                          width: 15,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 15,
          crossAxisSpacing: 7,
          crossAxisCount: 5,
        ));
  }
}

class ImagesXFileListToSend extends StatelessWidget {
  final List? imageXFileList;

  final Function deleteImage;
  const ImagesXFileListToSend(
      {required this.imageXFileList, required this.deleteImage, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Add image',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500, fontSize: 14),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 10, top: 4),
            itemCount: imageXFileList?.length,
            addAutomaticKeepAlives: true,
            itemBuilder: (BuildContext context, int index) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200)),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                      child: kIsWeb
                          ? Image.network(frameBuilder: (BuildContext context,
                              Widget child,
                              int? frame,
                              bool wasSynchronouslyLoaded) {
                              if (wasSynchronouslyLoaded) {
                                return child;
                              }
                              return AnimatedOpacity(
                                opacity: frame == null ? 0 : 1,
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.easeOut,
                                child: child,
                              );
                            }, File(imageXFileList![index].path).path)
                          : Image.file(
                              File(imageXFileList![index].path),
                              frameBuilder: (BuildContext context, Widget child,
                                  int? frame, bool wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) {
                                  return child;
                                }
                                return AnimatedOpacity(
                                  opacity: frame == null ? 0 : 1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeOut,
                                  child: child,
                                );
                              },
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Positioned(
                    left: 50,
                    bottom: 50,
                    child: InkWell(
                      onTap: () {
                        deleteImage(imageXFileList![index]);
                      },
                      child: Container(
                        height: 27,
                        width: 27,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.5, color: Colors.grey),
                            shape: BoxShape.circle,
                            color: Colors.white),
                        child: const Icon(
                          Icons.cancel,
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  )
                ],
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 15,
              crossAxisSpacing: 7,
              crossAxisCount: 5,
            )),
      ],
    );
  }
}
