import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stack_board/stack_items.dart';
import 'package:test_app/controllers/home_controller.dart';

class PropertiesSection extends StatelessWidget {
  const PropertiesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Obx(
      () => controller.selectedItem.value.value != null
          ? Container(
              width: 300,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Properties",
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(height: 20),
                  (controller.selectedItem.value.value is! StackTextItem &&
                          controller.selectedItem.value.value
                              is! StackImageItem)
                      ? const Text("Fill Color")
                      : const SizedBox(),
                  (controller.selectedItem.value.value is! StackTextItem &&
                          controller.selectedItem.value.value
                              is! StackImageItem)
                      ? GestureDetector(
                          onTap: () => controller.pickFillColor(context),
                          child: Container(
                            width: 100,
                            height: 40,
                            color: controller.selectedColor.value,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 20),
                  (controller.selectedItem.value.value is! StackTextItem &&
                          controller.selectedItem.value.value
                              is! StackImageItem)
                      ? const Text("Stroke Color")
                      : const SizedBox(),
                  (controller.selectedItem.value.value is! StackTextItem &&
                          controller.selectedItem.value.value
                              is! StackImageItem)
                      ? GestureDetector(
                          onTap: () => controller.pickStrokeColor(context),
                          child: Container(
                            width: 100,
                            height: 40,
                            color: controller.selectedStrokeColor.value,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 20),
                  (controller.selectedItem.value.value is! StackTextItem &&
                          controller.selectedItem.value.value
                              is! StackImageItem)
                      ? const Text("Stroke Width")
                      : const SizedBox(),
                  (controller.selectedItem.value.value is! StackTextItem &&
                          controller.selectedItem.value.value
                              is! StackImageItem)
                      ? Slider(
                          value: controller.strokeWidth.value,
                          min: 1.0,
                          max: 10.0,
                          onChanged: (value) =>
                              controller.updateStrokeWidth(value),
                        )
                      : const SizedBox(),
                ],
              ),
            )
          : const SizedBox(
              width: 300,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Select an item from \nlayers to customize",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
    );
  }
}
