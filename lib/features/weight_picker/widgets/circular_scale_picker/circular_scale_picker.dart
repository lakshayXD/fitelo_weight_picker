import 'package:fitelo_assignment/features/weight_picker/widgets/circular_scale_picker/painters/pin_painter.dart';
import 'package:fitelo_assignment/features/weight_picker/widgets/circular_scale_picker/painters/top_arc_ticks_painter.dart';
import 'package:flutter/material.dart';

class CircularScalePicker extends StatefulWidget {
  final int min;
  final int initialValue;
  final double radius;
  final double itemExtent;
  final int visibleItemCount;
  final ValueChanged<int>? onChanged;

  const CircularScalePicker({
    super.key,
    required this.min,
    required this.initialValue,
    this.radius = 120,
    this.itemExtent = 24,
    this.visibleItemCount = 41,
    this.onChanged,
  });

  @override
  State<CircularScalePicker> createState() => _CircularScalePickerState();
}

class _CircularScalePickerState extends State<CircularScalePicker> {
  late final ScrollController _controller;
  bool _snapping = false;
  double _lastOffset = 0.0;
  bool _isScrollingForward = true;

  double get _offset => _controller.hasClients ? _controller.offset : 0.0;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final double initialOffset =
          (widget.initialValue - widget.min) * widget.itemExtent;
      if (_controller.hasClients) {
        _controller.jumpTo(initialOffset.clamp(0.0, double.infinity));
        setState(() {});
      } else {
        Future.microtask(() {
          if (_controller.hasClients) {
            _controller.jumpTo(initialOffset.clamp(0.0, double.infinity));
            setState(() {});
          }
        });
      }
    });

    _controller.addListener(() {
      if (!_snapping) {
        final currentOffset = _controller.offset;
        _isScrollingForward = currentOffset >= _lastOffset;
        _lastOffset = currentOffset;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _selectedValueFromOffset(double offset) {
    final idx = offset / (widget.itemExtent * 20);
    return double.parse((widget.min + idx).toStringAsFixed(2));
  }

  void _snapToNearest() {
    if (!_controller.hasClients) return;
    final double rawIndex = _controller.offset / widget.itemExtent;
    final int targetIndex = rawIndex.round().clamp(0, 1 << 31);
    final double targetOffset = targetIndex * widget.itemExtent;

    _snapping = true;
    _controller
        .animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOut,
    )
        .whenComplete(() {
      _snapping = false;
      setState(() {});
      widget.onChanged?.call(widget.min + targetIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double diameter = widget.radius * 2;
    final double height = widget.radius + 80;
    final double width = diameter;
    final double selectedValue = _selectedValueFromOffset(_offset);

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: TopArcTicksPainter(
                scrollOffset: _offset,
                min: widget.min,
                itemExtent: widget.itemExtent,
                visibleItemCount: widget.visibleItemCount,
                radius: widget.radius,
                textStyle:
                Theme.of(context).textTheme.bodyMedium ??
                    const TextStyle(fontSize: 12),
              ),
            ),
          ),
          Positioned.fill(
            child: CustomPaint(
              painter: PinPainter(
                innerRadius: widget.radius - 80,
                // same as your inner border radius
                outerRadius: widget.radius + 8,
                // same as your outer border radius
                center: Offset(
                  width / 2,
                  widget.radius,
                ),
              ),
            ),
          ),
          Positioned(
            top: widget.radius - 18,
            child: Text(
              selectedValue % 1 == 0
                  ? "${selectedValue.toInt()} kg"
                  : "$selectedValue kg",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollEndNotification) {
                _snapToNearest();
              }
              return false;
            },
            child: SizedBox(
              width: width,
              height: height,
              child: Stack(
                children: [
                  ListView.builder(
                    controller: _controller,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: height / 2 - 12,
                      bottom: height / 2 - 12,
                    ),
                    itemExtent: widget.itemExtent,
                    itemBuilder: (context, index) => const SizedBox.shrink(),
                  ),
                  Positioned(
                    top: 0,
                    bottom: 0,
                    left: 0,
                    width: width / 2,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onVerticalDragStart: (_) {},
                      onVerticalDragUpdate: (_) {},
                      onVerticalDragEnd: (_) {},
                    ),
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}