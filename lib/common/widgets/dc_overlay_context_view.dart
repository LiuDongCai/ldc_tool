import 'package:flutter/material.dart';

typedef DCOverlayContextHandler = Function(BuildContext context);

class DCOverlayContextView extends StatefulWidget {
  final DCOverlayContextHandler contextInitHandler;
  const DCOverlayContextView({
    super.key,
    required this.contextInitHandler,
  });

  @override
  State<DCOverlayContextView> createState() => _DCOverlayContextViewState();
}

class _DCOverlayContextViewState extends State<DCOverlayContextView> {
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPageOverlay(widget.contextInitHandler);
  }

  /// 頁面overlay
  Widget _buildPageOverlay(
    DCOverlayContextHandler contextInitHandler,
  ) {
    return Overlay(
      initialEntries: [
        _overlayEntry = _overlayEntry ??
            OverlayEntry(
              builder: (context) {
                contextInitHandler(context);
                return const SizedBox.shrink();
              },
            )
      ],
    );
  }
}
