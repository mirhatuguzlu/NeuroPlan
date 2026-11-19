import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:neuroplan/ui/features/brain/brain_scene.dart';
import 'package:neuroplan/ui/features/brain/bridge.dart';

/// Testte 3D sahne: gönderilen mesajlar kaydedilir, sahne mesajları elle verilir.
class FakeBrainScene implements BrainScene {
  final sent = <ToScene>[];
  final _ctl = StreamController<FromScene>.broadcast();

  void emit(FromScene m) => _ctl.add(m);

  List<T> sentOf<T extends ToScene>() => sent.whereType<T>().toList();

  @override
  Stream<FromScene> get messages => _ctl.stream;

  @override
  void send(ToScene message) => sent.add(message);

  @override
  Widget view() => const ColoredBox(
    key: ValueKey('fake-brain-scene'),
    color: Color(0xFF000000),
  );

  @override
  void dispose() => _ctl.close();
}
