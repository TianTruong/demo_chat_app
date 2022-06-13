part of 'data_bloc.dart';

@immutable
abstract class DataEvent {}

class DataMessageEvent extends DataEvent {
  final dynamic data;
  Messages mess;

  DataMessageEvent(this.data, this.mess);
}