import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/tab/todo/w_todo_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

//상태관리는 Holder가, 데이터를 들고 있는 것은 Notifier가. 그러므로 이곳에서는
//상태가 필요없으므로 statelessWidget 선언
class TodoList extends StatelessWidget with TodoDataProvider {
  TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
    todoData.todoList.isEmpty
        ? "할 일을 작성해 보세요.".text.size(30).makeCentered()
        : Column(
        children: todoData.todoList.map((e) => TodoItem(e)).toList()
    )
    );
  }
}
