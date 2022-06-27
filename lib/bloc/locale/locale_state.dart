part of 'locale_bloc.dart';

@immutable
class LocaleState {
  const LocaleState();
}

class SetLocaleState extends LocaleState {
  final Locale locale;
  const SetLocaleState({required this.locale});
}
