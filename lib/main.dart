import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app.dart';
import 'common/data/preference/app_preferences.dart';
import 'data/memory/app_bloc/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await AppPreferences.init();

  //앱에서 일어나는 모든 변화들을 관찰 할 수 있다.
  //Bloc은 관찰에 장점이 있지만 번거로우므로 굳이 관찰 할 필요가 없다면 Cubit을 사용하는 편이 낫다.
  Bloc.observer = AppBlocObserver();

  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ko')],
      fallbackLocale: const Locale('en'),
      path: 'assets/translations',
      useOnlyLangCode: true,
      child: const App()));
}
