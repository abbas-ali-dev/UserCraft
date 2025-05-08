import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usercraft/core/provider/home_screen_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeScreenProvider>(context, listen: true);
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
      body: controller.isFetchData == false
          ? Center(
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
                  await controller.getApi();
                },
                child: Text('Fetch UserCraft Data'),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: controller.responceModel.length,
              itemBuilder: (context, index) {
                final data = controller.responceDatum[index];
                return ListTile(
                  leading: Text(data.avatar.toString()),
                  title: Text(
                      '${data.firstName.toString()} ${data.lastName.toString()}'),
                  subtitle: Text(data.email.toString()),
                );
              },
            ),
    );
  }
}
