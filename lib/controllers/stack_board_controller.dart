import 'package:get/get.dart';
import 'package:stack_board/flutter_stack_board.dart';
import 'package:stack_board/stack_board_item.dart';

class StackBoardGetxController extends GetxController {
  final Rx<StackBoardController> boardController = StackBoardController().obs;

  /// Adds an item to the board
  void addItem(StackItem item) {
    boardController.value.addItem(item);
  }

  /// Updates an item on the board
  void updateItem(StackItem item) {
    boardController.value.updateItem(item);
  }

  /// Removes an item from the board by ID
  void removeById(String id) {
    boardController.value.removeById(id);
  }

  /// Selects an item on the board by ID
  void selectItemOnBoard(String id) {
    boardController.value.selectOne(id);
  }
}
