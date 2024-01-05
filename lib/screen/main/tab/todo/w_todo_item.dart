import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/dart/extension/datetime_extension.dart';
import 'package:fast_app_base/common/widget/w_rounded_container.dart';
import 'package:fast_app_base/screen/main/tab/todo/w_todo_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/memory/vo/vo_todo.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;

  const TodoItem(this.todo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Dismissible( //Swipe해서 지울 수 있는 기능
      //지울 때 뒤에 쓰레기통이 나오도록 RoundContainer 생성
      background: RoundedContainer(
        color: context.appColors.removeTodoBg,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Width(20),
            Icon(
              EvaIcons.trash2Outline,
              color: Colors.white,
            ),
          ],
        ),
      ),
      secondaryBackground: RoundedContainer(
        color: context.appColors.removeTodoBg,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(
              EvaIcons.trash2Outline,
              color: Colors.white,
            ),
            Width(20),
          ],
        ),
      ),
      onDismissed: (Direction){ //실제로 지우는 것이 필요
        context.holder.removeTodo(todo);
      },
      key: ValueKey(todo.id),
      child: RoundedContainer(
        margin: const EdgeInsets.only(bottom: 6),
        color: context.appColors.itemBackground, //
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          todo.dueDate.relativeDays.text.make(),
          Row(
            children: [
              TodoStatusWidget(todo), //체크박스
              Expanded(
                child: todo.title.text.size(20).medium.make(),
              ),
              IconButton( //수정버튼
                onPressed: () async {
                  context.holder.editTodo(todo);
                },
                icon: const Icon(EvaIcons.editOutline),
              ),
            ],
          ),
        ],
      ).pOnly(top: 15,right: 15,left: 5,bottom: 10)),
    );
  }
}
