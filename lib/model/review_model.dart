import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Review extends Equatable{
  final String bookId;
  final String content;
  final double rating;
  final bool status;
  final String userId;

  const Review({
    required this.bookId,
    required this.content,
    required this.rating,
    required this.status,
    required this.userId
  });

  @override
  List<Object?> get props =>[bookId, content, status, userId];

  static Review fromSnapshot(DocumentSnapshot snap) {
    Review review = Review(
        bookId: snap['bookId'],
        content: snap['content'],
        rating: snap['rating'],
        status: snap['status'],
        userId: snap['userId']
    );
    return review;
  }
  static List<Review> reviews =[
    Review(bookId: '123', content: "Hoàng tử bé (tên tiếng Pháp: Le Petit Prince, phát âm: [lə p(ə)ti pʁɛ̃s]), được xuất bản năm 1943, là tiểu thuyết nổi tiếng nhất của nhà văn và phi công Pháp Antoine de Saint-Exupéry. Ông đã thuê ngôi biệt thự The Bevin House ở Asharoken, Long Island, New York trong khi viết tác phẩm này. Cuốn tiểu thuyết cũng bao gồm nhiều bức tranh do chính Saint-Exupéry vẽ. Tác phẩm đã được dịch sang hơn 250 ngôn ngữ (bao gồm cả tiếng địa phương) và cho đến nay đã bán được hơn 200 triệu bản khắp thế giới, trở thành một trong những sách bán chạy nhất của mọi thời đại, được phát triển thành một sê ri truyện tranh 39 chương bởi Élyum Studio, và một phiên bản graphic novel bìa cứng chuyển thể bởi danh họa tài năng Joann Sfar. Truyện còn được dùng như tài liệu cho những người muốn làm quen với ngoại ngữ.", rating: 4.9, status: true, userId: '123'),
    Review(bookId: '123', content: "hay", rating: 4.9, status: true, userId: '123')
  ];
}