import 'package:fast_app_base/data/memory/vo/todo_status.dart';
import 'package:fast_app_base/data/memory/vo/vo_todo.dart';
import 'package:get/get.dart';

import '../../../screen/dialog/d_confirm.dart';
import '../../../screen/main/write/d_write_todo.dart';

class TodoDataHolder extends GetxController {
  final RxList<Todo> todoList = <Todo>[].obs;


  void changeTodoStatus(Todo todo) async {
    switch (todo.status) {
      case TodoStatus.incomplete:
        todo.status = TodoStatus.ongoing;
      case TodoStatus.ongoing:
        todo.status = TodoStatus.complete;
      case TodoStatus.complete:
        final result = await ConfirmDialog("정말로 처음 상태로 변경하시겠어요?").show();
        result?.runIfSuccess((data) => todo.status = TodoStatus.incomplete);
    }
    todoList.refresh(); // 뷰 갱신
  }

  void addTodo() async {
    final result = await WriteTodoDialog().show();
    //mounted : 현재 WriteTodoDialog 화면이 살아있는지 체크
    if (result != null) {
      todoList.add(Todo( //add 기능에는 refresh 기능이 포함되어 있다.
        id: DateTime.now().millisecondsSinceEpoch, // 현재 시간값
        title: result.text,
        dueDate: result.dateTime,
      ));
    }
  }

  void editTodo(Todo todo) async {
    final result = await WriteTodoDialog(todoForEdit: todo).show();
    if (result != null) {
      todo.title = result.text;
      todo.dueDate = result.dateTime;
      todoList.refresh();
    }
  }

  void removeTodo(Todo todo) async {
    todoList.remove(todo); //삭제
    todoList.refresh();
  }
}

mixin class TodoDataProvider{
  late final TodoDataHolder todoData = Get.find();
}