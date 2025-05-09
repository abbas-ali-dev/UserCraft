import 'package:flutter/material.dart';
import 'package:usercraft/widgets/custom_widgets/custom_detail_row.dart';
import 'package:usercraft/widgets/toaster/toaster.dart';
import 'package:usercraft/model/list_model.dart';

class UserDetailScreen extends StatelessWidget {
  final Datum? user;

  const UserDetailScreen({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'User Details',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0XFFffd21f),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0XFFffd21f),
                    width: 5,
                  ),
                ),
                child: ClipOval(
                  child: Image.network(
                    user?.avatar ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.person, size: 80),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                '${user?.firstName} ${user?.lastName}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, color: Color(0XFFffd21f)),
                  SizedBox(width: 8),
                  Text(
                    user?.email ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      customDetailRow('User ID', '${user?.id}'),
                      Divider(),
                      customDetailRow('First Name', user?.firstName ?? 'N/A'),
                      Divider(),
                      customDetailRow('Last Name', user?.lastName ?? 'N/A'),
                      Divider(),
                      customDetailRow('Email', user?.email ?? 'N/A'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  Toaster.showToast('${user?.firstName} comming soon...');
                },
                icon: Icon(Icons.contact_mail, color: Colors.black),
                label: Text('Contact User'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0XFFffd21f),
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
