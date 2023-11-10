class ReviewItem {
  final int id;
  final String userName;
  final double rating;


  ReviewItem({
    required this.id,
    required this.userName,
    required this.rating,


  });

  factory ReviewItem.fromJson(Map<String, dynamic> json) {
    return ReviewItem(
      id: json['id'],
      userName: json['userName'],
      rating: json['rating'],

    );
  }
}