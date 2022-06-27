part of 'locale_bloc.dart';

@immutable
abstract class LocaleEvent {}

class SetLocaleEvent extends LocaleEvent {
  final Locale locale;

  SetLocaleEvent(this.locale);
}
