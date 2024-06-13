import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:apartments/app/models/get_all_appart_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppartDetailsListener with ChangeNotifier {
  ApartmentModel? apartmentModel;

  bool? useDifferentFormat;
  List? allPortfolioImagesWithNotifier = [];

  List<XFile> xfileList = [];
  List<Uint8List?> unitfileList = [];
  List<ApartmentModel> portfolioModelList = [];
  ApartmentModel? get getApartModel => apartmentModel;
  List<XFile> get getXfileList => xfileList;
  List<Uint8List?> get getunitfileList => unitfileList;
  UnmodifiableListView<ApartmentModel> get getPortfolioModelList =>
      UnmodifiableListView(portfolioModelList);
  get getuseDifferentFormat => useDifferentFormat;
  get getAllPortfolioImagesWithNotifier => allPortfolioImagesWithNotifier;

  set setApartmentModel(ApartmentModel apartmentModels) {
    apartmentModel = apartmentModels;
    notifyListeners();
  }

  set setUseDifferentFormat(bool differentFormat) {
    useDifferentFormat = differentFormat;
    notifyListeners();
  }

  setXfileList(dynamic xfileListData) {
    xfileList.addAll(xfileListData);
    notifyListeners();
  }

  setunitfileList(Uint8List ufileListData) {
    ufileListData.addAll(ufileListData);
    notifyListeners();
  }

  set setPortFolioModelList(List<ApartmentModel> portfolioModelLists) {
    portfolioModelList = portfolioModelLists;
    notifyListeners();
  }

  set setAllPortfolioImagesWithNotifier(List? imagesList) {
    allPortfolioImagesWithNotifier = imagesList;
    notifyListeners();
  }
}

class ModalForProfileDetailsListener {
  String? selfyFile;
  String? passportFile;
  String? dateOfBirth;
  String? taxId;
  String? uid;
  String? image;
  String? name;

  ModalForProfileDetailsListener();

  Map<String, dynamic> toMap() {
    return {
      'selfyFile': selfyFile,
      'passportFile': passportFile,
      'dateOfBirth': dateOfBirth,
      'taxId': taxId,
      'uid': uid,
      'image': image,
      'name': name,
    };
  }
}
