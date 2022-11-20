
class CommentModel
{
  String? name;
  String? profileImage;
  String? commentText;


  CommentModel({
    this.name,
    this.profileImage,
    this.commentText,
  });

  CommentModel.fromJson(Map<String, dynamic>? json){
    name = json!['name'];
    profileImage = json['profileImage'];
    commentText = json['commentText'];

  }

  Map<String, dynamic> toMap (){
    return {
      'name':name,
      'profileImage':profileImage,
      'commentText':commentText,

    };
  }
}