class Customer {
  final String? firstName;
  final String? lastName;
  final String email;
  //final String? phone;
  Customer({
    this.firstName,
    this.lastName,
    required this.email,
    //this.phone,
});

  Map<String, dynamic> toJson() => {
    'first_name': firstName,
    'last_name': lastName,
    'email': email,
    //'phone_number': phone,
  };
}