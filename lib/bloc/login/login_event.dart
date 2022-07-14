part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class CreateUserEvent extends LoginEvent {
  final String name;
  final String avatar;
  final String uid;
  final String pass;

  CreateUserEvent(this.name, this.avatar, this.uid, this.pass);
}

class SaveImageEvent extends LoginEvent {
  final ImageSource source;

  SaveImageEvent(this.source);
}
