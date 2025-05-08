import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:usercraft/core/api/dio_service.dart';
import 'package:usercraft/core/api/end_points.dart';
import 'package:usercraft/core/widgets/toaster/toaster.dart';
import 'package:usercraft/model/list_model.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool isFetchData = false;
  List<ListModel> responceModel = <ListModel>[];
  List<Datum> responceDatum = <Datum>[];

  Future<void> getApi() async {
    isFetchData = true;
    EasyLoading.show();
    try {
      final response = await NetworkManager().callApi(
        urlEndPoint: EndPoints.listUsers,
        method: HttpMethod.Get,
      );

      if (response != null && response.statusCode == 200) {
        Toaster.showToast('Data Fetch Successfully');
        final List<dynamic> dataList = response.data;

        responceModel = dataList
            .map((item) => ListModel.fromJson(item as Map<String, dynamic>))
            .toList();
        responceDatum = responceModel
            .map((data) => Datum.fromJson(data as Map<String, dynamic>))
            .toList();
      } else {
        Toaster.showToast('Something Went Wrong');
      }

      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();
      Toaster.showToast('Something Went Wrong $e');
    }
    notifyListeners();
  }
}
