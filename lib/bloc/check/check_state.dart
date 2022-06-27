part of 'check_bloc.dart';

@immutable
class CheckState {
  const CheckState();
}

class SetChatDocIdState extends CheckState {
  final String ChatDocID;
  const SetChatDocIdState({required this.ChatDocID});
}
