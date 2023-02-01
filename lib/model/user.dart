class User {
  String email;

  String firstName;

  String lastName;

  String userID;

  String password;

  String profilePictureURL;

  User(
      {this.email = '',
        this.firstName = '',
        this.lastName = '',
        this.userID = '',
        this.password = '',
        this.profilePictureURL = ''});

  String fullName() => '$firstName $lastName';

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
        email: parsedJson['email'] ?? '',
        firstName: parsedJson['firstName'] ?? '',
        lastName: parsedJson['lastName'] ?? '',
        password: parsedJson['password'] ?? '',
        userID: parsedJson['id'] ?? parsedJson['userID'] ?? '',
        profilePictureURL: parsedJson['profilePictureURL'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'id': userID,
      'password': password,
      'profilePictureURL': profilePictureURL,
    };
  }
}
