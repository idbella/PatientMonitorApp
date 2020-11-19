

class User{

	User({this.id,this.email,this.firstName,this.lastName,this.role,this.phone});
	int id;
	String firstName;
	String lastName;
	String email;
  String phone;
	int	 role;

	static User fromjson(Map<String, dynamic> json){
		User user = new User(
				id:json['id'] as int,
				firstName: json['first_name'] as String,
				lastName: json['last_name'] as String,
				email:json['email'] as String,
        phone:json['phone'] as String,
				role:json['role'] as int
			);
		return user;
	}
}
