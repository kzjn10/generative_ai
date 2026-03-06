import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../widgets/combo_list.dart';
import 'shimmer_loading.dart';
import 'ui_action.dart';
import 'ui_registry.dart';

/// Renders a [GenerativeUiResponse] using the [UiRegistry].
///
/// Shows a [ShimmerLoading] skeleton while the data is "loading", then
/// cross-fades into the real content via [AnimatedSwitcher].
class GenUiRenderer extends StatefulWidget {
  final GenerativeUiResponse response;
  final UiAction? action;

  /// Simulated parsing delay (ms). Set to 0 to disable.
  final int shimmerDelayMs;

  const GenUiRenderer({
    super.key,
    required this.response,
    this.action,
    this.shimmerDelayMs = 400,
  });

  @override
  State<GenUiRenderer> createState() => _GenUiRendererState();
}

class _GenUiRendererState extends State<GenUiRenderer> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoad();
  }

  @override
  void didUpdateWidget(covariant GenUiRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.response != widget.response) {
      setState(() => _isLoading = true);
      _simulateLoad();
    }
  }

  Future<void> _simulateLoad() async {
    if (widget.shimmerDelayMs <= 0) {
      setState(() => _isLoading = false);
      return;
    }
    await Future.delayed(Duration(milliseconds: widget.shimmerDelayMs));
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final action = widget.action ?? const DefaultUiAction();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOut,
      child: _isLoading ? _buildShimmer() : _buildContent(action),
    );
  }

  Widget _buildShimmer() {
    switch (widget.response.displayType) {
      case DisplayType.list:
        return ShimmerLoading.list(
          key: const ValueKey('shimmer_list'),
          itemCount: widget.response.products.length.clamp(1, 4),
        );
      case DisplayType.grid:
        return ShimmerLoading.grid(
          key: const ValueKey('shimmer_grid'),
          itemCount: widget.response.products.length.clamp(1, 6),
        );
      case DisplayType.single:
        return ShimmerLoading.single(key: const ValueKey('shimmer_single'));
    }
  }

  Widget _buildContent(UiAction action) {
    return Column(
      key: const ValueKey('genui_content'),
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        UiRegistry.instance.build(widget.response, action),
        ComboList(combos: widget.response.combos),
      ],
    );
  }
}
