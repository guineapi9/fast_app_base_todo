import 'package:fast_app_base/data/memory/vo/vo_todo.dart';
import 'package:flutter/cupertino.dart';

class TodoDataNotifier extends ValueNotifier<List<Todo>>{
  TodoDataNotifier() : super([]);
  //super([])를 호출하여 초기값으로 빈 List<Todo>를 설정 (ChatGPT)


  void addTodo(Todo todo){
    value.add(todo);
    notifyListeners(); //notifier를 사용하는 곳에 데이터 변경을 알림.
  }

  void notify(){
    notifyListeners();


  } //린트?를 보이지 않게 하기 위해 감싸기
}