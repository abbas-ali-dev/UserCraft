import 'package:flutter/material.dart';
import 'package:usercraft/core/api/dio_service.dart';
import 'package:usercraft/core/api/end_points.dart';
import 'package:usercraft/model/responce_model.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool isFetchData = false;
  List<ResponceModel> responceModel = <ResponceModel>[];

  Future<void> getApi() async {
    isFetchData = true;

    final response = await NetworkManager().callApi(
      urlEndPoint: EndPoints.mainCall,
      method: HttpMethod.Get,
    );

    if (response != null) {
      final List<dynamic> dataList = response.data;

      responceModel = dataList
          .map((item) => ResponceModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }
  }
}
