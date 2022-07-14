// ignore_for_file: prefer_const_constructors

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'locale_event.dart';
part 'locale_state.dart';

class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleState()) {
    on<SetLocaleEvent>(_onSetLocaleEvent);
  }
  
  void _onSetLocaleEvent(
      SetLocaleEvent event, Emitter<LocaleState> emit) async {
    emit(SetLocaleState(locale: event.locale));
  }
}
