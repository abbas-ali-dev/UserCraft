import 'package:flutter/material.dart';
import 'package:usercraft/core/api_services/dio_service.dart';
import 'package:usercraft/widgets/toaster/toaster.dart';
import 'package:usercraft/model/list_model.dart';

class HomeScreenProvider extends ChangeNotifier {
  bool isFetchData = false;
  bool isLoading = false;
  bool isLoadingMore = false;
  bool isSearching = false;
  String searchQuery = '';

  bool hasError = false;
  String errorMessage = '';

  int currentPage = 1;
  int totalPages = 0;

  List<Datum> users = [];
  List<Datum> filteredUsers = [];
  late ScrollController scrollController;

  HomeScreenProvider() {
    getApi();
  }

  Future<void> getApi() async {
    isLoading = true;
    isFetchData = false;
    hasError = false;
    errorMessage = '';
    currentPage = 1;
    users = [];
    filteredUsers = [];
    notifyListeners();

    try {
      final response = await NetworkManager().callApi(
        urlEndPoint: 'users?page=$currentPage',
        method: HttpMethod.Get,
      );

      if (response?.statusCode == 200) {
        final listModel = ListModel.fromJson(response?.data);
        users = listModel.data ?? [];
        filteredUsers = List.from(users);
        totalPages = listModel.totalPages ?? 1;

        isFetchData = true;
        Toaster.showToast('Data loaded successfully');
      } else {
        hasError = true;
        errorMessage =
            'Failed to fetch data. Server returned ${response?.statusCode}';
        Toaster.showToast(errorMessage);
      }
    } catch (e) {
      hasError = true;
      errorMessage = 'Network error: ${e.toString()}';
      Toaster.showToast('Something went wrong: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (currentPage >= totalPages || isLoadingMore || isSearching) {
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
        final newUsers = listModel.data ?? [];
        users.addAll(newUsers);

        if (searchQuery.isNotEmpty) {
          filterUsers(searchQuery);
        } else {
          filteredUsers = List.from(users);
        }

        Toaster.showToast('Loaded page $currentPage of $totalPages');
      } else {
        currentPage--;
        hasError = true;
        errorMessage =
            'Failed to load more data. Server returned ${response?.statusCode}';
        Toaster.showToast(errorMessage);
      }
    } catch (e) {
      currentPage--;
      hasError = true;
      errorMessage = 'Network error while loading more data: ${e.toString()}';
      Toaster.showToast('Error loading more data: $e');
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  void filterUsers(String query) {
    searchQuery = query;
    isSearching = query.isNotEmpty;

    if (query.isEmpty) {
      filteredUsers = List.from(users);
    } else {
      filteredUsers = users.where((user) {
        final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
        final email = user.email?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();

        return fullName.contains(searchLower) || email.contains(searchLower);
      }).toList();
    }

    notifyListeners();
  }

  void clearSearch() {
    searchQuery = '';
    isSearching = false;
    filteredUsers = List.from(users);
    notifyListeners();
  }

  Future<void> refreshData() async {
    if (isLoading) return;

    searchQuery = '';
    isSearching = false;
    await getApi();
  }

  void sortUsersByNameAscending() {
    users.sort((a, b) => '${a.firstName} ${a.lastName}'
        .compareTo('${b.firstName} ${b.lastName}'));

    if (isSearching) {
      filteredUsers.sort((a, b) => '${a.firstName} ${a.lastName}'
          .compareTo('${b.firstName} ${b.lastName}'));
    } else {
      filteredUsers = List.from(users);
    }

    notifyListeners();
  }

  void sortUsersByNameDescending() {
    users.sort((a, b) => '${b.firstName} ${b.lastName}'
        .compareTo('${a.firstName} ${a.lastName}'));

    if (isSearching) {
      filteredUsers.sort((a, b) => '${b.firstName} ${b.lastName}'
          .compareTo('${a.firstName} ${a.lastName}'));
    } else {
      filteredUsers = List.from(users);
    }

    notifyListeners();
  }

  Datum? getUserById(int id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> retryConnection() async {
    hasError = false;
    errorMessage = '';
    notifyListeners();
    await getApi();
  }

  bool get hasMorePages => currentPage < totalPages;

  List<Datum> get displayUsers => isSearching ? filteredUsers : users;

  bool get hasSearchResults => !isSearching || filteredUsers.isNotEmpty;

  int get searchResultsCount => filteredUsers.length;
}
