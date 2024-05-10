class CourseDetailsModel {
  String image;
  bool isBookmarked;
  String mentor;
  String price;
  String title;

  CourseDetailsModel(
      {required this.image,
        required this.isBookmarked,
        required this.title,
        required this.mentor,
        required this.price});

  // Factory method to create a CourseModel from a map
  factory CourseDetailsModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailsModel(
      image: json['image'] ?? '',
      isBookmarked: json['isBookmarked'] ,
      title: json['title'] ?? '',
      mentor: json['mentor'] ?? '',
      price: json['price'] ?? '',
    );
  }
}

class LinksModel {
  String id;
  bool isSeen;
  String link;
  String tutorialNumber;

  LinksModel({
    required this.id,
    required this.isSeen,
    required this.link,
    required this.tutorialNumber,
  });

  // Factory method to create a LinksModel from a map
  factory LinksModel.fromMap(Map<String, dynamic> map) {
    return LinksModel(
      id: map['id'] ?? '',
      isSeen: map['isSeen'] ,
      link: map['link'] ?? '',
      tutorialNumber: map['tutorialNumber'] ?? '',
    );
  }
}
