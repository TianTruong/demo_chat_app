part of 'send_bloc.dart';

@immutable
abstract class SendEvent {}

class SendMessEvent extends SendEvent {
  final String chatDocId;
  final String friendUid;
  final String friendName;
  final String message;

  SendMessEvent(this.chatDocId, this.friendUid, this.friendName, this.message);
}

class SendImageEvent extends SendEvent {
  final String chatDocId;
  final String friendUid;
  final String friendName;
  final ImageSource source;

  SendImageEvent(this.chatDocId, this.friendUid, this.friendName, this.source);
}

class SendVoiceEvent extends SendEvent {
  final String chatDocId;
  final String friendUid;
  final String friendName;
  final Record record;

  SendVoiceEvent(this.chatDocId, this.friendUid, this.friendName, this.record);
}
