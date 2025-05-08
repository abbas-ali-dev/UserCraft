import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usercraft/core/provider/home_screen_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<HomeScreenProvider>(context, listen: false);
      if (provider.hasMorePages && !provider.isLoadingMore) {
        provider.loadNextPage();
      }
    }
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
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
        centerTitle: true,
        backgroundColor: Color(0XFFffd21f),
      ),
      body: Consumer<HomeScreenProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0XFFffd21f),
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

          return ListView.builder(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            itemCount: provider.users.length + (provider.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.users.length) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: Color(0XFFffd21f),
                    ),
                  ),
                );
              }

              final user = provider.users[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
                elevation: 4,
                child: ListTile(
                  minVerticalPadding: 20,
                  contentPadding: EdgeInsets.all(8),
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0XFFffd21f),
                    child: ClipOval(
                      child: Image.network(
                        user.avatar ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.person, size: 30),
                      ),
                    ),
                  ),
                  title: Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(user.email ?? ''),
                  trailing: Icon(Icons.arrow_forward_ios, size: 16),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
