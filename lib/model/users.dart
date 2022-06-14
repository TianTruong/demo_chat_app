// ignore_for_file: prefer_typing_uninitialized_variables

class Users {
  final avatar;
  final name;
  final status;
  final uid;

  Users({
    this.avatar,
    this.name,
    this.status,
    this.uid,
  });

  Users map(dynamic data) {
    return Users(
      avatar: data['avatar'],
      name: data['name'],
      status: data['status'],
      uid: data['uid'],
    );
  }
}
