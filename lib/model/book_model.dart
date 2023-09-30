import 'package:equatable/equatable.dart';

class Book extends Equatable{
  final String authodId;
  final List categoryId;
  final String description;
  final String imageUrl;
  final String language;
  final double price;
  final DateTime publishDate;
  final bool status;
  final String title;

  const Book({
    required this.authodId,
    required this.categoryId,
    required this.description,
    required this.imageUrl,
    required this.language,
    required this.price,
    required this.publishDate,
    required this.status,
    required this.title
});

  @override
  List<Object?> get props =>[authodId, categoryId, description, imageUrl, language, price, publishDate, status, title];

  static List<Book> books = [
    Book(
        authodId: 'gb51TOSTxbkJNWZY0wJt',
        categoryId: const [
          're0RBYTYZsb1eAeuSYGk', 'enc0qB1JqjN1F90uLknL'
        ],
        description: 'Hoàng tử bé (tên tiếng Pháp: Le Petit Prince, phát âm: [lə p(ə)ti pʁɛ̃s]), được xuất bản năm 1943, là tiểu thuyết nổi tiếng nhất của nhà văn và phi công Pháp Antoine de Saint-Exupéry. Ông đã thuê ngôi biệt thự The Bevin House ở Asharoken, Long Island, New York trong khi viết tác phẩm này. Cuốn tiểu thuyết cũng bao gồm nhiều bức tranh do chính Saint-Exupéry vẽ. Tác phẩm đã được dịch sang hơn 250 ngôn ngữ (bao gồm cả tiếng địa phương) và cho đến nay đã bán được hơn 200 triệu bản khắp thế giới, trở thành một trong những sách bán chạy nhất của mọi thời đại, được phát triển thành một sê ri truyện tranh 39 chương bởi Élyum Studio, và một phiên bản graphic novel bìa cứng chuyển thể bởi danh họa tài năng Joann Sfar. Truyện còn được dùng như tài liệu cho những người muốn làm quen với ngoại ngữ.',
        imageUrl: 'https://s.net.vn/Zffz',
        language: 'Vietnamese',
        price: 0.0,
        publishDate: DateTime.now(),
        status: true,
        title: 'Hoàng tử bé'),
    Book(
        authodId: 'gb51TOSTxbkJNWZY0wJt',
        categoryId: const [
          're0RBYTYZsb1eAeuSYGk', 'enc0qB1JqjN1F90uLknL'
        ],
        description: 'Hoàng tử bé (tên tiếng Pháp: Le Petit Prince, phát âm: [lə p(ə)ti pʁɛ̃s]), được xuất bản năm 1943, là tiểu thuyết nổi tiếng nhất của nhà văn và phi công Pháp Antoine de Saint-Exupéry. Ông đã thuê ngôi biệt thự The Bevin House ở Asharoken, Long Island, New York trong khi viết tác phẩm này. Cuốn tiểu thuyết cũng bao gồm nhiều bức tranh do chính Saint-Exupéry vẽ. Tác phẩm đã được dịch sang hơn 250 ngôn ngữ (bao gồm cả tiếng địa phương) và cho đến nay đã bán được hơn 200 triệu bản khắp thế giới, trở thành một trong những sách bán chạy nhất của mọi thời đại, được phát triển thành một sê ri truyện tranh 39 chương bởi Élyum Studio, và một phiên bản graphic novel bìa cứng chuyển thể bởi danh họa tài năng Joann Sfar. Truyện còn được dùng như tài liệu cho những người muốn làm quen với ngoại ngữ.',
        imageUrl: 'https://s.net.vn/Zffz',
        language: 'Vietnamese',
        price: 0.0,
        publishDate: DateTime.now(),
        status: true,
        title: 'Hoàng tử bé')
  ];
}