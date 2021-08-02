class User {
  late String id;
  late String username;
  late String fullname;

  User(this.id, this.username, this.fullname);

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    fullname = json['fullname'];
  }
}
