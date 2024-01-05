import 'package:fast_app_base/data/memory/vo/todo_data_notifier.dart';
import 'package:fast_app_base/data/memory/vo/todo_status.dart';
import 'package:fast_app_base/data/memory/vo/vo_todo.dart';
import 'package:flutter/cupertino.dart';
import 'package:nav/dialog/dialog.dart';

import '../../../screen/dialog/d_confirm.dart';
import '../../../screen/main/write/d_write_todo.dart';

class TodoDataHolder extends InheritedWidget {
  final TodoDataNotifier notifier;

  const TodoDataHolder({
    super.key,
    required super.child,
    required this.notifier,
  });

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  static TodoDataHolder _of(BuildContext context) {
    TodoDataHolder inherited =
        (context.dependOnInheritedWidgetOfExactType<TodoDataHolder>())!;
    //"depend...Type"함수 : 위젯에 있는 TodoDataHolder를 찾아주는 함수.
    return inherited;
  }

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
    notifier.notify(); // 뷰 갱신
  }

  void addTodo() async {
    final result = await WriteTodoDialog().show();
    //mounted : 현재 WriteTodoDialog 화면이 살아있는지 체크
    if (result != null) {
      notifier.addTodo(Todo(
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
      notifier.notify();
    }
  }

  void removeTodo(Todo todo) async {
    notifier.value.remove(todo); //삭제
    notifier.notify();
  }
}

extension TodoDataHolderContextExtension on BuildContext {
  TodoDataHolder get holder => TodoDataHolder._of(this);
}
