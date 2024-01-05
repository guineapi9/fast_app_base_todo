import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/tab/todo/w_todo_item.dart';
import 'package:flutter/material.dart';

//상태관리는 Holder가, 데이터를 들고 있는 것은 Notifier가. 그러므로 이곳에서는
//상태가 필요없으므로 statelessWidget 선언
class TodoList extends StatelessWidget {
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.holder.notifier,
      builder: (context, todoList, child) { //valueListenable 값 = todoList
        return todoList.isEmpty ? "할 일을 작성해 보세요.".text.size(30).makeCentered() :
        Column(
          children: todoList.map((e) => TodoItem(e)).toList()
        );
      },
    );
  }
}
