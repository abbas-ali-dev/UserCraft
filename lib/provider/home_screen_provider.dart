import 'package:flutter/material.dart';
import 'package:usercraft/core/api_services/dio_service.dart';
import 'package:usercraft/widgets/toaster/toaster.dart';
import 'package:usercraft/model/list_model.dart';

/// HomeScreenProvider is responsible for managing the state and business logic
/// for the home screen of the application. It handles API calls, data processing,
/// search functionality, and pagination.
class HomeScreenProvider extends ChangeNotifier {
  // State flags for UI rendering
  bool isFetchData = false; // Indicates if data has been fetched at least once
  bool isLoading = false; // Indicates if initial data is being loaded
  bool isLoadingMore =
      false; // Indicates if more data is being loaded (pagination)
  bool isSearching = false; // Indicates if search is active
  String searchQuery = ''; // Current search query text

  // Error handling properties
  bool hasError = false; // Indicates if there's an error
  String errorMessage = ''; // Stores the error message to display

  // Pagination properties
  int currentPage = 1; // Current page being displayed
  int totalPages = 0; // Total number of pages available

  // Data storage
  List<Datum> users = []; // All users fetched from API
  List<Datum> filteredUsers = []; // Users filtered by search query
  late ScrollController scrollController; // Controller for scroll events

  /// Constructor initializes the provider and fetches initial data
  HomeScreenProvider() {
    getApi();
  }

  /// Fetches user data from the API
  /// Resets all state variables and starts a fresh data load
  Future<void> getApi() async {
    // Set loading state and reset variables
    isLoading = true;
    isFetchData = false;
    hasError = false;
    errorMessage = '';
    currentPage = 1;
    users = [];
    filteredUsers = [];
    notifyListeners();

    try {
      // Make API call to fetch users
      final response = await NetworkManager().callApi(
        urlEndPoint: 'users?page=$currentPage',
        method: HttpMethod.Get,
      );

      // Process successful response
      if (response?.statusCode == 200) {
        final listModel = ListModel.fromJson(response?.data);
        users = listModel.data ?? [];
        filteredUsers = List.from(users);
        totalPages = listModel.totalPages ?? 1;

        isFetchData = true;
        Toaster.showToast('Data loaded successfully');
      } else {
        // Handle API error (non-200 response)
        hasError = true;
        errorMessage =
            'Failed to fetch data. Server returned ${response?.statusCode}';
        Toaster.showToast(errorMessage);
      }
    } catch (e) {
      // Handle network or other exceptions
      hasError = true;
      errorMessage = 'Network error: ${e.toString()}';
      Toaster.showToast('Something went wrong: $e');
    } finally {
      // Update UI regardless of success or failure
      isLoading = false;
      notifyListeners();
    }
  }

  /// Loads the next page of user data when scrolling
  /// Implements pagination by incrementing the page number
  Future<void> loadNextPage() async {
    // Skip if already at last page, already loading, or in search mode
    if (currentPage >= totalPages || isLoadingMore || isSearching) {
      return;
    }

    isLoadingMore = true;
    notifyListeners();

    try {
      // Increment page and fetch next page data
      currentPage++;
      final response = await NetworkManager().callApi(
        urlEndPoint: 'users?page=$currentPage',
        method: HttpMethod.Get,
      );

      if (response?.statusCode == 200) {
        // Process successful response
        final listModel = ListModel.fromJson(response?.data);
        final newUsers = listModel.data ?? [];
        users.addAll(newUsers);

        // Update filtered users based on search state
        if (searchQuery.isNotEmpty) {
          filterUsers(searchQuery);
        } else {
          filteredUsers = List.from(users);
        }

        Toaster.showToast('Loaded page $currentPage of $totalPages');
      } else {
        // Handle API error
        currentPage--; // Revert page increment
        hasError = true;
        errorMessage =
            'Failed to load more data. Server returned ${response?.statusCode}';
        Toaster.showToast(errorMessage);
      }
    } catch (e) {
      // Handle network or other exceptions
      currentPage--; // Revert page increment
      hasError = true;
      errorMessage = 'Network error while loading more data: ${e.toString()}';
      Toaster.showToast('Error loading more data: $e');
    } finally {
      // Update UI regardless of success or failure
      isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Filters the user list based on search query
  /// Searches in both name and email fields
  void filterUsers(String query) {
    searchQuery = query;
    isSearching = query.isNotEmpty;

    if (query.isEmpty) {
      // If query is empty, show all users
      filteredUsers = List.from(users);
    } else {
      // Filter users by name or email
      filteredUsers = users.where((user) {
        final fullName = '${user.firstName} ${user.lastName}'.toLowerCase();
        final email = user.email?.toLowerCase() ?? '';
        final searchLower = query.toLowerCase();

        return fullName.contains(searchLower) || email.contains(searchLower);
      }).toList();
    }

    notifyListeners();
  }

  /// Clears the search query and resets to showing all users
  void clearSearch() {
    searchQuery = '';
    isSearching = false;
    filteredUsers = List.from(users);
    notifyListeners();
  }

  /// Refreshes all data by fetching from API again
  /// Used for pull-to-refresh functionality
  Future<void> refreshData() async {
    if (isLoading) return;

    searchQuery = '';
    isSearching = false;
    await getApi();
  }

  /// Sorts users by name in ascending order (A-Z)
  void sortUsersByNameAscending() {
    users.sort((a, b) => '${a.firstName} ${a.lastName}'
        .compareTo('${b.firstName} ${b.lastName}'));

    if (isSearching) {
      // Sort only filtered users if in search mode
      filteredUsers.sort((a, b) => '${a.firstName} ${a.lastName}'
          .compareTo('${b.firstName} ${b.lastName}'));
    } else {
      // Update filtered users to match sorted users
      filteredUsers = List.from(users);
    }

    notifyListeners();
  }

  /// Sorts users by name in descending order (Z-A)
  void sortUsersByNameDescending() {
    users.sort((a, b) => '${b.firstName} ${b.lastName}'
        .compareTo('${a.firstName} ${a.lastName}'));

    if (isSearching) {
      // Sort only filtered users if in search mode
      filteredUsers.sort((a, b) => '${b.firstName} ${b.lastName}'
          .compareTo('${a.firstName} ${a.lastName}'));
    } else {
      // Update filtered users to match sorted users
      filteredUsers = List.from(users);
    }

    notifyListeners();
  }

  /// Finds and returns a user by their ID
  /// Returns null if user not found
  Datum? getUserById(int id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Retries connection after an error
  /// Resets error state and attempts to fetch data again
  Future<void> retryConnection() async {
    hasError = false;
    errorMessage = '';
    notifyListeners();
    await getApi();
  }

  /// Checks if there are more pages to load
  bool get hasMorePages => currentPage < totalPages;

  /// Returns the appropriate user list based on search state
  List<Datum> get displayUsers => isSearching ? filteredUsers : users;

  /// Checks if there are search results to display
  bool get hasSearchResults => !isSearching || filteredUsers.isNotEmpty;

  /// Returns the count of search results
  int get searchResultsCount => filteredUsers.length;
}
