import 'package:e_book_app/widget/widget.dart';
import 'package:flutter/material.dart';

class TextNotesScreen extends StatelessWidget {
  const TextNotesScreen({super.key});

  static const String routeName = '/text_notes';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => const TextNotesScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentHeight = MediaQuery.of(context).size.height;
    final currentWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(
        title: "Text notes",
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            TextNoteCard(
              title: 'Trích đoạn hay',
              content:
                  "Chập tối, tôi tạm nghỉ tay và ra đứng ngoài cửa, họp cùng anh chị em hàng xóm quanh bờ ruộng,...Chập tối, tôi tạm nghỉ tay và ra đứng ngoài cửa, họp cùng anh chị em hàng xóm quanh bờ ruộng,...họp cùng anh chị em hàng xóm quanh bờ ruộng,...",
              time: "24/09/2023 tại Dế mèn phiêu lưu ký",
            ),
            TextNoteCard(
              title: 'Trích đoạn hay',
              content:
                  "Chập tối, tôi tạm nghỉ tay và ra đứng ngoài cửa, họp cùng anh chị em hàng xóm quanh bờ ruộng,...Chập tối, tôi tạm nghỉ tay và ra đứng ngoài cửa, họp cùng anh chị em hàng xóm quanh bờ ruộng,...họp cùng anh chị em hàng xóm quanh bờ ruộng,...",
              time: "24/09/2023 tại Dế mèn phiêu lưu ký",
            ),
            TextNoteCard(
              title: 'Trích đoạn hay',
              content:
                  "Chập tối, tôi tạm nghỉ tay và ra đứng ngoài cửa, họp cùng anh chị em hàng xóm quanh bờ ruộng,...Chập tối, tôi tạm nghỉ tay và ra đứng ngoài cửa, họp cùng anh chị em hàng xóm quanh bờ ruộng,...họp cùng anh chị em hàng xóm quanh bờ ruộng,...",
              time: "24/09/2023 tại Dế mèn phiêu lưu ký",
            ),
            TextNoteCard(
              title: 'Trích đoạn hay',
              content:
                  "Chập tối, tôi tạm nghỉ tay và ra đứng ngoài cửa, họp cùng anh chị em hàng xóm quanh bờ ruộng,...Chập tối, tôi tạm nghỉ tay và ra đứng ngoài cửa, họp cùng anh chị em hàng xóm quanh bờ ruộng,...họp cùng anh chị em hàng xóm quanh bờ ruộng,...",
              time: "24/09/2023 tại Dế mèn phiêu lưu ký",
            ),
            TextNoteCard(
                title: 'Trích đoạn hay',
                content:
                    "Chập tối, tôi tạm nghỉ tay và ra đứng ngoài cửa, họp cùng anh chị em hàng xóm quanh bờ ruộng,...Chập tối, tôi tạm nghỉ tay và ra đứng ngoài cửa, họp cùng anh chị em hàng xóm quanh bờ ruộng,...họp cùng anh chị em hàng xóm quanh bờ ruộng,...",
                time: "24/09/2023 tại Dế mèn phiêu lưu ký"),
          ],
        ),
      ),
    );
  }
}
