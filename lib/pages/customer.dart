class Customer {
  final String name;
  final String email;
  final String id;

  Customer(this.name, this.email,this.id);

  Customer.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        id =json['id'];

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'id':id,
  };
}