import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'theme.dart';

// Sayfa geçişleri (UX_RULES §5). `animations` paketi eski `flutter/material`'e bağlı
// olduğu için (material_ui ile tema paylaşmaz) aynı desenler burada yazıldı (D28).

/// Shared axis (yatay): hiyerarşide ileri / geri (liste → detay, sihirbaz).
CustomTransitionPage<void> sharedAxisPage(GoRouterState state, Widget child) =>
    CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: Durations.medium4,
      reverseTransitionDuration: Durations.medium2,
      transitionsBuilder: (context, animation, secondary, child) =>
          SharedAxisSwitch.transition(context, animation, secondary, child),
    );

/// Aynı yerde değişen içerik için shared axis (sihirbaz adımları).
class SharedAxisSwitch extends StatelessWidget {
  const SharedAxisSwitch({
    super.key,
    required this.child,
    this.reverse = false,
  });

  final Widget child;

  /// Geri giderken içerik soldan gelir.
  final bool reverse;

  static Widget transition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondary,
    Widget child, {
    bool reverse = false,
  }) {
    if (!AppTokens.animates(context)) return child;
    final t = AppTokens.of(context);
    final sign = reverse ? -1.0 : 1.0;
    final inSlide = Tween(
      begin: Offset(0.15 * sign, 0),
      end: Offset.zero,
    ).chain(CurveTween(curve: t.enterCurve));
    final outSlide = Tween(
      begin: Offset.zero,
      end: Offset(-0.15 * sign, 0),
    ).chain(CurveTween(curve: t.exitCurve));
    return SlideTransition(
      position: animation.drive(inSlide),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: const Interval(0.3, 1),
        ),
        child: SlideTransition(
          position: secondary.drive(outSlide),
          child: FadeTransition(
            opacity: ReverseAnimation(
              CurvedAnimation(parent: secondary, curve: const Interval(0, 0.3)),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AnimatedSwitcher(
    duration: AppTokens.duration(context, Durations.medium4),
    transitionBuilder: (child, animation) {
      final incoming = child.key == this.child.key;
      final sign = (reverse ? -1.0 : 1.0) * (incoming ? 1 : -1);
      final curve = incoming
          ? AppTokens.of(context).enterCurve
          : AppTokens.of(context).exitCurve;
      return SlideTransition(
        position: animation.drive(
          Tween(
            begin: Offset(0.15 * sign, 0),
            end: Offset.zero,
          ).chain(CurveTween(curve: curve)),
        ),
        child: FadeTransition(opacity: animation, child: child),
      );
    },
    child: child,
  );
}

/// Fade through'nun giriş yarısı: alt menü sekmeleri arası (ilişkisiz ekranlar).
/// Sekme durumu korunsun diye çocuk yeniden kurulmaz; yalnız giriş canlandırılır.
class FadeThroughOnChange extends StatefulWidget {
  const FadeThroughOnChange({
    super.key,
    required this.index,
    required this.child,
  });

  final int index;
  final Widget child;

  @override
  State<FadeThroughOnChange> createState() => _FadeThroughOnChangeState();
}

class _FadeThroughOnChangeState extends State<FadeThroughOnChange>
    with SingleTickerProviderStateMixin {
  late final _c = AnimationController(vsync: this, value: 1);

  @override
  void didUpdateWidget(FadeThroughOnChange old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index) {
      _c.duration = AppTokens.duration(context, Durations.medium2);
      _c.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: _c,
      curve: AppTokens.of(context).enterCurve,
    );
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween(begin: 0.96, end: 1.0).animate(curved),
        child: widget.child,
      ),
    );
  }
}
