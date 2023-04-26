

class CreateUserDto {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String upiId;

  CreateUserDto({required this.name,required  this.email,required  this.phone,required  this.password,required  this.upiId});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['password'] = this.password;
    data['upi_id'] = this.upiId;
    return data;
  }
}
