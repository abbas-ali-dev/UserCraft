import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color(0XFFffd21f),
      ),
      body: SizedBox(
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
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/profile_boy.png',
                    fit: BoxFit.cover,
                    width: 180,
                    height: 180,
                  ),
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
                    // text: '${user?.username}"',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
