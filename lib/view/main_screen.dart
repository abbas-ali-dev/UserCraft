import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/main_screen_controller.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MainScreenController controller = MainScreenController();
    return Scaffold(
      body: Obx(() => controller.isFetchData.value == false
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
              })),
    );
  }
}
