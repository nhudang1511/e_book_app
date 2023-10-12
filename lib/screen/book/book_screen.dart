import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../model/models.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookScreen extends StatefulWidget {
  static const String routeName = '/book';

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => BookScreen());
  }
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  late PdfViewerController _pdfViewerController;
  OverlayEntry? _overlayEntry;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  int currentPage = 1;

  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    super.initState();
  }

  void _showContextMenu(
      BuildContext context,
      PdfTextSelectionChangedDetails details,
      ) {
    final OverlayState overlayState = Overlay.of(context)!; // Remove the double underscores
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: details.globalSelectedRegion!.center.dy - 55,
        left: details.globalSelectedRegion!.bottomLeft.dx,
        child: ElevatedButton(
          onPressed: () {
            final selectedText = details.selectedText ?? '';
            Clipboard.setData(ClipboardData(text: selectedText));
            print('Text copied to clipboard: ' + details.selectedText.toString());
            _pdfViewerController.clearSelection();
          },
          child: Text('Copy', style: TextStyle(fontSize: 17)),
        ),
      ),
    );
    overlayState.insert(_overlayEntry!); // Remove the double underscores
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
              _pdfViewerKey.currentState?.openBookmarkView();
            },
            icon: const Icon(Icons.book),
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









