import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:usercraft/core/provider/main_screen_provider.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<MainScreenProvider>(context, listen: true);
    return Scaffold(
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
