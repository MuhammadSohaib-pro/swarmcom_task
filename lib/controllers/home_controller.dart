import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:stack_board/stack_board_item.dart';
import 'package:stack_board/stack_items.dart';
import 'package:test_app/models/color_stack_item.dart';
import 'package:test_app/controllers/stack_board_controller.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:test_app/views/ellipse_painter.dart';

class HomeController extends GetxController {
  final RxList<StackItem> layers =
      <StackItem>[].obs; // Observable list of layers
  final Rx<Color> selectedColor = Colors.blue.obs;
  final Rx<Color> selectedStrokeColor = Colors.black.obs;
  final RxDouble strokeWidth = 2.0.obs;
  final RxBool strokeEnabled = true.obs;
  final GlobalKey stackBoardKey = GlobalKey();
  var selectedItem = Rxn<StackItem<StackItemContent>>().obs;

  final StackBoardGetxController stackBoardController =
      Get.put(StackBoardGetxController());

  /// Adds a shape item (Rectangle, Square, Circle, Ellipse, or Icon)
  void addShape(Size size, Color fillColor, Color strokeColor,
      {BoxShape shape = BoxShape.rectangle, Widget? child}) {
    final item = ColorStackItem(
      size: size,
      content: ColorContent(color: fillColor),
      strokeColor: strokeColor,
      strokeWidth: strokeWidth.value,
      strokeFlag: strokeEnabled.value,
      shape: shape,
      child: child,
    );
    layers.add(item);
    stackBoardController.addItem(item);
    update(['updated']);
  }

  void addEllipse() {
    final item = ColorStackItem(
      size: const Size(150, 100),
      content: ColorContent(color: Colors.green),
      strokeColor: selectedStrokeColor.value,
      strokeWidth: strokeWidth.value,
      strokeFlag: strokeEnabled.value, // Ensure stroke is applied
      child: CustomPaint(
        size: const Size(150, 100),
        painter: EllipsePainter(
          color: Colors.green,
          strokeWidth: strokeWidth.value,
          strokeColor: selectedStrokeColor.value,
        ),
      ),
    );
    layers.add(item);
    stackBoardController.addItem(item);
    update(['updated']);
  }

  /// Adds a text item with adjustable font size
  void addText(String text, Size size) {
    final item = StackTextItem(
      size: size,
      content: TextItemContent(data: text),
    );
    layers.add(item);
    stackBoardController.addItem(item);
    update(['updated']);
  }

  /// Adds an image item
  void addImageItem(String imageUrl) {
    final item = StackImageItem(
      size: const Size(300, 85),
      content: ImageItemContent(url: imageUrl),
    );
    layers.add(item);
    stackBoardController.addItem(item);
    update(['updated']);
  }

  /// Removes an item from both the layers and the board
  void removeLayer(StackItem item) {
    layers.remove(item);
    stackBoardController.removeById(item.id);
    update(['updated']);
  }

  selectItemById(StackItem<StackItemContent> item) {
    if (item is ColorStackItem) {
      if (item.content?.color != null) {
        selectedColor.value =
            item.content?.color ?? const ui.Color.fromARGB(255, 0, 140, 255);
      }
      if (item.strokeColor != null) {
        selectedStrokeColor.value =
            item.strokeColor ?? const ui.Color.fromARGB(255, 0, 0, 0);
      }
    }
    stackBoardController.boardController.value.selectOne(item.id);
    update(['updated']);
  }

  void selectItem(StackItem item) {
    try {
      selectedItem.value.value = item;
      if (item is ColorStackItem) {
        selectedColor.value =
            item.content?.color ?? const ui.Color.fromARGB(255, 0, 140, 255);
        selectedStrokeColor.value =
            item.strokeColor ?? const ui.Color.fromARGB(255, 0, 0, 0);
      }
      update(['updated']);
    } catch (e) {}
  }

  /// Exports the stack board as an image and downloads it as a PNG
  Future<void> exportAsImage() async {
    try {
      RenderRepaintBoundary boundary = stackBoardKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      // Convert the boundary to an image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // Create a Blob for the image
      final blob = html.Blob([pngBytes]);

      // Create a link element and trigger download
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", "stackboard_design.png")
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      print('Error exporting image: $e');
    }
  }

  void updateColor(Color color) {
    selectedColor.value = color;
    if (selectedItem.value.value is ColorStackItem) {
      final updatedItem = (selectedItem.value.value as ColorStackItem).copyWith(
        content: ColorContent(color: color),
        angle: selectedItem.value.value!.angle,
        offset: selectedItem.value.value!.offset,
        size: selectedItem.value.value!.size,
      );
      // Update logic for StackBoard
      selectedItem.value.value = updatedItem;
    }
    stackBoardController.updateItem(selectedItem.value.value!);
    update(['updated']);
  }

  void updateStrokeColor(Color color) {
    selectedStrokeColor.value = color;
    if (selectedItem.value.value is ColorStackItem) {
      final updatedItem = (selectedItem.value.value as ColorStackItem).copyWith(
        strokeColor: color,
        angle: selectedItem.value.value!.angle,
        offset: selectedItem.value.value!.offset,
        size: selectedItem.value.value!.size,
      );
      // Update logic for StackBoard
      selectedItem.value.value = updatedItem;
    }
    stackBoardController.updateItem(selectedItem.value.value!);
    update(['updated']);
  }

  void updateStrokeWidth(double value) {
    strokeWidth.value = value;
    if (selectedItem.value.value is ColorStackItem) {
      final updatedItem = (selectedItem.value.value as ColorStackItem).copyWith(
        strokeWidth: value,
        angle: selectedItem.value.value!.angle,
        offset: selectedItem.value.value!.offset,
        size: selectedItem.value.value!.size,
      );
      // Update logic for StackBoard
      selectedItem.value.value = updatedItem;
    }
    stackBoardController.updateItem(selectedItem.value.value!);
    update(['updated']);
  }

  void toggleStrokeEnabled(bool value) {
    strokeEnabled.value = value;
    if (selectedItem.value.value is ColorStackItem) {
      final updatedItem = (selectedItem.value.value as ColorStackItem).copyWith(
        strokeFlag: value,
        angle: selectedItem.value.value!.angle,
        offset: selectedItem.value.value!.offset,
        size: selectedItem.value.value!.size,
      );
      // Update logic for StackBoard
      selectedItem.value.value = updatedItem;
    }
    stackBoardController.updateItem(selectedItem.value.value!);
    update(['updated']);
  }

  /// Shows a dialog for picking the **fill color**
  void pickFillColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick Fill Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedColor.value,
              onColorChanged: (Color color) {
                selectedColor.value = color;
                if (selectedItem.value.value is ColorStackItem) {
                  final updatedItem =
                      (selectedItem.value.value as ColorStackItem).copyWith(
                    content: ColorContent(color: color), // Update fill color
                  );
                  stackBoardController.updateItem(updatedItem);
                  selectedItem.value.value = updatedItem;
                }
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  /// Shows a dialog for picking the **stroke color**
  void pickStrokeColor(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick Stroke Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: selectedStrokeColor.value,
              onColorChanged: (Color color) {
                selectedStrokeColor.value = color;
                if (selectedItem.value.value is ColorStackItem) {
                  final updatedItem =
                      (selectedItem.value.value as ColorStackItem).copyWith(
                    strokeColor: color, // Update stroke color
                  );
                  stackBoardController.updateItem(updatedItem);
                  selectedItem.value.value = updatedItem;
                }
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Done'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
