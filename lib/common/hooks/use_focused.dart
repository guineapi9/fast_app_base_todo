import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

//같은 노드에 대해서 useEffect는 한번만 실행됨. 즉, Node가 바뀔때마다 새로 호출
bool useIsFocused(FocusNode node) {
  final isFocused = useState(node.hasFocus);

  useEffect(() {
    void listener() {
      isFocused.value = node.hasFocus;
    }

    node.addListener(listener);
    return () => node.removeListener(listener);
  }, [node]);

  return isFocused.value;
}