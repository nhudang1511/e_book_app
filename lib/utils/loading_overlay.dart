import 'package:flutter/material.dart';

class LoadingOverlay {
  static OverlayEntry? _overlayEntry;

  static void showLoading(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_overlayEntry == null) {
        _overlayEntry = OverlayEntry(
          builder: (context) => Stack(
            children: [
              // Background dim
              ModalBarrier(
                color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                dismissible: false,
              ),
              // Loading indicator
              const Center(
                child: CircularProgressIndicator(),
              ),
            ],
          ),
        );
        Overlay.of(context).insert(_overlayEntry!);
      }
    });
  }

  static void dismissLoading() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }
}
