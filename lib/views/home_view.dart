import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stack_board/flutter_stack_board.dart';
import 'package:stack_board/stack_board_item.dart';
import 'package:stack_board/stack_case.dart';
import 'package:stack_board/stack_items.dart';
import 'package:test_app/controllers/home_controller.dart';
import 'package:test_app/controllers/stack_board_controller.dart';
import 'package:test_app/models/color_stack_item.dart';
import 'package:test_app/widgets/properties_section.dart';
import 'package:test_app/widgets/tool_button.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());
    final stackBoardController = Get.put(StackBoardGetxController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade600,
        centerTitle: true,
        title: const Text("Canvas Task", style: TextStyle(fontSize: 28)),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save_alt,
              color: Colors.white,
            ),
            onPressed: () => homeController.exportAsImage(), // Export image
            tooltip: 'Export as PNG',
          ),
        ],
      ),
      body: Row(
        children: [
          // Tools Sidebar
          Container(
            width: 350,
            color: Colors.blueGrey,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Tools", style: TextStyle(fontSize: 28)),
                const Divider(color: Colors.white),
                const SizedBox(height: 10),
                // First row of tools
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ToolButton(
                      icon: Icons.rectangle_outlined,
                      label: "Rectangle",
                      onTap: () => homeController.addShape(
                        const Size(300, 200),
                        Colors.primaries[
                            Random().nextInt(Colors.primaries.length)],
                        Colors.black,
                      ),
                    ),
                    ToolButton(
                      icon: Icons.square_outlined,
                      label: "Square",
                      onTap: () => homeController.addShape(
                        const Size.square(100),
                        Colors.primaries[
                            Random().nextInt(Colors.primaries.length)],
                        Colors.black,
                      ),
                    ),
                    ToolButton(
                      icon: Icons.line_axis_sharp,
                      label: "Line",
                      onTap: () => homeController.addShape(
                        const Size(300, 2),
                        Colors.primaries[
                            Random().nextInt(Colors.primaries.length)],
                        Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Second row of tools
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ToolButton(
                      icon: Icons.text_fields,
                      label: "Text",
                      onTap: () => homeController.addText(
                          'Hello World', const Size(200, 100)),
                    ),
                    ToolButton(
                      icon: Icons.circle_outlined,
                      label: "Circle",
                      onTap: () => homeController.addShape(
                        const Size.square(100),
                        Colors.blue,
                        Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    ToolButton(
                      icon: Icons.egg_outlined,
                      label: "Ellipse",
                      onTap: () => homeController.addEllipse(),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                // Third row of tools
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ToolButton(
                      icon: Icons.image_outlined,
                      label: "Image",
                      onTap: () => homeController.addImageItem(
                        'https://files.flutter-io.cn/images/branding/flutterlogo/flutter-cn-logo.png',
                      ),
                    ),
                    ToolButton(
                      icon: Icons.star_outline_outlined,
                      label: "Icon",
                      onTap: () => homeController.addShape(
                        const Size.square(100),
                        Colors.transparent,
                        Colors.black,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            double iconSize = min(constraints.maxHeight,
                                    constraints.maxWidth) *
                                0.7;
                            return Icon(
                              Icons.star_outline_outlined,
                              size: iconSize,
                            );
                          },
                        ),
                      ),
                    ),
                    ToolButton(
                      icon: Icons.short_text_outlined,
                      label: "Multi-line\nText",
                      onTap: () => homeController.addText(
                        'This is a multi-line\ntext example.',
                        const Size(200, 150),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Layers Section
                const Text("Layers", style: TextStyle(fontSize: 28)),
                const Divider(color: Colors.white),
                Expanded(
                  child: Obx(
                    () => ListView.builder(
                      itemCount: homeController.layers.length,
                      itemBuilder: (context, index) {
                        final item = homeController.layers[index];
                        return ListTile(
                          title: Text('Layer ${index + 1}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.white),
                            onPressed: () => homeController.removeLayer(item),
                          ),
                          onTap: () {
                            homeController.selectedItem.value.value = item;
                            homeController.selectItemById(item);
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          // StackBoard Area
          Expanded(
            child: Obx(
              () => RepaintBoundary(
                key: homeController.stackBoardKey,
                child: StackBoard(
                  onDel: (item) {
                    homeController.removeLayer(item);
                  },
                  controller: stackBoardController.boardController.value,
                  customBuilder: (StackItem<StackItemContent> item) {
                    if (item is StackTextItem) {
                      return StackTextCase(item: item);
                    } else if (item is StackImageItem) {
                      return StackImageCase(item: item);
                    } else if (item is ColorStackItem) {
                      return Container(
                        width: item.size.width,
                        height: item.size.height,
                        decoration: item.shape != null
                            ? BoxDecoration(
                                color: item.content?.color,
                                shape: item.shape ?? BoxShape.rectangle,
                                border: (item.child == null &&
                                        (item.strokeFlag != null ||
                                            item.strokeFlag!))
                                    ? Border.all(
                                        color: item.strokeColor ??
                                            Colors.transparent,
                                        width: item.strokeWidth ?? 0,
                                      )
                                    : const Border.fromBorderSide(
                                        BorderSide.none),
                              )
                            : const BoxDecoration(),
                        child: item.child,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  background: const ColoredBox(color: Colors.transparent),
                ),
              ),
            ),
          ),
          // Properties Customization Section
          const PropertiesSection(),
        ],
      ),
    );
  }
}
