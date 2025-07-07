import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nowforecast/app/modules/menu/controllers/menu_controller.dart';

class MenuView extends GetView<MenuControllerNF> {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Locations"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.savedCities.isEmpty) {
          return const Center(child: Text("No locations saved."));
        }

        return ListView.separated(
          itemCount: controller.savedCities.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (context, index) {
            final city = controller.savedCities[index];
            return ListTile(
              title: Text(city),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => controller.removeCity(city),
              ),
              onTap: () {
              
                Get.back(result: city);
              },
            );
          },
        );
      }),
    );
  }
}
