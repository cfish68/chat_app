class User {
  final String userId;
  final String email;
  //final String displayName;
  //final String profilePicture;
  //final bool isActive;

  User({
    required this.userId,
    required this.email,
    //required this.displayName,
    //required this.profilePicture,
    //required this.isActive,
  });

  // Factory method to create a User object from Firestore data
  factory User.fromMap(Map<String, dynamic> data, String id) {
    return User(
      userId: id,
      email: data['email'] ?? '',
      //displayName: data['displayName'] ?? '',
      //profilePicture: data['profilePicture'] ?? '',
      //isActive: data['isActive'] ?? false,
    );
  }
}