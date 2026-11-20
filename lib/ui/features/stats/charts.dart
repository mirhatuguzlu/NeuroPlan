import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../core/format.dart';

/// Grafikler yalnız gösterir; hesap çekirdektedir (`neuroplan_core` stats). Kurallar
/// (UX_RULES §12, dataviz): ince işaret, 2 px çizgi, sessiz ızgara, tek eksen, ≥ 2 seride
/// lejant, renk tek başına bilgi taşımaz, yazı rengi seri rengi değildir; her grafiğin
/// liste görünümü ve ekran okuyucu özeti vardır. Dokununca seçim sayfaya bildirilir.

class ChartSeries {
  const ChartSeries(this.label, this.values, this.color);
  final String label;
  final List<double?> values;
  final Color color;
}

TextStyle? _axis(BuildContext c) =>
    Theme.of(c).textTheme.labelSmall
        ?.copyWith(color: Theme.of(c).colorScheme.onSurfaceVariant);

/// X ekseninde en çok ~6 etiket.
bool _showX(int i, int n) => n <= 7 || i % (n / 6).ceil() == 0 || i == n - 1;

/// Zaman serisi (çizgi). [maxY] verilmezse en büyük değerden.
class TrendChart extends StatelessWidget {
  const TrendChart({
    super.key,
    required this.series,
    required this.xLabel,
    required this.yLabel,
    required this.semantics,
    this.minY = 0,
    this.maxY,
    this.selected,
    this.onSelect,
    this.height = 220,
  });

  final List<ChartSeries> series;
  final String Function(int i) xLabel;
  final String Function(double v) yLabel;

  /// Ekran okuyucu için tek cümle.
  final String semantics;
  final double minY;
  final double? maxY;
  final int? selected;
  final ValueChanged<int>? onSelect;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final grid = ChartColors.from(context).grid;
    final n = series.isEmpty ? 0 : series.first.values.length;
    final top =
        maxY ??
        math.max(
          1.0,
          series
              .expand((s) => s.values)
              .whereType<double>()
              .fold(0.0, math.max),
        );
    return Semantics(
      label: semantics,
      child: SizedBox(
        height: height,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: math.max(1, n - 1).toDouble(),
            minY: minY,
            maxY: top * (maxY == null ? 1.1 : 1),
            gridData: FlGridData(
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: grid, strokeWidth: 1),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(bottom: BorderSide(color: scheme.outline)),
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(),
              rightTitles: const AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 44,
                  getTitlesWidget: (v, m) => v == m.max
                      ? const SizedBox.shrink()
                      : Text(yLabel(v), style: _axis(context)),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: 1,
                  reservedSize: 28,
                  getTitlesWidget: (v, m) {
                    final i = v.round();
                    if (v != i || i < 0 || i >= n || !_showX(i, n)) {
                      return const SizedBox.shrink();
                    }
                    return SideTitleWidget(
                      meta: m,
                      child: Text(xLabel(i), style: _axis(context)),
                    );
                  },
                ),
              ),
            ),
            lineTouchData: LineTouchData(
              handleBuiltInTouches: true,
              touchTooltipData: LineTouchTooltipData(
                getTooltipColor: (_) => scheme.inverseSurface,
                fitInsideHorizontally: true,
                fitInsideVertically: true,
                getTooltipItems: (spots) => [
                  for (final s in spots)
                    LineTooltipItem(
                      '${series[s.barIndex].label}: ${yLabel(s.y)}',
                      TextStyle(color: scheme.onInverseSurface),
                    ),
                ],
              ),
              touchCallback: (e, r) {
                final i = r?.lineBarSpots?.firstOrNull?.spotIndex;
                if (e is FlTapUpEvent && i != null) onSelect?.call(i);
              },
            ),
            extraLinesData: selected == null
                ? null
                : ExtraLinesData(
                    verticalLines: [
                      VerticalLine(
                        x: selected!.toDouble(),
                        color: scheme.onSurfaceVariant,
                        strokeWidth: 1,
                      ),
                    ],
                  ),
            lineBarsData: [
              for (final s in series)
                LineChartBarData(
                  spots: [
                    for (var i = 0; i < s.values.length; i++)
                      s.values[i] == null
                          ? FlSpot.nullSpot
                          : FlSpot(i.toDouble(), s.values[i]!),
                  ],
                  color: s.color,
                  barWidth: 2,
                  isCurved: false,
                  dotData: FlDotData(show: n <= 31),
                ),
            ],
          ),
          duration: AppTokens.duration(context, Durations.medium2),
        ),
      ),
    );
  }
}

/// Sütunlar; grup başına bir ya da iki seri (yan yana).
class ColumnChart extends StatelessWidget {
  const ColumnChart({
    super.key,
    required this.series,
    required this.xLabel,
    required this.yLabel,
    required this.semantics,
    this.selected,
    this.onSelect,
    this.height = 220,
    this.reference,
  });

  final List<ChartSeries> series;
  final String Function(int i) xLabel;
  final String Function(double v) yLabel;
  final String semantics;

  /// Hedef çizgisi (ör. uyku hedefi); düz ince çizgi, etiketi grafiğin altında yazılır.
  final double? reference;
  final int? selected;
  final ValueChanged<int>? onSelect;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final grid = ChartColors.from(context).grid;
    final n = series.first.values.length;
    final top = math.max(
      1.0,
      [
        ?reference,
        ...series.expand((s) => s.values).whereType<double>(),
      ].fold(0.0, math.max),
    );
    return LayoutBuilder(
      builder: (context, box) {
        final slot = (box.maxWidth - 52) / math.max(1, n);
        final width = (slot * 0.7 / series.length - 2).clamp(2.0, 18.0);
        return Semantics(
          label: semantics,
          child: SizedBox(
            height: height,
            child: BarChart(
              BarChartData(
                maxY: top * 1.1,
                gridData: FlGridData(
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) =>
                      FlLine(color: grid, strokeWidth: 1),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(bottom: BorderSide(color: scheme.outline)),
                ),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(),
                  rightTitles: const AxisTitles(),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 44,
                      getTitlesWidget: (v, m) => v == m.max
                          ? const SizedBox.shrink()
                          : Text(yLabel(v), style: _axis(context)),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      getTitlesWidget: (v, m) {
                        final i = v.round();
                        if (i < 0 || i >= n || !_showX(i, n)) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: m,
                          child: Text(xLabel(i), style: _axis(context)),
                        );
                      },
                    ),
                  ),
                ),
                extraLinesData: reference == null
                    ? null
                    : ExtraLinesData(
                        horizontalLines: [
                          HorizontalLine(
                            y: reference!,
                            color: scheme.onSurfaceVariant,
                            strokeWidth: 1.5,
                          ),
                        ],
                      ),
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => scheme.inverseSurface,
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    getTooltipItem: (g, gi, rod, ri) => BarTooltipItem(
                      '${series[ri].label}: ${yLabel(rod.toY)}',
                      TextStyle(color: scheme.onInverseSurface),
                    ),
                  ),
                  touchCallback: (e, r) {
                    final i = r?.spot?.touchedBarGroupIndex;
                    if (e is FlTapUpEvent && i != null) onSelect?.call(i);
                  },
                ),
                barGroups: [
                  for (var i = 0; i < n; i++)
                    BarChartGroupData(
                      x: i,
                      barsSpace: 2,
                      barRods: [
                        for (final s in series)
                          BarChartRodData(
                            toY: s.values[i] ?? 0,
                            color: selected == null || selected == i
                                ? s.color
                                : s.color.withValues(alpha: 0.45),
                            width: width,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              duration: AppTokens.duration(context, Durations.medium2),
            ),
          ),
        );
      },
    );
  }
}

/// Sıralı yatay çubuklar: tek seri, tek renk (dataviz: adlı kategoriler değere göre
/// boyanmaz). Etiket ve değer metin olarak görünür; satır dokunulabilir.
class RankedBars extends StatelessWidget {
  const RankedBars({super.key, required this.rows, this.onTap});

  final List<RankedRow> rows;
  final ValueChanged<String>? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = ChartColors.from(context).series.first;
    final top = rows.map((r) => r.value).fold(0.0, math.max);
    return Column(
      children: [
        for (final r in rows)
          MergeSemantics(
            child: InkWell(
              borderRadius: BorderRadius.circular(AppTokens.of(context).radius),
              onTap: onTap == null || !r.tappable ? null : () => onTap!(r.key),
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 48),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Gap.xs),
                  child: Row(
                    children: [
                      if (r.leading != null) ...[
                        r.leading!,
                        const SizedBox(width: Gap.m),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    r.label,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                                const SizedBox(width: Gap.s),
                                // Büyük yazıda değer alt satıra kayar, taşmaz.
                                Flexible(
                                  child: Text(
                                    r.valueText,
                                    textAlign: TextAlign.end,
                                    style: theme.textTheme.labelLarge,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: Gap.xs),
                            ExcludeSemantics(
                              child: LayoutBuilder(
                                builder: (_, box) => Align(
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Container(
                                    height: 8,
                                    width: top == 0
                                        ? 0
                                        : math.max(
                                            r.value > 0 ? 4 : 0,
                                            box.maxWidth * r.value / top,
                                          ),
                                    decoration: BoxDecoration(
                                      color: r.color ?? color,
                                      borderRadius:
                                          const BorderRadius.horizontal(
                                            right: Radius.circular(4),
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (onTap != null && r.tappable)
                        Icon(
                          Symbols.chevron_right_rounded,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class RankedRow {
  const RankedRow({
    required this.key,
    required this.label,
    required this.value,
    required this.valueText,
    this.leading,
    this.tappable = true,
    this.color,
  });
  final String key;
  final String label;
  final double value;
  final String valueText;
  final Widget? leading;
  final bool tappable;

  /// Satırın kendi rengi (kök kategori, D55); yoksa tek seri rengi.
  final Color? color;
}

/// Seri adları: renk kutusu + ad (renk yanında her zaman metin).
class ChartLegend extends StatelessWidget {
  const ChartLegend({super.key, required this.series});
  final List<ChartSeries> series;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Wrap(
      spacing: Gap.l,
      runSpacing: Gap.xs,
      children: [
        for (final s in series)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: s.color,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: Gap.xs),
              Flexible(
                child: Text(
                  s.label,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ],
          ),
      ],
    ),
  );
}

/// Saat × haftanın günü ısı haritası (sıralı tek renk; boş hücre ayrı ton).
/// [value] 0..1 ya da veri yoksa null.
class HeatGrid extends StatelessWidget {
  const HeatGrid({
    super.key,
    required this.value,
    required this.semantics,
    this.selected,
    this.onSelect,
  });

  final double? Function(int weekday, int hour) value;
  final String semantics;
  final (int, int)? selected;
  final void Function(int weekday, int hour)? onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = ChartColors.from(context);
    final scheme = Theme.of(context).colorScheme;
    const labelW = 36.0;
    return Semantics(
      label: semantics,
      child: LayoutBuilder(
        builder: (context, box) {
          final cell = (box.maxWidth - labelW) / 24;
          final rowH = math.max(cell, 18.0);
          // Tek dokunma alanı: hücreler 48 dp'den küçük; hücre konumdan bulunur (D55).
          final grid = GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapUp: onSelect == null
                ? null
                : (e) {
                    final d = (e.localPosition.dy ~/ rowH) + 1;
                    final h = ((e.localPosition.dx - labelW) ~/ cell);
                    if (d >= 1 && d <= 7 && h >= 0 && h < 24) onSelect!(d, h);
                  },
            child: Column(
              children: [
                for (var d = 1; d <= 7; d++)
                  Row(
                    children: [
                      SizedBox(
                        width: labelW,
                        child: Text(
                          weekdayShort(context, d),
                          style: _axis(context),
                        ),
                      ),
                      for (var h = 0; h < 24; h++)
                        Container(
                          width: cell,
                          height: rowH,
                          padding: const EdgeInsets.all(1),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: switch (value(d, h)) {
                                null => colors.empty,
                                final v => colors.level(v),
                              },
                              borderRadius: BorderRadius.circular(2),
                              border: selected == (d, h)
                                  ? Border.all(
                                      color: scheme.onSurface,
                                      width: 2,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                    ],
                  ),
              ],
            ),
          );
          return Column(
            children: [
              grid,
              Row(
                children: [
                  const SizedBox(width: labelW),
                  for (final h in const [0, 6, 12, 18])
                    SizedBox(
                      width: cell * 6,
                      child: Text(
                        clockOfDay(context, h * 60),
                        style: _axis(context),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Sıralı renk ölçeği lejantı: az → çok.
class RampLegend extends StatelessWidget {
  const RampLegend({super.key, required this.low, required this.high});
  final String low;
  final String high;

  @override
  Widget build(BuildContext context) {
    final c = ChartColors.from(context);
    return ExcludeSemantics(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(low, style: _axis(context)),
          const SizedBox(width: Gap.xs),
          for (final r in [c.empty, ...c.ramp])
            Container(
              width: 14,
              height: 14,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: r,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          const SizedBox(width: Gap.xs),
          Text(high, style: _axis(context)),
        ],
      ),
    );
  }
}

/// GitHub tarzı yıllık takvim: sütun = hafta (pazartesi üstte), en yeni hafta sağda.
/// Yatay kayar, açılışta bugün görünür.
class YearCalendar extends StatelessWidget {
  const YearCalendar({
    super.key,
    required this.weeks,
    required this.level,
    required this.semantics,
    this.selected,
    this.onSelect,
  });

  /// Gösterilecek hafta sayısı (bugünün haftası dahil).
  final int weeks;

  /// (hafta, gün) → 0..1, aktif değilse null; geleceği gösterme: -1.
  final double? Function(int week, int weekday) level;
  final String semantics;
  final (int, int)? selected;
  final void Function(int week, int weekday)? onSelect;

  @override
  Widget build(BuildContext context) {
    final colors = ChartColors.from(context);
    final scheme = Theme.of(context).colorScheme;
    const cell = 16.0;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Semantics(
        label: semantics,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          // Tek dokunma alanı (hücreler 48 dp'den küçük); gelecek günler seçilmez.
          onTapUp: onSelect == null
              ? null
              : (e) {
                  final w = e.localPosition.dx ~/ cell;
                  final d = (e.localPosition.dy ~/ cell) + 1;
                  if (w >= 0 &&
                      w < weeks &&
                      d >= 1 &&
                      d <= 7 &&
                      level(w, d) != -1) {
                    onSelect!(w, d);
                  }
                },
          child: Row(
            children: [
              for (var w = 0; w < weeks; w++)
                Column(
                  children: [
                    for (var d = 1; d <= 7; d++)
                      Container(
                        width: cell,
                        height: cell,
                        padding: const EdgeInsets.all(1.5),
                        child: switch (level(w, d)) {
                          -1 => const SizedBox.shrink(),
                          final v => DecoratedBox(
                            decoration: BoxDecoration(
                              color: v == null ? colors.empty : colors.level(v),
                              borderRadius: BorderRadius.circular(3),
                              border: selected == (w, d)
                                  ? Border.all(
                                      color: scheme.onSurface,
                                      width: 2,
                                    )
                                  : null,
                            ),
                          ),
                        },
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
