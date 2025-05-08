import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usercraft/core/provider/home_screen_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<HomeScreenProvider>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Screen',
          style: TextStyle(fontWeight: FontWeight.bold),
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
                onPressed: () async {
                  await controller.getApi();
                },
                child: Text('Hit me'),
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: controller.responceModel.length,
              itemBuilder: (context, index) {
                final data = controller.responceModel[index];
                return ListTile(
                  leading: Text(data.userId.toString()),
                  title: Text(data.title.toString()),
                  subtitle: Text(data.body.toString()),
                );
              },
            ),
    );
  }
}
