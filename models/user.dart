class User {
  final String id;
  final String userName;
  final String phoneNumber;
  final String photoUrl;

  User({this.id, this.userName, this.phoneNumber, this.photoUrl});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "userName": userName,
      "phone": phoneNumber,
      "photoUrl": photoUrl,
    };
  }

  User.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        userName = map['userName'],
        phoneNumber = map['phone'],
        photoUrl = map['photoUrl'];
}
