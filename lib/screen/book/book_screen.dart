import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translator/translator.dart';
import 'package:material_dialogs/dialogs.dart';

class BookScreen extends StatefulWidget {
  static const String routeName = '/book';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const BookScreen());
  }

  const BookScreen({Key? key}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  String selectedText = '';
  String selectedTableText = 'Tôi sống độc lập từ thủa bé. Ấy là tục lệ lâu đời trong họ nhà dế chúng tôi. Vả lại, mẹ thường bảo chúng tôi rằng: "Phải như thế để các con biết kiếm ăn một mình cho quen đi. Con cái mà cứ nhong nhong ăn bám vào bố mẹ thì chỉ sinh ra tính ỷ lại, xấu lắm, rồi ra đời không làm nên trò trống gì đâu". Bởi thế, lứa sinh nào cũng vậy, đẻ xong là bố mẹ thu xếp cho con cái ra ở riêng. Lứa sinh ấy, chúng tôi có cả thảy ba anh em. Ba anh em chúng tôi chỉ ở với mẹ ba hôm. Tới hôm thứ ba, mẹ đi trước, ba đứa tôi tấp tểnh, khấp khởi, nửa lo nửa vui theo sau. Mẹ dẫn chúng tôi đi và mẹ đem đặt mỗi đứa vào một cái hang đất ở bờ ruộng phía bên kia, chỗ trông ra đầm nước mà không biết mẹ đã chịu khó đào bới, be đắp tinh tươm thành hang, thành nhà cho chúng tôi từ bao giờ. Tôi là em út, bé nhất nên được mẹ tôi sau khi dắt vào hang, lại bỏ theo một ít ngọn cỏ non trước cửa, để tôi nếu có bỡ ngỡ, thì đã có ít thức ăn sẵn trong vài ngày.Tôi sống độc lập từ thủa bé. Ấy là tục lệ lâu đời trong họ nhà dế chúng tôi. Vả lại, mẹ thường bảo chúng tôi rằng: "Phải như thế để các con biết kiếm ăn một mình cho quen đi. Con cái mà cứ nhong nhong ăn bám vào bố mẹ thì chỉ sinh ra tính ỷ lại, xấu lắm, rồi ra đời không làm nên trò trống gì đâu". Bởi thế, lứa sinh nào cũng vậy, đẻ xong là bố mẹ thu xếp cho con cái ra ở riêng. Lứa sinh ấy, chúng tôi có cả thảy ba anh em. Ba anh em chúng tôi chỉ ở với mẹ ba hôm. Tới hôm thứ ba, mẹ đi trước, ba đứa tôi tấp tểnh, khấp khởi, nửa lo nửa vui theo sau. Mẹ dẫn chúng tôi đi và mẹ đem đặt mỗi đứa vào một cái hang đất ở bờ ruộng phía bên kia, chỗ trông ra đầm nước mà không biết mẹ đã chịu khó đào bới, be đắp tinh tươm thành hang, thành nhà cho chúng tôi từ bao giờ. Tôi là em út, bé nhất nên được mẹ tôi sau khi dắt vào hang, lại bỏ theo một ít ngọn cỏ non trước cửa, để tôi nếu có bỡ ngỡ, thì đã có ít thức ăn sẵn trong vài ngày.';
  OverlayEntry? _overlayEntry;
  bool isTickedWhite = true;
  bool isTickedBlack = false;
  List<String> textSegments = [];
  int currentPage = 0;
  List<TextSpan> highlightedTextSpans = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height*2;
    splitTextIntoSegments(screenHeight);
   return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFDFE2E0)),
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: const Icon(Icons.book,
                color: Color(0xFFDFE2E0)),
          ),
          IconButton(
            onPressed: () {
              Dialogs.bottomMaterialDialog(
                  context: context,
                  color: const Color(0xFF122158),
                  actions: [
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            _showClipboardDialog(context);
                          },
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(width: 10,),
                              Text('Add Notes', style: TextStyle(fontSize: 17, color: Colors.white),),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.color_lens, color: Colors.white),
                              const SizedBox(width: 10,),
                              const Text('Backgrounds', style: TextStyle(fontSize: 17, color: Colors.white),),
                              const SizedBox(width: 10,),
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    isTickedWhite = !isTickedWhite;
                                    isTickedBlack = !isTickedBlack;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child:  isTickedWhite
                                      ? const Icon(
                                    Icons.check,
                                    color: Colors.black,
                                    size: 10.0,
                                  ): null,
                                ),
                              ),
                              const SizedBox(width: 10,),
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    isTickedWhite = !isTickedWhite;
                                    isTickedBlack = !isTickedBlack;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  width: 20.0,
                                  height: 20.0,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black,
                                  ),
                                  child: isTickedBlack
                                      ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 10.0,
                                  ): null,
                                ),
                              )
                            ],
                          ),
                        ),
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: const Text('Close', style: TextStyle(color: Colors.white),))
                      ],
                    ),
                  ]
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      bottomNavigationBar:  BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                onPressed: (){
                  if (currentPage > 0) {
                    setState(() {
                      currentPage--;
                    });
                  }
                },
                icon: Icon(Icons.arrow_back_ios_new, color: currentPage>0? Colors.black: Colors.grey),
              ),
              Text(
                'Page ${currentPage+1}',
                style: const TextStyle(fontSize: 18),
              ),
              IconButton(
                onPressed: (){
                  if (currentPage < textSegments.length - 1) {
                    setState(() {
                      currentPage++;
                    });
                  }
                },
                icon: Icon(Icons.arrow_forward_ios, color: currentPage<textSegments.length-1? Colors.black: Colors.grey,),
              ),
            ],
          )
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: GestureDetector(
              onTapDown: (details) {
                showToolbar(context, details.localPosition);
              },
              child: SelectableText(
                currentPage < textSegments.length
                    ? textSegments[currentPage]
                    : '',
                style: Theme.of(context).textTheme.titleLarge,
                showCursor: true,
                toolbarOptions: ToolbarOptions(selectAll: false, copy: false),
                onSelectionChanged: (selection, cause) {
                  setState(() {
                    if (currentPage < textSegments.length) {
                      final start = selection.start.clamp(0, textSegments[currentPage].length);
                      final end = selection.end.clamp(0, textSegments[currentPage].length);

                      selectedText = textSegments[currentPage].substring(start, end);
                    } else {
                      selectedText = '';
                    }
                  });
                },


              ),
            ),
          ),
        ],
      ),
   );
  }
  void splitTextIntoSegments(double screenHeight) {
    final textLength = selectedTableText.length;
    textSegments.clear();

    if (textLength <= screenHeight) {
      // Nếu đoạn văn bản nhỏ hơn hoặc bằng chiều cao của thiết bị, không cần chia nhỏ
      textSegments.add(selectedTableText);
    } else {
      int start = 0;
      int end = screenHeight.toInt();

      while (end < textLength) {
        while (end < textLength && selectedTableText[end] != ' ') {
          end--;
        }
        textSegments.add(selectedTableText.substring(start, end));
        start = end;
        end += screenHeight.toInt();
      }

      // Thêm phần cuối cùng (nếu còn lại)
      if (start < textLength) {
        textSegments.add(selectedTableText.substring(start));
      }
    }
  }


  void showToolbar(BuildContext context, Offset localPosition) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
    }
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          right: 30,
          top: localPosition.dy + 30,
          child: Container(
            decoration: BoxDecoration(color: const Color(0xFF8C2EEE), borderRadius: BorderRadius.circular(5)),
            child: Row(
              children: [
                TextButton(
                  child: const Row(
                    children: [
                      Text('Copy', style: TextStyle(fontSize: 13, color: Colors.white),),
                      Icon(Icons.copy, color: Colors.white)
                    ],
                  ),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: selectedText));
                  },
                ),
                TextButton(
                  onPressed: (){
                    Clipboard.setData(ClipboardData(text: selectedText));
                    _overlayEntry!.remove();
                    _showClipboardDialog(context);
                  },
                  child: const Row(
                    children: [
                      Text('Save', style: TextStyle(fontSize: 13, color: Colors.white)),
                      Icon(Icons.save, color: Colors.white,)
                    ],
                  ),
                ),
                TextButton(
                  onPressed: (){

                  },
                  child: const Row(
                    children: [
                      Text('Mark', style: TextStyle(fontSize: 13, color: Colors.white)),
                      Icon(Icons.edit_note_outlined, color: Colors.white,)
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final translator = GoogleTranslator();
                    translator
                        .translate(selectedText, to: 'vi')
                        .then((result) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.toString()))));

                    },
                  child: const Row(
                    children: [
                      Text('Trans', style: TextStyle(fontSize: 13, color: Colors.white)),
                      Icon(Icons.g_translate, color: Colors.white,)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Overlay.of(context)!.insert(_overlayEntry!);
  }
  void _showClipboardDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF122158),
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit, color: Colors.white),
              Text('Add Notes', style: TextStyle(color: Colors.white),)
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(color: Colors.white, height: 10),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const Text('Name:', style: TextStyle(color: Colors.white),),
                  const SizedBox(width: 10,),
                  Flexible(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: TextFormField(
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 2), // Màu gạch dưới khi TextFormField được focus
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 2),),
                            )
                        )
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const Text('Content:', style: TextStyle(color: Colors.white),),
                  const SizedBox(width: 10,),
                  Flexible(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: selectedText.isNotEmpty ? Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2)),
                            child: Text(selectedText, style: const TextStyle(color: Colors.white),)):
                        TextFormField(
                            style: const TextStyle(color: Colors.white),
                            cursorColor: Colors.white,
                            decoration: const InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.white, width: 2), // Màu gạch dưới khi TextFormField được focus
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey, width: 2),),
                            )
                        )
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close', style: TextStyle(color: Colors.white),),
            ),
          ],
        );
      },
    );
  }

}

