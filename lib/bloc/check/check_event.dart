part of 'check_bloc.dart';

@immutable
abstract class CheckEvent {}

class SetChatDocIdEvent extends CheckEvent {
  final String friendUid;
  final String friendName;

  SetChatDocIdEvent(this.friendUid, this.friendName);
}
