class UserModel {
  final String name;
  final String email;
  final String value;
  final bool isBan;

  UserModel(this.name, this.email, this.value, this.isBan);

  UserModel.fromJson(Map<dynamic, dynamic> json)
      : name = json['name'] as String,
        email = json['email'] as String,
        value = json['value'] as String,
        isBan = json['isBan'] as bool;


  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'name': name,
        'email': email,
        'value': value,
        'isBan': isBan
      };

}
