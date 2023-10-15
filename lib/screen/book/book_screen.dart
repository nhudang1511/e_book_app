import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:translator/translator.dart';

class BookScreen extends StatefulWidget {
  static const String routeName = '/book';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => BookScreen());
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



  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  void _showContextMenu(
      BuildContext context,
      PdfTextSelectionChangedDetails details,
      ) {
    final OverlayState overlayState = Overlay.of(context)!;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: Container(
          decoration: BoxDecoration(color: Color(0xFF8C2EEE), borderRadius: BorderRadius.circular(5)),
          padding: EdgeInsets.all(5),
          child: Row(
            children: [
              TextButton(
                onPressed: () {
                  final selectedText = details.selectedText ?? '';
                  Clipboard.setData(ClipboardData(text: selectedText));
                  print('Text copied to clipboard: ' + details.selectedText.toString());
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
                      .then((result) => print("Source: $selectedText\nTranslated: $result"));
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
          title: Text('Clipboard Content'),
          content: Text(clipboardText),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFDFE2E0)),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isBookmarkViewOpen = !isBookmarkViewOpen;
              });
              _pdfViewerKey.currentState?.openBookmarkView();
            },
            icon: Icon(Icons.book,
                color: isBookmarkViewOpen
                    ? const Color(0xFF8C2EEE)
                    : const Color(0xFFDFE2E0)),
          ),
          IconButton(
            onPressed: () {},
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
              icon: Icon(Icons.arrow_back_ios_new),
            ),
            Text(
              'Page $currentPage of  ${_pdfViewerController.pageCount}',
              style: TextStyle(fontSize: 18),
            ),
            IconButton(
              onPressed: nextPage,
              icon: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
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
    );
  }
}
