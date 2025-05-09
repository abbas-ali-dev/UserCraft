// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usercraft/provider/home_screen_provider.dart';
import 'package:usercraft/widgets/custom_widgets/custom_user_list.dart';
import 'package:usercraft/widgets/custom_widgets/custom_sort_option.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearchVisible = false;

  @override
  void initState() {
    super.initState();
    final controller = Provider.of<HomeScreenProvider>(context, listen: false);
    controller.scrollController = ScrollController();
    controller.scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    final controller = Provider.of<HomeScreenProvider>(context, listen: false);
    controller.scrollController.removeListener(_scrollListener);
    controller.scrollController.dispose();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _scrollListener() {
    final controller = Provider.of<HomeScreenProvider>(context, listen: false);
    if (controller.scrollController.position.pixels >=
        controller.scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<HomeScreenProvider>(context, listen: false);
      if (provider.hasMorePages &&
          !provider.isLoadingMore &&
          !provider.isSearching) {
        provider.loadNextPage();
      }
    }
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
      if (!_isSearchVisible) {
        _searchController.clear();
        Provider.of<HomeScreenProvider>(context, listen: false).clearSearch();
      } else {
        _searchFocusNode.requestFocus();
      }
    });
  }

  void _clearSearch() {
    _searchController.clear();
    Provider.of<HomeScreenProvider>(context, listen: false).clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Home Screen',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0XFFffd21f),
        actions: [
          IconButton(
            icon: Icon(Icons.sort, color: Colors.black),
            onPressed: () {
              customSortOptions(context);
            },
          ),
          IconButton(
            icon: Icon(
              _isSearchVisible ? Icons.close : Icons.search,
              color: Colors.black,
            ),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isSearchVisible)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                      border: Border.all(
                        color: Color(0XFFffd21f),
                        width: 2,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      decoration: InputDecoration(
                        hintText: 'Search by name or email...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0XFFffd21f),
                        ),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(
                                  Icons.clear,
                                  color: Color(0XFFffd21f),
                                ),
                                onPressed: _clearSearch,
                              )
                            : null,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {});
                        Provider.of<HomeScreenProvider>(context, listen: false)
                            .filterUsers(value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Consumer<HomeScreenProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Color(0XFFffd21f),
                    ),
                  );
                }

                if (provider.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 80,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Text(
                            provider.errorMessage,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red[700],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () => provider.retryConnection(),
                          icon: Icon(Icons.refresh),
                          label: Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0XFFffd21f),
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (!provider.isFetchData) {
                  return Center(
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(
                          Color(0XFFffd21f),
                        ),
                        foregroundColor: WidgetStateProperty.all(
                          Colors.black,
                        ),
                      ),
                      onPressed: () async {
                        await provider.getApi();
                      },
                      child: Text('Fetch UserCraft Data'),
                    ),
                  );
                }

                if (provider.isSearching) {
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        color: Colors.grey[200],
                        child: Text(
                          'Found ${provider.searchResultsCount} results',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (provider.filteredUsers.isEmpty)
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No results found for "${provider.searchQuery}"',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 24),
                                ElevatedButton.icon(
                                  onPressed: _clearSearch,
                                  icon: Icon(
                                    Icons.refresh,
                                    color: Colors.black,
                                  ),
                                  label: Text('Clear Search'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0XFFffd21f),
                                    foregroundColor: Colors.black,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        Expanded(
                          child: customUserList(provider, context),
                        ),
                    ],
                  );
                }

                return RefreshIndicator(
                  onRefresh: provider.refreshData,
                  color: Color(0XFFffd21f),
                  child: customUserList(provider, context),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
