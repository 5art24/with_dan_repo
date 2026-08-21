class ReviewModel {
  final String reviewsId;
  final double rating;
  final DateTime createdAt;
  final String? comment;
  final String servId;
  final String userId;

  ReviewModel({
    required this.reviewsId,
    required this.rating,
    required this.createdAt,
    this.comment,
    required this.servId,
    required this.userId,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      reviewsId: json['reviewsId']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      comment: json['comment'],
      servId: json['servId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewsId': reviewsId,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'comment': comment,
      'servId': servId,
      'userId': userId,
    };
  }
}