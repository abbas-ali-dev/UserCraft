import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/home_screen_provider.dart';

void customSortOptions(BuildContext context) {
  final provider = Provider.of<HomeScreenProvider>(context, listen: false);

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Sort Users',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.arrow_upward, color: Color(0XFFffd21f)),
              title: Text('Name (A-Z)'),
              onTap: () {
                provider.sortUsersByNameAscending();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.arrow_downward, color: Color(0XFFffd21f)),
              title: Text('Name (Z-A)'),
              onTap: () {
                provider.sortUsersByNameDescending();
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
