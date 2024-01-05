import 'package:fast_app_base/data/memory/vo/todo_status.dart';

class Todo {
  int id;
  String title;
  final DateTime createdTime;
  DateTime? modifyTime;
  DateTime dueDate;
  TodoStatus status;

  Todo({
    required this.id,
    required this.title,
    this.modifyTime,
    required this.dueDate,
    this.status = TodoStatus.incomplete,
}):createdTime = DateTime.now();
  //생성자 호출과 무관하게 객체가 생성될 때 현재 시간으로 초기화 (ChatGPT)
}