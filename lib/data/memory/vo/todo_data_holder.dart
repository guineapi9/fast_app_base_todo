import 'package:fast_app_base/data/memory/vo/todo_status.dart';
import 'package:fast_app_base/data/memory/vo/vo_todo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../screen/dialog/d_confirm.dart';
import '../../../screen/main/write/d_write_todo.dart';

final todoDataProvider = StateNotifierProvider<TodoDataHolder, List<Todo>>(
    (ref) => TodoDataHolder());

class TodoDataHolder extends StateNotifier<List<Todo>> {

  //비어있는 초기값
  TodoDataHolder() : super([]);

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
    state = List.of(state); //Getx의 Refresh와 동일한 효과
  }

  void addTodo() async {
    final result = await WriteTodoDialog().show();
    //mounted : 현재 WriteTodoDialog 화면이 살아있는지 체크
    if (result != null) {
      state.add(Todo(
        //add 기능에는 refresh 기능이 포함되어 있다.
        id: DateTime.now().millisecondsSinceEpoch, // 현재 시간값
        title: result.text,
        dueDate: result.dateTime,
      ));
      state = List.of(state); //Getx의 Refresh와 동일한 효과
    }
  }

  void editTodo(Todo todo) async {
    final result = await WriteTodoDialog(todoForEdit: todo).show();
    if (result != null) {
      todo.title = result.text;
      todo.dueDate = result.dateTime;
      state = List.of(state); //Getx의 Refresh와 동일한 효과
    }
  }

  void removeTodo(Todo todo) async {
    state.remove(todo); //삭제
    state = List.of(state); //Getx의 Refresh와 동일한 효과
  }
}

extension TodoListHolderProvider on WidgetRef{
  TodoDataHolder get readTodoHolder => read(todoDataProvider.notifier);
}