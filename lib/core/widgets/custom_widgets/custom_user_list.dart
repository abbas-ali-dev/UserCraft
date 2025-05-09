import 'package:flutter/material.dart';
import 'package:usercraft/core/provider/home_screen_provider.dart';
import 'package:usercraft/view/user_detail/user_detail_screen.dart';

Widget customUserList(HomeScreenProvider provider, BuildContext context) {
  final displayUsers = provider.displayUsers;
  final scrollController = provider.scrollController;

  return ListView.builder(
    controller: scrollController,
    physics: BouncingScrollPhysics(),
    itemCount: displayUsers.length +
        (provider.isLoadingMore && !provider.isSearching ? 1 : 0),
    itemBuilder: (context, index) {
      if (index == displayUsers.length) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              color: Color(0XFFffd21f),
            ),
          ),
        );
      }

      final user = displayUsers[index];
      return Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.all(12),
          leading: Hero(
            tag: 'avatar-${user.id}',
            child: CircleAvatar(
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
          ),
          title: Text(
            '${user.firstName} ${user.lastName}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(user.email ?? ''),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailScreen(user: user),
              ),
            );
          },
        ),
      );
    },
  );
}
