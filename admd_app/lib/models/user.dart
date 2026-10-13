class User {
  String name;
  int? age;
  String? email;
User({
    required this.name,
    this.age,
    this.email,
  });
  String getDisplayAge() {
    if (age == null) {
      return 'Age not specified';
    }
    return age.toString();
  }
}