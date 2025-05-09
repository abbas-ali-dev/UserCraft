import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usercraft/provider/profile_screen_provider.dart';

/// ProfileScreen displays the user's profile information including their avatar,
/// name, and email. It fetches data using the ProfileScreenProvider and displays
/// a loading indicator while data is being loaded.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile Screen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0XFFffd21f),
      ),
      body:
          Consumer<ProfileScreenProvider>(builder: (context, consumer, child) {
        // Display loading indicator while data is being fetched
        if (consumer.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0XFFffd21f),
            ),
          );
        }

        // Display profile information once data is loaded
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile avatar with circular border
              Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0XFFffd21f),
                    width: 5,
                  ),
                ),
                child: consumer.userModel?.data?.avatar != null &&
                        consumer.userModel!.data!.avatar
                            .toString()
                            .startsWith('http')
                    ? ClipOval(
                        // Display network image if avatar URL is valid
                        child: CachedNetworkImage(
                          imageUrl: consumer.userModel!.data!.avatar.toString(),
                          fit: BoxFit.cover,
                          width: 180,
                          height: 180,
                          // Show loading indicator while image is loading
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            color: Colors.black,
                          ),
                          // Show fallback image if error occurs
                          errorWidget: (context, url, error) => Image.asset(
                            'assets/images/profile_boy.png',
                            fit: BoxFit.cover,
                            width: 180,
                            height: 180,
                          ),
                        ),
                      )
                    : // Display default image if no valid avatar URL
                    Image.asset(
                        'assets/images/profile_boy.png',
                        fit: BoxFit.cover,
                        width: 180,
                        height: 180,
                      ),
              ),
              SizedBox(height: 10),
              // User name with styled text
              RichText(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                text: TextSpan(
                  style: TextStyle(fontSize: 25),
                  children: <TextSpan>[
                    TextSpan(
                        text: '"Hey, ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0XFFffd21f),
                        )),
                    TextSpan(
                      text:
                          '${consumer.userModel?.data?.firstName} ${consumer.userModel?.data?.lastName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 10),
              // User email with subtle styling
              Text(
                '${consumer.userModel?.data?.email}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
