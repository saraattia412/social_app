class UserModel{
  late String? uid;
  late String? name;
  late String? email;
  late String? phone;
  late String? image;
  late String? bio;
  late String? cover;

  UserModel({
     this.uid,
     this.name,
     this.email,
     this.phone,
     this.image,
     this.bio,
     this.cover,

});

  UserModel.formJson(Map <String , dynamic>? json){
    uid=json!['uid'];
    name=json['name'];
    email=json['email'];
    phone=json['phone'];
    image=json['image'];
    bio=json['bio'];
    cover=json['cover'];
  }

  Map <String , dynamic> toMap(){
    return {
      'uid' : uid,
      'name' : name,
      'email' : email,
      'phone' :phone,
      'image' :image,
      'bio' :bio,
      'cover' : cover,
    };
  }
}