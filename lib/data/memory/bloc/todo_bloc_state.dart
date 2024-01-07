import 'package:fast_app_base/data/memory/bloc/bloc_status.dart';
import 'package:fast_app_base/data/memory/vo_todo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_bloc_state.freezed.dart'; //TodoBlocState을 생성해주는 문구
//flutter pub run build_runner build

// @freezed 어노테이션은 불변 클래스를 생성하도록 지시합니다. TodoBlocState 클래스의 경우, freezed 패키지가 생성한 코드의 일부입니다.
//freezed 패키지를 사용하면 불변한(immutable) 데이터 클래스를 쉽게 생성할 수 있으며, 생성된 클래스에는 불변성을 유지하기 위한 여러 기능들이 내장되어 있습니다.
// from Chat GPT

//bloc state를 제대로 사용하려면 스스로를 복사할 수 있는 copywith가 필요한데
//이 번거로움을 줄여주는 것이 freezed 패키지를 사용하는 것이 좋다
@freezed
class TodoBlocState with _$TodoBlocState{
  const factory TodoBlocState(
      BlocStatus status,
      List<Todo> todoList,
      ) = _TodoBlocState;

}