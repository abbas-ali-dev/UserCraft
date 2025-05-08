import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usercraft/core/provider/profile_screen_provider.dart';

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
        if (consumer.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: Color(0XFFffd21f),
            ),
          );
        }
        return SizedBox(
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 160,
                width: 160,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: Color(0XFFffd21f),
                  child: consumer.userModel?.data?.avatar != null &&
                          consumer.userModel!.data!.avatar
                              .toString()
                              .startsWith('http')
                      ? ClipOval(
                          child: CachedNetworkImage(
                            imageUrl:
                                consumer.userModel!.data!.avatar.toString(),
                            fit: BoxFit.cover,
                            width: 180,
                            height: 180,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              color: Colors.black,
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              'assets/images/profile_boy.png',
                              fit: BoxFit.cover,
                              width: 180,
                              height: 180,
                            ),
                          ),
                        )
                      : Image.asset(
                          'assets/images/profile_boy.png',
                          fit: BoxFit.cover,
                          width: 180,
                          height: 180,
                        ),
                ),
              ),
              SizedBox(height: 10),
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
