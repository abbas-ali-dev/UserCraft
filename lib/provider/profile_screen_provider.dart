import 'package:flutter/material.dart';
import 'package:usercraft/core/api_services/dio_service.dart';
import 'package:usercraft/core/api_services/end_points.dart';
import 'package:usercraft/widgets/toaster/toaster.dart';
import 'package:usercraft/model/profile_model.dart';

/// ProfileScreenProvider is responsible for managing the state and business logic
/// for the profile screen of the application. It handles fetching user profile data
/// from the API and maintaining the loading state.
class ProfileScreenProvider extends ChangeNotifier {
  /// Stores the user profile data fetched from the API
  ProfileModel? userModel;

  /// Indicates whether profile data is currently being loaded
  bool isLoading = true;

  /// Fetches the user profile data from the API
  ///
  /// Makes a GET request to the profile endpoint and updates the userModel
  /// with the response data. Handles errors and updates the loading state.
  Future<void> fetchProfile() async {
    try {
      // Make API call to fetch profile data
      final response = await NetworkManager().callApi(
        urlEndPoint: EndPoints.profile,
        method: HttpMethod.Get,
      );

      // Process successful response
      if (response != null && response.statusCode == 200) {
        // Parse the response data into ProfileModel
        userModel = ProfileModel.fromJson(response.data);
      } else {
        // Handle API error (non-200 response)
        Toaster.showToast('Something Went Wrong');
      }
    } catch (e) {
      // Handle network or other exceptions
      Toaster.showToast('Something Went Wrong $e');
    } finally {
      // Update loading state and notify listeners regardless of success or failure
      isLoading = false;
      notifyListeners();
    }
  }
}
