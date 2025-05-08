import 'package:flutter/material.dart';
import 'package:usercraft/core/api/dio_service.dart';
import 'package:usercraft/core/api/end_points.dart';
import 'package:usercraft/core/widgets/toaster/toaster.dart';
import 'package:usercraft/model/user_model.dart';

class ProfileScreenProvider extends ChangeNotifier {
  UserModel? userModel;
  bool isLoading = true;

  Future<void> fetchProfile() async {
    try {
      final response = await NetworkManager().callApi(
        urlEndPoint: EndPoints.profile,
        method: HttpMethod.Get,
      );

      if (response != null && response.statusCode == 200) {
        userModel = UserModel.fromJson(response.data);
      } else {
        Toaster.showToast('Something Went Wrong');
      }
    } catch (e) {
      Toaster.showToast('Something Went Wrong $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
