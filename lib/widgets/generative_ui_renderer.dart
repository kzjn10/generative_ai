import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../genui/gen_ui_renderer.dart';

/// Backward-compatible wrapper — delegates to the new [GenUiRenderer].
class GenerativeUiRenderer extends StatelessWidget {
  final GenerativeUiResponse response;

  const GenerativeUiRenderer({super.key, required this.response});

  @override
  Widget build(BuildContext context) {
    return GenUiRenderer(response: response);
  }
}
