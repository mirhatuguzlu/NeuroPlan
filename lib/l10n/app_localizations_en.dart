// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NeuroPlan';

  @override
  String get navToday => 'Today';

  @override
  String get navPlan => 'Plan';

  @override
  String get navBrain => 'Brain';

  @override
  String get navProfile => 'Profile';

  @override
  String get actionAdd => 'Add';

  @override
  String get commonNext => 'Next';

  @override
  String get commonBack => 'Back';

  @override
  String get commonClose => 'Close';

  @override
  String get commonSkip => 'Skip for now';

  @override
  String get commonSave => 'Save';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonLoading => 'Loading';

  @override
  String errorTitle(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Whoops, something got stuck',
      'young': 'Oops, something went wrong',
      'coder': 'Unhandled exception',
      'calm': 'A small hiccup',
      'other': 'Something went wrong',
    });
    return '$_temp0';
  }

  @override
  String errorBody(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful':
          'Your data is safe and sound on your device. Shall we try again?',
      'young': 'Your data is safe on your device. Give it another go!',
      'coder': 'Local data is intact, nothing lost. Retry.',
      'calm': 'Your data is safe on your device. Try again when you\'re ready.',
      'other': 'Your data is safe on this device. You can try again.',
    });
    return '$_temp0';
  }

  @override
  String saveError(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'We couldn\'t save that, let\'s try once more.',
      'young': 'Not saved, try again!',
      'coder': 'Write failed. Retry.',
      'calm': 'Couldn\'t save. You can try again in a moment.',
      'other': 'Couldn\'t save. Try again.',
    });
    return '$_temp0';
  }

  @override
  String stepProgress(int current, int total) {
    return '$current / $total';
  }

  @override
  String minutesShort(int n) {
    return '$n min';
  }

  @override
  String hoursShort(int h) {
    return '$h h';
  }

  @override
  String hoursMinutes(int h, int m) {
    return '$h h $m min';
  }

  @override
  String inDuration(String duration) {
    return 'in $duration';
  }

  @override
  String timeRange(String from, String to) {
    return '$from–$to';
  }

  @override
  String get langSystem => 'Device language';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get langEnglish => 'English';

  @override
  String get modeSystem => 'Match device';

  @override
  String get modeLight => 'Light';

  @override
  String get modeDark => 'Dark';

  @override
  String get onbLanguageTitle => 'Which language should we use?';

  @override
  String get onbAppearanceTitle => 'How should it look?';

  @override
  String get onbAppearanceBody =>
      'Pick light or dark and a theme. You can change it any time in Settings.';

  @override
  String get onbSleepTitle => 'When do you usually sleep?';

  @override
  String get onbSleepBody =>
      'We protect your sleep window: automatic planning never puts anything there.';

  @override
  String get sleepBedtime => 'Bedtime';

  @override
  String get sleepWake => 'Wake-up';

  @override
  String get sleepActivityTitle => 'Sleep';

  @override
  String get onbLocationTitle => 'Use your location?';

  @override
  String get onbLocationBody =>
      'To tie something to sunrise or sunset we need your approximate location. It is stored with about 11 km precision and never shared. You can skip this step.';

  @override
  String get locationAllow => 'Use location';

  @override
  String get locationSaved => 'Location saved';

  @override
  String get locationDenied =>
      'Location permission wasn\'t granted. You can turn it on later in Profile.';

  @override
  String get locationError =>
      'Couldn\'t get your location. Make sure location services are on.';

  @override
  String get onbPrayerTitle => 'Would you like to use prayer times?';

  @override
  String get onbPrayerBody =>
      'You can tie your own activities to prayer times, for example 30 minutes after maghrib. Times are calculated offline from your location and are only used as anchors.';

  @override
  String get prayerEnable => 'Turn on prayer times';

  @override
  String get prayerMethod => 'Calculation method';

  @override
  String get prayerMadhab => 'Asr calculation';

  @override
  String get madhabShafi => 'Standard (Shafi, Maliki, Hanbali)';

  @override
  String get madhabHanafi => 'Hanafi';

  @override
  String get prayerNeedsLocation => 'Prayer times also need your location.';

  @override
  String prayerMethodName(String method) {
    String _temp0 = intl.Intl.selectLogic(method, {
      'turkiye': 'Türkiye (Diyanet)',
      'muslimWorldLeague': 'Muslim World League',
      'egyptian': 'Egyptian General Authority',
      'karachi': 'Karachi',
      'ummAlQura': 'Umm al-Qura (Makkah)',
      'dubai': 'Dubai',
      'gulfRegion': 'Gulf region',
      'kuwait': 'Kuwait',
      'qatar': 'Qatar',
      'moonsightingCommittee': 'Moonsighting Committee',
      'northAmerica': 'North America (ISNA)',
      'singapore': 'Singapore',
      'indonesian': 'Indonesia',
      'tehran': 'Tehran',
      'jafari': 'Jafari',
      'jordan': 'Jordan',
      'algerian': 'Algeria',
      'morocco': 'Morocco',
      'tunisia': 'Tunisia',
      'france': 'France (UOIF)',
      'portugal': 'Portugal',
      'russia': 'Russia',
      'other': 'Other',
    });
    return '$_temp0';
  }

  @override
  String get onbCategoriesTitle => 'Everything links to 9 root categories';

  @override
  String get onbCategoriesBody =>
      'These categories are fixed; you add as many of your own categories under them as you like. The brain is a metaphor, not a measurement.';

  @override
  String onbFirstTitle(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Let\'s add your first routine',
      'young': 'Ready for your first routine?',
      'coder': 'Define your first routine',
      'calm': 'Let\'s add your first routine',
      'other': 'Let\'s add your first routine',
    });
    return '$_temp0';
  }

  @override
  String onbFirstBody(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'You know your life best; there are no ready-made examples, you add the first item.',
      'young':
          'Your life, your rules: no ready-made examples, add your first item.',
      'coder':
          'No seed data; the template starts empty. You insert the first row.',
      'calm': 'The app assumes nothing about your life. No rush; you add your first item.',
      'other': 'The app assumes nothing about your life. There are no ready-made examples; you add the first item yourself.',
    });
    return '$_temp0';
  }

  @override
  String get onbFirstAction => 'Add my first routine';

  @override
  String get todayNow => 'Now';

  @override
  String get todayNext => 'Up next';

  @override
  String todayEnds(String time) {
    return 'Ends $time';
  }

  @override
  String todayEmptyTitle(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Today is a blank page',
      'young': 'Your day is wide open',
      'coder': 'Today: 0 rows',
      'calm': 'Today is quiet so far',
      'other': 'Your plan is empty',
    });
    return '$_temp0';
  }

  @override
  String todayEmptyBody(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Add routines and your day fills with colour; we\'ll find your free time too.',
      'young': 'Add your routines and watch your day take shape; we\'ll work out your free time.',
      'coder': 'Add routines and tasks to compile your day; free slots are computed automatically.',
      'calm': 'As you add routines, your day appears here gently; your free time is worked out too.',
      'other': 'As you add routines and tasks your day appears here, and your free time is calculated.',
    });
    return '$_temp0';
  }

  @override
  String todayEmptyAction(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Let\'s add your first routine',
      'young': 'Add your first routine',
      'coder': 'Create first routine',
      'calm': 'Add your first routine',
      'other': 'Add your first routine',
    });
    return '$_temp0';
  }

  @override
  String get todayNothing => 'Nothing is planned for today.';

  @override
  String get todayUnplanned =>
      'Today is an unplanned day: no automatic placement, free time isn\'t calculated.';

  @override
  String freeSlot(String duration) {
    return 'Free · $duration';
  }

  @override
  String get untimedSection => 'Sometime today';

  @override
  String afterAnchor(String title) {
    return 'After $title';
  }

  @override
  String get overflowSection => 'Buffer: didn\'t fit';

  @override
  String get overflowBody =>
      'No room within its constraints. You can change its time or skip it.';

  @override
  String get droppedLabel => 'Optional, dropped for lack of room';

  @override
  String conflictLabel(String title) {
    return 'Overlaps with $title';
  }

  @override
  String get cycleLabel =>
      'Relative links form a loop; the time couldn\'t be calculated';

  @override
  String get missingAnchorLabel =>
      'This needs your location or prayer time setting';

  @override
  String get focusLabel => 'Needs focus';

  @override
  String get suggestedLabel => 'Suggested time';

  @override
  String get actionDone => 'Done';

  @override
  String get actionSkip => 'Skip';

  @override
  String get actionChangeTime => 'Change time';

  @override
  String get statusDone => 'Done';

  @override
  String get statusSkipped => 'Skipped';

  @override
  String snackDone(String title) {
    return '$title done';
  }

  @override
  String snackSkipped(String title) {
    return '$title skipped';
  }

  @override
  String variantPrompt(String title) {
    return '$title: which one today?';
  }

  @override
  String get variantAsIs => 'As usual';

  @override
  String get proposalLabel => 'Suggestion';

  @override
  String get proposalAccept => 'Accept';

  @override
  String get proposalAccepted => 'Added to your plan';

  @override
  String get changeScopeTitle => 'When should this change apply?';

  @override
  String get changeScopeOnce => 'Only this time';

  @override
  String get changeScopeAlways => 'Every time';

  @override
  String get planWeek => 'Week';

  @override
  String get planRules => 'Rules';

  @override
  String get prevWeek => 'Previous week';

  @override
  String get nextWeek => 'Next week';

  @override
  String get thisWeek => 'This week';

  @override
  String dayFree(String duration) {
    return 'Free $duration';
  }

  @override
  String get dayUnplanned => 'Unplanned day';

  @override
  String get dayEmpty => 'Nothing planned';

  @override
  String get rulesEmptyTitle => 'Nothing here yet';

  @override
  String get rulesEmptyBody =>
      'When you add something, its schedule is listed here.';

  @override
  String itemDeleted(String title) {
    return '$title deleted';
  }

  @override
  String get inboxSection => 'Undated';

  @override
  String get projectsSection => 'Projects and tasks';

  @override
  String get routinesSection => 'Recurring and dated';

  @override
  String get recDaily => 'Every day';

  @override
  String recWeekdays(String days) {
    return 'Every $days';
  }

  @override
  String recEveryNDays(int n) {
    return 'Every $n days';
  }

  @override
  String recMonthDay(int day) {
    return 'Day $day of every month';
  }

  @override
  String recMonthNth(int n, String weekday) {
    return 'Every month on $weekday #$n';
  }

  @override
  String recMonthLast(String weekday) {
    return 'Every month on the last $weekday';
  }

  @override
  String recCycle(int length, int count) {
    return '$count days in a $length-day cycle';
  }

  @override
  String recDates(int count) {
    return '$count chosen days';
  }

  @override
  String recPerPeriod(String unit, int count) {
    String _temp0 = intl.Intl.selectLogic(unit, {
      'day': 'day',
      'week': 'week',
      'other': 'month',
    });
    return '$count times a $_temp0';
  }

  @override
  String get recFollow => 'Together with the item it follows';

  @override
  String get recCustom => 'Custom repeat';

  @override
  String timeWindow(String from, String to) {
    return 'Between $from and $to';
  }

  @override
  String timeRelative(String title) {
    return 'Tied to $title';
  }

  @override
  String timeAstro(String event) {
    return 'Based on $event';
  }

  @override
  String get timeNone => 'No time';

  @override
  String astroEvent(String event) {
    String _temp0 = intl.Intl.selectLogic(event, {
      'sunrise': 'Sunrise',
      'sunset': 'Sunset',
      'fajr': 'Fajr',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'other': 'Isha',
    });
    return '$_temp0';
  }

  @override
  String get wizTitle => 'New item';

  @override
  String get wizWhatTitle => 'What is it?';

  @override
  String get wizWhatLabel => 'Name';

  @override
  String get wizWhatError => 'Enter a name';

  @override
  String get wizKind => 'Type';

  @override
  String get kindRoutine => 'Routine';

  @override
  String get kindOneOff => 'One-off';

  @override
  String get kindTask => 'Task with deadline';

  @override
  String get kindProject => 'Project';

  @override
  String get kindFreeTime => 'Free time';

  @override
  String get kindTravel => 'Travel / prep';

  @override
  String get wizCategoryTitle => 'Which category does it belong to?';

  @override
  String get wizCategoryNone => 'No category (doesn\'t feed the brain)';

  @override
  String get wizNewSubcategory => 'New subcategory';

  @override
  String get wizSubcategoryName => 'Subcategory name';

  @override
  String get wizWhenTitle => 'When does it happen?';

  @override
  String get recTypeOnce => 'Once';

  @override
  String get recTypeDaily => 'Every day';

  @override
  String get recTypeWeekly => 'Certain days of the week';

  @override
  String get recTypeEveryN => 'Every N days';

  @override
  String get recTypeMonthly => 'Once a month';

  @override
  String get recTypeCycle => 'Rotating (on / off days)';

  @override
  String get recTypeDates => 'On dates I choose';

  @override
  String get recTypePerPeriod => 'A number of times, no fixed day';

  @override
  String get recTypeFollow => 'Together with another item';

  @override
  String get wizDate => 'Date';

  @override
  String get wizStartDate => 'Starts';

  @override
  String get wizEveryNDays => 'Every how many days';

  @override
  String get wizMonthByDay => 'Day of month';

  @override
  String get wizMonthByWeek => 'Week of month';

  @override
  String get wizMonthDay => 'Day';

  @override
  String get wizNth => 'Which';

  @override
  String get nthLast => 'Last';

  @override
  String get wizCycleOn => 'Days on';

  @override
  String get wizCycleOff => 'Days off';

  @override
  String get wizAddDate => 'Add date';

  @override
  String get wizPerCount => 'How many times';

  @override
  String get unitDay => 'A day';

  @override
  String get unitWeek => 'A week';

  @override
  String get unitMonth => 'A month';

  @override
  String get wizFollowNote =>
      'You\'ll pick the item it follows in the next step. On days without that item, this doesn\'t happen either.';

  @override
  String wizNumberError(int min, int max) {
    return 'Enter a number from $min to $max';
  }

  @override
  String get wizPickDay => 'Pick at least one day';

  @override
  String get wizPickDate => 'Add at least one date';

  @override
  String get wizTimeTitle => 'Does it have a time?';

  @override
  String get timeTypeFixed => 'Fixed time';

  @override
  String get timeTypeWindow => 'Within a time window';

  @override
  String get timeTypeRelative => 'Relative to another item';

  @override
  String get timeTypeAstro => 'Relative to sunrise or a prayer time';

  @override
  String get timeTypeNone => 'No time, sometime during the day';

  @override
  String get wizStartTime => 'Starts';

  @override
  String get wizWindowFrom => 'Earliest';

  @override
  String get wizWindowTo => 'Latest';

  @override
  String get wizRelativeTo => 'Which item';

  @override
  String get relAfterEnd => 'Start when it ends';

  @override
  String get relBeforeStart => 'End before it starts';

  @override
  String get wizOffset => 'Minutes in between';

  @override
  String get wizAstroEvent => 'Which time';

  @override
  String get astroBefore => 'Before';

  @override
  String get astroAfter => 'After';

  @override
  String get wizAstroNeedsLocation =>
      'This needs your location. You can turn it on in Profile.';

  @override
  String get wizNoActivities => 'You have no other item to link to.';

  @override
  String get wizPickActivity => 'Pick an item';

  @override
  String get wizFlex => 'Flexibility';

  @override
  String get flexFixed => 'Fixed';

  @override
  String get flexShiftable => 'Shiftable';

  @override
  String get flexOptional => 'Optional';

  @override
  String get flexFixedHint =>
      'Never moves; if it overlaps another fixed item, you\'ll see it.';

  @override
  String get flexShiftableHint =>
      'Moves to the nearest free slot if there\'s no room.';

  @override
  String get flexOptionalHint => 'Dropped that day if there\'s no room.';

  @override
  String get wizDurationTitle => 'How long does it take?';

  @override
  String get wizMinutes => 'Minutes';

  @override
  String get wizVariantTitle => 'Does it have different versions?';

  @override
  String get wizVariantBody =>
      'If this goes differently on some days, add each version as a variant. You pick one with a single tap at the start of the day.';

  @override
  String get wizVariantName => 'Variant name';

  @override
  String get wizVariantAdd => 'Add variant';

  @override
  String get wizVariantCancels => 'In this version it doesn\'t happen that day';

  @override
  String get wizVariantDefault => 'Use this if I don\'t choose';

  @override
  String get wizVariantMin => 'Add at least two variants';

  @override
  String get wizVariantRemove => 'Remove variant';

  @override
  String get wizFocusTitle => 'Does it need focus?';

  @override
  String get focusYes => 'Yes';

  @override
  String get focusNo => 'No';

  @override
  String get wizFocusMode => 'Focus mode';

  @override
  String get modeFree => 'Free';

  @override
  String get modePomodoro => 'Pomodoro';

  @override
  String get modeDeep => 'Deep work';

  @override
  String get wizDeadlineTitle => 'What\'s the deadline?';

  @override
  String get wizDeadlineNone => 'No deadline';

  @override
  String get wizTotalTitle => 'How long will it take in total?';

  @override
  String get wizHours => 'Hours';

  @override
  String get wizChunksTitle => 'How should it be split?';

  @override
  String get wizMinChunk => 'Shortest chunk (min)';

  @override
  String get wizMaxChunk => 'Longest chunk (min)';

  @override
  String get wizDailyCap => 'At most per day (min)';

  @override
  String get splitAuto => 'Suggest automatically, I approve';

  @override
  String get splitManual => 'I\'ll place it in free slots';

  @override
  String get wizSummaryTitle => 'Summary';

  @override
  String wizSaved(String title) {
    return '$title added';
  }

  @override
  String get sumName => 'Name';

  @override
  String get sumKind => 'Type';

  @override
  String get sumCategory => 'Category';

  @override
  String get sumWhen => 'When';

  @override
  String get sumTime => 'Time';

  @override
  String get sumDuration => 'Duration';

  @override
  String get sumVariants => 'Variants';

  @override
  String get sumFocus => 'Focus';

  @override
  String get sumDeadline => 'Deadline';

  @override
  String get sumTotal => 'Total time';

  @override
  String get sumSplit => 'Splitting';

  @override
  String get sumNotSet => 'Not set';

  @override
  String get brainTitle => 'Categories and brain';

  @override
  String get brainIntro =>
      'Root categories are fixed; you can add unlimited subcategories and items under them. The 3D brain is a metaphor, not a measurement.';

  @override
  String get brainRegionsTitle => 'Which brain regions does it work?';

  @override
  String evidenceLevel(String level) {
    String _temp0 = intl.Intl.selectLogic(level, {
      'strong': 'Strong evidence',
      'moderate': 'Moderate evidence',
      'weak': 'Weak evidence',
      'other': 'No source, association only',
    });
    return '$_temp0';
  }

  @override
  String evidenceSources(String ids) {
    return 'Source: $ids';
  }

  @override
  String get catAddSub => 'Add subcategory';

  @override
  String get catName => 'Name';

  @override
  String get catMove => 'Move';

  @override
  String get catInUse =>
      'First move or delete the categories and items inside it.';

  @override
  String catMoved(String name) {
    return '$name moved';
  }

  @override
  String catEmpty(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Nothing here yet; you can add the first subcategory.',
      'young': 'Nothing yet, add something now.',
      'coder': 'Empty node: no subcategories or items.',
      'calm': 'Nothing here yet.',
      'other': 'No subcategories or items yet.',
    });
    return '$_temp0';
  }

  @override
  String get catDragHint =>
      'To move a row, drag it by the handle on the left and drop it onto a category or a root heading.';

  @override
  String get moveTitle => 'Move where?';

  @override
  String get moveCannotIntoSelf => 'A category can\'t be moved under itself.';

  @override
  String get projectProgress => 'Progress';

  @override
  String projectDoneOf(String done, String total) {
    return '$done of $total done';
  }

  @override
  String projectRemaining(String duration) {
    return 'Remaining: $duration';
  }

  @override
  String projectDeadline(String date) {
    return 'Deadline: $date';
  }

  @override
  String get projectNoDeadline => 'No deadline; you place the chunks yourself.';

  @override
  String get projectNoTotal =>
      'No total time set; you place the chunks yourself.';

  @override
  String get projectModeAuto => 'Automatic';

  @override
  String get projectModeManual => 'Manual';

  @override
  String get projectProposals => 'Suggested chunks';

  @override
  String get projectAcceptAll => 'Accept all';

  @override
  String projectAccepted(int n) {
    return '$n chunks accepted';
  }

  @override
  String get projectScheduled => 'Chunks in your plan';

  @override
  String get projectNoProposals => 'No chunks to suggest right now.';

  @override
  String get projectComplete =>
      'The total time is done or already in your plan.';

  @override
  String riskTitle(String date, String duration) {
    return 'At this pace you\'ll be $duration short by $date.';
  }

  @override
  String get riskExtendChunk => 'Longer chunks';

  @override
  String get riskRaiseCap => 'Raise daily limit';

  @override
  String get riskMoveDeadline => 'Move deadline';

  @override
  String get riskApplied => 'Setting updated; the plan was recalculated.';

  @override
  String get manualTitle => 'Free slots';

  @override
  String get manualHint =>
      'Drag the chunk by its handle onto a free slot, or tap a slot.';

  @override
  String manualChunk(String duration) {
    return '$duration chunk';
  }

  @override
  String get manualPlaced => 'Chunk placed';

  @override
  String get manualNoSlots => 'No suitable free slots in the coming days.';

  @override
  String get projectNotFound => 'This project wasn\'t found.';

  @override
  String get chunkRemove => 'Remove chunk';

  @override
  String get profileTitle => 'Profile';

  @override
  String get secGeneral => 'General';

  @override
  String get secPlan => 'Plan';

  @override
  String get secLocation => 'Location and times';

  @override
  String get secNotifications => 'Notifications';

  @override
  String get settingLanguage => 'Language';

  @override
  String get settingAppearance => 'Appearance';

  @override
  String get settingSleep => 'Sleep window';

  @override
  String get notSet => 'Not set';

  @override
  String get settingLocation => 'Location';

  @override
  String locationValue(String lat, String lon) {
    return '$lat, $lon';
  }

  @override
  String get locationRemove => 'Remove location';

  @override
  String get settingPrayer => 'Prayer times';

  @override
  String get prayerOff => 'Off';

  @override
  String get settingMinChunk => 'Shortest chunk';

  @override
  String get settingBuffer => 'Buffer between chunks';

  @override
  String get settingDailyCap => 'Daily focus limit';

  @override
  String engineDefault(String value) {
    return 'Default ($value)';
  }

  @override
  String get noLimit => 'No limit';

  @override
  String get settingNotify => 'Up-next notification';

  @override
  String notifyLead(int n) {
    return '$n min before';
  }

  @override
  String get notifyOff => 'Off';

  @override
  String get settingExact => 'Right on time';

  @override
  String get settingExactBody =>
      'Arrives on time even while the phone sleeps; needs a system permission.';

  @override
  String get notifPermissionDenied =>
      'Notification permission wasn\'t granted. You can turn it on in system settings.';

  @override
  String get onbNotifyTitle => 'Allow notifications?';

  @override
  String get onbNotifyBody =>
      'We\'ll remind you of what\'s next on time, show your focus session on the lock screen and tell you when a friend writes. Notifications never show message text. You can change this later in Profile.';

  @override
  String get notifyAllow => 'Allow notifications';

  @override
  String get notifyGranted => 'Notifications are on.';

  @override
  String get notifyOffTitle => 'Notifications are off';

  @override
  String get notifyOffBody => 'Reminders and message alerts won\'t arrive.';

  @override
  String get notifyTurnOn => 'Turn on';

  @override
  String get settingHaptics => 'Haptic feedback';

  @override
  String get notifChannel => 'Up next';

  @override
  String get notifChannelDesc =>
      'Reminds you shortly before your next item starts.';

  @override
  String notifBody(String time, String when) {
    return '$time · $when';
  }

  @override
  String widgetNext(String title) {
    return 'Up next: $title';
  }

  @override
  String get widgetNone => 'Nothing up next';

  @override
  String get widgetNow => 'Starting now';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get actionFocus => 'Focus';

  @override
  String get secFocus => 'Focus';

  @override
  String get focusStart => 'Start';

  @override
  String get focusMissingTitle => 'This item is no longer in your plan';

  @override
  String get focusMissingBody =>
      'Your plan may have changed. Pick it again from Today.';

  @override
  String get focusChangeDurations => 'Change durations';

  @override
  String get focusRuleHint =>
      'When you start, Android asks to pin the app; while pinned you can\'t switch to other apps. If you unpin and leave the app or pull down the notification shade, come back within 10 seconds or the session breaks. Turning off the screen and incoming calls don\'t count, and leaving during a break is fine.';

  @override
  String get focusSummaryFree => 'No time limit; stop when you\'re done.';

  @override
  String focusSummaryPomodoro(int work, int rest, int every, int long) {
    return '$work min focus, $rest min break; a $long min long break every $every cycles.';
  }

  @override
  String focusSummaryDeep(int target) {
    return 'Target: $target min of uninterrupted focus. You can take a break, suggested from how long you\'ve focused so far.';
  }

  @override
  String get focusFieldWork => 'Focus (min)';

  @override
  String get focusFieldBreak => 'Break (min)';

  @override
  String get focusFieldLongBreak => 'Long break (min)';

  @override
  String get focusFieldLongEvery => 'Long break every … cycles';

  @override
  String get focusFieldTarget => 'Target (min)';

  @override
  String get focusPause => 'Pause';

  @override
  String get focusResume => 'Resume';

  @override
  String get focusFinish => 'Finish';

  @override
  String get focusEndBreak => 'End break';

  @override
  String focusTakeBreak(int minutes) {
    return 'Take a break · $minutes min suggested';
  }

  @override
  String focusEmergency(int left) {
    return 'Emergency ($left left)';
  }

  @override
  String get focusEmergencyNone => 'No emergency pauses left today';

  @override
  String get focusEmergencyTitle => 'Emergency';

  @override
  String focusEmergencyBody(int left) {
    return 'The session pauses without penalty and you can leave the app. Tap Resume when you\'re back. Left today after this: $left.';
  }

  @override
  String get focusEmergencyConfirm => 'Pause';

  @override
  String focusPhaseCycle(int n) {
    return 'Focus · cycle $n';
  }

  @override
  String focusPhaseDeep(int target) {
    return 'Deep work · target $target min';
  }

  @override
  String get focusPhaseBreak => 'Break · you can leave the app';

  @override
  String get focusPhaseBreakOver => 'Break over · resume when ready';

  @override
  String get focusPhasePaused => 'Paused · stay in the app';

  @override
  String get focusPhaseEmergency => 'Emergency · you can leave the app';

  @override
  String focusTimeLeft(String time) {
    return '$time left';
  }

  @override
  String focusTimeElapsed(String time) {
    return '$time elapsed';
  }

  @override
  String focusTotal(String time) {
    return '$time of focus this session';
  }

  @override
  String get focusBackHint => 'Tap Finish to end the session.';

  @override
  String focusOverlaySeconds(int seconds) {
    return 'Come back within $seconds s';
  }

  @override
  String get focusPardonTitle => 'Looks like you were on a call';

  @override
  String get focusPardonBody =>
      'You were away for more than 10 seconds, but the phone showed a call. If you were on a call, the session continues and the call time isn\'t counted as focus.';

  @override
  String get focusPardonYes => 'Yes, I was on a call';

  @override
  String get focusPardonNo => 'No';

  @override
  String get focusOngoingChannel => 'Running focus session';

  @override
  String get focusAlertChannel => 'Focus alerts';

  @override
  String get focusAlertTitle => 'You\'re breaking your plan';

  @override
  String get focusAlertBody =>
      'Come back within 10 seconds or the session breaks. Tap to return.';

  @override
  String get focusBrokenTitle => 'Focus broken';

  @override
  String get focusBrokenBody =>
      'You didn\'t come back within 10 seconds. Start again whenever you\'re ready.';

  @override
  String get focusBreakTitle => 'Break time';

  @override
  String focusBreakBody(int minutes) {
    return '$minutes min break. You can leave the app.';
  }

  @override
  String get focusBreakOverTitle => 'Break over';

  @override
  String get focusBreakOverBody => 'Come back and resume when you\'re ready.';

  @override
  String get focusTargetTitle => 'Target reached';

  @override
  String focusTargetBody(int minutes) {
    return '$minutes min of deep work done. Keep going or finish.';
  }

  @override
  String focusBrokenHeading(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Not this time',
      'young': 'This round broke',
      'coder': 'Session terminated: broken',
      'calm': 'The session stopped halfway',
      'other': 'Session broken',
    });
    return '$_temp0';
  }

  @override
  String focusBrokenWhat(String time) {
    return 'At $time the app was left and nobody came back within 10 seconds, so the session stopped.';
  }

  @override
  String focusBrokenBrain(String root, int minutes) {
    return 'This session wasn\'t added to the brain. In regions associated with $root, $minutes minutes\' worth went dark; it lights up again as you focus.';
  }

  @override
  String get focusBrokenBrainNone =>
      'This session wasn\'t added to the brain; nothing went dark.';

  @override
  String focusBrokenAgain(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'It happens. We\'ll start again when you\'re ready.',
      'young': 'No worries, start again when you\'re ready.',
      'coder': 'Restart is always available.',
      'calm': 'That\'s fine. Start again whenever you feel ready.',
      'other': 'It happens. Start again whenever you\'re ready.',
    });
    return '$_temp0';
  }

  @override
  String get focusRestart => 'Start again';

  @override
  String get focusBackToToday => 'Back to Today';

  @override
  String get focusRateFocus => 'How focused were you?';

  @override
  String get focusRateFocusLow => '1 · not at all';

  @override
  String get focusRateFocusHigh => '5 · completely';

  @override
  String get focusRateFatigue => 'How tired are you?';

  @override
  String get focusRateFatigueLow => '1 · not at all';

  @override
  String get focusRateFatigueHigh => '5 · very';

  @override
  String get focusNoteTitle => 'A short note';

  @override
  String get focusNoteLabel => 'Note (optional)';

  @override
  String focusGainTitle(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Your reward for this session',
      'young': 'What you earned',
      'coder': 'Session output',
      'calm': 'What this session gave',
      'other': 'What this session added',
    });
    return '$_temp0';
  }

  @override
  String focusGainBody(String root, int minutes) {
    return 'You spent $minutes min on regions associated with $root.';
  }

  @override
  String focusGainNone(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Too short this time; not enough time to add to the brain.',
      'young': 'Under a minute, so no gain this time.',
      'coder': 'Duration < 1 min; nothing to write to the brain.',
      'calm':
          'It lasted under a minute; no time built up for the brain this time.',
      'other': 'It lasted less than a minute; no time to add to the brain yet.',
    });
    return '$_temp0';
  }

  @override
  String focusGainShare(int percent) {
    return 'Share: $percent%';
  }

  @override
  String get focusGainExplain =>
      'The bars show how the neuron gain is split across these regions. The split is a product decision based on each region\'s evidence level, not a measurement of your brain.';

  @override
  String focusRewardPomodoro(int cycles, int streak) {
    String _temp0 = intl.Intl.pluralLogic(
      cycles,
      locale: localeName,
      other: '$cycles cycles completed',
      one: '1 cycle completed',
    );
    return '$_temp0 · streak: $streak';
  }

  @override
  String focusRewardDeep(int longest, int record) {
    return 'Longest uninterrupted focus: $longest min · your record: $record min';
  }

  @override
  String get focusDone => 'Done';

  @override
  String get settingFocusDnd => 'Do Not Disturb while focusing';

  @override
  String get settingFocusDndBody =>
      'Turns on when a session starts and goes back when it ends.';

  @override
  String get focusDndDenied => 'Do Not Disturb access wasn\'t granted.';

  @override
  String get settingFocusCalls => 'Don\'t count incoming calls as leaving';

  @override
  String get settingFocusCallsBody =>
      'Needs phone state permission. Without it, you\'ll be asked when you come back.';

  @override
  String get settingFocusCallsOn =>
      'Permission granted. Use system settings to remove it.';

  @override
  String get focusPhoneDenied =>
      'Phone state permission wasn\'t granted; you\'ll be asked after a call.';

  @override
  String get secAbout => 'About';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutSubtitle => 'Licenses and attributions';

  @override
  String get aboutAppBody =>
      'NeuroPlan is open source and distributed under the AGPL-3.0 license.';

  @override
  String get aboutModelTitle => '3D brain model';

  @override
  String get aboutModelBody =>
      'The 3D brain was made by simplifying the BodyParts3D 4.0 polygon data and merging it into regions.';

  @override
  String get aboutModelCredit =>
      'BodyParts3D, © The Database Center for Life Science licensed under CC Attribution 4.0 International';

  @override
  String get aboutThreeBody =>
      'The 3D scene is drawn with Three.js (MIT license). The scene and the library ship inside the app; no internet is needed.';

  @override
  String get aboutLicenses => 'Show all licenses';

  @override
  String get brainListAction => 'List view';

  @override
  String get brainResetView => 'Reset view';

  @override
  String get brainSceneLoading => 'Preparing the brain';

  @override
  String get brainSceneErrorTitle =>
      'The 3D brain could not open on this device';

  @override
  String get brainSceneErrorBody =>
      'You can see the same information as a list.';

  @override
  String brainEmptyTitle(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Your brain is waiting for you',
      'young': 'Ready to light up your brain',
      'coder': 'Neuron count: 0',
      'calm': 'The brain is quiet so far',
      'other': 'No lit neurons yet',
    });
    return '$_temp0';
  }

  @override
  String get brainEmptyBody =>
      'When you complete a focus session, neurons light up in the regions associated with that activity\'s category. The 3D brain is a metaphor, not a measurement.';

  @override
  String get brainTimeline => 'Timeline';

  @override
  String get brainTimelineNow => 'Today';

  @override
  String brainTimelineAt(String date) {
    return 'As of $date';
  }

  @override
  String get brainListTitle => 'Brain regions';

  @override
  String get brainCategoriesTile => 'Categories';

  @override
  String get brainCategoriesBody =>
      'Add and move subcategories; see each root\'s regions.';

  @override
  String regionNeurons(int count, int brightness) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count neurons · brightness $brightness%',
      one: '1 neuron · brightness $brightness%',
      zero: 'Not fed yet',
    );
    return '$_temp0';
  }

  @override
  String regionDimmed(int count) {
    return '$count neurons are dimmed; they light up again as you focus.';
  }

  @override
  String regionHemisphere(String side) {
    String _temp0 = intl.Intl.selectLogic(side, {
      'left': 'Left hemisphere',
      'right': 'Right hemisphere',
      'other': 'Both hemispheres',
    });
    return '$_temp0';
  }

  @override
  String get regionInner => 'Inner structure';

  @override
  String regionLastActive(String date) {
    return 'Last fed: $date';
  }

  @override
  String regionMinutes30(int minutes) {
    return 'In the last 30 days you spent $minutes minutes on activities associated with this region.';
  }

  @override
  String get regionMinutes30None =>
      'No focus session associated with this region in the last 30 days.';

  @override
  String get regionChartLabel => 'Last 30 days, neurons lit per day';

  @override
  String regionChartSummary(int days, int max) {
    return 'Fed on $days days; at most $max neurons in a day.';
  }

  @override
  String get regionFedBy => 'What fed it (last 30 days)';

  @override
  String get regionEvidence => 'Which categories, with what evidence';

  @override
  String get regionEvidenceNone =>
      'No root category is linked to this region; it is drawn so the brain looks whole.';

  @override
  String get regionMetaphor =>
      'The 3D brain is a metaphor, not a measurement. The evidence level describes the strength of the research; it does not measure your brain.';

  @override
  String regionMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get navTogether => 'Together';

  @override
  String navBadge(String label, int count) {
    return '$label, $count pending';
  }

  @override
  String get secAccount => 'Account';

  @override
  String get accountGoogle => 'Google account';

  @override
  String get accountGuest => 'Guest';

  @override
  String get accountGuestBody =>
      'Your data is on this device and backed up. Connect Google to keep it and use it on other devices.';

  @override
  String get accountDeviceOnly => 'This device only';

  @override
  String get accountDeviceOnlyBody =>
      'This build has no server settings; everything runs on your device.';

  @override
  String get accountOffline =>
      'Not connected right now; it syncs when you are back online.';

  @override
  String get accountDeleteTitle => 'Delete account and data';

  @override
  String get accountDeleteSubtitle =>
      'Your plan, focus sessions, brain and social data are permanently deleted.';

  @override
  String get accountDeleteBody =>
      'This cannot be undone. Your friendships, messages and shared plans are deleted too. Reports about you stay for moderation without your identity.';

  @override
  String get accountDeleteAction => 'Delete permanently';

  @override
  String get accountDeleteError =>
      'Could not delete. Check your connection and try again.';

  @override
  String get onbAgeTitle => 'Your birth year';

  @override
  String get onbAgeBody =>
      'Only the year is kept. It sets protections for your age; children under 13 cannot use the app.';

  @override
  String get onbAgeTooYoung =>
      'NeuroPlan is for ages 13 and up. You cannot continue with this year.';

  @override
  String get tgOfflineTitle => 'Together needs a server';

  @override
  String get tgOfflineBody =>
      'This build has no server settings. Plan, focus and brain work fully on your device.';

  @override
  String get tgGuestTitle => 'Work together with friends';

  @override
  String get tgGuestBody =>
      'Together needs a Google account. Your data stays the same when you connect. Nobody can find you at random; friendships only start with an invite.';

  @override
  String get tgConnectGoogle => 'Connect with Google';

  @override
  String get tgConnected => 'Your Google account is connected.';

  @override
  String get tgConnectedSwitched =>
      'Switched to your Google account; this device\'s data is being sent to it.';

  @override
  String get tgConnectError => 'Could not connect with Google. Try again.';

  @override
  String get tgAgeTitle => 'First, your birth year';

  @override
  String get tgAgeBody =>
      'Social features open at 15; under 18 the strictest privacy settings apply. Only the year is kept.';

  @override
  String get tgBirthYear => 'Birth year';

  @override
  String get tgTooYoungTitle => 'Together opens at 15';

  @override
  String get tgTooYoungBody =>
      'This rule is there to protect you. Plan, focus and brain work fully at any age.';

  @override
  String get tgSuspendedTitle => 'Social features are paused';

  @override
  String tgSuspendedBody(String date) {
    return 'A report was reviewed and your social features are off until $date. Plan, focus and brain keep working.';
  }

  @override
  String get tgSetupTitle => 'How should friends see you?';

  @override
  String get tgSetupBody =>
      'Your nickname is only shown to friends. A username is optional; unless you turn it on, nobody can find you by it.';

  @override
  String get tgDisplayName => 'Nickname';

  @override
  String get tgUsernameOptional => 'Username (optional)';

  @override
  String get tgUsernameHelp =>
      '3–20 characters: lowercase letters, digits, underscore. Someone who knows it exactly can send a request, but only if you turn discoverability on.';

  @override
  String get tgNameRequired => 'Enter a nickname.';

  @override
  String get tgUsernameRule =>
      'Username must be 3–20 characters: lowercase letters, digits or underscore.';

  @override
  String get tgTermsBody =>
      'By continuing you accept the community rules: harassment, hate speech, sexual content, spam and anything that endangers children are forbidden. You can report and block from every screen; reports are reviewed.';

  @override
  String get tgSetupAction => 'Accept and start';

  @override
  String get tgEmptyTitle => 'Invite your first friend';

  @override
  String get tgEmptyBody =>
      'Friendships only start with an invite: share your code or QR code, or enter theirs.';

  @override
  String get tgInviteFirst => 'Invite a friend';

  @override
  String get tgCofocusBack => 'Your co-focus session is open.';

  @override
  String get tgOpen => 'Open';

  @override
  String tgCofocusInvite(String name) {
    return '$name invites you to focus together.';
  }

  @override
  String get tgJoin => 'Join';

  @override
  String get tgDecline => 'Decline';

  @override
  String get tgAccept => 'Accept';

  @override
  String tgPartnerAsked(String name) {
    return '$name wants to be your partner.';
  }

  @override
  String get tgPartnerDone => 'You are partners now.';

  @override
  String get tgSecTogether => 'Work together';

  @override
  String get tgSecPeople => 'People';

  @override
  String get tgSecPrivacy => 'Privacy';

  @override
  String tgPartnerPlan(String name) {
    return 'Your partner $name: plan';
  }

  @override
  String get tgChoosePartner => 'Choose a partner';

  @override
  String get tgChoosePartnerBody =>
      'A closer bond for working together and seeing plans; one partner at a time.';

  @override
  String get tgCofocusNew => 'Start co-focus';

  @override
  String get tgCofocusNewBody =>
      'Start at the same time, everyone on their own task.';

  @override
  String get tgShared => 'Shared plans';

  @override
  String get tgFreeTime => 'Find common free time';

  @override
  String get tgMessages => 'Messages';

  @override
  String get tgFriends => 'Friends';

  @override
  String get tgInvite => 'Invite';

  @override
  String get tgLeaderboard => 'Leaderboard';

  @override
  String get tgPrivacy => 'Privacy settings';

  @override
  String get tgPrivacyBody => 'Who sees what: plan, profile, brain.';

  @override
  String get tgCancel => 'Cancel';

  @override
  String get tgPartner => 'Partner';

  @override
  String get tgErrRate => 'Slow down a little; try again shortly.';

  @override
  String get tgErrNetwork =>
      'Could not reach the server. Check your connection.';

  @override
  String get tgErrNotFound => 'Not found or no longer valid.';

  @override
  String get tgErrForbidden => 'You are not allowed to do this.';

  @override
  String get tgErrNotPublished =>
      'Someone you picked has not shared their calendar yet; it is shared when they open Together.';

  @override
  String get tgErrNotEligible =>
      'Social features are not available for this account.';

  @override
  String get tgErrUsernameTaken => 'This username is taken.';

  @override
  String get tgErrPartnerTaken =>
      'One of you already has a partner; that partnership has to end first.';

  @override
  String get tgErrAlready => 'This is already done.';

  @override
  String get tgErrInvalid => 'The input is not valid.';

  @override
  String get tgIncoming => 'Requests';

  @override
  String get tgWantsToBeFriends => 'Wants to be friends';

  @override
  String get tgPartnerPending => 'Partner request pending';

  @override
  String get tgOutgoing => 'Sent requests';

  @override
  String get tgRequestSent => 'Request sent';

  @override
  String get tgWithdraw => 'Withdraw';

  @override
  String get tgBlocked => 'Blocked';

  @override
  String get tgUnblock => 'Unblock';

  @override
  String get tgUnblocked =>
      'Unblocked. A new invite is needed to be friends again.';

  @override
  String get tgNotFriendTitle => 'You are no longer friends';

  @override
  String get tgNotFriendBody => 'Nothing about this person can be shown.';

  @override
  String get tgSendMessage => 'Send a message';

  @override
  String get tgSeePlan => 'See their plan';

  @override
  String get tgCompareBrains => 'Compare brains';

  @override
  String get tgEndPartner => 'End partnership';

  @override
  String get tgEndPartnerBody =>
      'You stay friends; partner-only visibility ends.';

  @override
  String get tgAskPartner => 'Ask to be partners';

  @override
  String get tgAskPartnerBody => 'You become partners once they accept.';

  @override
  String get tgAskPartnerBlocked => 'End your current partnership first.';

  @override
  String get tgPartnerRequested => 'Partner request sent.';

  @override
  String get tgShowFull => 'Show my full plan to this person';

  @override
  String get tgShowFullBody =>
      'Title, time, category and notes. This exception overrides your category rules for this person.';

  @override
  String get tgSafety => 'Safety';

  @override
  String get tgRemoveFriend => 'Remove friend';

  @override
  String tgRemoveFriendBody(String name) {
    return '$name will no longer see your plan, messages or brain. A new invite is needed to be friends again.';
  }

  @override
  String get tgBlock => 'Block';

  @override
  String tgBlockTitle(String name) {
    return 'Block $name?';
  }

  @override
  String get tgBlockBody =>
      'Friendship and partnership end and the chat closes for both of you. They cannot find you or invite you, and they are not told they were blocked.';

  @override
  String get tgBlocked1 => 'Blocked.';

  @override
  String get tgReport => 'Report';

  @override
  String get tgInviteTitle => 'Your invite code';

  @override
  String get tgInviteBody =>
      'The code is valid for 7 days and works once. Share it only with someone you trust.';

  @override
  String get tgKindFriend => 'Friend invite';

  @override
  String get tgKindPartner => 'Partner invite';

  @override
  String get tgCreateCode => 'Create a code';

  @override
  String tgQrLabel(String code) {
    return 'QR image of your invite code: $code';
  }

  @override
  String tgExpires(String date) {
    return 'Valid until $date';
  }

  @override
  String get tgCopy => 'Copy';

  @override
  String get tgCopied => 'Copied.';

  @override
  String get tgRevoke => 'Revoke';

  @override
  String get tgHaveCode => 'Have a code?';

  @override
  String get tgCode => 'Invite code';

  @override
  String get tgScan => 'Scan QR code';

  @override
  String get tgUseCode => 'Use code';

  @override
  String get tgCodeRule => 'An invite code has 10 characters.';

  @override
  String tgRedeemed(String name) {
    return 'You and $name are friends now.';
  }

  @override
  String tgRedeemedPartner(String name) {
    return 'You and $name are partners now.';
  }

  @override
  String get tgByUsername => 'By exact username';

  @override
  String get tgByUsernameBody =>
      'Requests only reach accounts that turned discoverability on. There is no search or suggestions.';

  @override
  String get tgUsername => 'Username';

  @override
  String get tgSendRequest => 'Send request';

  @override
  String get tgCameraTitle => 'Camera unavailable';

  @override
  String get tgCameraBody =>
      'Camera permission was not given or there is no camera. You can also type the code.';

  @override
  String get tgScanHint =>
      'Point the camera at the QR code on your friend\'s screen.';

  @override
  String tgPlanOf(String name) {
    return '$name: plan';
  }

  @override
  String get tgWeek => 'Week';

  @override
  String get tgPlanEmptyTitle => 'Nothing shared';

  @override
  String tgPlanEmptyBody(String name) {
    return '$name shares nothing for these days or the plan is empty. $name decides what is visible.';
  }

  @override
  String get tgBusy => 'Busy';

  @override
  String get tgPlanReadOnly => 'Read-only. The owner chooses what is visible.';

  @override
  String get tgLevelFull => 'Full (title, time, notes)';

  @override
  String get tgLevelTitleTime => 'Title and time';

  @override
  String get tgLevelBusy => 'Only \"busy\"';

  @override
  String get tgLevelHidden => 'Hidden';

  @override
  String get tgLevelDefault => 'Default';

  @override
  String get tgLevelFullBody => 'Title, time, category and notes are visible.';

  @override
  String get tgLevelTitleTimeBody =>
      'Title and time are visible; notes and category are not.';

  @override
  String get tgLevelBusyBody =>
      'Only that you are busy at that time is visible.';

  @override
  String get tgLevelHiddenBody => 'Not visible at all.';

  @override
  String get tgLevelDefaultBody =>
      'Partner sees title and time, other friends see \"busy\".';

  @override
  String get tgSecProfile => 'Profile';

  @override
  String get tgDiscoverable => 'Findable by my username';

  @override
  String tgDiscoverableBody(String username) {
    return 'Someone who types exactly @$username can send a request.';
  }

  @override
  String get tgDiscoverableNoUsername => 'You need a username first.';

  @override
  String get tgGlobalBoard => 'Join the global leaderboard';

  @override
  String get tgGlobalBoardBody =>
      'With your nickname, weekly focus minutes and consistency.';

  @override
  String get tgGlobalBoardMinor => 'The global leaderboard is off under 18.';

  @override
  String get tgShareBrain => 'Friends can see my brain';

  @override
  String get tgShareBrainBody =>
      'For comparison; the server computes the brain from your session records.';

  @override
  String get tgSecPlanVisibility => 'Plan visibility';

  @override
  String get tgPlanVisibilityBody =>
      'Choose for each category. A subcategory without a rule follows its parent. Rules are enforced in the database.';

  @override
  String get tgAllCategories => 'All categories';

  @override
  String get tgVisibilityFootnote =>
      'Common free time only shares free slots; hidden items count as taken but their content is never sent.';

  @override
  String get tgNoMessagesTitle => 'No messages yet';

  @override
  String get tgNoMessagesBody => 'Start a chat from a friend\'s page.';

  @override
  String get tgNoMessagesYet => 'No messages yet';

  @override
  String get tgMessageDeleted => 'Message deleted';

  @override
  String get tgYou => 'You';

  @override
  String get tgMuted => 'Notifications off';

  @override
  String tgReactWith(String emoji) {
    return 'React with $emoji';
  }

  @override
  String get tgReportMessage => 'Report message';

  @override
  String get tgMore => 'More';

  @override
  String get tgMute => 'Mute notifications';

  @override
  String get tgUnmute => 'Unmute notifications';

  @override
  String tgChatEmptyTitle(String name) {
    return 'Chat with $name';
  }

  @override
  String get tgChatEmptyBody =>
      'Messages are only visible to the two of you. Inappropriate words are starred out.';

  @override
  String get tgMessageHint => 'Long-press to react, copy or report';

  @override
  String get tgWriteMessage => 'Write a message';

  @override
  String get tgSend => 'Send';

  @override
  String get tgReasonHarassment => 'Harassment or bullying';

  @override
  String get tgReasonInappropriate => 'Inappropriate content';

  @override
  String get tgReasonSpam => 'Spam';

  @override
  String get tgReasonChildSafety => 'Child safety';

  @override
  String get tgReasonOther => 'Something else';

  @override
  String get tgReportBody =>
      'What happened? Your report is reviewed; the person is not told who reported. For a message, a copy of it is kept.';

  @override
  String get tgReportDetails => 'Details (optional)';

  @override
  String get tgReportSend => 'Send report';

  @override
  String get tgReportThanks =>
      'Report received. You can also block this person.';

  @override
  String get tgReportUrgent =>
      'If someone is putting you or others in immediate danger, call your local emergency number.';

  @override
  String get tgGlobal => 'Global';

  @override
  String get tgMetricFocus => 'Focus minutes';

  @override
  String get tgMetricStreak => 'Consistency';

  @override
  String get tgBoardNote =>
      'Weekly, resets on Monday. Only server-verified sessions count: overlapping or impossible sessions are left out.';

  @override
  String get tgGlobalNotJoined => 'You have not joined the global leaderboard.';

  @override
  String get tgBoardEmpty => 'No completed sessions this week yet.';

  @override
  String tgDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get tgSharedNew => 'Propose a shared plan';

  @override
  String get tgSharedEmptyTitle => 'No shared plans yet';

  @override
  String get tgSharedEmptyBody =>
      'Propose an activity or project; once your friend accepts, it lands in both of your plans.';

  @override
  String tgProgress(String done, String total) {
    return '$done / $total';
  }

  @override
  String tgWith(String names) {
    return 'With: $names';
  }

  @override
  String get tgStatusConfirmed => 'Confirmed';

  @override
  String get tgStatusCancelled => 'Cancelled';

  @override
  String get tgStatusProposed => 'Waiting for an answer';

  @override
  String tgChangeProposed(String text) {
    return 'Change proposed: $text';
  }

  @override
  String tgChangeWaiting(String text) {
    return 'Change waiting for approval: $text';
  }

  @override
  String get tgSharedAccepted => 'Added to your plan.';

  @override
  String get tgSharedCancel => 'Cancel plan';

  @override
  String get tgSharedCancelBody => 'It is removed from everyone\'s plan.';

  @override
  String get tgSharedLeave => 'Leave';

  @override
  String get tgSharedLeaveBody =>
      'It is removed from your plan; it continues for the others.';

  @override
  String get tgSuggestChange => 'Suggest a change';

  @override
  String tgPatchTitle(String title) {
    return 'name \"$title\"';
  }

  @override
  String get tgSharedKindTitle => 'What are you planning?';

  @override
  String get tgKindActivity => 'Activity';

  @override
  String get tgKindActivityBody => 'Together at a set day and time.';

  @override
  String get tgKindProject => 'Project';

  @override
  String get tgKindProjectBody =>
      'Total time and a deadline; progress is shared.';

  @override
  String get tgSharedNameTitle => 'What should it be called?';

  @override
  String get tgSharedName => 'Name';

  @override
  String get tgSharedNotes => 'Note (optional)';

  @override
  String get tgSharedWithTitle => 'With whom?';

  @override
  String get tgSharedWhenTitle => 'When?';

  @override
  String get tgSharedDeadlineTitle => 'Deadline and total time';

  @override
  String tgSharedTotal(String duration) {
    return 'Total: $duration';
  }

  @override
  String get tgFrom => 'Start';

  @override
  String get tgTo => 'End';

  @override
  String get tgEndAfterStart => 'The end must be after the start.';

  @override
  String get tgSharedRootTitle => 'Which root category?';

  @override
  String get tgSharedRootBody =>
      'Your focus sessions grow the brain by this category.';

  @override
  String get tgNoCategory => 'No category';

  @override
  String get tgSharedConfirmTitle => 'Send it?';

  @override
  String get tgSharedConfirmBody =>
      'It lands as a fixed item in the plan of everyone who accepts. Later changes need the others\' approval.';

  @override
  String get tgSharedSend => 'Send';

  @override
  String get tgSharedSent => 'Proposal sent.';

  @override
  String get tgChangeBody =>
      'The change goes to the other participants; it applies once everyone approves.';

  @override
  String get tgSendChange => 'Send for approval';

  @override
  String get tgChangeSent => 'Change sent for approval.';

  @override
  String get tgFreeTimeBody =>
      'Finds times in the next 7 days when everyone you pick is free. Nobody\'s activities are shown.';

  @override
  String get tgFreeTimeLength => 'At least how long?';

  @override
  String get tgFreeTimeFind => 'Find free time';

  @override
  String get tgFreeTimeNone =>
      'No slot where everyone is free. Try a shorter length.';

  @override
  String get tgPlanHere => 'Plan here';

  @override
  String tgCompareTitle(String name) {
    return 'You and $name';
  }

  @override
  String get tgCompareNote =>
      'The brain is a metaphor, not a measurement. Your friend\'s brain is computed on the server from session records.';

  @override
  String get tgLeftYou => 'You on the left';

  @override
  String tgRightFriend(String name) {
    return '$name on the right';
  }

  @override
  String tgNeurons(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n neurons',
      one: '1 neuron',
    );
    return '$_temp0';
  }

  @override
  String get tgCofocus => 'Co-focus';

  @override
  String get tgCofocusIntro =>
      'You start at the same moment; everyone picks their own task and mode. If someone breaks the plan, the others see a calm note. A session completed together earns a small shared connection.';

  @override
  String get tgCofocusWho => 'Who';

  @override
  String get tgVoice => 'Voice chat';

  @override
  String get tgVoiceBody =>
      'Optional. The microphone starts off and nothing is recorded.';

  @override
  String get tgCofocusInviteAction => 'Invite';

  @override
  String get tgCofocusEnded => 'This co-focus session has ended.';

  @override
  String get tgCofocusLive =>
      'The session has started. Pick your task and join.';

  @override
  String get tgCofocusHostHint =>
      'Start when everyone has picked a task; timers start together.';

  @override
  String get tgCofocusGuestHint => 'Your timer starts when the host starts.';

  @override
  String get tgCofocusMine => 'Your task';

  @override
  String get tgCofocusNoTasks =>
      'You have no pending task today. Add one first.';

  @override
  String get tgCofocusStart => 'Start for everyone';

  @override
  String get tgCofocusJoinNow => 'Join now';

  @override
  String get tgCofocusLeave => 'Leave';

  @override
  String get tgPhaseDone => 'Finished';

  @override
  String get tgPhaseBroken => 'Left their session';

  @override
  String get tgPhaseLeft => 'Left';

  @override
  String get tgPhaseInvited => 'Invited';

  @override
  String get tgPhaseFocus => 'Focusing';

  @override
  String get tgPhaseBreak => 'On a break';

  @override
  String get tgPhasePaused => 'Paused';

  @override
  String get tgPhaseAway => 'Not connected';

  @override
  String get tgPhaseLobby => 'In the lobby';

  @override
  String get tgSpeaking => 'speaking';

  @override
  String tgMutePerson(String name) {
    return 'Mute $name';
  }

  @override
  String tgUnmutePerson(String name) {
    return 'Unmute $name';
  }

  @override
  String get tgVoiceNoRecording =>
      'Nothing is recorded. Muting someone only affects what you hear.';

  @override
  String get tgVoiceConnect => 'Join voice';

  @override
  String get tgVoiceErrPermission =>
      'Microphone permission is needed. You can allow it in settings.';

  @override
  String get tgVoiceErrUnavailable => 'Voice chat is not available right now.';

  @override
  String get tgMicOn => 'Turn microphone on';

  @override
  String get tgMicOff => 'Turn microphone off';

  @override
  String tgNoticeBroken(String name) {
    return '$name left their session. You can keep going.';
  }

  @override
  String tgNoticeCompleted(String name) {
    return '$name finished their session.';
  }

  @override
  String tgNoticeLeft(String name) {
    return '$name left.';
  }

  @override
  String get tgNoticeMessagesTitle => 'NeuroPlan';

  @override
  String get tgNoticeMessagesChannel => 'Messages';

  @override
  String tgNoticeMessagesBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new messages',
      one: '1 new message',
    );
    return '$_temp0';
  }

  @override
  String tgPickMax(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'You can pick up to $n people.',
      one: 'You can pick 1 person.',
    );
    return '$_temp0';
  }

  @override
  String get tgCofocusChooseFirst => 'Pick your task first to start.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingTheme => 'Theme';

  @override
  String get settingSleepGoal => 'Sleep goal';

  @override
  String get secData => 'Data and sources';

  @override
  String get exportTitle => 'Export my data';

  @override
  String get exportSubtitle =>
      'All your data as one JSON file; no internet needed.';

  @override
  String exportError(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'We couldn\'t prepare the file, let\'s try again.',
      'young': 'File didn\'t work, try again!',
      'coder': 'Export failed. Retry.',
      'calm': 'Couldn\'t prepare the file. You can try again in a moment.',
      'other': 'Couldn\'t prepare the file. Try again.',
    });
    return '$_temp0';
  }

  @override
  String get sourcesTitle => 'Scientific sources';

  @override
  String get sourcesSubtitle =>
      'The studies behind every scientific statement in the app';

  @override
  String get sourcesIntro =>
      'Every scientific statement in the app rests on a peer-reviewed source in this list. Evidence levels are shown on the region pages.';

  @override
  String get sourcesCopy => 'Copy link';

  @override
  String get themeSerious => 'Serious';

  @override
  String get themeSeriousBody => 'Calm authority, readability first';

  @override
  String get themePlayful => 'Playful';

  @override
  String get themePlayfulBody => 'Rounded shapes, warm colours';

  @override
  String get themeYoung => 'Young';

  @override
  String get themeYoungBody => 'Energetic and easy to read';

  @override
  String get themeCoder => 'Coder';

  @override
  String get themeCoderBody => 'A terminal feel; monospaced numbers';

  @override
  String get themeCalm => 'Calm';

  @override
  String get themeCalmBody => 'Low saturation, for evenings';

  @override
  String get themeHighContrast => 'High contrast';

  @override
  String get themeHighContrastBody => 'Maximum contrast, bold outlines';

  @override
  String get themeMinimal => 'Minimal';

  @override
  String get themeMinimalBody => 'Grey surfaces, one accent colour';

  @override
  String get pfAnalyses => 'Insights';

  @override
  String get pfWeekFocus => 'Focus this week';

  @override
  String pfLastWeek(String time) {
    return 'Last week $time';
  }

  @override
  String get pfAdherence => 'Plan adherence this week';

  @override
  String get pfNoPlanYet => 'No planned items yet';

  @override
  String get pfStreak => 'Streak';

  @override
  String pfLongest(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days',
      one: '1 day',
    );
    return 'Longest: $_temp0';
  }

  @override
  String get pfStrongest => 'Strongest region';

  @override
  String get pfStrongestEmpty => 'Starts with your first focus session';

  @override
  String get stQTime => 'Where does my time go?';

  @override
  String get stQAdherence => 'How well do I follow my plan?';

  @override
  String get stQBestHours => 'When do I focus best?';

  @override
  String get stQConsistency => 'Am I consistent?';

  @override
  String get stQQuality => 'How is my focus quality changing?';

  @override
  String get stQInterruptions => 'What interrupts me?';

  @override
  String get stQModes => 'Does Pomodoro or deep work suit me better?';

  @override
  String get stQBrain => 'How is my brain map growing?';

  @override
  String get stQProjects => 'Will my projects finish on time?';

  @override
  String get stQSleep => 'Am I planning enough sleep?';

  @override
  String get stQBalance => 'Am I balanced?';

  @override
  String get stQWeekly => 'Weekly report';

  @override
  String get stPeriodWeek => 'Week';

  @override
  String get stPeriodMonth => 'Month';

  @override
  String get stPeriodQuarter => '3 months';

  @override
  String get stPeriodYear => 'Year';

  @override
  String get stPeriodAll => 'All';

  @override
  String get stShowList => 'Show as list';

  @override
  String get stLoading => 'Loading';

  @override
  String stEmptyFocus(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Nothing here yet. Start your first focus session and the charts come alive.',
      'young': 'No data yet. Start a focus session and fill this up!',
      'coder': 'Empty dataset. Your first focus session writes the first row.',
      'calm':
          'No data yet. After your first focus session this slowly fills up.',
      'other': 'No data yet. Start your first focus session and this fills up.',
    });
    return '$_temp0';
  }

  @override
  String stEmptyFocusAction(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Let\'s start a focus session',
      'young': 'Start a focus session',
      'coder': 'Start focus session',
      'calm': 'Start your first focus session',
      'other': 'Start your first focus session',
    });
    return '$_temp0';
  }

  @override
  String stEmptyRated(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'No rated sessions yet. Rate your focus and fatigue after a session and this lights up.',
      'young': 'No rated sessions. Rate them at the end and they show up here.',
      'coder': 'No rated rows. Enter focus and fatigue scores at the end of a session.',
      'calm': 'You haven\'t rated a session yet. Rate focus and fatigue when one ends and it shows up here.',
      'other': 'You haven\'t rated a focus session yet. Rate focus and fatigue when a session ends and it shows up here.',
    });
    return '$_temp0';
  }

  @override
  String stEmptyPlan(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Nothing was planned this period. Add a routine and we\'ll start measuring tomorrow.',
      'young': 'No plan this period. Add a routine and adherence counts from tomorrow.',
      'coder':
          'No planned rows in range. Adherence is computed from the next day.',
      'calm': 'Nothing was planned this period. Once you add a routine, adherence is measured from the next day.',
      'other': 'Nothing was planned in this period. Add a routine or task; adherence is measured from the next day.',
    });
    return '$_temp0';
  }

  @override
  String get stEmptyPlanAction => 'Add an item';

  @override
  String stEmptyProjects(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'No projects. Add one with a deadline and we\'ll track what\'s left together.',
      'young': 'No projects yet. Add one and track what\'s left.',
      'coder': 'Projects table empty. Add one with a total and a deadline.',
      'calm': 'No projects yet. Add one with a deadline and total time to follow the remaining work here.',
      'other': 'No projects yet. Add one with a deadline and total time to track the remaining work here.',
    });
    return '$_temp0';
  }

  @override
  String get stEmptyProjectsAction => 'Add a project';

  @override
  String stEmptySleep(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'You haven\'t told us your sleep window yet. Set it and we\'ll show your sleep here.',
      'young': 'Set your sleep window and your sleep shows up here.',
      'coder': 'Sleep window undefined. Define it in Settings.',
      'calm': 'You haven\'t set a sleep window yet. Once you do, your planned sleep shows up here.',
      'other': 'You haven\'t set a sleep window yet. Once you do, your planned sleep shows up here.',
    });
    return '$_temp0';
  }

  @override
  String get stEmptySleepAction => 'Set sleep window';

  @override
  String stEmptyWeekly(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'No focus sessions these two weeks. Your report is ready after the first one.',
      'young': 'No sessions for two weeks. Report\'s ready after your first!',
      'coder': 'No rows in the last two weeks; report not generated.',
      'calm': 'No focus sessions this week or last week. The report is ready after your first session.',
      'other': 'No focus sessions this week or last week. The report is ready after your first session.',
    });
    return '$_temp0';
  }

  @override
  String get stNoSessionsHere => 'No focus sessions here.';

  @override
  String stMoreSessions(int n) {
    return 'and $n more';
  }

  @override
  String get stFreeSession => 'Free focus';

  @override
  String get stBroken => 'broken';

  @override
  String stFocusScoreShort(int n) {
    return 'focus $n/5';
  }

  @override
  String stPercent(int n) {
    return '$n%';
  }

  @override
  String stDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String stNeurons(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n neurons',
      one: '1 neuron',
    );
    return '$_temp0';
  }

  @override
  String stNeuronsGained(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n neurons',
      one: '1 neuron',
    );
    return '+$_temp0';
  }

  @override
  String stPoints(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n points',
      one: '1 point',
    );
    return '$_temp0';
  }

  @override
  String get stNoCategory => 'Uncategorised';

  @override
  String get stUncategorized => 'No subcategory';

  @override
  String get stDirectly => 'This category itself';

  @override
  String get stUpLevel => 'Up one level';

  @override
  String get stNone => 'none';

  @override
  String stTimeInsight(String name, String time, int pct) {
    return 'You spent the most time on $name: $time ($pct%).';
  }

  @override
  String stTimeTotal(String time) {
    return 'Total focus: $time. Focus time in broken sessions counts too.';
  }

  @override
  String get stPlanned => 'Planned';

  @override
  String get stDone => 'Done';

  @override
  String get stAdherence => 'Plan adherence';

  @override
  String stDoneOf(int done, int planned) {
    return '$done of $planned items';
  }

  @override
  String stAdherenceInsight(int done, int planned, int pct) {
    return 'You did $done of the $planned items you planned ($pct%).';
  }

  @override
  String get stDailyAdherence => 'Daily adherence';

  @override
  String stBestInsight(String from, String to, String score) {
    return 'Your best focus hours are $from–$to (average focus score $score).';
  }

  @override
  String get stBestNeedMore =>
      'To find your best hours, you need at least 3 rated sessions in the same time window.';

  @override
  String get stHeatCaption =>
      'Each cell is the average focus score (1–5) of sessions started on that day and hour. Grey: no sessions.';

  @override
  String stScoreCount(String score, int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sessions',
      one: '1 session',
    );
    return '$score · $_temp0';
  }

  @override
  String get stNoRating => 'No rating';

  @override
  String stStreakInsight(int current, int longest) {
    return 'Your current streak is $current days; your longest is $longest days.';
  }

  @override
  String get stStreakCurrent => 'Current streak';

  @override
  String get stStreakLongest => 'Longest streak';

  @override
  String stCalendarCaption(int n) {
    return 'In the last year you completed at least one focus session on $n days.';
  }

  @override
  String get stLess => 'Less';

  @override
  String get stMore => 'More';

  @override
  String get stFocusScore => 'Focus score';

  @override
  String get stFatigueScore => 'Fatigue score';

  @override
  String stFocusFatigue(String focus, String fatigue) {
    return 'Focus $focus · Fatigue $fatigue';
  }

  @override
  String stQualityUp(String d) {
    return 'Your focus score rose by $d in the second half of the period.';
  }

  @override
  String stQualityDown(String d) {
    return 'Your focus score fell by $d in the second half of the period.';
  }

  @override
  String get stQualityStable =>
      'Your focus score stayed about the same this period.';

  @override
  String get stQualityNeedMore =>
      'A trend needs rated sessions at two or more different times.';

  @override
  String get stQualityCaption =>
      'Scores are the values you give at the end of a session (1–5).';

  @override
  String get stInterruptions => 'Interruptions';

  @override
  String get stPerSession => 'Per session';

  @override
  String get stByReason => 'By reason';

  @override
  String get stByHour => 'By hour of day';

  @override
  String stInterruptInsight(String reason, String hour, int n) {
    return 'There were $n interruptions this period; most often: $reason, mostly around $hour.';
  }

  @override
  String stNoInterruptions(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Not a single interruption this period, spotless!',
      'young': 'Zero interruptions this period!',
      'coder': 'Interruption count: 0.',
      'calm': 'No interruptions in your focus sessions this period.',
      'other': 'No interruptions in your focus sessions this period.',
    });
    return '$_temp0';
  }

  @override
  String get stReasonAppLeft => 'Left the app';

  @override
  String get stReasonShade => 'Notification shade';

  @override
  String get stReasonScreenOff => 'Screen turned off';

  @override
  String get stReasonCall => 'Phone call';

  @override
  String get stReasonAlarm => 'Alarm';

  @override
  String get stReasonOther => 'Other';

  @override
  String stModesNeedMore(int pomodoro, int deep) {
    return 'To compare, you need $pomodoro more Pomodoro and $deep more deep work sessions.';
  }

  @override
  String stModeProgress(String mode, int n) {
    return '$mode: $n of 5 sessions';
  }

  @override
  String get stModesHow =>
      'Pick the mode when you start a focus session; once you have 5 sessions of each, we compare them using your own data.';

  @override
  String stModesPomodoroHigher(String a, String b) {
    return 'In your data, your focus score is higher with Pomodoro ($a vs $b).';
  }

  @override
  String stModesDeepHigher(String a, String b) {
    return 'In your data, your focus score is higher with deep work ($a vs $b).';
  }

  @override
  String get stModesClose =>
      'In your data, your focus scores in the two modes are close.';

  @override
  String get stModesScience =>
      'Research shows no consistent evidence that one method is better in general; this comparison is only your own data.';

  @override
  String get stCompletion => 'Completion rate';

  @override
  String get stAvgLength => 'Average length';

  @override
  String get stSessions => 'Sessions';

  @override
  String stModeSessions(String mode) {
    return '$mode sessions';
  }

  @override
  String stBrainInsight(String region, int n) {
    return 'In your brain map this period, the most neurons were added to $region ($n).';
  }

  @override
  String get stBrainNoGrowth =>
      'No neurons were added to your brain map this period.';

  @override
  String stBrainCaption(int n) {
    return 'Lines show totals for the three regions that gained the most. Connection strength this period: +$n.';
  }

  @override
  String get stFadingTitle => 'Fading regions';

  @override
  String get stFadingNone => 'No regions are fading right now.';

  @override
  String get stFadingBody =>
      'Activities linked to these regions haven\'t had time for a while. Neurons are never removed; they light up again when you return.';

  @override
  String stBrightness(int n) {
    return 'Brightness $n%';
  }

  @override
  String get stBrainMetaphor =>
      'The brain map is a metaphor, not a measurement of your brain.';

  @override
  String get stOpenProject => 'Open project';

  @override
  String get stProjectNoTotal =>
      'No total time set; add one to the project to calculate the remaining work.';

  @override
  String get stRemaining => 'Remaining';

  @override
  String stRemainingOf(String left, String total) {
    return '$left of $total left';
  }

  @override
  String stProjectDone(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'Project done! Nicely done.',
      'young': 'Project finished, awesome!',
      'coder': 'Project: complete (exit 0).',
      'calm': 'Project complete.',
      'other': 'Project complete.',
    });
    return '$_temp0';
  }

  @override
  String get stProjectNoForecast =>
      'No recent work or planned parts to forecast from.';

  @override
  String stProjectFinishPlan(String date) {
    return 'Expected finish by plan: $date';
  }

  @override
  String stProjectFinishPace(String date) {
    return 'Expected finish at your last-14-day pace: $date';
  }

  @override
  String stProjectOnTime(String date) {
    return 'deadline $date, on track';
  }

  @override
  String stProjectLate(String date) {
    return 'deadline $date, not on track at this pace';
  }

  @override
  String get stSleepPlanned => 'Planned sleep';

  @override
  String stSleepInsight(String avg, String diff) {
    return 'Your planned sleep averages $avg; $diff.';
  }

  @override
  String get stSleepOnGoal => 'right on your goal';

  @override
  String stSleepAbove(String d) {
    return '$d above your goal';
  }

  @override
  String stSleepBelow(String d) {
    return '$d below your goal';
  }

  @override
  String get stSleepNotice =>
      'Your planned sleep is under 7 hours. You might want to look at your sleep window.';

  @override
  String stSleepGoalLine(String goal) {
    return 'The horizontal line is your sleep goal: $goal. Values are the planned window, not measured sleep.';
  }

  @override
  String stBalanceAll(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'You gave every area some time, a colourful period!',
      'young': 'Time for every area, great balance!',
      'coder': 'All roots > 0 min.',
      'calm': 'You gave time to every area this period.',
      'other': 'You gave time to every area this period.',
    });
    return '$_temp0';
  }

  @override
  String stBalanceNeglected(int n, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n areas had no focus time this period',
      one: 'One area had no focus time this period',
    );
    return '$_temp0: $names.';
  }

  @override
  String get stBalanceCaption =>
      'How focus sessions split across root categories. Rest and Sleep isn\'t measured by focus, so it never counts as neglected.';

  @override
  String get stShareImage => 'Share as image';

  @override
  String stShareError(String tone) {
    String _temp0 = intl.Intl.selectLogic(tone, {
      'playful': 'We couldn\'t prepare the image, let\'s try again.',
      'young': 'Image didn\'t work, try again!',
      'coder': 'Image render failed. Retry.',
      'calm': 'Couldn\'t prepare the image. You can try again in a moment.',
      'other': 'Couldn\'t prepare the image. Try again.',
    });
    return '$_temp0';
  }

  @override
  String get stWeekFocus => 'Focus time';

  @override
  String get stWeekSessions => 'Completed sessions';

  @override
  String get stWeekActiveDays => 'Active days';

  @override
  String get stSameAsLastWeek => 'same as last week';

  @override
  String stUpBy(String d) {
    return '$d more than last week';
  }

  @override
  String stDownBy(String d) {
    return '$d less than last week';
  }

  @override
  String stWeekTop(String name) {
    return 'Most time: $name';
  }
}
