import 'package:after_layout/after_layout.dart';
import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/common/dart/extension/datetime_extension.dart';
import 'package:fast_app_base/common/util/app_keyboard_util.dart';
import 'package:fast_app_base/common/widget/scaffold/bottom_dialog_scaffold.dart';
import 'package:fast_app_base/common/widget/w_round_button.dart';
import 'package:fast_app_base/screen/main/write/vo_write_todo_result.dart';
import 'package:flutter/material.dart';
import 'package:nav/dialog/dialog.dart';

import '../../../common/widget/w_rounded_container.dart';
import '../../../data/memory/vo/vo_todo.dart';

class WriteTodoDialog extends DialogWidget<WriteTodoResult> {
  final Todo? todoForEdit;

  WriteTodoDialog({this.todoForEdit ,super.key});

  @override
  DialogState<WriteTodoDialog> createState() => _WriteTodoDialogState();
}

class _WriteTodoDialogState extends DialogState<WriteTodoDialog>
    with AfterLayoutMixin {
  //바로 키보드가 뜨게 하기 위해 믹스인 사용
  DateTime _selectedDate = DateTime.now(); //변할 수 있기 때문에 final 선언 안함
  final textController = TextEditingController();
  final node = FocusNode();

  //수정시에 적용
  @override
  void initState() {
    if (widget.todoForEdit != null) { //todoForEdit가 null이 아니라는건, Edit라는 의미
      _selectedDate = widget.todoForEdit!.dueDate;
      textController.text = widget.todoForEdit!.title;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomDialogScaffold(
      body: RoundedContainer(
        color: context.backgroundColor,
        child: Column(
          children: [
            Row(
              children: [
                "할 일을 작성해주세요.".text.size(18).bold.make(),
                spacer,
                _selectedDate.formattedDate.text.make(),
                IconButton(
                  onPressed: _selectDate,
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
            height20,
            Row(
              children: [
                Expanded(
                    child: TextField(
                  focusNode: node,
                  controller: textController,
                )),
                RoundButton(text: isEditMode ? "완료" : "추가" , onTap: () {
                  widget.hide(WriteTodoResult(_selectedDate, textController.text));
                  //결과를 내보내면서 닫기
                }),
              ],
            )
          ],
        ),
      ),
    );
  }

  bool get isEditMode => widget.todoForEdit != null;

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate, //오늘
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if(date!=null){
      setState(() {
        _selectedDate = date;
      });
    }
  }

  //바로 키보드가 뜨게 하기 위해 믹스인 사용
  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    AppKeyboardUtil.show(context, node);

    // TODO: implement afterFirstLayout
    throw UnimplementedError();
  }
}
