import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:apartments/app/models/get_all_appart.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppartDetailsListener with ChangeNotifier {
  bool toogleBetweenAboutAndComments = true;
  bool comments = false;
  bool toogle = true;
  bool updatePhoneNumber = false;
  bool highRated = false;
  File? selfyFile;
  File? passportFile;
  String? dateOfBirth;
  String? taxId;
  ApartmentModel? portfolioModel;
  bool? useDifferentFormat;
  List? allPortfolioImagesWithNotifier = [];

  List<XFile> xfileList = [];
  List<Uint8List?> unitfileList = [];
  List<ApartmentModel> portfolioModelList = [];
  ApartmentModel? get getPortfolioModel => portfolioModel;
  List<XFile> get getXfileList => xfileList;
  List<Uint8List?> get getunitfileList => unitfileList;
  UnmodifiableListView<ApartmentModel> get getPortfolioModelList =>
      UnmodifiableListView(portfolioModelList);

  get getUseDifferentFormat => useDifferentFormat;
  get getSelfyFile => selfyFile;
  get getPassportFile => passportFile;
  get getDateOfBirth => dateOfBirth;
  get gettaxId => taxId;
  get changePhoneNumber => updatePhoneNumber;
  get getAllPortfolioImagesWithNotifier => allPortfolioImagesWithNotifier;
  get gettoogleBetweenAboutAndComments => toogleBetweenAboutAndComments;
  get getRate => highRated;
  set toogleBetweenAboutAndComment(bool toogleBetweenAboutAndComments) {
    toogleBetweenAboutAndComments = toogleBetweenAboutAndComments;
    notifyListeners();
  }

  set setPhoneNumber(bool newPhoneNumber) {
    updatePhoneNumber = newPhoneNumber;
    notifyListeners();
  }

  set setSelfyFile(File? image) {
    selfyFile = image;
    notifyListeners();
  }

  set setPassFile(File? image) {
    passportFile = image;
    notifyListeners();
  }

  set setTaxId(String? number) {
    taxId = number;
    notifyListeners();
  }

  set setDateOfBirth(String? number) {
    dateOfBirth = number;
    notifyListeners();
  }

  set setPortFolioModel(ApartmentModel portfolioModelData) {
    portfolioModel = portfolioModelData;
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

  set setRating(bool rate) {
    highRated = rate;
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
