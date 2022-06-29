import 'package:demo_chat_app/bloc/check/check_bloc.dart';
import 'package:demo_chat_app/bloc/locale/locale_bloc.dart';
import 'package:demo_chat_app/bloc/login/login_bloc.dart';
import 'package:demo_chat_app/bloc/send/send_bloc.dart';
import 'package:demo_chat_app/page/login/intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    Locale? _locale;

    void SetLocale(Locale locale) {
      setState(() {
        _locale = locale;
      });
    }

    return BlocBuilder<LocaleBloc, LocaleState>(
      builder: (context, state) {
        if (state is SetLocaleState) _locale = state.locale;
        return MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>(
              create: (context) => LoginBloc(),
            ),
            BlocProvider<CheckBloc>(
              create: (context) => CheckBloc(),
            ),
            BlocProvider(
              create: (context) => SendBloc(),
            ),
          ],
          child: MaterialApp(
            // locale: Locale.fromSubtags(languageCode: 'vi'),
            locale: _locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            debugShowCheckedModeBanner: false,
            home: Intro(SetLocale),
            theme: ThemeData(
                brightness: Brightness.light,
                primaryColor: const Color(0xFF08C187)),
          ),
        );
      },
    );
  }
}
