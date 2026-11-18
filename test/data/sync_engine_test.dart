import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:neuroplan/data/local/app_database.dart';

import 'test_support.dart';

void main() {
  late FakeServer server;
  late TestDevice a;
  late TestDevice b;
  var nowA = 0;
  var nowB = 0;
  const id = '0193a5b2-0000-7000-8000-000000000001';

  setUp(() {
    server = FakeServer();
    nowA = 1000;
    nowB = 1000;
    a = TestDevice(remote: server, now: () => nowA);
    b = TestDevice(remote: server, now: () => nowB);
  });

  tearDown(() async {
    await a.db.close();
    await b.db.close();
  });

  Future<Activity> on(TestDevice d) async =>
      (await d.writer.find(d.db.activities, id))!;

  Future<void> createOnA() async {
    await a.writer.insert(
      a.db.activities,
      ActivitiesCompanion.insert(id: id, kind: 'task', title: 'Koşu'),
    );
    await a.sync.syncOnce();
    await b.sync.syncOnce();
  }

  test('bir cihazda eklenen satır diğerine gelir, outbox boşalır', () async {
    await createOnA();
    expect((await on(b)).title, 'Koşu');
    expect(await a.outbox(), isEmpty);
  });

  test('farklı alanlardaki çevrimdışı düzenlemeler birlikte korunur', () async {
    await createOnA();
    nowA = 2000;
    await a.writer.update(
      a.db.activities,
      id,
      const ActivitiesCompanion(title: Value('Sabah koşusu')),
    );
    nowB = 2500;
    await b.writer.update(
      b.db.activities,
      id,
      const ActivitiesCompanion(notes: Value('5 km')),
    );

    await a.sync.syncOnce();
    await b.sync.syncOnce();
    await a.sync.syncOnce();

    for (final d in [a, b]) {
      final row = await on(d);
      expect(row.title, 'Sabah koşusu');
      expect(row.notes, '5 km');
    }
  });

  test('aynı alanda son yazan kazanır, sunucuya son ulaşan değil', () async {
    await createOnA();
    nowA = 4000;
    await a.writer.update(
      a.db.activities,
      id,
      const ActivitiesCompanion(title: Value('A sonra yazdı')),
    );
    nowB = 3000;
    await b.writer.update(
      b.db.activities,
      id,
      const ActivitiesCompanion(title: Value('B önce yazdı')),
    );

    await a.sync.syncOnce(); // A önce gönderir
    await b.sync.syncOnce(); // B'nin eski yaması sunucuda kaybeder
    await a.sync.syncOnce();

    expect((await on(a)).title, 'A sonra yazdı');
    expect((await on(b)).title, 'A sonra yazdı');
  });

  test('yumuşak silme eşitlenir', () async {
    await createOnA();
    await b.writer.softDelete(b.db.activities, id);
    await b.sync.syncOnce();
    await a.sync.syncOnce();
    expect((await on(a)).deletedAt, isNotNull);
  });

  test('ağ hatasında outbox korunur, kalıcı red "dead" olur', () async {
    await a.writer.insert(
      a.db.activities,
      ActivitiesCompanion.insert(id: id, kind: 'task', title: 'Koşu'),
    );
    server.offline = true;
    await expectLater(a.sync.syncOnce(), throwsA(anything));
    expect(await a.outbox(), hasLength(1));

    server
      ..offline = false
      ..rejectCodes[0] = '23514';
    await a.sync.syncOnce();
    final entry = (await a.outbox()).single;
    expect(entry.dead, isTrue);
    expect(entry.lastError, startsWith('23514'));
  });
}
