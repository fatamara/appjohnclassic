import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
// import 'package:google_maps_webservice/src/places.dart';

import '../Model/prediction.dart';
import '../Services/Api.dart';

class LocationController extends GetxController{

  List<Prediction> _predictionList = [];

  final ApiService _apiService = ApiService();

  Future<List<Prediction>> searchLocation(BuildContext context, String text) async {
    if(text.isNotEmpty) {
      http.Response response = await _apiService.getLocationData(text);
      var data = jsonDecode(response.body.toString());
      if (kDebugMode) {
        print("my status is ${data["status"]}");
      }
      if ( data['status']== 'OK') {
        _predictionList = [];
        data['predictions'].forEach((prediction)
        => _predictionList.add(Prediction.fromJson(prediction)));
      }
      // else {
      //   // ApiChecker.checkApi(response);
      // }
    }
    return _predictionList;
  }


}

