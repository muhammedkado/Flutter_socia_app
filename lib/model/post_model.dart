class PostModel {
  String? name;
  String? image;
  String? uId;
  String? time;
  String? text;
  String? postImage;

  PostModel({
    required this.name,
    required this.image,
    required this.text,
    required this.time,
    this.uId,
    required this.postImage,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    time = json['time'];
    text = json['text'];
    postImage = json['postImage'];
    uId = json['uId'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'text': text,
      'image': image,
      'uId': uId,
      'postImage': postImage,
      'time': time,

    };
  }
}
