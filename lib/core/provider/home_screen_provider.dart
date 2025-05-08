import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:usercraft/core/api/dio_service.dart';
import 'package:usercraft/core/api/end_points.dart';
import 'package:usercraft/core/widgets/toaster/toaster.dart';
import 'package:usercraft/model/responce_model.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool isFetchData = false;
  List<ResponceModel> responceModel = <ResponceModel>[];

  Future<void> getApi() async {
    isFetchData = true;
    EasyLoading.show();
    try {
      final response = await NetworkManager().callApi(
        urlEndPoint: EndPoints.mainCall,
        method: HttpMethod.Get,
      );

      if (response != null && response.statusCode == 200) {
        Toaster.showToast('Data Fetch Successfully');
        final List<dynamic> dataList = response.data;

        responceModel = dataList
            .map((item) => ResponceModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }

      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      Toaster.showToast('Something Went Wrong');
    }
    notifyListeners();
  }
}
