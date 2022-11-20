class PostModel{
  late String? uid;
  late String? name;
  late String? image;
  late String? date;
  late String? text;
  late String? postImage;


  PostModel({
    this.uid,
    this.name,
    this.image,
    this.date,
    this.text,
    this.postImage,
  });

  PostModel.formJson(Map <String , dynamic>? json){
    uid=json!['uid'];
    name=json['name'];
    image=json['image'];
    date=json['date'];
    text=json['text'];
    postImage=json['postImage'];
  }

  Map <String , dynamic> toMap(){
    return {
      'uid' : uid,
      'name' : name,
      'image' :image,
      'date' : date,
      'text' : text,
      'postImage':postImage,
    };
  }
}