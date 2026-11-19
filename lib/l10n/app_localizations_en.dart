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
  String get errorTitle => 'Something went wrong';

  @override
  String get errorBody =>
      'Your data is safe on this device. You can try again.';

  @override
  String get saveError => 'Couldn\'t save. Try again.';

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
      'Light, dark or the same as your device. You can change it any time in Profile.';

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
  String get onbFirstTitle => 'Let\'s add your first routine';

  @override
  String get onbFirstBody =>
      'The app assumes nothing about your life. There are no ready-made examples; you add the first item yourself.';

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
  String get todayEmptyTitle => 'Your plan is empty';

  @override
  String get todayEmptyBody =>
      'As you add routines and tasks your day appears here, and your free time is calculated.';

  @override
  String get todayEmptyAction => 'Add your first routine';

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
  String get catEmpty => 'No subcategories or items yet.';

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
  String get profileTitle => 'Profile and settings';

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
  String get focusBrokenHeading => 'Session broken';

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
  String get focusBrokenAgain =>
      'It happens. Start again whenever you\'re ready.';

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
  String get focusGainTitle => 'What this session added';

  @override
  String focusGainBody(String root, int minutes) {
    return 'You spent $minutes min on regions associated with $root.';
  }

  @override
  String get focusGainNone =>
      'It lasted less than a minute; no time to add to the brain yet.';

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
  String get brainEmptyTitle => 'No lit neurons yet';

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
}
