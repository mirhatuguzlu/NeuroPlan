import '../focus/focus_clock.dart';
import '../model/json_checks.dart';
import '../model/recurrence.dart';
import '../model/timing.dart';

// Plan motorunun girdi ve çıktı tipleri (docs/ARCHITECTURE.md §6). Zaman: UTC dakika
// (epoch / 60 000, tamsayı); gün: `YYYY-MM-DD`. Girdiler veri katmanında Drift
// satırlarından kurulur; motor yalnız okuduğu alanları bilir.

T _enum<T extends Enum>(List<T> values, String v, String field) =>
    values.firstWhere((e) => e.name == v, orElse: () => fail('$field: $v'));

enum Flexibility {
  fixed,
  shiftable,
  optional;

  static Flexibility fromJson(String v) => _enum(values, v, 'flexibility');
}

enum DayKeep {
  all('all'),
  fixedOnly('fixed_only'),
  none('none');

  const DayKeep(this.json);
  final String json;

  static DayKeep fromJson(String v) =>
      values.firstWhere((e) => e.json == v, orElse: () => fail('keep: $v'));
}

enum InstanceStatus {
  planned,
  done,
  skipped,
  moved,
  failed;

  static InstanceStatus fromJson(String v) => _enum(values, v, 'status');
}

enum InstanceSource {
  rule,
  auto,
  manual;

  static InstanceSource fromJson(String v) => _enum(values, v, 'source');
}

final class PlanActivity {
  const PlanActivity({
    required this.id,
    this.variantId,
    this.priority,
    this.estimatedMinutes,
    this.blocks,
  });

  final String id;

  /// Yalnız bu varyant seçildiği gün var olan alt aktivite.
  final String? variantId;

  /// 1 (yüksek) … 3 (düşük); null = 2.
  final int? priority;
  final int? estimatedMinutes;

  /// Derin çalışma blok planı (D66): süre saf odaktır, molalar planda yer kaplar; gün
  /// içine dağıtılırsa (kesin olmayan işte) her blok ayrı oluşum olur.
  final FocusBlocks? blocks;
}

final class PlanRule {
  const PlanRule({
    required this.id,
    required this.activityId,
    required this.recurrence,
    this.timing = Timing.none,
    this.durationMin,
    this.durationMax,
    this.flexibility = Flexibility.fixed,
    this.validFrom,
    this.validUntil,
    this.exceptionDates = const [],
  });

  final String id;
  final String activityId;
  final Recurrence recurrence;
  final Timing timing;
  final int? durationMin;
  final int? durationMax;
  final Flexibility flexibility;
  final String? validFrom;
  final String? validUntil;
  final List<String> exceptionDates;
}

final class PlanVariantGroup {
  const PlanVariantGroup({
    required this.id,
    required this.activityId,
    this.appliesOn,
    this.defaultVariantId,
  });

  final String id;
  final String activityId;
  final Recurrence? appliesOn;
  final String? defaultVariantId;
}

final class PlanVariant {
  const PlanVariant({
    required this.id,
    required this.groupId,
    this.timing,
    this.durationMin,
    this.durationMax,
    this.cancelsOccurrence = false,
  });

  final String id;
  final String groupId;
  final Timing? timing;
  final int? durationMin;
  final int? durationMax;
  final bool cancelsOccurrence;
}

/// `projects.preferred_windows` öğesi: `{"days":["MO"],"from":"09:00","to":"12:00"}`.
final class PreferredWindow {
  const PreferredWindow({
    this.weekdays = const {},
    required this.from,
    required this.to,
  });

  factory PreferredWindow.fromJson(Map<String, Object?> json) {
    const names = ['MO', 'TU', 'WE', 'TH', 'FR', 'SA', 'SU'];
    int minute(Object? v) {
      final c = ClockRef.parse(v is String ? v : fail('pencere saati: $v'));
      return c.hour * 60 + c.minute;
    }

    final days = json['days'];
    return PreferredWindow(
      weekdays: {
        if (days is List)
          for (final d in days)
            switch (names.indexOf(d as String)) {
              -1 => fail('pencere günü: $d'),
              final i => i + 1,
            },
      },
      from: minute(json['from']),
      to: minute(json['to']),
    );
  }

  /// 1 = pazartesi … 7 = pazar; boş = her gün.
  final Set<int> weekdays;
  final int from;
  final int to;
}

final class PlanProject {
  const PlanProject({
    required this.activityId,
    this.totalMinutes,
    this.deadline,
    this.autoSplit = true,
    this.minChunk,
    this.maxChunk,
    this.dailyCap,
    this.preferredWindows = const [],
    this.safetyMargin,
  });

  final String activityId;
  final int? totalMinutes;

  /// UTC dakika.
  final int? deadline;
  final bool autoSplit;
  final int? minChunk;
  final int? maxChunk;
  final int? dailyCap;
  final List<PreferredWindow> preferredWindows;
  final int? safetyMargin;
}

final class PlanDayOverride {
  const PlanDayOverride({
    this.date,
    this.recurrence,
    this.validFrom,
    this.validUntil,
    this.keep = DayKeep.all,
    this.autoPlacement = false,
  });

  final String? date;
  final Recurrence? recurrence;
  final String? validFrom;
  final String? validUntil;
  final DayKeep keep;
  final bool autoPlacement;
}

/// Veritabanındaki `plan_instances` satırı: kullanıcının dokunduğu oluşumlar.
final class PersistedInstance {
  const PersistedInstance({
    required this.id,
    required this.activityId,
    required this.date,
    this.ruleId,
    this.start,
    this.end,
    this.status = InstanceStatus.planned,
    this.source = InstanceSource.rule,
    this.variantId,
    this.isManual = false,
    this.minutes,
  });

  final String id;
  final String activityId;
  final String? ruleId;
  final String date;
  final int? start;
  final int? end;
  final InstanceStatus status;
  final InstanceSource source;
  final String? variantId;
  final bool isManual;

  /// Molada bitirilen işin kalan saf odağı (D69); saatsizse saatsiz bekler.
  final int? minutes;
}

/// Profil ayarları (docs/DB_SCHEMA.md §3.1); null = motor varsayılanı.
final class PlanSettings {
  const PlanSettings({
    required this.timezone,
    this.latitude,
    this.longitude,
    this.prayerMethod,
    this.prayerMadhab,
    this.minChunk,
    this.chunkBuffer,
    this.dailyFocusCap,
  });

  final String timezone;
  final double? latitude;
  final double? longitude;
  final String? prayerMethod;
  final String? prayerMadhab;
  final int? minChunk;
  final int? chunkBuffer;
  final int? dailyFocusCap;
}

final class PlanInput {
  const PlanInput({
    required this.settings,
    required this.from,
    required this.to,
    required this.asOf,
    this.activities = const [],
    this.rules = const [],
    this.variantGroups = const [],
    this.variants = const [],
    this.projects = const [],
    this.dayOverrides = const [],
    this.instances = const [],
  });

  final PlanSettings settings;

  /// Planlanan aralık, iki uç dahil.
  final String from;
  final String to;

  /// "Şimdi", UTC dakika. Motor saati kendisi okumaz.
  final int asOf;
  final List<PlanActivity> activities;
  final List<PlanRule> rules;
  final List<PlanVariantGroup> variantGroups;
  final List<PlanVariant> variants;
  final List<PlanProject> projects;
  final List<PlanDayOverride> dayOverrides;
  final List<PersistedInstance> instances;
}

// ---------------------------------------------------------------- çıktı

final class TimeSlot {
  const TimeSlot(this.start, this.end);
  final int start;
  final int end;
  int get minutes => end - start;

  @override
  bool operator ==(Object other) =>
      other is TimeSlot && other.start == start && other.end == end;
  @override
  int get hashCode => Object.hash(start, end);
  @override
  String toString() => 'TimeSlot($start, $end)';
}

final class PlannedInstance {
  const PlannedInstance({
    required this.id,
    required this.activityId,
    required this.date,
    required this.status,
    required this.source,
    required this.flexibility,
    this.ruleId,
    this.start,
    this.end,
    this.variantId,
    this.parentInstanceId,
    this.anchorActivityId,
    this.persisted = false,
    this.isManual = false,
    this.suggested = false,
    this.block,
    this.blocks,
    this.minutes,
  });

  final String id;
  final String activityId;
  final String? ruleId;
  final String date;

  /// null = saatsiz ("bugün bir ara").
  final int? start;
  final int? end;
  final InstanceStatus status;
  final InstanceSource source;
  final Flexibility flexibility;
  final String? variantId;
  final String? parentInstanceId;

  /// Saatsiz göreli işin bağlı olduğu aktivite ("yemekten sonra" etiketi).
  final String? anchorActivityId;

  /// Satır veritabanında var (kullanıcı dokunmuş).
  final bool persisted;
  final bool isManual;

  /// Saatsiz işe motorun önerdiği saat.
  final bool suggested;

  /// Gün içine dağıtılan derin çalışmada bu oluşumun sırası (1'den) ve blok sayısı.
  final int? block;
  final int? blocks;

  /// Kalan iş (D69): saf odak süresi; oturum bu kadar sürer.
  final int? minutes;

  bool get isTimed => start != null && end != null;
}

sealed class PlanIssue {
  const PlanIssue();
}

/// İki taşınamaz iş çakışıyor; motor karar vermez, kullanıcıya gösterir.
final class Overlap extends PlanIssue {
  const Overlap(this.a, this.b);
  final String a;
  final String b;
}

/// Kısıtları içinde yer bulunamayan iş: "tampon" listesi. [dropped] = isteğe bağlıydı, düştü.
final class Overflow extends PlanIssue {
  const Overflow(this.instanceId, {this.dropped = false});
  final String instanceId;
  final bool dropped;
}

/// Göreli bağımlılıkta döngü; bu aktivitelerin oluşumları saatsiz kalır.
final class DependencyCycle extends PlanIssue {
  const DependencyCycle(this.activityIds);
  final List<String> activityIds;
}

enum MissingData { location, prayerMethod }

/// Astronomik çapa için konum ya da namaz yöntemi yok; kısıt düştü.
final class MissingAnchorData extends PlanIssue {
  const MissingAnchorData(this.ruleId, this.missing);
  final String ruleId;
  final MissingData missing;
}

final class ChunkProposal {
  const ChunkProposal({
    required this.activityId,
    required this.date,
    required this.start,
    required this.end,
  });

  final String activityId;
  final String date;
  final int start;
  final int end;
  int get minutes => end - start;
}

/// SLOT-5: bu tempoyla son tarihe [missingMinutes] eksik kalıyor.
final class DeadlineRisk {
  const DeadlineRisk({
    required this.activityId,
    required this.deadline,
    required this.missingMinutes,
  });

  final String activityId;
  final int deadline;
  final int missingMinutes;
}

/// O gün varyantı seçilebilen oluşum (Bugün ekranındaki tek dokunuşluk seçim).
final class VariantChoice {
  const VariantChoice({
    required this.instanceId,
    required this.activityId,
    required this.ruleId,
    required this.date,
    required this.groupId,
    this.selectedVariantId,
    this.explicit = false,
  });

  final String instanceId;
  final String activityId;
  final String ruleId;
  final String date;
  final String groupId;

  /// Uygulanan varyant (seçim ya da varsayılan); null = aktivite olduğu gibi.
  final String? selectedVariantId;

  /// Kullanıcı o gün için seçti (varsayılan değil).
  final bool explicit;
}

final class PlanOutput {
  const PlanOutput({
    required this.instances,
    required this.freeSlots,
    required this.unplannedDays,
    required this.issues,
    required this.proposals,
    required this.risks,
    required this.variantChoices,
    required this.engineVersion,
  });

  final List<PlannedInstance> instances;

  /// Gün → boş dilimler; plansız günlerde anahtar yoktur.
  final Map<String, List<TimeSlot>> freeSlots;
  final Set<String> unplannedDays;
  final List<PlanIssue> issues;
  final List<ChunkProposal> proposals;
  final List<DeadlineRisk> risks;
  final List<VariantChoice> variantChoices;
  final int engineVersion;

  Iterable<Overflow> get overflow => issues.whereType<Overflow>();
}
