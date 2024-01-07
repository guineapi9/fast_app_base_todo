import 'package:fast_app_base/data/memory/bloc/bloc_status.dart';
import 'package:fast_app_base/data/memory/bloc/todo_bloc_state.dart';
import 'package:fast_app_base/data/memory/bloc/todo_event.dart';
import 'package:fast_app_base/data/memory/todo_status.dart';
import 'package:fast_app_base/data/memory/vo_todo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../screen/dialog/d_confirm.dart';
import '../../screen/main/write/d_write_todo.dart';

class TodoBloc extends Bloc<TodoEvent,TodoBlocState> {
  //최초 생성자. 비어있는 Todo 리스트
  TodoBloc() : super(const TodoBlocState(BlocStatus.initial, <Todo>[])){
    //Listening 함수
    on<TodoAddEvent>(_addTodo);
    on<TodoStatusUpdateEvent>(_changeTodoStatus);
    on<TodoContentUpdateEvent>(_editTodo);
    on<TodoRemovedEvent>(_removeTodo);
  }

  void _addTodo(TodoAddEvent event, Emitter<TodoBlocState> emit) async {
    final result = await WriteTodoDialog().show();
    if (result != null) {
      //List.of()는 기존 리스트의 요소들을 포함하는 새로운 리스트를 생성하는 메서드입니다.
      // 이 메서드를 사용하면 원래 리스트를 변경하지 않으면서 새로운 리스트를 만들 수 있습니다.
      //state.todoList를 직접 수정하지 않고 새로운 상태를 만들어야 하기 때문입니다.
      // Flutter와 Bloc 패턴에서 상태는 불변성을 유지해야 하므로,
      // 새로운 상태를 만들 때에는 기존 상태를 직접 수정하는 것이 아니라 복사본을 만들어서 사용하는 것이 권장됩니다.
      // from ChatGPT

      //Bloc에서는 todoList에 직접 데이터 add 가 불가능해서 다음과 같이 감싼 후 add한다.
      final copiedOldTodoList = List.of(state.todoList);
      copiedOldTodoList.add(Todo(
        id: DateTime.now().millisecondsSinceEpoch,
        title: result.text,
        dueDate: result.dateTime,
        status: TodoStatus.incomplete,
        createdTime: DateTime.now(),
      ));
      //State를 Copy 후 새로 바뀐 todoList를 보낸다.
      emitNewList(copiedOldTodoList, emit);
    }
  }

  void _changeTodoStatus(TodoStatusUpdateEvent event, Emitter<TodoBlocState> emit) async {
    final copiedOldTodoList = List.of(state.todoList);
    final todo = event.updateTodo;
    final todoIndex =
        copiedOldTodoList.indexWhere((element) => element.id == todo.id);

    TodoStatus status = todo.status; //todo가 getter로 변화하여 바로 변화가 불가능함.
    switch (todo.status) {
      case TodoStatus.incomplete:
        status = TodoStatus.ongoing;
      case TodoStatus.ongoing:
        status = TodoStatus.complete;
      case TodoStatus.complete:
        final result = await ConfirmDialog("정말로 처음 상태로 변경하시겠어요?").show();
        result?.runIfSuccess((data) => status = TodoStatus.incomplete);
    }
    //동일한 인덱스 숫자에 todo를 덮어쓰기
    copiedOldTodoList[todoIndex] = todo.copyWith(status: status);
    //State를 Copy 후 새로 바뀐 todoList를 보낸다.
    emitNewList(copiedOldTodoList, emit);
  }

  void _editTodo(TodoContentUpdateEvent event, Emitter<TodoBlocState> emit) async {
    final todo = event.updateTodo;
    final result = await WriteTodoDialog(todoForEdit: todo).show();
    if (result != null) {
      //동일한 인덱스 숫자에 todo를 덮어쓰기
      final oldCopiedList = List<Todo>.from(state.todoList);
      oldCopiedList[oldCopiedList.indexOf(todo)] = todo.copyWith(
        title: result.text,
        dueDate: result.dateTime,
        modifyTime: DateTime.now(),
      );
      //State를 Copy 후 새로 바뀐 todoList를 보낸다.
      emitNewList(oldCopiedList, emit);
    }
  }

  void _removeTodo(TodoRemovedEvent event, Emitter<TodoBlocState> emit) async {
    final oldCopiedList = List<Todo>.from(state.todoList);

    final todo = event.removedTodo;
    //삭제할 todo의 id 찾기
    oldCopiedList.removeWhere((element) => element.id == todo.id);

    //State를 Copy 후 새로 바뀐 todoList를 보낸다.
    emitNewList(oldCopiedList, emit);
  }

  void emitNewList(List<Todo> oldCopiedList, Emitter<TodoBlocState> emit) =>
      emit(state.copyWith(todoList: oldCopiedList));
}

mixin class TodoDataProvider {
  late final TodoBloc todoData = Get.find();
}
