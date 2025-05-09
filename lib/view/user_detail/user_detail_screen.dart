import 'package:flutter/material.dart';
import 'package:usercraft/widgets/custom_widgets/custom_detail_row.dart';
import 'package:usercraft/widgets/toaster/toaster.dart';
import 'package:usercraft/model/list_model.dart';

/// UserDetailScreen displays detailed information about a specific user.
/// It shows the user's avatar, name, email, and other details in a structured format.
/// This screen is typically navigated to from the HomeScreen when a user is selected.
class UserDetailScreen extends StatelessWidget {
  /// The user data to display in the detail view
  final Datum? user;

  /// Constructor requires user data that will be displayed
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
        // Back button to return to previous screen
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
              // User avatar with circular yellow border
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
                  // Display user avatar or fallback icon if image fails to load
                  child: Image.network(
                    user?.avatar ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        Icon(Icons.person, size: 80),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // User's full name in large bold text
              Text(
                '${user?.firstName} ${user?.lastName}',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              // User's email with icon
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
              // Card containing detailed user information
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      // Structured display of user details with labels and values
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
              // Contact button with toast message (placeholder functionality)
              ElevatedButton.icon(
                onPressed: () {
                  // Show toast message indicating feature is coming soon
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
