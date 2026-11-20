import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';

/// Dokunsal geri bildirim (UX_RULES §5–6, D56): tek yer. Ayardaki "Dokunsal geri bildirim"
/// kapalıysa hiçbiri çalışmaz. Abartı yok: seçimde tık, tamamlanmada hafif darbe; canlı
/// temalarda (Eğlenceli, Genç) tamamlanma biraz daha belirgin, Kâğıt'ta yalnız tık.
abstract final class Haptics {
  static bool _on(BuildContext context) =>
      ProviderScope.containerOf(
        context,
        listen: false,
      ).read(profileProvider).value?.hapticsEnabled ??
      true;

  /// Sekme, seçim, anahtar.
  static void select(BuildContext context) {
    if (_on(context)) HapticFeedback.selectionClick();
  }

  /// İş bitti, odak tamamlandı, sihirbaz kaydedildi.
  static void success(BuildContext context) {
    if (!_on(context)) return;
    switch (AppTokens.of(context).theme.motion) {
      case Motion.lively || Motion.brisk:
        HapticFeedback.mediumImpact();
      case Motion.instant:
        HapticFeedback.selectionClick();
      case Motion.quiet || Motion.soft:
        HapticFeedback.lightImpact();
    }
  }
}
