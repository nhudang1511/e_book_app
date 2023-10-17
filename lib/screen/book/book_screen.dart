import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:translator/translator.dart';
import 'package:syncfusion_flutter_core/theme.dart';

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
  late PdfViewerController _pdfViewerController;
  OverlayEntry? _overlayEntry;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  int currentPage = 1;
  bool isBookmarkViewOpen = false;
  // Text from clipboard
  String clipboardText = '';
  double _value = 100;
  bool isTickedWhite = true;
  bool isTickedBlack = false;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  void _showContextMenu(
      BuildContext context,
      PdfTextSelectionChangedDetails details,
      ) {
    final OverlayState overlayState = Overlay.of(context);
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: Container(
          decoration: BoxDecoration(color: const Color(0xFF8C2EEE), borderRadius: BorderRadius.circular(5)),
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  final selectedText = details.selectedText ?? '';
                  Clipboard.setData(ClipboardData(text: selectedText));
                  //print('Text copied to clipboard: ' + details.selectedText.toString());
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Text copied to clipboard + ${details.selectedText}')));
                  _pdfViewerController.clearSelection();
                },
                child: const Row(
                  children: [
                    Text('Copy', style: TextStyle(fontSize: 17, color: Colors.white),),
                    Icon(Icons.copy, color: Colors.white)
                  ],
                ),
              ),
              TextButton(
                  onPressed: (){
                    final selectedText = details.selectedText ?? '';
                    Clipboard.setData(ClipboardData(text: selectedText));
                    _pdfViewerController.clearSelection();
                    // Store the clipboard text and show it in a dialog
                    setState(() {
                      clipboardText = selectedText;
                    });
                    _showClipboardDialog(context);
                  },
                  child: const Row(
                    children: [
                    Text('Save', style: TextStyle(fontSize: 17, color: Colors.white)),
                    Icon(Icons.save, color: Colors.white,)
                  ],
                  ),
              ),
              TextButton(
                onPressed: (){
                },
                child: const Row(
                  children: [
                    Text('Mark', style: TextStyle(fontSize: 17, color: Colors.white)),
                    Icon(Icons.edit_note_outlined, color: Colors.white,)
                  ],
                ),
              ),
              TextButton(
                onPressed: () async {
                  final selectedText = details.selectedText ?? '';
                  final translator = GoogleTranslator();
                  translator
                      .translate(selectedText, to: 'vi')
                      .then((result) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result.toString()))));
                },
                child: const Row(
                  children: [
                    Text('Trans', style: TextStyle(fontSize: 17, color: Colors.white)),
                    Icon(Icons.g_translate, color: Colors.white,)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
    overlayState.insert(_overlayEntry!);
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
                  SizedBox(
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
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const Text('Content:', style: TextStyle(color: Colors.white),),
                  const SizedBox(width: 10,),
                  SizedBox(
                      width: MediaQuery.of(context).size.width / 2 - 20,
                      child: clipboardText.isNotEmpty ? Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2)),
                          child: Text(clipboardText, style: const TextStyle(color: Colors.white),)):
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

  void _updateCurrentPageNumber(PdfPageChangedDetails details) {
    setState(() {
      currentPage = details.newPageNumber;
    });
  }

  void nextPage() {
    _pdfViewerController.nextPage();
  }

  void previousPage() {
    _pdfViewerController.previousPage();
  }


  @override
  Widget build(BuildContext context) {
    final pdfViewerTheme = SfPdfViewerThemeData(
      bookmarkViewStyle: const PdfBookmarkViewStyle(
          backgroundColor: Color(0xFF122158),
          titleTextStyle: TextStyle(color: Colors.white),
        headerBarColor: Color(0xFF122158),
        headerTextStyle: TextStyle(color: Colors.white),
        navigationIconColor: Colors.white,
        closeIconColor: Colors.white,
        selectionColor: Colors.grey,
      ),
      backgroundColor: isTickedWhite ? Colors.white : Colors.black,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFDFE2E0)),
        actions: [
          IconButton(
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
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
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _value = _value + 10;
                            });
                          },
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.zoom_in, color: Colors.white),
                              SizedBox(width: 10,),
                              Text('Zoom In', style: TextStyle(fontSize: 17, color: Colors.white),),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _value = _value - 10;
                            });
                          },
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.zoom_out, color: Colors.white),
                              SizedBox(width: 10,),
                              Text('Zoom out', style: TextStyle(fontSize: 17, color: Colors.white),),
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
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              onPressed: previousPage,
              icon: const Icon(Icons.arrow_back_ios_new),
            ),
            Text(
              'Page $currentPage of  ${_pdfViewerController.pageCount}',
              style: const TextStyle(fontSize: 18),
            ),
            IconButton(
              onPressed: nextPage,
              icon: const Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: Transform.scale(
          scale: _value / 100,
          child: SfPdfViewerTheme(
            data: pdfViewerTheme,
            child: SfPdfViewer.network(
              'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
              key: _pdfViewerKey,
              onPageChanged: _updateCurrentPageNumber,
              onTextSelectionChanged: (PdfTextSelectionChangedDetails details) {
                if (details.selectedText == null && _overlayEntry != null) {
                  _overlayEntry!.remove();
                  _overlayEntry = null;
                } else if (details.selectedText != null && _overlayEntry == null) {
                  _showContextMenu(context, details);
                }
              },
              controller: _pdfViewerController,
              scrollDirection: PdfScrollDirection.horizontal,

            ),
          ),
        ),
      ),
    );
  }
}
