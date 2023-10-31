import 'dart:ui';

class ListQuote {
  final String imageUrl;
  final String name;
  final String quote;
  final Color color;

  ListQuote({required this.imageUrl, required this.name, required this.quote, required this.color});
}
List<ListQuote> listQuote = [
  ListQuote(
    imageUrl: 'assets/image/quote_image_1.png',
    name: 'Mark Twain',
    quote: 'A person who won’t read has no advantage over one who can’t read.',
    color: Color(0xFFFDC844)
  ),
  ListQuote(
      imageUrl: 'assets/image/quote_image_2.png',
      name: 'Albert Einstein',
      quote: 'If you can’t explain it simply, you don’t understand it well enough.',
      color: Color(0xFF6A1CBD)
  ),
  ListQuote(
      imageUrl: 'assets/image/quote_image_3.png',
      name: 'Victor Hugo',
      quote: 'It is from books that wise people derive consolation in the troubles of life',
      color: Color(0xFFEB6097)
  ),

];
