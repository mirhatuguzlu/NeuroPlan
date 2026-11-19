import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/app/providers.dart';
import 'package:neuroplan/app/router.dart';
import 'package:neuroplan/data/local/app_database.dart';
import 'package:neuroplan/data/remote/social_api.dart';
import 'package:neuroplan/l10n/app_localizations.dart';
import 'package:neuroplan/ui/features/together/together_providers.dart';
import 'package:neuroplan/ui/features/together/together_screen.dart';
import 'package:neuroplan/ui/features/together/together_widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show PostgrestException, User;

import 'harness.dart';

const _me = '00000000-0000-0000-0000-0000000000a1';
const _friend = '00000000-0000-0000-0000-0000000000b1';

User _user({bool anonymous = false}) => User(
  id: _me,
  appMetadata: const {},
  userMetadata: const {},
  aud: 'authenticated',
  createdAt: '2026-11-19T00:00:00Z',
  isAnonymous: anonymous,
);

/// Sunucusuz Birlikte: kurallar veritabanında (pgTAP testleri); burada yalnız ekranlar.
class FakeSocialApi extends Fake implements SocialApi {
  FakeSocialApi({this.tier = SocialTier.adult, this.friendList = const []});

  final SocialTier tier;
  final List<Friend> friendList;
  final sent = <String>[];
  final reports = <String>[];
  var blocked = <String>[];

  @override
  String? get myId => _me;

  @override
  Future<SocialStatus> status() async => SocialStatus(
    anonymous: false,
    age: 30,
    tier: tier,
    profile: const SocialProfile(displayName: 'Ben'),
  );

  @override
  Future<FriendOverview> friends() async => FriendOverview(friends: friendList);

  @override
  Future<TogetherBadges> badges() async => const TogetherBadges(unread: 2);

  @override
  Future<List<Json>> myVisibility() async => const [];

  @override
  Future<String> openDirect(String friendId) async => 'conv-1';

  @override
  Future<List<ChatMessage>> messages(
    String conversationId, {
    int limit = 60,
  }) async => [
    for (final (i, b) in sent.indexed)
      ChatMessage(
        id: 'm$i',
        userId: _me,
        body: b,
        createdAt: DateTime(2026, 11, 19, 10, i),
      ),
  ];

  @override
  Future<List<ConversationSummary>> conversations() async => const [];

  @override
  Future<void> markRead(String conversationId) async {}

  @override
  Future<void> sendMessage(String conversationId, String body) async {
    if (sent.length >= 2) {
      throw const SocialException(SocialError.rateLimited);
    }
    sent.add(body);
  }

  @override
  Future<void> report({
    required String targetType,
    String? targetId,
    String? userId,
    required String reason,
    String? details,
  }) async => reports.add('$targetType:$userId:$reason');

  @override
  Future<void> block(String userId) async => blocked.add(userId);

  @override
  Future<void> publishCalendar(
    DateTime from,
    DateTime to,
    List<PublishedBlock> blocks,
  ) async {}

  @override
  Future<List<SharedActivity>> shared() async => const [];
}

Future<Harness> _pump(
  WidgetTester t, {
  required FakeSocialApi? api,
  User? user,
  int? birthYear = 1990,
}) => pumpApp(
  t,
  seed: (c) => c
      .read(profileRepositoryProvider)
      .update(ProfilesCompanion(birthYear: Value(birthYear))),
  overrides: [
    socialApiProvider.overrideWithValue(api),
    authUserProvider.overrideWith((ref) => Stream.value(user)),
    // Canlı kanal testte açılmaz.
    togetherLiveProvider.overrideWithValue(null),
  ],
);

Future<void> _openTogether(Harness h) async {
  h.read(routerProvider).go('/together');
  await h.settle();
}

void main() {
  test('en düşük olası yaş: yalnız doğum yılı tutulur', () {
    expect(minAgeOf(2011, now: DateTime(2026, 11, 19)), 14);
    expect(minAgeOf(2010, now: DateTime(2026, 1, 1)), 15);
  });

  test('sunucu hata kodları kullanıcı metnine çevrilir', () {
    SocialException m(String code, [String msg = '']) =>
        SocialException.from(PostgrestException(message: msg, code: code));
    expect(m('NP429').kind, SocialError.rateLimited);
    expect(m('NP404').kind, SocialError.notFound);
    expect(m('42501').kind, SocialError.forbidden);
    expect(m('NP409', 'partner_taken').detail, contains('partner_taken'));
  });

  testWidgets('sunucu ayarı yoksa Birlikte bunu söyler, işlevsiz buton yok', (
    t,
  ) async {
    final h = await _pump(t, api: null);
    await _openTogether(h);
    expect(find.text('Birlikte bölümü sunucu ister'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
  });

  testWidgets('misafir: Google ile bağlan ister', (t) async {
    final h = await _pump(
      t,
      api: FakeSocialApi(),
      user: _user(anonymous: true),
    );
    await _openTogether(h);
    expect(find.text('Google ile bağlan'), findsOneWidget);
    await h.expectAccessible();
  });

  testWidgets('15 yaş altı: Birlikte kapalı ve nedeni yazılı', (t) async {
    final h = await _pump(
      t,
      api: FakeSocialApi(),
      user: _user(),
      birthYear: DateTime.now().year - 14,
    );
    await _openTogether(h);
    expect(find.text('Birlikte bölümü 15 yaşında açılır'), findsOneWidget);
  });

  testWidgets('arkadaş yoksa boş durum ilk daveti gösterir', (t) async {
    final h = await _pump(t, api: FakeSocialApi(), user: _user());
    await _openTogether(h);
    expect(find.text('İlk arkadaşını davet et'), findsOneWidget);
    await h.tap(find.text('Arkadaş davet et'));
    expect(find.text('Davet kodun'), findsOneWidget);
  });

  testWidgets(
    'arkadaş varken merkez: tek amaçlı ekranlara giriş, okunmamış rozeti',
    (t) async {
      final h = await _pump(
        t,
        api: FakeSocialApi(
          friendList: const [Friend(userId: _friend, displayName: 'Ayşe')],
        ),
        user: _user(),
      );
      await _openTogether(h);
      expect(find.text('Partner seç'), findsOneWidget);
      expect(find.text('Mesajlar'), findsOneWidget);
      expect(find.text('Gizlilik ayarları'), findsOneWidget);
      expect(find.text('2'), findsWidgets); // okunmamış mesaj rozeti
      await h.expectAccessible();
    },
  );

  testWidgets(
    'arkadaş sayfası: mesaj gönderilir, hız sınırı anlaşılır dille söylenir',
    (t) async {
      final api = FakeSocialApi(
        friendList: const [Friend(userId: _friend, displayName: 'Ayşe')],
      );
      final h = await _pump(t, api: api, user: _user());
      h.read(routerProvider).push('/together/friend/$_friend');
      await h.settle();
      await h.tap(find.text('Mesaj gönder'));
      for (final m in ['selam', 'nasılsın', 'üçüncü']) {
        await t.enterText(find.byType(TextField), m);
        await h.tap(find.byTooltip('Gönder'));
      }
      expect(api.sent, ['selam', 'nasılsın']);
      expect(
        find.text('Biraz yavaşla; kısa bir süre sonra tekrar dene.'),
        findsOneWidget,
      );
      expect(find.text('nasılsın'), findsOneWidget);
    },
  );

  testWidgets('şikâyet: neden seçilmeden gönderilemez, seçince gider', (
    t,
  ) async {
    final api = FakeSocialApi(
      friendList: const [Friend(userId: _friend, displayName: 'Ayşe')],
    );
    final h = await _pump(t, api: api, user: _user());
    h.read(routerProvider).push('/together/report?type=user&user=$_friend');
    await h.settle();
    final send = find.ancestor(
      of: find.text('Şikâyeti gönder'),
      matching: find.byType(FilledButton),
    );
    expect(t.widget<FilledButton>(send).onPressed, isNull);
    await h.tap(find.text('Taciz ya da zorbalık'));
    await h.tap(find.text('Şikâyeti gönder'));
    expect(api.reports, ['user:$_friend:harassment']);
  });

  testWidgets('engelleme onay ister', (t) async {
    final api = FakeSocialApi(
      friendList: const [Friend(userId: _friend, displayName: 'Ayşe')],
    );
    final h = await _pump(t, api: api, user: _user());
    h.read(routerProvider).push('/together/friend/$_friend');
    await h.settle();
    await h.tap(find.text('Engelle'));
    expect(find.text('Ayşe engellensin mi?'), findsOneWidget);
    await h.tap(find.widgetWithText(FilledButton, 'Engelle'));
    expect(api.blocked, [_friend]);
  });

  test('görünürlük düzey adları', () async {
    // Varsayılan etiket, düzeyi olmayan kurala karşılık gelir.
    expect(levelText(lookupL10n(const Locale('tr')), null), 'Varsayılan');
  });
}
