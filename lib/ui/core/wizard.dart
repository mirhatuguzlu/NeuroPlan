import 'feedback.dart';

import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../app/theme.dart';
import '../../app/transitions.dart';
import 'format.dart';
import 'states.dart';

/// Sihirbaz adımı: tek soru, ilerleme "n / N", geri dönülebilir (UX_RULES §2).
class WizardStep {
  const WizardStep({
    required this.id,
    required this.title,
    required this.body,
    this.subtitle,
    this.optional = false,
    this.canNext = true,
    this.nextLabel,
    this.onNext,
    this.onSkip,
  });

  /// Geçiş animasyonu için kalıcı anahtar.
  final String id;
  final String title;
  final String? subtitle;
  final Widget body;

  /// "Şimdilik geç" gösterilir.
  final bool optional;
  final bool canNext;
  final String? nextLabel;

  /// İleri basıldığında adımın sonucunu kaydeder; hata olursa adım değişmez.
  final Future<void> Function()? onNext;

  /// "Şimdilik geç"in kendi eylemi (verilmezse sonraki adıma geçer).
  final Future<void> Function()? onSkip;
}

class WizardScaffold extends StatefulWidget {
  const WizardScaffold({
    super.key,
    required this.steps,
    required this.onFinish,
    this.onClose,
  });

  final List<WizardStep> steps;

  /// Son adımda İleri.
  final Future<void> Function() onFinish;

  /// İlk adımda geri (null = kapatma yok).
  final VoidCallback? onClose;

  @override
  State<WizardScaffold> createState() => WizardScaffoldState();
}

class WizardScaffoldState extends State<WizardScaffold> {
  var _index = 0;
  var _reverse = false;

  int get index => _index;

  void _go(int to) => setState(() {
    _reverse = to < _index;
    _index = to.clamp(0, widget.steps.length - 1);
  });

  Future<void> _next({required bool skip}) async {
    final step = widget.steps[_index];
    if (skip && step.onSkip != null) {
      // Atlamanın kendi eylemi (ör. alanı temizle) çalışır, sonra sonraki adıma geçilir.
      if (!await guard(context, step.onSkip!) || !mounted) return;
      if (_index < widget.steps.length - 1) {
        _go(_index + 1);
        return;
      }
      // Son adımda atlamak da bitirir (düzenlemede tek adım: "temizle ve kaydet").
      final saved = await guard(context, widget.onFinish);
      if (saved && mounted) Haptics.success(context);
      return;
    }
    if (!skip && step.onNext != null) {
      if (!await guard(context, step.onNext!)) return;
    }
    if (!mounted) return;
    if (_index == widget.steps.length - 1) {
      final saved = await guard(context, widget.onFinish);
      if (saved && mounted) Haptics.success(context);
    } else {
      _go(_index + 1);
    }
  }

  void _back() => _index == 0 ? widget.onClose?.call() : _go(_index - 1);

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final steps = widget.steps;
    if (_index >= steps.length) _index = steps.length - 1;
    final step = steps[_index];
    final last = _index == steps.length - 1;
    return PopScope(
      canPop: _index == 0 && widget.onClose == null,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _back();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: _index == 0 && widget.onClose == null
              ? null
              : IconButton(
                  tooltip: _index == 0 ? l.commonClose : l.commonBack,
                  icon: Icon(
                    _index == 0
                        ? Symbols.close_rounded
                        : Symbols.arrow_back_rounded,
                  ),
                  onPressed: _back,
                ),
          automaticallyImplyLeading: false,
          title: Semantics(
            liveRegion: true,
            child: Text(l.stepProgress(_index + 1, steps.length)),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: (_index + 1) / steps.length),
              duration: AppTokens.duration(context, Durations.medium2),
              builder: (_, v, _) => LinearProgressIndicator(value: v),
            ),
          ),
        ),
        body: SafeArea(
          child: SharedAxisSwitch(
            reverse: _reverse,
            child: KeyedSubtree(
              key: ValueKey(step.id),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  Gap.xl,
                  Gap.xl,
                  Gap.xl,
                  Gap.xxl,
                ),
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      step.title,
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  if (step.subtitle != null) ...[
                    const SizedBox(height: Gap.s),
                    Text(step.subtitle!, style: theme.textTheme.bodyLarge),
                  ],
                  const SizedBox(height: Gap.xl),
                  step.body,
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
          minimum: const EdgeInsets.fromLTRB(Gap.l, Gap.s, Gap.l, Gap.l),
          // Dar ekranda ya da büyük yazı ölçeğinde butonlar alt alta dizilir (UX_RULES §9).
          child: OverflowBar(
            alignment: MainAxisAlignment.spaceBetween,
            overflowAlignment: OverflowBarAlignment.end,
            overflowSpacing: Gap.s,
            children: [
              if (step.optional)
                TextButton(
                  onPressed: () => _next(skip: true),
                  child: Text(l.commonSkip),
                )
              else
                const SizedBox.shrink(),
              BusyButton(
                label: step.nextLabel ?? (last ? l.commonSave : l.commonNext),
                onPressed: step.canNext ? () => _next(skip: false) : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Sihirbazlarda tek seçimli liste (radyo). Her seçenek 56dp satır.
class ChoiceList<T> extends StatelessWidget {
  const ChoiceList({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final T? value;
  final List<(T, String, String?)> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) => RadioGroup<T>(
    groupValue: value,
    onChanged: (v) => v == null ? null : onChanged(v),
    child: Column(
      children: [
        for (final (v, label, hint) in options)
          RadioListTile<T>(
            value: v,
            title: Text(label),
            subtitle: hint == null ? null : Text(hint),
          ),
      ],
    ),
  );
}

/// Saat seçen satır; sistem saat seçicisini açar (D29).
class TimeTile extends StatelessWidget {
  const TimeTile({
    super.key,
    required this.label,
    required this.minuteOfDay,
    required this.onChanged,
  });

  final String label;
  final int minuteOfDay;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(label),
    trailing: Text(
      clockOfDay(context, minuteOfDay),
      style: Theme.of(context).textTheme.titleMedium,
    ),
    leading: const Icon(Symbols.schedule_rounded),
    onTap: () async {
      final t = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: minuteOfDay ~/ 60,
          minute: minuteOfDay % 60,
        ),
      );
      if (t != null) onChanged(t.hour * 60 + t.minute);
    },
  );
}

class DateTile extends StatelessWidget {
  const DateTile({
    super.key,
    required this.label,
    required this.date,
    required this.onChanged,
    this.trailing,
  });

  final String label;
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(label),
    subtitle: Text(dateText(context, date.toIso8601String().substring(0, 10))),
    leading: const Icon(Symbols.event_rounded),
    trailing: trailing,
    onTap: () async {
      final now = DateTime.now();
      final d = await showDatePicker(
        context: context,
        initialDate: date,
        firstDate: DateTime(now.year - 1),
        lastDate: DateTime(now.year + 5),
      );
      if (d != null) onChanged(d);
    },
  );
}

/// Tamsayı girişi: görünür etiket, hata alanın yanında, gönderirken ve çıkarken doğrulanır.
class NumberField extends StatelessWidget {
  const NumberField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 1440,
  });

  final String label;
  final int? value;
  final ValueChanged<int?> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) => TextFormField(
    initialValue: value?.toString() ?? '',
    keyboardType: TextInputType.number,
    autovalidateMode: AutovalidateMode.onUserInteraction,
    decoration: InputDecoration(labelText: label),
    validator: (v) {
      if (v == null || v.isEmpty) return null;
      final n = int.tryParse(v);
      return n == null || n < min || n > max
          ? context.l10n.wizNumberError(min, max)
          : null;
    },
    onChanged: (v) {
      final n = int.tryParse(v);
      onChanged(n != null && n >= min && n <= max ? n : null);
    },
  );
}
