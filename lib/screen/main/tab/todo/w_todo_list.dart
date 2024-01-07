import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/data/memory/bloc/todo_bloc_state.dart';
import 'package:fast_app_base/screen/main/tab/todo/w_todo_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//상태가 필요없으므로 statelessWidget 선언
class TodoList extends StatelessWidget{
  const TodoList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TodoBloc, TodoBlocState>(builder: (context, state){
      return state.todoList.isEmpty
          ? "할 일을 작성해 보세요.".text.size(30).makeCentered()
          : Column(
          children: state.todoList.map((e) => TodoItem(e)).toList()
      );
    });
  }
}
