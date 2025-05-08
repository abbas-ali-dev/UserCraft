import 'package:flutter/material.dart';
import 'package:usercraft/core/api/dio_service.dart';
import 'package:usercraft/core/widgets/toaster/toaster.dart';
import 'package:usercraft/model/list_model.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool isFetchData = false;
  bool isLoading = false;
  bool isLoadingMore = false;
  int currentPage = 1;
  int totalPages = 0;
  List<Datum> users = [];

  HomeScreenProvider() {
    getApi();
  }

  Future<void> getApi() async {
    isLoading = true;
    isFetchData = false;
    currentPage = 1;
    users = [];
    notifyListeners();

    try {
      final response = await NetworkManager().callApi(
        urlEndPoint: 'users?page=$currentPage',
        method: HttpMethod.Get,
      );

      if (response?.statusCode == 200) {
        final listModel = ListModel.fromJson(response?.data);
        users = listModel.data ?? [];
        totalPages = listModel.totalPages ?? 1;

        isFetchData = true;
      } else {
        Toaster.showToast('Failed to fetch data');
      }
    } catch (e) {
      Toaster.showToast('Something Went Wrong: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (currentPage >= totalPages || isLoadingMore) {
      return;
    }

    isLoadingMore = true;
    notifyListeners();

    try {
      currentPage++;
      final response = await NetworkManager().callApi(
        urlEndPoint: 'users?page=$currentPage',
        method: HttpMethod.Get,
      );

      if (response?.statusCode == 200) {
        final listModel = ListModel.fromJson(response?.data);
        users.addAll(listModel.data ?? []);
      } else {
        currentPage--;
        Toaster.showToast('Failed to load more data');
      }
    } catch (e) {
      currentPage--;
      Toaster.showToast('Error loading more data: $e');
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  bool get hasMorePages => currentPage < totalPages;
}
