class Course {
  final String id;
  final String title;
  final String imageUrl;
  final String price;

  Course({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.price,
  });

  factory Course.fromMap(Map<String, dynamic> map, String id) {
    return Course(
      id: id,
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: map['price'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
    };
  }
}
