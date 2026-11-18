import 'package:flutter/gestures.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';

/// Sürüklenebilir öğe. [builder]'a verilen tutamaçtan tutunca hemen, öğenin kendisine
/// basılı tutunca sürüklenir. Parmak listenin üst ya da alt kenarına gelince liste
/// kendiliğinden kayar; Flutter'ın Draggable'ı bunu kendisi yapmaz.
/// Ekran okuyucu için "Taşı" gibi dokunmalı bir alternatif ayrıca sunulmalı (UX_RULES §9).
class DragItem<T extends Object> extends StatefulWidget {
  const DragItem({
    super.key,
    required this.data,
    required this.label,
    required this.builder,
    this.bottomOverlay = 0,
  });

  final T data;

  /// Sürüklenirken parmağın altında görünen metin.
  final String label;

  /// Tutamacı öğenin içine yerleştirir.
  final Widget Function(BuildContext context, Widget handle) builder;

  /// Listenin altını örten yükseklik (havada duran alt menü); kayma onun üstünde başlar.
  final double bottomOverlay;

  @override
  State<DragItem<T>> createState() => _DragItemState<T>();
}

class _DragItemState<T extends Object> extends State<DragItem<T>> {
  static const _edge = 56.0;

  EdgeDraggingAutoScroller? _scroller;
  var _dragging = false;
  int? _pointer;
  Offset? _position;

  void _start() {
    final scrollable = Scrollable.maybeOf(context);
    _scroller = scrollable == null
        ? null
        : EdgeDraggingAutoScroller(
            scrollable,
            velocityScalar: 50,
            onScrollViewScrolled: _scrolled,
          );
    setState(() => _dragging = true);
  }

  void _update(DragUpdateDetails d) {
    _position = d.globalPosition;
    _autoScroll();
  }

  /// Kaydırıcı parmağın yerini liste içeriğine göre tutar; her adımdan sonra
  /// güncellenmezse ilk adımda durur.
  void _autoScroll() {
    final p = _position;
    if (p == null) return;
    _scroller?.startAutoScrollIfNecessary(
      Rect.fromLTRB(
        p.dx,
        p.dy - _edge,
        p.dx + 1,
        p.dy + _edge + widget.bottomOverlay,
      ),
    );
  }

  void _scrolled() {
    _autoScroll();
    _refreshTarget();
  }

  /// Liste parmağın altında kayınca bırakılacak hedef de değişir. Draggable bunu ancak
  /// parmak oynayınca fark eder; yoksa bırakınca eski hedefe düşerdi. Bu yüzden yeni
  /// yerleşimden sonra aynı noktada sentetik bir hareket olayı gönderilir. (Kayma
  /// sürerken liste dokunuşları yok sayar; o an bırakılırsa taşıma iptal olur.)
  void _refreshTarget() => WidgetsBinding.instance.addPostFrameCallback((_) {
    final (pointer, position) = (_pointer, _position);
    if (pointer == null || position == null || _scroller == null) return;
    GestureBinding.instance.handlePointerEvent(
      PointerMoveEvent(pointer: pointer, position: position, synthesized: true),
    );
  });

  void _end() {
    _scroller?.stopAutoScroll();
    _scroller = null;
    if (mounted) setState(() => _dragging = false);
  }

  @override
  Widget build(BuildContext context) {
    final feedback = Material(
      elevation: 6,
      borderRadius: BorderRadius.circular(AppTokens.of(context).radius),
      child: Padding(
        padding: const EdgeInsets.all(Gap.m),
        child: Text(widget.label),
      ),
    );
    final handle = Draggable<T>(
      data: widget.data,
      feedback: feedback,
      hitTestBehavior: HitTestBehavior.opaque,
      onDragStarted: _start,
      onDragUpdate: _update,
      onDragCompleted: _end,
      onDraggableCanceled: (_, _) => _end(),
      child: const ExcludeSemantics(
        child: SizedBox.square(
          dimension: 48,
          child: Icon(Symbols.drag_indicator_rounded),
        ),
      ),
    );
    return Listener(
      onPointerDown: (e) => _pointer = e.pointer,
      child: LongPressDraggable<T>(
        data: widget.data,
        feedback: feedback,
        onDragStarted: _start,
        onDragUpdate: _update,
        onDragCompleted: _end,
        onDraggableCanceled: (_, _) => _end(),
        child: Opacity(
          opacity: _dragging ? 0.4 : 1,
          child: widget.builder(context, handle),
        ),
      ),
    );
  }
}
