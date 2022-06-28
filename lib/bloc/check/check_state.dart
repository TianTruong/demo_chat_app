part of 'check_bloc.dart';

@immutable
class CheckState {
  const CheckState();
}

class CleanChatIdState extends CheckState {

}

class SetChatDocIdState extends CheckState {
  final String ChatDocID;
  final String friendUid;
  final String friendName;
  const SetChatDocIdState({required this.ChatDocID, required this.friendUid, required this.friendName});
}
