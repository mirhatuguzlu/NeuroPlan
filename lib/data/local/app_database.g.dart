// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RootCategoriesTable extends RootCategories
    with TableInfo<$RootCategoriesTable, RootCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RootCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameTrMeta = const VerificationMeta('nameTr');
  @override
  late final GeneratedColumn<String> nameTr = GeneratedColumn<String>(
    'name_tr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionTrMeta = const VerificationMeta(
    'descriptionTr',
  );
  @override
  late final GeneratedColumn<String> descriptionTr = GeneratedColumn<String>(
    'description_tr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionEnMeta = const VerificationMeta(
    'descriptionEn',
  );
  @override
  late final GeneratedColumn<String> descriptionEn = GeneratedColumn<String>(
    'description_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    sortOrder,
    nameTr,
    nameEn,
    descriptionTr,
    descriptionEn,
    icon,
    color,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'root_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<RootCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('name_tr')) {
      context.handle(
        _nameTrMeta,
        nameTr.isAcceptableOrUnknown(data['name_tr']!, _nameTrMeta),
      );
    } else if (isInserting) {
      context.missing(_nameTrMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('description_tr')) {
      context.handle(
        _descriptionTrMeta,
        descriptionTr.isAcceptableOrUnknown(
          data['description_tr']!,
          _descriptionTrMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionTrMeta);
    }
    if (data.containsKey('description_en')) {
      context.handle(
        _descriptionEnMeta,
        descriptionEn.isAcceptableOrUnknown(
          data['description_en']!,
          _descriptionEnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionEnMeta);
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    } else if (isInserting) {
      context.missing(_iconMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  RootCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RootCategory(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      nameTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_tr'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      descriptionTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_tr'],
      )!,
      descriptionEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description_en'],
      )!,
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      )!,
    );
  }

  @override
  $RootCategoriesTable createAlias(String alias) {
    return $RootCategoriesTable(attachedDatabase, alias);
  }
}

class RootCategory extends DataClass implements Insertable<RootCategory> {
  final String key;
  final int sortOrder;
  final String nameTr;
  final String nameEn;
  final String descriptionTr;
  final String descriptionEn;
  final String icon;
  final String color;
  const RootCategory({
    required this.key,
    required this.sortOrder,
    required this.nameTr,
    required this.nameEn,
    required this.descriptionTr,
    required this.descriptionEn,
    required this.icon,
    required this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['sort_order'] = Variable<int>(sortOrder);
    map['name_tr'] = Variable<String>(nameTr);
    map['name_en'] = Variable<String>(nameEn);
    map['description_tr'] = Variable<String>(descriptionTr);
    map['description_en'] = Variable<String>(descriptionEn);
    map['icon'] = Variable<String>(icon);
    map['color'] = Variable<String>(color);
    return map;
  }

  RootCategoriesCompanion toCompanion(bool nullToAbsent) {
    return RootCategoriesCompanion(
      key: Value(key),
      sortOrder: Value(sortOrder),
      nameTr: Value(nameTr),
      nameEn: Value(nameEn),
      descriptionTr: Value(descriptionTr),
      descriptionEn: Value(descriptionEn),
      icon: Value(icon),
      color: Value(color),
    );
  }

  factory RootCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RootCategory(
      key: serializer.fromJson<String>(json['key']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      nameTr: serializer.fromJson<String>(json['name_tr']),
      nameEn: serializer.fromJson<String>(json['name_en']),
      descriptionTr: serializer.fromJson<String>(json['description_tr']),
      descriptionEn: serializer.fromJson<String>(json['description_en']),
      icon: serializer.fromJson<String>(json['icon']),
      color: serializer.fromJson<String>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'sort_order': serializer.toJson<int>(sortOrder),
      'name_tr': serializer.toJson<String>(nameTr),
      'name_en': serializer.toJson<String>(nameEn),
      'description_tr': serializer.toJson<String>(descriptionTr),
      'description_en': serializer.toJson<String>(descriptionEn),
      'icon': serializer.toJson<String>(icon),
      'color': serializer.toJson<String>(color),
    };
  }

  RootCategory copyWith({
    String? key,
    int? sortOrder,
    String? nameTr,
    String? nameEn,
    String? descriptionTr,
    String? descriptionEn,
    String? icon,
    String? color,
  }) => RootCategory(
    key: key ?? this.key,
    sortOrder: sortOrder ?? this.sortOrder,
    nameTr: nameTr ?? this.nameTr,
    nameEn: nameEn ?? this.nameEn,
    descriptionTr: descriptionTr ?? this.descriptionTr,
    descriptionEn: descriptionEn ?? this.descriptionEn,
    icon: icon ?? this.icon,
    color: color ?? this.color,
  );
  RootCategory copyWithCompanion(RootCategoriesCompanion data) {
    return RootCategory(
      key: data.key.present ? data.key.value : this.key,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      nameTr: data.nameTr.present ? data.nameTr.value : this.nameTr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      descriptionTr: data.descriptionTr.present
          ? data.descriptionTr.value
          : this.descriptionTr,
      descriptionEn: data.descriptionEn.present
          ? data.descriptionEn.value
          : this.descriptionEn,
      icon: data.icon.present ? data.icon.value : this.icon,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RootCategory(')
          ..write('key: $key, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('nameTr: $nameTr, ')
          ..write('nameEn: $nameEn, ')
          ..write('descriptionTr: $descriptionTr, ')
          ..write('descriptionEn: $descriptionEn, ')
          ..write('icon: $icon, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    key,
    sortOrder,
    nameTr,
    nameEn,
    descriptionTr,
    descriptionEn,
    icon,
    color,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RootCategory &&
          other.key == this.key &&
          other.sortOrder == this.sortOrder &&
          other.nameTr == this.nameTr &&
          other.nameEn == this.nameEn &&
          other.descriptionTr == this.descriptionTr &&
          other.descriptionEn == this.descriptionEn &&
          other.icon == this.icon &&
          other.color == this.color);
}

class RootCategoriesCompanion extends UpdateCompanion<RootCategory> {
  final Value<String> key;
  final Value<int> sortOrder;
  final Value<String> nameTr;
  final Value<String> nameEn;
  final Value<String> descriptionTr;
  final Value<String> descriptionEn;
  final Value<String> icon;
  final Value<String> color;
  final Value<int> rowid;
  const RootCategoriesCompanion({
    this.key = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.nameTr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.descriptionTr = const Value.absent(),
    this.descriptionEn = const Value.absent(),
    this.icon = const Value.absent(),
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RootCategoriesCompanion.insert({
    required String key,
    required int sortOrder,
    required String nameTr,
    required String nameEn,
    required String descriptionTr,
    required String descriptionEn,
    required String icon,
    required String color,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       sortOrder = Value(sortOrder),
       nameTr = Value(nameTr),
       nameEn = Value(nameEn),
       descriptionTr = Value(descriptionTr),
       descriptionEn = Value(descriptionEn),
       icon = Value(icon),
       color = Value(color);
  static Insertable<RootCategory> custom({
    Expression<String>? key,
    Expression<int>? sortOrder,
    Expression<String>? nameTr,
    Expression<String>? nameEn,
    Expression<String>? descriptionTr,
    Expression<String>? descriptionEn,
    Expression<String>? icon,
    Expression<String>? color,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (nameTr != null) 'name_tr': nameTr,
      if (nameEn != null) 'name_en': nameEn,
      if (descriptionTr != null) 'description_tr': descriptionTr,
      if (descriptionEn != null) 'description_en': descriptionEn,
      if (icon != null) 'icon': icon,
      if (color != null) 'color': color,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RootCategoriesCompanion copyWith({
    Value<String>? key,
    Value<int>? sortOrder,
    Value<String>? nameTr,
    Value<String>? nameEn,
    Value<String>? descriptionTr,
    Value<String>? descriptionEn,
    Value<String>? icon,
    Value<String>? color,
    Value<int>? rowid,
  }) {
    return RootCategoriesCompanion(
      key: key ?? this.key,
      sortOrder: sortOrder ?? this.sortOrder,
      nameTr: nameTr ?? this.nameTr,
      nameEn: nameEn ?? this.nameEn,
      descriptionTr: descriptionTr ?? this.descriptionTr,
      descriptionEn: descriptionEn ?? this.descriptionEn,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (nameTr.present) {
      map['name_tr'] = Variable<String>(nameTr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (descriptionTr.present) {
      map['description_tr'] = Variable<String>(descriptionTr.value);
    }
    if (descriptionEn.present) {
      map['description_en'] = Variable<String>(descriptionEn.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RootCategoriesCompanion(')
          ..write('key: $key, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('nameTr: $nameTr, ')
          ..write('nameEn: $nameEn, ')
          ..write('descriptionTr: $descriptionTr, ')
          ..write('descriptionEn: $descriptionEn, ')
          ..write('icon: $icon, ')
          ..write('color: $color, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BrainRegionsTable extends BrainRegions
    with TableInfo<$BrainRegionsTable, BrainRegion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrainRegionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameTrMeta = const VerificationMeta('nameTr');
  @override
  late final GeneratedColumn<String> nameTr = GeneratedColumn<String>(
    'name_tr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameEnMeta = const VerificationMeta('nameEn');
  @override
  late final GeneratedColumn<String> nameEn = GeneratedColumn<String>(
    'name_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hemisphereMeta = const VerificationMeta(
    'hemisphere',
  );
  @override
  late final GeneratedColumn<String> hemisphere = GeneratedColumn<String>(
    'hemisphere',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _meshNameMeta = const VerificationMeta(
    'meshName',
  );
  @override
  late final GeneratedColumn<String> meshName = GeneratedColumn<String>(
    'mesh_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isInnerMeta = const VerificationMeta(
    'isInner',
  );
  @override
  late final GeneratedColumn<bool> isInner = GeneratedColumn<bool>(
    'is_inner',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_inner" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    key,
    sortOrder,
    nameTr,
    nameEn,
    hemisphere,
    meshName,
    isInner,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brain_regions';
  @override
  VerificationContext validateIntegrity(
    Insertable<BrainRegion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    if (data.containsKey('name_tr')) {
      context.handle(
        _nameTrMeta,
        nameTr.isAcceptableOrUnknown(data['name_tr']!, _nameTrMeta),
      );
    } else if (isInserting) {
      context.missing(_nameTrMeta);
    }
    if (data.containsKey('name_en')) {
      context.handle(
        _nameEnMeta,
        nameEn.isAcceptableOrUnknown(data['name_en']!, _nameEnMeta),
      );
    } else if (isInserting) {
      context.missing(_nameEnMeta);
    }
    if (data.containsKey('hemisphere')) {
      context.handle(
        _hemisphereMeta,
        hemisphere.isAcceptableOrUnknown(data['hemisphere']!, _hemisphereMeta),
      );
    } else if (isInserting) {
      context.missing(_hemisphereMeta);
    }
    if (data.containsKey('mesh_name')) {
      context.handle(
        _meshNameMeta,
        meshName.isAcceptableOrUnknown(data['mesh_name']!, _meshNameMeta),
      );
    } else if (isInserting) {
      context.missing(_meshNameMeta);
    }
    if (data.containsKey('is_inner')) {
      context.handle(
        _isInnerMeta,
        isInner.isAcceptableOrUnknown(data['is_inner']!, _isInnerMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  BrainRegion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BrainRegion(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      nameTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_tr'],
      )!,
      nameEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_en'],
      )!,
      hemisphere: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hemisphere'],
      )!,
      meshName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mesh_name'],
      )!,
      isInner: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_inner'],
      )!,
    );
  }

  @override
  $BrainRegionsTable createAlias(String alias) {
    return $BrainRegionsTable(attachedDatabase, alias);
  }
}

class BrainRegion extends DataClass implements Insertable<BrainRegion> {
  final String key;
  final int sortOrder;
  final String nameTr;
  final String nameEn;
  final String hemisphere;
  final String meshName;
  final bool isInner;
  const BrainRegion({
    required this.key,
    required this.sortOrder,
    required this.nameTr,
    required this.nameEn,
    required this.hemisphere,
    required this.meshName,
    required this.isInner,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['sort_order'] = Variable<int>(sortOrder);
    map['name_tr'] = Variable<String>(nameTr);
    map['name_en'] = Variable<String>(nameEn);
    map['hemisphere'] = Variable<String>(hemisphere);
    map['mesh_name'] = Variable<String>(meshName);
    map['is_inner'] = Variable<bool>(isInner);
    return map;
  }

  BrainRegionsCompanion toCompanion(bool nullToAbsent) {
    return BrainRegionsCompanion(
      key: Value(key),
      sortOrder: Value(sortOrder),
      nameTr: Value(nameTr),
      nameEn: Value(nameEn),
      hemisphere: Value(hemisphere),
      meshName: Value(meshName),
      isInner: Value(isInner),
    );
  }

  factory BrainRegion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BrainRegion(
      key: serializer.fromJson<String>(json['key']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      nameTr: serializer.fromJson<String>(json['name_tr']),
      nameEn: serializer.fromJson<String>(json['name_en']),
      hemisphere: serializer.fromJson<String>(json['hemisphere']),
      meshName: serializer.fromJson<String>(json['mesh_name']),
      isInner: serializer.fromJson<bool>(json['is_inner']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'sort_order': serializer.toJson<int>(sortOrder),
      'name_tr': serializer.toJson<String>(nameTr),
      'name_en': serializer.toJson<String>(nameEn),
      'hemisphere': serializer.toJson<String>(hemisphere),
      'mesh_name': serializer.toJson<String>(meshName),
      'is_inner': serializer.toJson<bool>(isInner),
    };
  }

  BrainRegion copyWith({
    String? key,
    int? sortOrder,
    String? nameTr,
    String? nameEn,
    String? hemisphere,
    String? meshName,
    bool? isInner,
  }) => BrainRegion(
    key: key ?? this.key,
    sortOrder: sortOrder ?? this.sortOrder,
    nameTr: nameTr ?? this.nameTr,
    nameEn: nameEn ?? this.nameEn,
    hemisphere: hemisphere ?? this.hemisphere,
    meshName: meshName ?? this.meshName,
    isInner: isInner ?? this.isInner,
  );
  BrainRegion copyWithCompanion(BrainRegionsCompanion data) {
    return BrainRegion(
      key: data.key.present ? data.key.value : this.key,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      nameTr: data.nameTr.present ? data.nameTr.value : this.nameTr,
      nameEn: data.nameEn.present ? data.nameEn.value : this.nameEn,
      hemisphere: data.hemisphere.present
          ? data.hemisphere.value
          : this.hemisphere,
      meshName: data.meshName.present ? data.meshName.value : this.meshName,
      isInner: data.isInner.present ? data.isInner.value : this.isInner,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BrainRegion(')
          ..write('key: $key, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('nameTr: $nameTr, ')
          ..write('nameEn: $nameEn, ')
          ..write('hemisphere: $hemisphere, ')
          ..write('meshName: $meshName, ')
          ..write('isInner: $isInner')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    key,
    sortOrder,
    nameTr,
    nameEn,
    hemisphere,
    meshName,
    isInner,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrainRegion &&
          other.key == this.key &&
          other.sortOrder == this.sortOrder &&
          other.nameTr == this.nameTr &&
          other.nameEn == this.nameEn &&
          other.hemisphere == this.hemisphere &&
          other.meshName == this.meshName &&
          other.isInner == this.isInner);
}

class BrainRegionsCompanion extends UpdateCompanion<BrainRegion> {
  final Value<String> key;
  final Value<int> sortOrder;
  final Value<String> nameTr;
  final Value<String> nameEn;
  final Value<String> hemisphere;
  final Value<String> meshName;
  final Value<bool> isInner;
  final Value<int> rowid;
  const BrainRegionsCompanion({
    this.key = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.nameTr = const Value.absent(),
    this.nameEn = const Value.absent(),
    this.hemisphere = const Value.absent(),
    this.meshName = const Value.absent(),
    this.isInner = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BrainRegionsCompanion.insert({
    required String key,
    required int sortOrder,
    required String nameTr,
    required String nameEn,
    required String hemisphere,
    required String meshName,
    this.isInner = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       sortOrder = Value(sortOrder),
       nameTr = Value(nameTr),
       nameEn = Value(nameEn),
       hemisphere = Value(hemisphere),
       meshName = Value(meshName);
  static Insertable<BrainRegion> custom({
    Expression<String>? key,
    Expression<int>? sortOrder,
    Expression<String>? nameTr,
    Expression<String>? nameEn,
    Expression<String>? hemisphere,
    Expression<String>? meshName,
    Expression<bool>? isInner,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (nameTr != null) 'name_tr': nameTr,
      if (nameEn != null) 'name_en': nameEn,
      if (hemisphere != null) 'hemisphere': hemisphere,
      if (meshName != null) 'mesh_name': meshName,
      if (isInner != null) 'is_inner': isInner,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BrainRegionsCompanion copyWith({
    Value<String>? key,
    Value<int>? sortOrder,
    Value<String>? nameTr,
    Value<String>? nameEn,
    Value<String>? hemisphere,
    Value<String>? meshName,
    Value<bool>? isInner,
    Value<int>? rowid,
  }) {
    return BrainRegionsCompanion(
      key: key ?? this.key,
      sortOrder: sortOrder ?? this.sortOrder,
      nameTr: nameTr ?? this.nameTr,
      nameEn: nameEn ?? this.nameEn,
      hemisphere: hemisphere ?? this.hemisphere,
      meshName: meshName ?? this.meshName,
      isInner: isInner ?? this.isInner,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (nameTr.present) {
      map['name_tr'] = Variable<String>(nameTr.value);
    }
    if (nameEn.present) {
      map['name_en'] = Variable<String>(nameEn.value);
    }
    if (hemisphere.present) {
      map['hemisphere'] = Variable<String>(hemisphere.value);
    }
    if (meshName.present) {
      map['mesh_name'] = Variable<String>(meshName.value);
    }
    if (isInner.present) {
      map['is_inner'] = Variable<bool>(isInner.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrainRegionsCompanion(')
          ..write('key: $key, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('nameTr: $nameTr, ')
          ..write('nameEn: $nameEn, ')
          ..write('hemisphere: $hemisphere, ')
          ..write('meshName: $meshName, ')
          ..write('isInner: $isInner, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoryRegionWeightsTable extends CategoryRegionWeights
    with TableInfo<$CategoryRegionWeightsTable, CategoryRegionWeight> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryRegionWeightsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _rootCategoryKeyMeta = const VerificationMeta(
    'rootCategoryKey',
  );
  @override
  late final GeneratedColumn<String> rootCategoryKey = GeneratedColumn<String>(
    'root_category_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES root_categories ("key")',
    ),
  );
  static const VerificationMeta _regionKeyMeta = const VerificationMeta(
    'regionKey',
  );
  @override
  late final GeneratedColumn<String> regionKey = GeneratedColumn<String>(
    'region_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES brain_regions ("key")',
    ),
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _evidenceLevelMeta = const VerificationMeta(
    'evidenceLevel',
  );
  @override
  late final GeneratedColumn<String> evidenceLevel = GeneratedColumn<String>(
    'evidence_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> sourceIds =
      GeneratedColumn<String>(
        'source_ids',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $CategoryRegionWeightsTable.$convertersourceIds,
      );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> sourceUrls =
      GeneratedColumn<String>(
        'source_urls',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>(
        $CategoryRegionWeightsTable.$convertersourceUrls,
      );
  static const VerificationMeta _detailTrMeta = const VerificationMeta(
    'detailTr',
  );
  @override
  late final GeneratedColumn<String> detailTr = GeneratedColumn<String>(
    'detail_tr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _detailEnMeta = const VerificationMeta(
    'detailEn',
  );
  @override
  late final GeneratedColumn<String> detailEn = GeneratedColumn<String>(
    'detail_en',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    rootCategoryKey,
    regionKey,
    weight,
    evidenceLevel,
    sourceIds,
    sourceUrls,
    detailTr,
    detailEn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_region_weights';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRegionWeight> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('root_category_key')) {
      context.handle(
        _rootCategoryKeyMeta,
        rootCategoryKey.isAcceptableOrUnknown(
          data['root_category_key']!,
          _rootCategoryKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rootCategoryKeyMeta);
    }
    if (data.containsKey('region_key')) {
      context.handle(
        _regionKeyMeta,
        regionKey.isAcceptableOrUnknown(data['region_key']!, _regionKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_regionKeyMeta);
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('evidence_level')) {
      context.handle(
        _evidenceLevelMeta,
        evidenceLevel.isAcceptableOrUnknown(
          data['evidence_level']!,
          _evidenceLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_evidenceLevelMeta);
    }
    if (data.containsKey('detail_tr')) {
      context.handle(
        _detailTrMeta,
        detailTr.isAcceptableOrUnknown(data['detail_tr']!, _detailTrMeta),
      );
    }
    if (data.containsKey('detail_en')) {
      context.handle(
        _detailEnMeta,
        detailEn.isAcceptableOrUnknown(data['detail_en']!, _detailEnMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {rootCategoryKey, regionKey};
  @override
  CategoryRegionWeight map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRegionWeight(
      rootCategoryKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_category_key'],
      )!,
      regionKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_key'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      evidenceLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}evidence_level'],
      )!,
      sourceIds: $CategoryRegionWeightsTable.$convertersourceIds.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source_ids'],
        )!,
      ),
      sourceUrls: $CategoryRegionWeightsTable.$convertersourceUrls.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}source_urls'],
        )!,
      ),
      detailTr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail_tr'],
      )!,
      detailEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}detail_en'],
      )!,
    );
  }

  @override
  $CategoryRegionWeightsTable createAlias(String alias) {
    return $CategoryRegionWeightsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<List<String>, String, Object?> $convertersourceIds =
      const StringListConverter();
  static JsonTypeConverter2<List<String>, String, Object?>
  $convertersourceUrls = const StringListConverter();
}

class CategoryRegionWeight extends DataClass
    implements Insertable<CategoryRegionWeight> {
  final String rootCategoryKey;
  final String regionKey;
  final double weight;
  final String evidenceLevel;
  final List<String> sourceIds;
  final List<String> sourceUrls;
  final String detailTr;
  final String detailEn;
  const CategoryRegionWeight({
    required this.rootCategoryKey,
    required this.regionKey,
    required this.weight,
    required this.evidenceLevel,
    required this.sourceIds,
    required this.sourceUrls,
    required this.detailTr,
    required this.detailEn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['root_category_key'] = Variable<String>(rootCategoryKey);
    map['region_key'] = Variable<String>(regionKey);
    map['weight'] = Variable<double>(weight);
    map['evidence_level'] = Variable<String>(evidenceLevel);
    {
      map['source_ids'] = Variable<String>(
        $CategoryRegionWeightsTable.$convertersourceIds.toSql(sourceIds),
      );
    }
    {
      map['source_urls'] = Variable<String>(
        $CategoryRegionWeightsTable.$convertersourceUrls.toSql(sourceUrls),
      );
    }
    map['detail_tr'] = Variable<String>(detailTr);
    map['detail_en'] = Variable<String>(detailEn);
    return map;
  }

  CategoryRegionWeightsCompanion toCompanion(bool nullToAbsent) {
    return CategoryRegionWeightsCompanion(
      rootCategoryKey: Value(rootCategoryKey),
      regionKey: Value(regionKey),
      weight: Value(weight),
      evidenceLevel: Value(evidenceLevel),
      sourceIds: Value(sourceIds),
      sourceUrls: Value(sourceUrls),
      detailTr: Value(detailTr),
      detailEn: Value(detailEn),
    );
  }

  factory CategoryRegionWeight.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRegionWeight(
      rootCategoryKey: serializer.fromJson<String>(json['root_category_key']),
      regionKey: serializer.fromJson<String>(json['region_key']),
      weight: serializer.fromJson<double>(json['weight']),
      evidenceLevel: serializer.fromJson<String>(json['evidence_level']),
      sourceIds: $CategoryRegionWeightsTable.$convertersourceIds.fromJson(
        serializer.fromJson<Object?>(json['source_ids']),
      ),
      sourceUrls: $CategoryRegionWeightsTable.$convertersourceUrls.fromJson(
        serializer.fromJson<Object?>(json['source_urls']),
      ),
      detailTr: serializer.fromJson<String>(json['detail_tr']),
      detailEn: serializer.fromJson<String>(json['detail_en']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'root_category_key': serializer.toJson<String>(rootCategoryKey),
      'region_key': serializer.toJson<String>(regionKey),
      'weight': serializer.toJson<double>(weight),
      'evidence_level': serializer.toJson<String>(evidenceLevel),
      'source_ids': serializer.toJson<Object?>(
        $CategoryRegionWeightsTable.$convertersourceIds.toJson(sourceIds),
      ),
      'source_urls': serializer.toJson<Object?>(
        $CategoryRegionWeightsTable.$convertersourceUrls.toJson(sourceUrls),
      ),
      'detail_tr': serializer.toJson<String>(detailTr),
      'detail_en': serializer.toJson<String>(detailEn),
    };
  }

  CategoryRegionWeight copyWith({
    String? rootCategoryKey,
    String? regionKey,
    double? weight,
    String? evidenceLevel,
    List<String>? sourceIds,
    List<String>? sourceUrls,
    String? detailTr,
    String? detailEn,
  }) => CategoryRegionWeight(
    rootCategoryKey: rootCategoryKey ?? this.rootCategoryKey,
    regionKey: regionKey ?? this.regionKey,
    weight: weight ?? this.weight,
    evidenceLevel: evidenceLevel ?? this.evidenceLevel,
    sourceIds: sourceIds ?? this.sourceIds,
    sourceUrls: sourceUrls ?? this.sourceUrls,
    detailTr: detailTr ?? this.detailTr,
    detailEn: detailEn ?? this.detailEn,
  );
  CategoryRegionWeight copyWithCompanion(CategoryRegionWeightsCompanion data) {
    return CategoryRegionWeight(
      rootCategoryKey: data.rootCategoryKey.present
          ? data.rootCategoryKey.value
          : this.rootCategoryKey,
      regionKey: data.regionKey.present ? data.regionKey.value : this.regionKey,
      weight: data.weight.present ? data.weight.value : this.weight,
      evidenceLevel: data.evidenceLevel.present
          ? data.evidenceLevel.value
          : this.evidenceLevel,
      sourceIds: data.sourceIds.present ? data.sourceIds.value : this.sourceIds,
      sourceUrls: data.sourceUrls.present
          ? data.sourceUrls.value
          : this.sourceUrls,
      detailTr: data.detailTr.present ? data.detailTr.value : this.detailTr,
      detailEn: data.detailEn.present ? data.detailEn.value : this.detailEn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRegionWeight(')
          ..write('rootCategoryKey: $rootCategoryKey, ')
          ..write('regionKey: $regionKey, ')
          ..write('weight: $weight, ')
          ..write('evidenceLevel: $evidenceLevel, ')
          ..write('sourceIds: $sourceIds, ')
          ..write('sourceUrls: $sourceUrls, ')
          ..write('detailTr: $detailTr, ')
          ..write('detailEn: $detailEn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    rootCategoryKey,
    regionKey,
    weight,
    evidenceLevel,
    sourceIds,
    sourceUrls,
    detailTr,
    detailEn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRegionWeight &&
          other.rootCategoryKey == this.rootCategoryKey &&
          other.regionKey == this.regionKey &&
          other.weight == this.weight &&
          other.evidenceLevel == this.evidenceLevel &&
          other.sourceIds == this.sourceIds &&
          other.sourceUrls == this.sourceUrls &&
          other.detailTr == this.detailTr &&
          other.detailEn == this.detailEn);
}

class CategoryRegionWeightsCompanion
    extends UpdateCompanion<CategoryRegionWeight> {
  final Value<String> rootCategoryKey;
  final Value<String> regionKey;
  final Value<double> weight;
  final Value<String> evidenceLevel;
  final Value<List<String>> sourceIds;
  final Value<List<String>> sourceUrls;
  final Value<String> detailTr;
  final Value<String> detailEn;
  final Value<int> rowid;
  const CategoryRegionWeightsCompanion({
    this.rootCategoryKey = const Value.absent(),
    this.regionKey = const Value.absent(),
    this.weight = const Value.absent(),
    this.evidenceLevel = const Value.absent(),
    this.sourceIds = const Value.absent(),
    this.sourceUrls = const Value.absent(),
    this.detailTr = const Value.absent(),
    this.detailEn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoryRegionWeightsCompanion.insert({
    required String rootCategoryKey,
    required String regionKey,
    required double weight,
    required String evidenceLevel,
    required List<String> sourceIds,
    required List<String> sourceUrls,
    this.detailTr = const Value.absent(),
    this.detailEn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : rootCategoryKey = Value(rootCategoryKey),
       regionKey = Value(regionKey),
       weight = Value(weight),
       evidenceLevel = Value(evidenceLevel),
       sourceIds = Value(sourceIds),
       sourceUrls = Value(sourceUrls);
  static Insertable<CategoryRegionWeight> custom({
    Expression<String>? rootCategoryKey,
    Expression<String>? regionKey,
    Expression<double>? weight,
    Expression<String>? evidenceLevel,
    Expression<String>? sourceIds,
    Expression<String>? sourceUrls,
    Expression<String>? detailTr,
    Expression<String>? detailEn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (rootCategoryKey != null) 'root_category_key': rootCategoryKey,
      if (regionKey != null) 'region_key': regionKey,
      if (weight != null) 'weight': weight,
      if (evidenceLevel != null) 'evidence_level': evidenceLevel,
      if (sourceIds != null) 'source_ids': sourceIds,
      if (sourceUrls != null) 'source_urls': sourceUrls,
      if (detailTr != null) 'detail_tr': detailTr,
      if (detailEn != null) 'detail_en': detailEn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoryRegionWeightsCompanion copyWith({
    Value<String>? rootCategoryKey,
    Value<String>? regionKey,
    Value<double>? weight,
    Value<String>? evidenceLevel,
    Value<List<String>>? sourceIds,
    Value<List<String>>? sourceUrls,
    Value<String>? detailTr,
    Value<String>? detailEn,
    Value<int>? rowid,
  }) {
    return CategoryRegionWeightsCompanion(
      rootCategoryKey: rootCategoryKey ?? this.rootCategoryKey,
      regionKey: regionKey ?? this.regionKey,
      weight: weight ?? this.weight,
      evidenceLevel: evidenceLevel ?? this.evidenceLevel,
      sourceIds: sourceIds ?? this.sourceIds,
      sourceUrls: sourceUrls ?? this.sourceUrls,
      detailTr: detailTr ?? this.detailTr,
      detailEn: detailEn ?? this.detailEn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (rootCategoryKey.present) {
      map['root_category_key'] = Variable<String>(rootCategoryKey.value);
    }
    if (regionKey.present) {
      map['region_key'] = Variable<String>(regionKey.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (evidenceLevel.present) {
      map['evidence_level'] = Variable<String>(evidenceLevel.value);
    }
    if (sourceIds.present) {
      map['source_ids'] = Variable<String>(
        $CategoryRegionWeightsTable.$convertersourceIds.toSql(sourceIds.value),
      );
    }
    if (sourceUrls.present) {
      map['source_urls'] = Variable<String>(
        $CategoryRegionWeightsTable.$convertersourceUrls.toSql(
          sourceUrls.value,
        ),
      );
    }
    if (detailTr.present) {
      map['detail_tr'] = Variable<String>(detailTr.value);
    }
    if (detailEn.present) {
      map['detail_en'] = Variable<String>(detailEn.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRegionWeightsCompanion(')
          ..write('rootCategoryKey: $rootCategoryKey, ')
          ..write('regionKey: $regionKey, ')
          ..write('weight: $weight, ')
          ..write('evidenceLevel: $evidenceLevel, ')
          ..write('sourceIds: $sourceIds, ')
          ..write('sourceUrls: $sourceUrls, ')
          ..write('detailTr: $detailTr, ')
          ..write('detailEn: $detailEn, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProfilesTable extends Profiles with TableInfo<$ProfilesTable, Profile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  fieldVersions = GeneratedColumn<String>(
    'field_versions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  ).withConverter<Map<String, String>>($ProfilesTable.$converterfieldVersions);
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _themeMeta = const VerificationMeta('theme');
  @override
  late final GeneratedColumn<String> theme = GeneratedColumn<String>(
    'theme',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    check: () => themeMode.isIn(const ['system', 'light', 'dark']),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _timezoneMeta = const VerificationMeta(
    'timezone',
  );
  @override
  late final GeneratedColumn<String> timezone = GeneratedColumn<String>(
    'timezone',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sleepGoalMinutesMeta = const VerificationMeta(
    'sleepGoalMinutes',
  );
  @override
  late final GeneratedColumn<int> sleepGoalMinutes = GeneratedColumn<int>(
    'sleep_goal_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _birthYearMeta = const VerificationMeta(
    'birthYear',
  );
  @override
  late final GeneratedColumn<int> birthYear = GeneratedColumn<int>(
    'birth_year',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingCompletedAtMeta =
      const VerificationMeta('onboardingCompletedAt');
  @override
  late final GeneratedColumn<DateTime> onboardingCompletedAt =
      GeneratedColumn<DateTime>(
        'onboarding_completed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _locationLatMeta = const VerificationMeta(
    'locationLat',
  );
  @override
  late final GeneratedColumn<double> locationLat = GeneratedColumn<double>(
    'location_lat',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationLonMeta = const VerificationMeta(
    'locationLon',
  );
  @override
  late final GeneratedColumn<double> locationLon = GeneratedColumn<double>(
    'location_lon',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _locationLabelMeta = const VerificationMeta(
    'locationLabel',
  );
  @override
  late final GeneratedColumn<String> locationLabel = GeneratedColumn<String>(
    'location_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prayerMethodMeta = const VerificationMeta(
    'prayerMethod',
  );
  @override
  late final GeneratedColumn<String> prayerMethod = GeneratedColumn<String>(
    'prayer_method',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _prayerMadhabMeta = const VerificationMeta(
    'prayerMadhab',
  );
  @override
  late final GeneratedColumn<String> prayerMadhab = GeneratedColumn<String>(
    'prayer_madhab',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _minChunkMinutesMeta = const VerificationMeta(
    'minChunkMinutes',
  );
  @override
  late final GeneratedColumn<int> minChunkMinutes = GeneratedColumn<int>(
    'min_chunk_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chunkBufferMinutesMeta =
      const VerificationMeta('chunkBufferMinutes');
  @override
  late final GeneratedColumn<int> chunkBufferMinutes = GeneratedColumn<int>(
    'chunk_buffer_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dailyFocusCapMinutesMeta =
      const VerificationMeta('dailyFocusCapMinutes');
  @override
  late final GeneratedColumn<int> dailyFocusCapMinutes = GeneratedColumn<int>(
    'daily_focus_cap_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hapticsEnabledMeta = const VerificationMeta(
    'hapticsEnabled',
  );
  @override
  late final GeneratedColumn<bool> hapticsEnabled = GeneratedColumn<bool>(
    'haptics_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("haptics_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    displayName,
    locale,
    theme,
    themeMode,
    timezone,
    sleepGoalMinutes,
    birthYear,
    onboardingCompletedAt,
    locationLat,
    locationLon,
    locationLabel,
    prayerMethod,
    prayerMadhab,
    minChunkMinutes,
    chunkBufferMinutes,
    dailyFocusCapMinutes,
    hapticsEnabled,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<Profile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    }
    if (data.containsKey('theme')) {
      context.handle(
        _themeMeta,
        theme.isAcceptableOrUnknown(data['theme']!, _themeMeta),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('timezone')) {
      context.handle(
        _timezoneMeta,
        timezone.isAcceptableOrUnknown(data['timezone']!, _timezoneMeta),
      );
    } else if (isInserting) {
      context.missing(_timezoneMeta);
    }
    if (data.containsKey('sleep_goal_minutes')) {
      context.handle(
        _sleepGoalMinutesMeta,
        sleepGoalMinutes.isAcceptableOrUnknown(
          data['sleep_goal_minutes']!,
          _sleepGoalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('birth_year')) {
      context.handle(
        _birthYearMeta,
        birthYear.isAcceptableOrUnknown(data['birth_year']!, _birthYearMeta),
      );
    }
    if (data.containsKey('onboarding_completed_at')) {
      context.handle(
        _onboardingCompletedAtMeta,
        onboardingCompletedAt.isAcceptableOrUnknown(
          data['onboarding_completed_at']!,
          _onboardingCompletedAtMeta,
        ),
      );
    }
    if (data.containsKey('location_lat')) {
      context.handle(
        _locationLatMeta,
        locationLat.isAcceptableOrUnknown(
          data['location_lat']!,
          _locationLatMeta,
        ),
      );
    }
    if (data.containsKey('location_lon')) {
      context.handle(
        _locationLonMeta,
        locationLon.isAcceptableOrUnknown(
          data['location_lon']!,
          _locationLonMeta,
        ),
      );
    }
    if (data.containsKey('location_label')) {
      context.handle(
        _locationLabelMeta,
        locationLabel.isAcceptableOrUnknown(
          data['location_label']!,
          _locationLabelMeta,
        ),
      );
    }
    if (data.containsKey('prayer_method')) {
      context.handle(
        _prayerMethodMeta,
        prayerMethod.isAcceptableOrUnknown(
          data['prayer_method']!,
          _prayerMethodMeta,
        ),
      );
    }
    if (data.containsKey('prayer_madhab')) {
      context.handle(
        _prayerMadhabMeta,
        prayerMadhab.isAcceptableOrUnknown(
          data['prayer_madhab']!,
          _prayerMadhabMeta,
        ),
      );
    }
    if (data.containsKey('min_chunk_minutes')) {
      context.handle(
        _minChunkMinutesMeta,
        minChunkMinutes.isAcceptableOrUnknown(
          data['min_chunk_minutes']!,
          _minChunkMinutesMeta,
        ),
      );
    }
    if (data.containsKey('chunk_buffer_minutes')) {
      context.handle(
        _chunkBufferMinutesMeta,
        chunkBufferMinutes.isAcceptableOrUnknown(
          data['chunk_buffer_minutes']!,
          _chunkBufferMinutesMeta,
        ),
      );
    }
    if (data.containsKey('daily_focus_cap_minutes')) {
      context.handle(
        _dailyFocusCapMinutesMeta,
        dailyFocusCapMinutes.isAcceptableOrUnknown(
          data['daily_focus_cap_minutes']!,
          _dailyFocusCapMinutesMeta,
        ),
      );
    }
    if (data.containsKey('haptics_enabled')) {
      context.handle(
        _hapticsEnabledMeta,
        hapticsEnabled.isAcceptableOrUnknown(
          data['haptics_enabled']!,
          _hapticsEnabledMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Profile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Profile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      fieldVersions: $ProfilesTable.$converterfieldVersions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}field_versions'],
        )!,
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      ),
      theme: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme'],
      ),
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      timezone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}timezone'],
      )!,
      sleepGoalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sleep_goal_minutes'],
      ),
      birthYear: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}birth_year'],
      ),
      onboardingCompletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}onboarding_completed_at'],
      ),
      locationLat: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}location_lat'],
      ),
      locationLon: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}location_lon'],
      ),
      locationLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location_label'],
      ),
      prayerMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prayer_method'],
      ),
      prayerMadhab: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prayer_madhab'],
      ),
      minChunkMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_chunk_minutes'],
      ),
      chunkBufferMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}chunk_buffer_minutes'],
      ),
      dailyFocusCapMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_focus_cap_minutes'],
      ),
      hapticsEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}haptics_enabled'],
      )!,
    );
  }

  @override
  $ProfilesTable createAlias(String alias) {
    return $ProfilesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, String>, String, Object?>
  $converterfieldVersions = const FieldVersionsConverter();
}

class Profile extends DataClass implements Insertable<Profile> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Map<String, String> fieldVersions;
  final String? displayName;
  final String? locale;
  final String? theme;
  final String themeMode;
  final String timezone;
  final int? sleepGoalMinutes;
  final int? birthYear;
  final DateTime? onboardingCompletedAt;
  final double? locationLat;
  final double? locationLon;
  final String? locationLabel;
  final String? prayerMethod;
  final String? prayerMadhab;
  final int? minChunkMinutes;
  final int? chunkBufferMinutes;
  final int? dailyFocusCapMinutes;
  final bool hapticsEnabled;
  const Profile({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.fieldVersions,
    this.displayName,
    this.locale,
    this.theme,
    required this.themeMode,
    required this.timezone,
    this.sleepGoalMinutes,
    this.birthYear,
    this.onboardingCompletedAt,
    this.locationLat,
    this.locationLon,
    this.locationLabel,
    this.prayerMethod,
    this.prayerMadhab,
    this.minChunkMinutes,
    this.chunkBufferMinutes,
    this.dailyFocusCapMinutes,
    required this.hapticsEnabled,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['field_versions'] = Variable<String>(
        $ProfilesTable.$converterfieldVersions.toSql(fieldVersions),
      );
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    if (!nullToAbsent || locale != null) {
      map['locale'] = Variable<String>(locale);
    }
    if (!nullToAbsent || theme != null) {
      map['theme'] = Variable<String>(theme);
    }
    map['theme_mode'] = Variable<String>(themeMode);
    map['timezone'] = Variable<String>(timezone);
    if (!nullToAbsent || sleepGoalMinutes != null) {
      map['sleep_goal_minutes'] = Variable<int>(sleepGoalMinutes);
    }
    if (!nullToAbsent || birthYear != null) {
      map['birth_year'] = Variable<int>(birthYear);
    }
    if (!nullToAbsent || onboardingCompletedAt != null) {
      map['onboarding_completed_at'] = Variable<DateTime>(
        onboardingCompletedAt,
      );
    }
    if (!nullToAbsent || locationLat != null) {
      map['location_lat'] = Variable<double>(locationLat);
    }
    if (!nullToAbsent || locationLon != null) {
      map['location_lon'] = Variable<double>(locationLon);
    }
    if (!nullToAbsent || locationLabel != null) {
      map['location_label'] = Variable<String>(locationLabel);
    }
    if (!nullToAbsent || prayerMethod != null) {
      map['prayer_method'] = Variable<String>(prayerMethod);
    }
    if (!nullToAbsent || prayerMadhab != null) {
      map['prayer_madhab'] = Variable<String>(prayerMadhab);
    }
    if (!nullToAbsent || minChunkMinutes != null) {
      map['min_chunk_minutes'] = Variable<int>(minChunkMinutes);
    }
    if (!nullToAbsent || chunkBufferMinutes != null) {
      map['chunk_buffer_minutes'] = Variable<int>(chunkBufferMinutes);
    }
    if (!nullToAbsent || dailyFocusCapMinutes != null) {
      map['daily_focus_cap_minutes'] = Variable<int>(dailyFocusCapMinutes);
    }
    map['haptics_enabled'] = Variable<bool>(hapticsEnabled);
    return map;
  }

  ProfilesCompanion toCompanion(bool nullToAbsent) {
    return ProfilesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      fieldVersions: Value(fieldVersions),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      locale: locale == null && nullToAbsent
          ? const Value.absent()
          : Value(locale),
      theme: theme == null && nullToAbsent
          ? const Value.absent()
          : Value(theme),
      themeMode: Value(themeMode),
      timezone: Value(timezone),
      sleepGoalMinutes: sleepGoalMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(sleepGoalMinutes),
      birthYear: birthYear == null && nullToAbsent
          ? const Value.absent()
          : Value(birthYear),
      onboardingCompletedAt: onboardingCompletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(onboardingCompletedAt),
      locationLat: locationLat == null && nullToAbsent
          ? const Value.absent()
          : Value(locationLat),
      locationLon: locationLon == null && nullToAbsent
          ? const Value.absent()
          : Value(locationLon),
      locationLabel: locationLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(locationLabel),
      prayerMethod: prayerMethod == null && nullToAbsent
          ? const Value.absent()
          : Value(prayerMethod),
      prayerMadhab: prayerMadhab == null && nullToAbsent
          ? const Value.absent()
          : Value(prayerMadhab),
      minChunkMinutes: minChunkMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(minChunkMinutes),
      chunkBufferMinutes: chunkBufferMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(chunkBufferMinutes),
      dailyFocusCapMinutes: dailyFocusCapMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyFocusCapMinutes),
      hapticsEnabled: Value(hapticsEnabled),
    );
  }

  factory Profile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Profile(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      fieldVersions: $ProfilesTable.$converterfieldVersions.fromJson(
        serializer.fromJson<Object?>(json['field_versions']),
      ),
      displayName: serializer.fromJson<String?>(json['display_name']),
      locale: serializer.fromJson<String?>(json['locale']),
      theme: serializer.fromJson<String?>(json['theme']),
      themeMode: serializer.fromJson<String>(json['theme_mode']),
      timezone: serializer.fromJson<String>(json['timezone']),
      sleepGoalMinutes: serializer.fromJson<int?>(json['sleep_goal_minutes']),
      birthYear: serializer.fromJson<int?>(json['birth_year']),
      onboardingCompletedAt: serializer.fromJson<DateTime?>(
        json['onboarding_completed_at'],
      ),
      locationLat: serializer.fromJson<double?>(json['location_lat']),
      locationLon: serializer.fromJson<double?>(json['location_lon']),
      locationLabel: serializer.fromJson<String?>(json['location_label']),
      prayerMethod: serializer.fromJson<String?>(json['prayer_method']),
      prayerMadhab: serializer.fromJson<String?>(json['prayer_madhab']),
      minChunkMinutes: serializer.fromJson<int?>(json['min_chunk_minutes']),
      chunkBufferMinutes: serializer.fromJson<int?>(
        json['chunk_buffer_minutes'],
      ),
      dailyFocusCapMinutes: serializer.fromJson<int?>(
        json['daily_focus_cap_minutes'],
      ),
      hapticsEnabled: serializer.fromJson<bool>(json['haptics_enabled']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'field_versions': serializer.toJson<Object?>(
        $ProfilesTable.$converterfieldVersions.toJson(fieldVersions),
      ),
      'display_name': serializer.toJson<String?>(displayName),
      'locale': serializer.toJson<String?>(locale),
      'theme': serializer.toJson<String?>(theme),
      'theme_mode': serializer.toJson<String>(themeMode),
      'timezone': serializer.toJson<String>(timezone),
      'sleep_goal_minutes': serializer.toJson<int?>(sleepGoalMinutes),
      'birth_year': serializer.toJson<int?>(birthYear),
      'onboarding_completed_at': serializer.toJson<DateTime?>(
        onboardingCompletedAt,
      ),
      'location_lat': serializer.toJson<double?>(locationLat),
      'location_lon': serializer.toJson<double?>(locationLon),
      'location_label': serializer.toJson<String?>(locationLabel),
      'prayer_method': serializer.toJson<String?>(prayerMethod),
      'prayer_madhab': serializer.toJson<String?>(prayerMadhab),
      'min_chunk_minutes': serializer.toJson<int?>(minChunkMinutes),
      'chunk_buffer_minutes': serializer.toJson<int?>(chunkBufferMinutes),
      'daily_focus_cap_minutes': serializer.toJson<int?>(dailyFocusCapMinutes),
      'haptics_enabled': serializer.toJson<bool>(hapticsEnabled),
    };
  }

  Profile copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Map<String, String>? fieldVersions,
    Value<String?> displayName = const Value.absent(),
    Value<String?> locale = const Value.absent(),
    Value<String?> theme = const Value.absent(),
    String? themeMode,
    String? timezone,
    Value<int?> sleepGoalMinutes = const Value.absent(),
    Value<int?> birthYear = const Value.absent(),
    Value<DateTime?> onboardingCompletedAt = const Value.absent(),
    Value<double?> locationLat = const Value.absent(),
    Value<double?> locationLon = const Value.absent(),
    Value<String?> locationLabel = const Value.absent(),
    Value<String?> prayerMethod = const Value.absent(),
    Value<String?> prayerMadhab = const Value.absent(),
    Value<int?> minChunkMinutes = const Value.absent(),
    Value<int?> chunkBufferMinutes = const Value.absent(),
    Value<int?> dailyFocusCapMinutes = const Value.absent(),
    bool? hapticsEnabled,
  }) => Profile(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    fieldVersions: fieldVersions ?? this.fieldVersions,
    displayName: displayName.present ? displayName.value : this.displayName,
    locale: locale.present ? locale.value : this.locale,
    theme: theme.present ? theme.value : this.theme,
    themeMode: themeMode ?? this.themeMode,
    timezone: timezone ?? this.timezone,
    sleepGoalMinutes: sleepGoalMinutes.present
        ? sleepGoalMinutes.value
        : this.sleepGoalMinutes,
    birthYear: birthYear.present ? birthYear.value : this.birthYear,
    onboardingCompletedAt: onboardingCompletedAt.present
        ? onboardingCompletedAt.value
        : this.onboardingCompletedAt,
    locationLat: locationLat.present ? locationLat.value : this.locationLat,
    locationLon: locationLon.present ? locationLon.value : this.locationLon,
    locationLabel: locationLabel.present
        ? locationLabel.value
        : this.locationLabel,
    prayerMethod: prayerMethod.present ? prayerMethod.value : this.prayerMethod,
    prayerMadhab: prayerMadhab.present ? prayerMadhab.value : this.prayerMadhab,
    minChunkMinutes: minChunkMinutes.present
        ? minChunkMinutes.value
        : this.minChunkMinutes,
    chunkBufferMinutes: chunkBufferMinutes.present
        ? chunkBufferMinutes.value
        : this.chunkBufferMinutes,
    dailyFocusCapMinutes: dailyFocusCapMinutes.present
        ? dailyFocusCapMinutes.value
        : this.dailyFocusCapMinutes,
    hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
  );
  Profile copyWithCompanion(ProfilesCompanion data) {
    return Profile(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      fieldVersions: data.fieldVersions.present
          ? data.fieldVersions.value
          : this.fieldVersions,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      locale: data.locale.present ? data.locale.value : this.locale,
      theme: data.theme.present ? data.theme.value : this.theme,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      timezone: data.timezone.present ? data.timezone.value : this.timezone,
      sleepGoalMinutes: data.sleepGoalMinutes.present
          ? data.sleepGoalMinutes.value
          : this.sleepGoalMinutes,
      birthYear: data.birthYear.present ? data.birthYear.value : this.birthYear,
      onboardingCompletedAt: data.onboardingCompletedAt.present
          ? data.onboardingCompletedAt.value
          : this.onboardingCompletedAt,
      locationLat: data.locationLat.present
          ? data.locationLat.value
          : this.locationLat,
      locationLon: data.locationLon.present
          ? data.locationLon.value
          : this.locationLon,
      locationLabel: data.locationLabel.present
          ? data.locationLabel.value
          : this.locationLabel,
      prayerMethod: data.prayerMethod.present
          ? data.prayerMethod.value
          : this.prayerMethod,
      prayerMadhab: data.prayerMadhab.present
          ? data.prayerMadhab.value
          : this.prayerMadhab,
      minChunkMinutes: data.minChunkMinutes.present
          ? data.minChunkMinutes.value
          : this.minChunkMinutes,
      chunkBufferMinutes: data.chunkBufferMinutes.present
          ? data.chunkBufferMinutes.value
          : this.chunkBufferMinutes,
      dailyFocusCapMinutes: data.dailyFocusCapMinutes.present
          ? data.dailyFocusCapMinutes.value
          : this.dailyFocusCapMinutes,
      hapticsEnabled: data.hapticsEnabled.present
          ? data.hapticsEnabled.value
          : this.hapticsEnabled,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Profile(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('displayName: $displayName, ')
          ..write('locale: $locale, ')
          ..write('theme: $theme, ')
          ..write('themeMode: $themeMode, ')
          ..write('timezone: $timezone, ')
          ..write('sleepGoalMinutes: $sleepGoalMinutes, ')
          ..write('birthYear: $birthYear, ')
          ..write('onboardingCompletedAt: $onboardingCompletedAt, ')
          ..write('locationLat: $locationLat, ')
          ..write('locationLon: $locationLon, ')
          ..write('locationLabel: $locationLabel, ')
          ..write('prayerMethod: $prayerMethod, ')
          ..write('prayerMadhab: $prayerMadhab, ')
          ..write('minChunkMinutes: $minChunkMinutes, ')
          ..write('chunkBufferMinutes: $chunkBufferMinutes, ')
          ..write('dailyFocusCapMinutes: $dailyFocusCapMinutes, ')
          ..write('hapticsEnabled: $hapticsEnabled')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    displayName,
    locale,
    theme,
    themeMode,
    timezone,
    sleepGoalMinutes,
    birthYear,
    onboardingCompletedAt,
    locationLat,
    locationLon,
    locationLabel,
    prayerMethod,
    prayerMadhab,
    minChunkMinutes,
    chunkBufferMinutes,
    dailyFocusCapMinutes,
    hapticsEnabled,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Profile &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.fieldVersions == this.fieldVersions &&
          other.displayName == this.displayName &&
          other.locale == this.locale &&
          other.theme == this.theme &&
          other.themeMode == this.themeMode &&
          other.timezone == this.timezone &&
          other.sleepGoalMinutes == this.sleepGoalMinutes &&
          other.birthYear == this.birthYear &&
          other.onboardingCompletedAt == this.onboardingCompletedAt &&
          other.locationLat == this.locationLat &&
          other.locationLon == this.locationLon &&
          other.locationLabel == this.locationLabel &&
          other.prayerMethod == this.prayerMethod &&
          other.prayerMadhab == this.prayerMadhab &&
          other.minChunkMinutes == this.minChunkMinutes &&
          other.chunkBufferMinutes == this.chunkBufferMinutes &&
          other.dailyFocusCapMinutes == this.dailyFocusCapMinutes &&
          other.hapticsEnabled == this.hapticsEnabled);
}

class ProfilesCompanion extends UpdateCompanion<Profile> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<Map<String, String>> fieldVersions;
  final Value<String?> displayName;
  final Value<String?> locale;
  final Value<String?> theme;
  final Value<String> themeMode;
  final Value<String> timezone;
  final Value<int?> sleepGoalMinutes;
  final Value<int?> birthYear;
  final Value<DateTime?> onboardingCompletedAt;
  final Value<double?> locationLat;
  final Value<double?> locationLon;
  final Value<String?> locationLabel;
  final Value<String?> prayerMethod;
  final Value<String?> prayerMadhab;
  final Value<int?> minChunkMinutes;
  final Value<int?> chunkBufferMinutes;
  final Value<int?> dailyFocusCapMinutes;
  final Value<bool> hapticsEnabled;
  final Value<int> rowid;
  const ProfilesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.displayName = const Value.absent(),
    this.locale = const Value.absent(),
    this.theme = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.timezone = const Value.absent(),
    this.sleepGoalMinutes = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.onboardingCompletedAt = const Value.absent(),
    this.locationLat = const Value.absent(),
    this.locationLon = const Value.absent(),
    this.locationLabel = const Value.absent(),
    this.prayerMethod = const Value.absent(),
    this.prayerMadhab = const Value.absent(),
    this.minChunkMinutes = const Value.absent(),
    this.chunkBufferMinutes = const Value.absent(),
    this.dailyFocusCapMinutes = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProfilesCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.displayName = const Value.absent(),
    this.locale = const Value.absent(),
    this.theme = const Value.absent(),
    this.themeMode = const Value.absent(),
    required String timezone,
    this.sleepGoalMinutes = const Value.absent(),
    this.birthYear = const Value.absent(),
    this.onboardingCompletedAt = const Value.absent(),
    this.locationLat = const Value.absent(),
    this.locationLon = const Value.absent(),
    this.locationLabel = const Value.absent(),
    this.prayerMethod = const Value.absent(),
    this.prayerMadhab = const Value.absent(),
    this.minChunkMinutes = const Value.absent(),
    this.chunkBufferMinutes = const Value.absent(),
    this.dailyFocusCapMinutes = const Value.absent(),
    this.hapticsEnabled = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       timezone = Value(timezone);
  static Insertable<Profile> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? fieldVersions,
    Expression<String>? displayName,
    Expression<String>? locale,
    Expression<String>? theme,
    Expression<String>? themeMode,
    Expression<String>? timezone,
    Expression<int>? sleepGoalMinutes,
    Expression<int>? birthYear,
    Expression<DateTime>? onboardingCompletedAt,
    Expression<double>? locationLat,
    Expression<double>? locationLon,
    Expression<String>? locationLabel,
    Expression<String>? prayerMethod,
    Expression<String>? prayerMadhab,
    Expression<int>? minChunkMinutes,
    Expression<int>? chunkBufferMinutes,
    Expression<int>? dailyFocusCapMinutes,
    Expression<bool>? hapticsEnabled,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (fieldVersions != null) 'field_versions': fieldVersions,
      if (displayName != null) 'display_name': displayName,
      if (locale != null) 'locale': locale,
      if (theme != null) 'theme': theme,
      if (themeMode != null) 'theme_mode': themeMode,
      if (timezone != null) 'timezone': timezone,
      if (sleepGoalMinutes != null) 'sleep_goal_minutes': sleepGoalMinutes,
      if (birthYear != null) 'birth_year': birthYear,
      if (onboardingCompletedAt != null)
        'onboarding_completed_at': onboardingCompletedAt,
      if (locationLat != null) 'location_lat': locationLat,
      if (locationLon != null) 'location_lon': locationLon,
      if (locationLabel != null) 'location_label': locationLabel,
      if (prayerMethod != null) 'prayer_method': prayerMethod,
      if (prayerMadhab != null) 'prayer_madhab': prayerMadhab,
      if (minChunkMinutes != null) 'min_chunk_minutes': minChunkMinutes,
      if (chunkBufferMinutes != null)
        'chunk_buffer_minutes': chunkBufferMinutes,
      if (dailyFocusCapMinutes != null)
        'daily_focus_cap_minutes': dailyFocusCapMinutes,
      if (hapticsEnabled != null) 'haptics_enabled': hapticsEnabled,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProfilesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<Map<String, String>>? fieldVersions,
    Value<String?>? displayName,
    Value<String?>? locale,
    Value<String?>? theme,
    Value<String>? themeMode,
    Value<String>? timezone,
    Value<int?>? sleepGoalMinutes,
    Value<int?>? birthYear,
    Value<DateTime?>? onboardingCompletedAt,
    Value<double?>? locationLat,
    Value<double?>? locationLon,
    Value<String?>? locationLabel,
    Value<String?>? prayerMethod,
    Value<String?>? prayerMadhab,
    Value<int?>? minChunkMinutes,
    Value<int?>? chunkBufferMinutes,
    Value<int?>? dailyFocusCapMinutes,
    Value<bool>? hapticsEnabled,
    Value<int>? rowid,
  }) {
    return ProfilesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      fieldVersions: fieldVersions ?? this.fieldVersions,
      displayName: displayName ?? this.displayName,
      locale: locale ?? this.locale,
      theme: theme ?? this.theme,
      themeMode: themeMode ?? this.themeMode,
      timezone: timezone ?? this.timezone,
      sleepGoalMinutes: sleepGoalMinutes ?? this.sleepGoalMinutes,
      birthYear: birthYear ?? this.birthYear,
      onboardingCompletedAt:
          onboardingCompletedAt ?? this.onboardingCompletedAt,
      locationLat: locationLat ?? this.locationLat,
      locationLon: locationLon ?? this.locationLon,
      locationLabel: locationLabel ?? this.locationLabel,
      prayerMethod: prayerMethod ?? this.prayerMethod,
      prayerMadhab: prayerMadhab ?? this.prayerMadhab,
      minChunkMinutes: minChunkMinutes ?? this.minChunkMinutes,
      chunkBufferMinutes: chunkBufferMinutes ?? this.chunkBufferMinutes,
      dailyFocusCapMinutes: dailyFocusCapMinutes ?? this.dailyFocusCapMinutes,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (fieldVersions.present) {
      map['field_versions'] = Variable<String>(
        $ProfilesTable.$converterfieldVersions.toSql(fieldVersions.value),
      );
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    if (theme.present) {
      map['theme'] = Variable<String>(theme.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (timezone.present) {
      map['timezone'] = Variable<String>(timezone.value);
    }
    if (sleepGoalMinutes.present) {
      map['sleep_goal_minutes'] = Variable<int>(sleepGoalMinutes.value);
    }
    if (birthYear.present) {
      map['birth_year'] = Variable<int>(birthYear.value);
    }
    if (onboardingCompletedAt.present) {
      map['onboarding_completed_at'] = Variable<DateTime>(
        onboardingCompletedAt.value,
      );
    }
    if (locationLat.present) {
      map['location_lat'] = Variable<double>(locationLat.value);
    }
    if (locationLon.present) {
      map['location_lon'] = Variable<double>(locationLon.value);
    }
    if (locationLabel.present) {
      map['location_label'] = Variable<String>(locationLabel.value);
    }
    if (prayerMethod.present) {
      map['prayer_method'] = Variable<String>(prayerMethod.value);
    }
    if (prayerMadhab.present) {
      map['prayer_madhab'] = Variable<String>(prayerMadhab.value);
    }
    if (minChunkMinutes.present) {
      map['min_chunk_minutes'] = Variable<int>(minChunkMinutes.value);
    }
    if (chunkBufferMinutes.present) {
      map['chunk_buffer_minutes'] = Variable<int>(chunkBufferMinutes.value);
    }
    if (dailyFocusCapMinutes.present) {
      map['daily_focus_cap_minutes'] = Variable<int>(
        dailyFocusCapMinutes.value,
      );
    }
    if (hapticsEnabled.present) {
      map['haptics_enabled'] = Variable<bool>(hapticsEnabled.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProfilesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('displayName: $displayName, ')
          ..write('locale: $locale, ')
          ..write('theme: $theme, ')
          ..write('themeMode: $themeMode, ')
          ..write('timezone: $timezone, ')
          ..write('sleepGoalMinutes: $sleepGoalMinutes, ')
          ..write('birthYear: $birthYear, ')
          ..write('onboardingCompletedAt: $onboardingCompletedAt, ')
          ..write('locationLat: $locationLat, ')
          ..write('locationLon: $locationLon, ')
          ..write('locationLabel: $locationLabel, ')
          ..write('prayerMethod: $prayerMethod, ')
          ..write('prayerMadhab: $prayerMadhab, ')
          ..write('minChunkMinutes: $minChunkMinutes, ')
          ..write('chunkBufferMinutes: $chunkBufferMinutes, ')
          ..write('dailyFocusCapMinutes: $dailyFocusCapMinutes, ')
          ..write('hapticsEnabled: $hapticsEnabled, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserCategoriesTable extends UserCategories
    with TableInfo<$UserCategoriesTable, UserCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  fieldVersions =
      GeneratedColumn<String>(
        'field_versions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      ).withConverter<Map<String, String>>(
        $UserCategoriesTable.$converterfieldVersions,
      );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_categories (id)',
    ),
  );
  static const VerificationMeta _rootCategoryKeyMeta = const VerificationMeta(
    'rootCategoryKey',
  );
  @override
  late final GeneratedColumn<String> rootCategoryKey = GeneratedColumn<String>(
    'root_category_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES root_categories ("key")',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconMeta = const VerificationMeta('icon');
  @override
  late final GeneratedColumn<String> icon = GeneratedColumn<String>(
    'icon',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requiresFocusMeta = const VerificationMeta(
    'requiresFocus',
  );
  @override
  late final GeneratedColumn<bool> requiresFocus = GeneratedColumn<bool>(
    'requires_focus',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_focus" IN (0, 1))',
    ),
  );
  static const VerificationMeta _defaultFocusModeMeta = const VerificationMeta(
    'defaultFocusMode',
  );
  @override
  late final GeneratedColumn<String> defaultFocusMode = GeneratedColumn<String>(
    'default_focus_mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    parentId,
    rootCategoryKey,
    name,
    color,
    icon,
    requiresFocus,
    defaultFocusMode,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('root_category_key')) {
      context.handle(
        _rootCategoryKeyMeta,
        rootCategoryKey.isAcceptableOrUnknown(
          data['root_category_key']!,
          _rootCategoryKeyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_rootCategoryKeyMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('icon')) {
      context.handle(
        _iconMeta,
        icon.isAcceptableOrUnknown(data['icon']!, _iconMeta),
      );
    }
    if (data.containsKey('requires_focus')) {
      context.handle(
        _requiresFocusMeta,
        requiresFocus.isAcceptableOrUnknown(
          data['requires_focus']!,
          _requiresFocusMeta,
        ),
      );
    }
    if (data.containsKey('default_focus_mode')) {
      context.handle(
        _defaultFocusModeMeta,
        defaultFocusMode.isAcceptableOrUnknown(
          data['default_focus_mode']!,
          _defaultFocusModeMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      fieldVersions: $UserCategoriesTable.$converterfieldVersions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}field_versions'],
        )!,
      ),
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      rootCategoryKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_category_key'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      icon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon'],
      ),
      requiresFocus: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_focus'],
      ),
      defaultFocusMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_focus_mode'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $UserCategoriesTable createAlias(String alias) {
    return $UserCategoriesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, String>, String, Object?>
  $converterfieldVersions = const FieldVersionsConverter();
}

class UserCategory extends DataClass implements Insertable<UserCategory> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Map<String, String> fieldVersions;
  final String? parentId;
  final String rootCategoryKey;
  final String name;
  final String? color;
  final String? icon;
  final bool? requiresFocus;
  final String? defaultFocusMode;
  final int sortOrder;
  const UserCategory({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.fieldVersions,
    this.parentId,
    required this.rootCategoryKey,
    required this.name,
    this.color,
    this.icon,
    this.requiresFocus,
    this.defaultFocusMode,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['field_versions'] = Variable<String>(
        $UserCategoriesTable.$converterfieldVersions.toSql(fieldVersions),
      );
    }
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['root_category_key'] = Variable<String>(rootCategoryKey);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || icon != null) {
      map['icon'] = Variable<String>(icon);
    }
    if (!nullToAbsent || requiresFocus != null) {
      map['requires_focus'] = Variable<bool>(requiresFocus);
    }
    if (!nullToAbsent || defaultFocusMode != null) {
      map['default_focus_mode'] = Variable<String>(defaultFocusMode);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  UserCategoriesCompanion toCompanion(bool nullToAbsent) {
    return UserCategoriesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      fieldVersions: Value(fieldVersions),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      rootCategoryKey: Value(rootCategoryKey),
      name: Value(name),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      icon: icon == null && nullToAbsent ? const Value.absent() : Value(icon),
      requiresFocus: requiresFocus == null && nullToAbsent
          ? const Value.absent()
          : Value(requiresFocus),
      defaultFocusMode: defaultFocusMode == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultFocusMode),
      sortOrder: Value(sortOrder),
    );
  }

  factory UserCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserCategory(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      fieldVersions: $UserCategoriesTable.$converterfieldVersions.fromJson(
        serializer.fromJson<Object?>(json['field_versions']),
      ),
      parentId: serializer.fromJson<String?>(json['parent_id']),
      rootCategoryKey: serializer.fromJson<String>(json['root_category_key']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<String?>(json['color']),
      icon: serializer.fromJson<String?>(json['icon']),
      requiresFocus: serializer.fromJson<bool?>(json['requires_focus']),
      defaultFocusMode: serializer.fromJson<String?>(
        json['default_focus_mode'],
      ),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'field_versions': serializer.toJson<Object?>(
        $UserCategoriesTable.$converterfieldVersions.toJson(fieldVersions),
      ),
      'parent_id': serializer.toJson<String?>(parentId),
      'root_category_key': serializer.toJson<String>(rootCategoryKey),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<String?>(color),
      'icon': serializer.toJson<String?>(icon),
      'requires_focus': serializer.toJson<bool?>(requiresFocus),
      'default_focus_mode': serializer.toJson<String?>(defaultFocusMode),
      'sort_order': serializer.toJson<int>(sortOrder),
    };
  }

  UserCategory copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Map<String, String>? fieldVersions,
    Value<String?> parentId = const Value.absent(),
    String? rootCategoryKey,
    String? name,
    Value<String?> color = const Value.absent(),
    Value<String?> icon = const Value.absent(),
    Value<bool?> requiresFocus = const Value.absent(),
    Value<String?> defaultFocusMode = const Value.absent(),
    int? sortOrder,
  }) => UserCategory(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    fieldVersions: fieldVersions ?? this.fieldVersions,
    parentId: parentId.present ? parentId.value : this.parentId,
    rootCategoryKey: rootCategoryKey ?? this.rootCategoryKey,
    name: name ?? this.name,
    color: color.present ? color.value : this.color,
    icon: icon.present ? icon.value : this.icon,
    requiresFocus: requiresFocus.present
        ? requiresFocus.value
        : this.requiresFocus,
    defaultFocusMode: defaultFocusMode.present
        ? defaultFocusMode.value
        : this.defaultFocusMode,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  UserCategory copyWithCompanion(UserCategoriesCompanion data) {
    return UserCategory(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      fieldVersions: data.fieldVersions.present
          ? data.fieldVersions.value
          : this.fieldVersions,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      rootCategoryKey: data.rootCategoryKey.present
          ? data.rootCategoryKey.value
          : this.rootCategoryKey,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      icon: data.icon.present ? data.icon.value : this.icon,
      requiresFocus: data.requiresFocus.present
          ? data.requiresFocus.value
          : this.requiresFocus,
      defaultFocusMode: data.defaultFocusMode.present
          ? data.defaultFocusMode.value
          : this.defaultFocusMode,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserCategory(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('parentId: $parentId, ')
          ..write('rootCategoryKey: $rootCategoryKey, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('requiresFocus: $requiresFocus, ')
          ..write('defaultFocusMode: $defaultFocusMode, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    parentId,
    rootCategoryKey,
    name,
    color,
    icon,
    requiresFocus,
    defaultFocusMode,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserCategory &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.fieldVersions == this.fieldVersions &&
          other.parentId == this.parentId &&
          other.rootCategoryKey == this.rootCategoryKey &&
          other.name == this.name &&
          other.color == this.color &&
          other.icon == this.icon &&
          other.requiresFocus == this.requiresFocus &&
          other.defaultFocusMode == this.defaultFocusMode &&
          other.sortOrder == this.sortOrder);
}

class UserCategoriesCompanion extends UpdateCompanion<UserCategory> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<Map<String, String>> fieldVersions;
  final Value<String?> parentId;
  final Value<String> rootCategoryKey;
  final Value<String> name;
  final Value<String?> color;
  final Value<String?> icon;
  final Value<bool?> requiresFocus;
  final Value<String?> defaultFocusMode;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const UserCategoriesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.parentId = const Value.absent(),
    this.rootCategoryKey = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.requiresFocus = const Value.absent(),
    this.defaultFocusMode = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserCategoriesCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.parentId = const Value.absent(),
    required String rootCategoryKey,
    required String name,
    this.color = const Value.absent(),
    this.icon = const Value.absent(),
    this.requiresFocus = const Value.absent(),
    this.defaultFocusMode = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       rootCategoryKey = Value(rootCategoryKey),
       name = Value(name);
  static Insertable<UserCategory> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? fieldVersions,
    Expression<String>? parentId,
    Expression<String>? rootCategoryKey,
    Expression<String>? name,
    Expression<String>? color,
    Expression<String>? icon,
    Expression<bool>? requiresFocus,
    Expression<String>? defaultFocusMode,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (fieldVersions != null) 'field_versions': fieldVersions,
      if (parentId != null) 'parent_id': parentId,
      if (rootCategoryKey != null) 'root_category_key': rootCategoryKey,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (icon != null) 'icon': icon,
      if (requiresFocus != null) 'requires_focus': requiresFocus,
      if (defaultFocusMode != null) 'default_focus_mode': defaultFocusMode,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserCategoriesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<Map<String, String>>? fieldVersions,
    Value<String?>? parentId,
    Value<String>? rootCategoryKey,
    Value<String>? name,
    Value<String?>? color,
    Value<String?>? icon,
    Value<bool?>? requiresFocus,
    Value<String?>? defaultFocusMode,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return UserCategoriesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      fieldVersions: fieldVersions ?? this.fieldVersions,
      parentId: parentId ?? this.parentId,
      rootCategoryKey: rootCategoryKey ?? this.rootCategoryKey,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      requiresFocus: requiresFocus ?? this.requiresFocus,
      defaultFocusMode: defaultFocusMode ?? this.defaultFocusMode,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (fieldVersions.present) {
      map['field_versions'] = Variable<String>(
        $UserCategoriesTable.$converterfieldVersions.toSql(fieldVersions.value),
      );
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (rootCategoryKey.present) {
      map['root_category_key'] = Variable<String>(rootCategoryKey.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (icon.present) {
      map['icon'] = Variable<String>(icon.value);
    }
    if (requiresFocus.present) {
      map['requires_focus'] = Variable<bool>(requiresFocus.value);
    }
    if (defaultFocusMode.present) {
      map['default_focus_mode'] = Variable<String>(defaultFocusMode.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('parentId: $parentId, ')
          ..write('rootCategoryKey: $rootCategoryKey, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('icon: $icon, ')
          ..write('requiresFocus: $requiresFocus, ')
          ..write('defaultFocusMode: $defaultFocusMode, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VariantGroupsTable extends VariantGroups
    with TableInfo<$VariantGroupsTable, VariantGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VariantGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  fieldVersions =
      GeneratedColumn<String>(
        'field_versions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      ).withConverter<Map<String, String>>(
        $VariantGroupsTable.$converterfieldVersions,
      );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Recurrence?, String> appliesOn =
      GeneratedColumn<String>(
        'applies_on',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Recurrence?>($VariantGroupsTable.$converterappliesOnn);
  static const VerificationMeta _defaultVariantIdMeta = const VerificationMeta(
    'defaultVariantId',
  );
  @override
  late final GeneratedColumn<String> defaultVariantId = GeneratedColumn<String>(
    'default_variant_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES variants (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    activityId,
    name,
    appliesOn,
    defaultVariantId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'variant_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<VariantGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('default_variant_id')) {
      context.handle(
        _defaultVariantIdMeta,
        defaultVariantId.isAcceptableOrUnknown(
          data['default_variant_id']!,
          _defaultVariantIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  VariantGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return VariantGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      fieldVersions: $VariantGroupsTable.$converterfieldVersions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}field_versions'],
        )!,
      ),
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      appliesOn: $VariantGroupsTable.$converterappliesOnn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}applies_on'],
        ),
      ),
      defaultVariantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}default_variant_id'],
      ),
    );
  }

  @override
  $VariantGroupsTable createAlias(String alias) {
    return $VariantGroupsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, String>, String, Object?>
  $converterfieldVersions = const FieldVersionsConverter();
  static JsonTypeConverter2<Recurrence, String, Map<String, Object?>>
  $converterappliesOn = const RecurrenceConverter();
  static JsonTypeConverter2<Recurrence?, String?, Map<String, Object?>?>
  $converterappliesOnn = JsonTypeConverter2.asNullable($converterappliesOn);
}

class VariantGroup extends DataClass implements Insertable<VariantGroup> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Map<String, String> fieldVersions;
  final String activityId;
  final String? name;
  final Recurrence? appliesOn;
  final String? defaultVariantId;
  const VariantGroup({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.fieldVersions,
    required this.activityId,
    this.name,
    this.appliesOn,
    this.defaultVariantId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['field_versions'] = Variable<String>(
        $VariantGroupsTable.$converterfieldVersions.toSql(fieldVersions),
      );
    }
    map['activity_id'] = Variable<String>(activityId);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    if (!nullToAbsent || appliesOn != null) {
      map['applies_on'] = Variable<String>(
        $VariantGroupsTable.$converterappliesOnn.toSql(appliesOn),
      );
    }
    if (!nullToAbsent || defaultVariantId != null) {
      map['default_variant_id'] = Variable<String>(defaultVariantId);
    }
    return map;
  }

  VariantGroupsCompanion toCompanion(bool nullToAbsent) {
    return VariantGroupsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      fieldVersions: Value(fieldVersions),
      activityId: Value(activityId),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      appliesOn: appliesOn == null && nullToAbsent
          ? const Value.absent()
          : Value(appliesOn),
      defaultVariantId: defaultVariantId == null && nullToAbsent
          ? const Value.absent()
          : Value(defaultVariantId),
    );
  }

  factory VariantGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return VariantGroup(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      fieldVersions: $VariantGroupsTable.$converterfieldVersions.fromJson(
        serializer.fromJson<Object?>(json['field_versions']),
      ),
      activityId: serializer.fromJson<String>(json['activity_id']),
      name: serializer.fromJson<String?>(json['name']),
      appliesOn: $VariantGroupsTable.$converterappliesOnn.fromJson(
        serializer.fromJson<Map<String, Object?>?>(json['applies_on']),
      ),
      defaultVariantId: serializer.fromJson<String?>(
        json['default_variant_id'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'field_versions': serializer.toJson<Object?>(
        $VariantGroupsTable.$converterfieldVersions.toJson(fieldVersions),
      ),
      'activity_id': serializer.toJson<String>(activityId),
      'name': serializer.toJson<String?>(name),
      'applies_on': serializer.toJson<Map<String, Object?>?>(
        $VariantGroupsTable.$converterappliesOnn.toJson(appliesOn),
      ),
      'default_variant_id': serializer.toJson<String?>(defaultVariantId),
    };
  }

  VariantGroup copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Map<String, String>? fieldVersions,
    String? activityId,
    Value<String?> name = const Value.absent(),
    Value<Recurrence?> appliesOn = const Value.absent(),
    Value<String?> defaultVariantId = const Value.absent(),
  }) => VariantGroup(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    fieldVersions: fieldVersions ?? this.fieldVersions,
    activityId: activityId ?? this.activityId,
    name: name.present ? name.value : this.name,
    appliesOn: appliesOn.present ? appliesOn.value : this.appliesOn,
    defaultVariantId: defaultVariantId.present
        ? defaultVariantId.value
        : this.defaultVariantId,
  );
  VariantGroup copyWithCompanion(VariantGroupsCompanion data) {
    return VariantGroup(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      fieldVersions: data.fieldVersions.present
          ? data.fieldVersions.value
          : this.fieldVersions,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      name: data.name.present ? data.name.value : this.name,
      appliesOn: data.appliesOn.present ? data.appliesOn.value : this.appliesOn,
      defaultVariantId: data.defaultVariantId.present
          ? data.defaultVariantId.value
          : this.defaultVariantId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('VariantGroup(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('activityId: $activityId, ')
          ..write('name: $name, ')
          ..write('appliesOn: $appliesOn, ')
          ..write('defaultVariantId: $defaultVariantId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    activityId,
    name,
    appliesOn,
    defaultVariantId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is VariantGroup &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.fieldVersions == this.fieldVersions &&
          other.activityId == this.activityId &&
          other.name == this.name &&
          other.appliesOn == this.appliesOn &&
          other.defaultVariantId == this.defaultVariantId);
}

class VariantGroupsCompanion extends UpdateCompanion<VariantGroup> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<Map<String, String>> fieldVersions;
  final Value<String> activityId;
  final Value<String?> name;
  final Value<Recurrence?> appliesOn;
  final Value<String?> defaultVariantId;
  final Value<int> rowid;
  const VariantGroupsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.activityId = const Value.absent(),
    this.name = const Value.absent(),
    this.appliesOn = const Value.absent(),
    this.defaultVariantId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VariantGroupsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    required String activityId,
    this.name = const Value.absent(),
    this.appliesOn = const Value.absent(),
    this.defaultVariantId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       activityId = Value(activityId);
  static Insertable<VariantGroup> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? fieldVersions,
    Expression<String>? activityId,
    Expression<String>? name,
    Expression<String>? appliesOn,
    Expression<String>? defaultVariantId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (fieldVersions != null) 'field_versions': fieldVersions,
      if (activityId != null) 'activity_id': activityId,
      if (name != null) 'name': name,
      if (appliesOn != null) 'applies_on': appliesOn,
      if (defaultVariantId != null) 'default_variant_id': defaultVariantId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VariantGroupsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<Map<String, String>>? fieldVersions,
    Value<String>? activityId,
    Value<String?>? name,
    Value<Recurrence?>? appliesOn,
    Value<String?>? defaultVariantId,
    Value<int>? rowid,
  }) {
    return VariantGroupsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      fieldVersions: fieldVersions ?? this.fieldVersions,
      activityId: activityId ?? this.activityId,
      name: name ?? this.name,
      appliesOn: appliesOn ?? this.appliesOn,
      defaultVariantId: defaultVariantId ?? this.defaultVariantId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (fieldVersions.present) {
      map['field_versions'] = Variable<String>(
        $VariantGroupsTable.$converterfieldVersions.toSql(fieldVersions.value),
      );
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (appliesOn.present) {
      map['applies_on'] = Variable<String>(
        $VariantGroupsTable.$converterappliesOnn.toSql(appliesOn.value),
      );
    }
    if (defaultVariantId.present) {
      map['default_variant_id'] = Variable<String>(defaultVariantId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VariantGroupsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('activityId: $activityId, ')
          ..write('name: $name, ')
          ..write('appliesOn: $appliesOn, ')
          ..write('defaultVariantId: $defaultVariantId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $VariantsTable extends Variants with TableInfo<$VariantsTable, Variant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $VariantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  fieldVersions = GeneratedColumn<String>(
    'field_versions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  ).withConverter<Map<String, String>>($VariantsTable.$converterfieldVersions);
  static const VerificationMeta _groupIdMeta = const VerificationMeta(
    'groupId',
  );
  @override
  late final GeneratedColumn<String> groupId = GeneratedColumn<String>(
    'group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES variant_groups (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Timing?, String> timing =
      GeneratedColumn<String>(
        'timing',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Timing?>($VariantsTable.$convertertimingn);
  static const VerificationMeta _durationMinMinutesMeta =
      const VerificationMeta('durationMinMinutes');
  @override
  late final GeneratedColumn<int> durationMinMinutes = GeneratedColumn<int>(
    'duration_min_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMaxMinutesMeta =
      const VerificationMeta('durationMaxMinutes');
  @override
  late final GeneratedColumn<int> durationMaxMinutes = GeneratedColumn<int>(
    'duration_max_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cancelsOccurrenceMeta = const VerificationMeta(
    'cancelsOccurrence',
  );
  @override
  late final GeneratedColumn<bool> cancelsOccurrence = GeneratedColumn<bool>(
    'cancels_occurrence',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("cancels_occurrence" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    groupId,
    name,
    sortOrder,
    timing,
    durationMinMinutes,
    durationMaxMinutes,
    cancelsOccurrence,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'variants';
  @override
  VerificationContext validateIntegrity(
    Insertable<Variant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('group_id')) {
      context.handle(
        _groupIdMeta,
        groupId.isAcceptableOrUnknown(data['group_id']!, _groupIdMeta),
      );
    } else if (isInserting) {
      context.missing(_groupIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('duration_min_minutes')) {
      context.handle(
        _durationMinMinutesMeta,
        durationMinMinutes.isAcceptableOrUnknown(
          data['duration_min_minutes']!,
          _durationMinMinutesMeta,
        ),
      );
    }
    if (data.containsKey('duration_max_minutes')) {
      context.handle(
        _durationMaxMinutesMeta,
        durationMaxMinutes.isAcceptableOrUnknown(
          data['duration_max_minutes']!,
          _durationMaxMinutesMeta,
        ),
      );
    }
    if (data.containsKey('cancels_occurrence')) {
      context.handle(
        _cancelsOccurrenceMeta,
        cancelsOccurrence.isAcceptableOrUnknown(
          data['cancels_occurrence']!,
          _cancelsOccurrenceMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Variant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Variant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      fieldVersions: $VariantsTable.$converterfieldVersions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}field_versions'],
        )!,
      ),
      groupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}group_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      timing: $VariantsTable.$convertertimingn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}timing'],
        ),
      ),
      durationMinMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_min_minutes'],
      ),
      durationMaxMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_max_minutes'],
      ),
      cancelsOccurrence: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}cancels_occurrence'],
      )!,
    );
  }

  @override
  $VariantsTable createAlias(String alias) {
    return $VariantsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, String>, String, Object?>
  $converterfieldVersions = const FieldVersionsConverter();
  static JsonTypeConverter2<Timing, String, Map<String, Object?>>
  $convertertiming = const TimingConverter();
  static JsonTypeConverter2<Timing?, String?, Map<String, Object?>?>
  $convertertimingn = JsonTypeConverter2.asNullable($convertertiming);
}

class Variant extends DataClass implements Insertable<Variant> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Map<String, String> fieldVersions;
  final String groupId;
  final String name;
  final int sortOrder;
  final Timing? timing;
  final int? durationMinMinutes;
  final int? durationMaxMinutes;
  final bool cancelsOccurrence;
  const Variant({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.fieldVersions,
    required this.groupId,
    required this.name,
    required this.sortOrder,
    this.timing,
    this.durationMinMinutes,
    this.durationMaxMinutes,
    required this.cancelsOccurrence,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['field_versions'] = Variable<String>(
        $VariantsTable.$converterfieldVersions.toSql(fieldVersions),
      );
    }
    map['group_id'] = Variable<String>(groupId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || timing != null) {
      map['timing'] = Variable<String>(
        $VariantsTable.$convertertimingn.toSql(timing),
      );
    }
    if (!nullToAbsent || durationMinMinutes != null) {
      map['duration_min_minutes'] = Variable<int>(durationMinMinutes);
    }
    if (!nullToAbsent || durationMaxMinutes != null) {
      map['duration_max_minutes'] = Variable<int>(durationMaxMinutes);
    }
    map['cancels_occurrence'] = Variable<bool>(cancelsOccurrence);
    return map;
  }

  VariantsCompanion toCompanion(bool nullToAbsent) {
    return VariantsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      fieldVersions: Value(fieldVersions),
      groupId: Value(groupId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      timing: timing == null && nullToAbsent
          ? const Value.absent()
          : Value(timing),
      durationMinMinutes: durationMinMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinMinutes),
      durationMaxMinutes: durationMaxMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMaxMinutes),
      cancelsOccurrence: Value(cancelsOccurrence),
    );
  }

  factory Variant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Variant(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      fieldVersions: $VariantsTable.$converterfieldVersions.fromJson(
        serializer.fromJson<Object?>(json['field_versions']),
      ),
      groupId: serializer.fromJson<String>(json['group_id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
      timing: $VariantsTable.$convertertimingn.fromJson(
        serializer.fromJson<Map<String, Object?>?>(json['timing']),
      ),
      durationMinMinutes: serializer.fromJson<int?>(
        json['duration_min_minutes'],
      ),
      durationMaxMinutes: serializer.fromJson<int?>(
        json['duration_max_minutes'],
      ),
      cancelsOccurrence: serializer.fromJson<bool>(json['cancels_occurrence']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'field_versions': serializer.toJson<Object?>(
        $VariantsTable.$converterfieldVersions.toJson(fieldVersions),
      ),
      'group_id': serializer.toJson<String>(groupId),
      'name': serializer.toJson<String>(name),
      'sort_order': serializer.toJson<int>(sortOrder),
      'timing': serializer.toJson<Map<String, Object?>?>(
        $VariantsTable.$convertertimingn.toJson(timing),
      ),
      'duration_min_minutes': serializer.toJson<int?>(durationMinMinutes),
      'duration_max_minutes': serializer.toJson<int?>(durationMaxMinutes),
      'cancels_occurrence': serializer.toJson<bool>(cancelsOccurrence),
    };
  }

  Variant copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Map<String, String>? fieldVersions,
    String? groupId,
    String? name,
    int? sortOrder,
    Value<Timing?> timing = const Value.absent(),
    Value<int?> durationMinMinutes = const Value.absent(),
    Value<int?> durationMaxMinutes = const Value.absent(),
    bool? cancelsOccurrence,
  }) => Variant(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    fieldVersions: fieldVersions ?? this.fieldVersions,
    groupId: groupId ?? this.groupId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    timing: timing.present ? timing.value : this.timing,
    durationMinMinutes: durationMinMinutes.present
        ? durationMinMinutes.value
        : this.durationMinMinutes,
    durationMaxMinutes: durationMaxMinutes.present
        ? durationMaxMinutes.value
        : this.durationMaxMinutes,
    cancelsOccurrence: cancelsOccurrence ?? this.cancelsOccurrence,
  );
  Variant copyWithCompanion(VariantsCompanion data) {
    return Variant(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      fieldVersions: data.fieldVersions.present
          ? data.fieldVersions.value
          : this.fieldVersions,
      groupId: data.groupId.present ? data.groupId.value : this.groupId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      timing: data.timing.present ? data.timing.value : this.timing,
      durationMinMinutes: data.durationMinMinutes.present
          ? data.durationMinMinutes.value
          : this.durationMinMinutes,
      durationMaxMinutes: data.durationMaxMinutes.present
          ? data.durationMaxMinutes.value
          : this.durationMaxMinutes,
      cancelsOccurrence: data.cancelsOccurrence.present
          ? data.cancelsOccurrence.value
          : this.cancelsOccurrence,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Variant(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('timing: $timing, ')
          ..write('durationMinMinutes: $durationMinMinutes, ')
          ..write('durationMaxMinutes: $durationMaxMinutes, ')
          ..write('cancelsOccurrence: $cancelsOccurrence')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    groupId,
    name,
    sortOrder,
    timing,
    durationMinMinutes,
    durationMaxMinutes,
    cancelsOccurrence,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Variant &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.fieldVersions == this.fieldVersions &&
          other.groupId == this.groupId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.timing == this.timing &&
          other.durationMinMinutes == this.durationMinMinutes &&
          other.durationMaxMinutes == this.durationMaxMinutes &&
          other.cancelsOccurrence == this.cancelsOccurrence);
}

class VariantsCompanion extends UpdateCompanion<Variant> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<Map<String, String>> fieldVersions;
  final Value<String> groupId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<Timing?> timing;
  final Value<int?> durationMinMinutes;
  final Value<int?> durationMaxMinutes;
  final Value<bool> cancelsOccurrence;
  final Value<int> rowid;
  const VariantsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.groupId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.timing = const Value.absent(),
    this.durationMinMinutes = const Value.absent(),
    this.durationMaxMinutes = const Value.absent(),
    this.cancelsOccurrence = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  VariantsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    required String groupId,
    required String name,
    this.sortOrder = const Value.absent(),
    this.timing = const Value.absent(),
    this.durationMinMinutes = const Value.absent(),
    this.durationMaxMinutes = const Value.absent(),
    this.cancelsOccurrence = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       groupId = Value(groupId),
       name = Value(name);
  static Insertable<Variant> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? fieldVersions,
    Expression<String>? groupId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<String>? timing,
    Expression<int>? durationMinMinutes,
    Expression<int>? durationMaxMinutes,
    Expression<bool>? cancelsOccurrence,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (fieldVersions != null) 'field_versions': fieldVersions,
      if (groupId != null) 'group_id': groupId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (timing != null) 'timing': timing,
      if (durationMinMinutes != null)
        'duration_min_minutes': durationMinMinutes,
      if (durationMaxMinutes != null)
        'duration_max_minutes': durationMaxMinutes,
      if (cancelsOccurrence != null) 'cancels_occurrence': cancelsOccurrence,
      if (rowid != null) 'rowid': rowid,
    });
  }

  VariantsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<Map<String, String>>? fieldVersions,
    Value<String>? groupId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<Timing?>? timing,
    Value<int?>? durationMinMinutes,
    Value<int?>? durationMaxMinutes,
    Value<bool>? cancelsOccurrence,
    Value<int>? rowid,
  }) {
    return VariantsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      fieldVersions: fieldVersions ?? this.fieldVersions,
      groupId: groupId ?? this.groupId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      timing: timing ?? this.timing,
      durationMinMinutes: durationMinMinutes ?? this.durationMinMinutes,
      durationMaxMinutes: durationMaxMinutes ?? this.durationMaxMinutes,
      cancelsOccurrence: cancelsOccurrence ?? this.cancelsOccurrence,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (fieldVersions.present) {
      map['field_versions'] = Variable<String>(
        $VariantsTable.$converterfieldVersions.toSql(fieldVersions.value),
      );
    }
    if (groupId.present) {
      map['group_id'] = Variable<String>(groupId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (timing.present) {
      map['timing'] = Variable<String>(
        $VariantsTable.$convertertimingn.toSql(timing.value),
      );
    }
    if (durationMinMinutes.present) {
      map['duration_min_minutes'] = Variable<int>(durationMinMinutes.value);
    }
    if (durationMaxMinutes.present) {
      map['duration_max_minutes'] = Variable<int>(durationMaxMinutes.value);
    }
    if (cancelsOccurrence.present) {
      map['cancels_occurrence'] = Variable<bool>(cancelsOccurrence.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('VariantsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('groupId: $groupId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('timing: $timing, ')
          ..write('durationMinMinutes: $durationMinMinutes, ')
          ..write('durationMaxMinutes: $durationMaxMinutes, ')
          ..write('cancelsOccurrence: $cancelsOccurrence, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivitiesTable extends Activities
    with TableInfo<$ActivitiesTable, Activity> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivitiesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  fieldVersions =
      GeneratedColumn<String>(
        'field_versions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      ).withConverter<Map<String, String>>(
        $ActivitiesTable.$converterfieldVersions,
      );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    check: () => kind.isIn(activityKinds),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_categories (id)',
    ),
  );
  static const VerificationMeta _rootCategoryKeyMeta = const VerificationMeta(
    'rootCategoryKey',
  );
  @override
  late final GeneratedColumn<String> rootCategoryKey = GeneratedColumn<String>(
    'root_category_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES root_categories ("key")',
    ),
  );
  static const VerificationMeta _parentActivityIdMeta = const VerificationMeta(
    'parentActivityId',
  );
  @override
  late final GeneratedColumn<String> parentActivityId = GeneratedColumn<String>(
    'parent_activity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id)',
    ),
  );
  static const VerificationMeta _variantIdMeta = const VerificationMeta(
    'variantId',
  );
  @override
  late final GeneratedColumn<String> variantId = GeneratedColumn<String>(
    'variant_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES variants (id)',
    ),
  );
  static const VerificationMeta _estimatedMinutesMeta = const VerificationMeta(
    'estimatedMinutes',
  );
  @override
  late final GeneratedColumn<int> estimatedMinutes = GeneratedColumn<int>(
    'estimated_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<int> priority = GeneratedColumn<int>(
    'priority',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _requiresFocusMeta = const VerificationMeta(
    'requiresFocus',
  );
  @override
  late final GeneratedColumn<bool> requiresFocus = GeneratedColumn<bool>(
    'requires_focus',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("requires_focus" IN (0, 1))',
    ),
  );
  static const VerificationMeta _focusModeMeta = const VerificationMeta(
    'focusMode',
  );
  @override
  late final GeneratedColumn<String> focusMode = GeneratedColumn<String>(
    'focus_mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _focusBlockMinutesMeta = const VerificationMeta(
    'focusBlockMinutes',
  );
  @override
  late final GeneratedColumn<int> focusBlockMinutes = GeneratedColumn<int>(
    'focus_block_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _focusBreakMinutesMeta = const VerificationMeta(
    'focusBreakMinutes',
  );
  @override
  late final GeneratedColumn<int> focusBreakMinutes = GeneratedColumn<int>(
    'focus_break_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _focusSpreadMeta = const VerificationMeta(
    'focusSpread',
  );
  @override
  late final GeneratedColumn<bool> focusSpread = GeneratedColumn<bool>(
    'focus_spread',
    aliasedName,
    true,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("focus_spread" IN (0, 1))',
    ),
  );
  static const VerificationMeta _focusGraceMinutesMeta = const VerificationMeta(
    'focusGraceMinutes',
  );
  @override
  late final GeneratedColumn<int> focusGraceMinutes = GeneratedColumn<int>(
    'focus_grace_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _focusCyclesMeta = const VerificationMeta(
    'focusCycles',
  );
  @override
  late final GeneratedColumn<int> focusCycles = GeneratedColumn<int>(
    'focus_cycles',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _focusLongBreakMinutesMeta =
      const VerificationMeta('focusLongBreakMinutes');
  @override
  late final GeneratedColumn<int> focusLongBreakMinutes = GeneratedColumn<int>(
    'focus_long_break_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _focusLongEveryMeta = const VerificationMeta(
    'focusLongEvery',
  );
  @override
  late final GeneratedColumn<int> focusLongEvery = GeneratedColumn<int>(
    'focus_long_every',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    kind,
    title,
    notes,
    categoryId,
    rootCategoryKey,
    parentActivityId,
    variantId,
    estimatedMinutes,
    priority,
    requiresFocus,
    focusMode,
    focusBlockMinutes,
    focusBreakMinutes,
    focusSpread,
    focusGraceMinutes,
    focusCycles,
    focusLongBreakMinutes,
    focusLongEvery,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activities';
  @override
  VerificationContext validateIntegrity(
    Insertable<Activity> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('root_category_key')) {
      context.handle(
        _rootCategoryKeyMeta,
        rootCategoryKey.isAcceptableOrUnknown(
          data['root_category_key']!,
          _rootCategoryKeyMeta,
        ),
      );
    }
    if (data.containsKey('parent_activity_id')) {
      context.handle(
        _parentActivityIdMeta,
        parentActivityId.isAcceptableOrUnknown(
          data['parent_activity_id']!,
          _parentActivityIdMeta,
        ),
      );
    }
    if (data.containsKey('variant_id')) {
      context.handle(
        _variantIdMeta,
        variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta),
      );
    }
    if (data.containsKey('estimated_minutes')) {
      context.handle(
        _estimatedMinutesMeta,
        estimatedMinutes.isAcceptableOrUnknown(
          data['estimated_minutes']!,
          _estimatedMinutesMeta,
        ),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('requires_focus')) {
      context.handle(
        _requiresFocusMeta,
        requiresFocus.isAcceptableOrUnknown(
          data['requires_focus']!,
          _requiresFocusMeta,
        ),
      );
    }
    if (data.containsKey('focus_mode')) {
      context.handle(
        _focusModeMeta,
        focusMode.isAcceptableOrUnknown(data['focus_mode']!, _focusModeMeta),
      );
    }
    if (data.containsKey('focus_block_minutes')) {
      context.handle(
        _focusBlockMinutesMeta,
        focusBlockMinutes.isAcceptableOrUnknown(
          data['focus_block_minutes']!,
          _focusBlockMinutesMeta,
        ),
      );
    }
    if (data.containsKey('focus_break_minutes')) {
      context.handle(
        _focusBreakMinutesMeta,
        focusBreakMinutes.isAcceptableOrUnknown(
          data['focus_break_minutes']!,
          _focusBreakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('focus_spread')) {
      context.handle(
        _focusSpreadMeta,
        focusSpread.isAcceptableOrUnknown(
          data['focus_spread']!,
          _focusSpreadMeta,
        ),
      );
    }
    if (data.containsKey('focus_grace_minutes')) {
      context.handle(
        _focusGraceMinutesMeta,
        focusGraceMinutes.isAcceptableOrUnknown(
          data['focus_grace_minutes']!,
          _focusGraceMinutesMeta,
        ),
      );
    }
    if (data.containsKey('focus_cycles')) {
      context.handle(
        _focusCyclesMeta,
        focusCycles.isAcceptableOrUnknown(
          data['focus_cycles']!,
          _focusCyclesMeta,
        ),
      );
    }
    if (data.containsKey('focus_long_break_minutes')) {
      context.handle(
        _focusLongBreakMinutesMeta,
        focusLongBreakMinutes.isAcceptableOrUnknown(
          data['focus_long_break_minutes']!,
          _focusLongBreakMinutesMeta,
        ),
      );
    }
    if (data.containsKey('focus_long_every')) {
      context.handle(
        _focusLongEveryMeta,
        focusLongEvery.isAcceptableOrUnknown(
          data['focus_long_every']!,
          _focusLongEveryMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Activity map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Activity(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      fieldVersions: $ActivitiesTable.$converterfieldVersions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}field_versions'],
        )!,
      ),
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      rootCategoryKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_category_key'],
      ),
      parentActivityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_activity_id'],
      ),
      variantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant_id'],
      ),
      estimatedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_minutes'],
      ),
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}priority'],
      ),
      requiresFocus: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}requires_focus'],
      ),
      focusMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}focus_mode'],
      ),
      focusBlockMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_block_minutes'],
      ),
      focusBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_break_minutes'],
      ),
      focusSpread: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}focus_spread'],
      ),
      focusGraceMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_grace_minutes'],
      ),
      focusCycles: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_cycles'],
      ),
      focusLongBreakMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_long_break_minutes'],
      ),
      focusLongEvery: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_long_every'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $ActivitiesTable createAlias(String alias) {
    return $ActivitiesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, String>, String, Object?>
  $converterfieldVersions = const FieldVersionsConverter();
}

class Activity extends DataClass implements Insertable<Activity> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Map<String, String> fieldVersions;
  final String kind;
  final String title;
  final String? notes;
  final String? categoryId;
  final String? rootCategoryKey;
  final String? parentActivityId;
  final String? variantId;
  final int? estimatedMinutes;
  final int? priority;
  final bool? requiresFocus;
  final String? focusMode;

  /// Derin çalışma blok planı ve geç kalma payı (D66); null = varsayılan.
  final int? focusBlockMinutes;
  final int? focusBreakMinutes;
  final bool? focusSpread;
  final int? focusGraceMinutes;

  /// Planlı Pomodoro (D67): tekrar sayısı, uzun mola ve kaç döngüde bir olduğu.
  final int? focusCycles;
  final int? focusLongBreakMinutes;
  final int? focusLongEvery;
  final int sortOrder;
  const Activity({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.fieldVersions,
    required this.kind,
    required this.title,
    this.notes,
    this.categoryId,
    this.rootCategoryKey,
    this.parentActivityId,
    this.variantId,
    this.estimatedMinutes,
    this.priority,
    this.requiresFocus,
    this.focusMode,
    this.focusBlockMinutes,
    this.focusBreakMinutes,
    this.focusSpread,
    this.focusGraceMinutes,
    this.focusCycles,
    this.focusLongBreakMinutes,
    this.focusLongEvery,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['field_versions'] = Variable<String>(
        $ActivitiesTable.$converterfieldVersions.toSql(fieldVersions),
      );
    }
    map['kind'] = Variable<String>(kind);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || rootCategoryKey != null) {
      map['root_category_key'] = Variable<String>(rootCategoryKey);
    }
    if (!nullToAbsent || parentActivityId != null) {
      map['parent_activity_id'] = Variable<String>(parentActivityId);
    }
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<String>(variantId);
    }
    if (!nullToAbsent || estimatedMinutes != null) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes);
    }
    if (!nullToAbsent || priority != null) {
      map['priority'] = Variable<int>(priority);
    }
    if (!nullToAbsent || requiresFocus != null) {
      map['requires_focus'] = Variable<bool>(requiresFocus);
    }
    if (!nullToAbsent || focusMode != null) {
      map['focus_mode'] = Variable<String>(focusMode);
    }
    if (!nullToAbsent || focusBlockMinutes != null) {
      map['focus_block_minutes'] = Variable<int>(focusBlockMinutes);
    }
    if (!nullToAbsent || focusBreakMinutes != null) {
      map['focus_break_minutes'] = Variable<int>(focusBreakMinutes);
    }
    if (!nullToAbsent || focusSpread != null) {
      map['focus_spread'] = Variable<bool>(focusSpread);
    }
    if (!nullToAbsent || focusGraceMinutes != null) {
      map['focus_grace_minutes'] = Variable<int>(focusGraceMinutes);
    }
    if (!nullToAbsent || focusCycles != null) {
      map['focus_cycles'] = Variable<int>(focusCycles);
    }
    if (!nullToAbsent || focusLongBreakMinutes != null) {
      map['focus_long_break_minutes'] = Variable<int>(focusLongBreakMinutes);
    }
    if (!nullToAbsent || focusLongEvery != null) {
      map['focus_long_every'] = Variable<int>(focusLongEvery);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  ActivitiesCompanion toCompanion(bool nullToAbsent) {
    return ActivitiesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      fieldVersions: Value(fieldVersions),
      kind: Value(kind),
      title: Value(title),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      rootCategoryKey: rootCategoryKey == null && nullToAbsent
          ? const Value.absent()
          : Value(rootCategoryKey),
      parentActivityId: parentActivityId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentActivityId),
      variantId: variantId == null && nullToAbsent
          ? const Value.absent()
          : Value(variantId),
      estimatedMinutes: estimatedMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(estimatedMinutes),
      priority: priority == null && nullToAbsent
          ? const Value.absent()
          : Value(priority),
      requiresFocus: requiresFocus == null && nullToAbsent
          ? const Value.absent()
          : Value(requiresFocus),
      focusMode: focusMode == null && nullToAbsent
          ? const Value.absent()
          : Value(focusMode),
      focusBlockMinutes: focusBlockMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(focusBlockMinutes),
      focusBreakMinutes: focusBreakMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(focusBreakMinutes),
      focusSpread: focusSpread == null && nullToAbsent
          ? const Value.absent()
          : Value(focusSpread),
      focusGraceMinutes: focusGraceMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(focusGraceMinutes),
      focusCycles: focusCycles == null && nullToAbsent
          ? const Value.absent()
          : Value(focusCycles),
      focusLongBreakMinutes: focusLongBreakMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(focusLongBreakMinutes),
      focusLongEvery: focusLongEvery == null && nullToAbsent
          ? const Value.absent()
          : Value(focusLongEvery),
      sortOrder: Value(sortOrder),
    );
  }

  factory Activity.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Activity(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      fieldVersions: $ActivitiesTable.$converterfieldVersions.fromJson(
        serializer.fromJson<Object?>(json['field_versions']),
      ),
      kind: serializer.fromJson<String>(json['kind']),
      title: serializer.fromJson<String>(json['title']),
      notes: serializer.fromJson<String?>(json['notes']),
      categoryId: serializer.fromJson<String?>(json['category_id']),
      rootCategoryKey: serializer.fromJson<String?>(json['root_category_key']),
      parentActivityId: serializer.fromJson<String?>(
        json['parent_activity_id'],
      ),
      variantId: serializer.fromJson<String?>(json['variant_id']),
      estimatedMinutes: serializer.fromJson<int?>(json['estimated_minutes']),
      priority: serializer.fromJson<int?>(json['priority']),
      requiresFocus: serializer.fromJson<bool?>(json['requires_focus']),
      focusMode: serializer.fromJson<String?>(json['focus_mode']),
      focusBlockMinutes: serializer.fromJson<int?>(json['focus_block_minutes']),
      focusBreakMinutes: serializer.fromJson<int?>(json['focus_break_minutes']),
      focusSpread: serializer.fromJson<bool?>(json['focus_spread']),
      focusGraceMinutes: serializer.fromJson<int?>(json['focus_grace_minutes']),
      focusCycles: serializer.fromJson<int?>(json['focus_cycles']),
      focusLongBreakMinutes: serializer.fromJson<int?>(
        json['focus_long_break_minutes'],
      ),
      focusLongEvery: serializer.fromJson<int?>(json['focus_long_every']),
      sortOrder: serializer.fromJson<int>(json['sort_order']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'field_versions': serializer.toJson<Object?>(
        $ActivitiesTable.$converterfieldVersions.toJson(fieldVersions),
      ),
      'kind': serializer.toJson<String>(kind),
      'title': serializer.toJson<String>(title),
      'notes': serializer.toJson<String?>(notes),
      'category_id': serializer.toJson<String?>(categoryId),
      'root_category_key': serializer.toJson<String?>(rootCategoryKey),
      'parent_activity_id': serializer.toJson<String?>(parentActivityId),
      'variant_id': serializer.toJson<String?>(variantId),
      'estimated_minutes': serializer.toJson<int?>(estimatedMinutes),
      'priority': serializer.toJson<int?>(priority),
      'requires_focus': serializer.toJson<bool?>(requiresFocus),
      'focus_mode': serializer.toJson<String?>(focusMode),
      'focus_block_minutes': serializer.toJson<int?>(focusBlockMinutes),
      'focus_break_minutes': serializer.toJson<int?>(focusBreakMinutes),
      'focus_spread': serializer.toJson<bool?>(focusSpread),
      'focus_grace_minutes': serializer.toJson<int?>(focusGraceMinutes),
      'focus_cycles': serializer.toJson<int?>(focusCycles),
      'focus_long_break_minutes': serializer.toJson<int?>(
        focusLongBreakMinutes,
      ),
      'focus_long_every': serializer.toJson<int?>(focusLongEvery),
      'sort_order': serializer.toJson<int>(sortOrder),
    };
  }

  Activity copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Map<String, String>? fieldVersions,
    String? kind,
    String? title,
    Value<String?> notes = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> rootCategoryKey = const Value.absent(),
    Value<String?> parentActivityId = const Value.absent(),
    Value<String?> variantId = const Value.absent(),
    Value<int?> estimatedMinutes = const Value.absent(),
    Value<int?> priority = const Value.absent(),
    Value<bool?> requiresFocus = const Value.absent(),
    Value<String?> focusMode = const Value.absent(),
    Value<int?> focusBlockMinutes = const Value.absent(),
    Value<int?> focusBreakMinutes = const Value.absent(),
    Value<bool?> focusSpread = const Value.absent(),
    Value<int?> focusGraceMinutes = const Value.absent(),
    Value<int?> focusCycles = const Value.absent(),
    Value<int?> focusLongBreakMinutes = const Value.absent(),
    Value<int?> focusLongEvery = const Value.absent(),
    int? sortOrder,
  }) => Activity(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    fieldVersions: fieldVersions ?? this.fieldVersions,
    kind: kind ?? this.kind,
    title: title ?? this.title,
    notes: notes.present ? notes.value : this.notes,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    rootCategoryKey: rootCategoryKey.present
        ? rootCategoryKey.value
        : this.rootCategoryKey,
    parentActivityId: parentActivityId.present
        ? parentActivityId.value
        : this.parentActivityId,
    variantId: variantId.present ? variantId.value : this.variantId,
    estimatedMinutes: estimatedMinutes.present
        ? estimatedMinutes.value
        : this.estimatedMinutes,
    priority: priority.present ? priority.value : this.priority,
    requiresFocus: requiresFocus.present
        ? requiresFocus.value
        : this.requiresFocus,
    focusMode: focusMode.present ? focusMode.value : this.focusMode,
    focusBlockMinutes: focusBlockMinutes.present
        ? focusBlockMinutes.value
        : this.focusBlockMinutes,
    focusBreakMinutes: focusBreakMinutes.present
        ? focusBreakMinutes.value
        : this.focusBreakMinutes,
    focusSpread: focusSpread.present ? focusSpread.value : this.focusSpread,
    focusGraceMinutes: focusGraceMinutes.present
        ? focusGraceMinutes.value
        : this.focusGraceMinutes,
    focusCycles: focusCycles.present ? focusCycles.value : this.focusCycles,
    focusLongBreakMinutes: focusLongBreakMinutes.present
        ? focusLongBreakMinutes.value
        : this.focusLongBreakMinutes,
    focusLongEvery: focusLongEvery.present
        ? focusLongEvery.value
        : this.focusLongEvery,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Activity copyWithCompanion(ActivitiesCompanion data) {
    return Activity(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      fieldVersions: data.fieldVersions.present
          ? data.fieldVersions.value
          : this.fieldVersions,
      kind: data.kind.present ? data.kind.value : this.kind,
      title: data.title.present ? data.title.value : this.title,
      notes: data.notes.present ? data.notes.value : this.notes,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      rootCategoryKey: data.rootCategoryKey.present
          ? data.rootCategoryKey.value
          : this.rootCategoryKey,
      parentActivityId: data.parentActivityId.present
          ? data.parentActivityId.value
          : this.parentActivityId,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      estimatedMinutes: data.estimatedMinutes.present
          ? data.estimatedMinutes.value
          : this.estimatedMinutes,
      priority: data.priority.present ? data.priority.value : this.priority,
      requiresFocus: data.requiresFocus.present
          ? data.requiresFocus.value
          : this.requiresFocus,
      focusMode: data.focusMode.present ? data.focusMode.value : this.focusMode,
      focusBlockMinutes: data.focusBlockMinutes.present
          ? data.focusBlockMinutes.value
          : this.focusBlockMinutes,
      focusBreakMinutes: data.focusBreakMinutes.present
          ? data.focusBreakMinutes.value
          : this.focusBreakMinutes,
      focusSpread: data.focusSpread.present
          ? data.focusSpread.value
          : this.focusSpread,
      focusGraceMinutes: data.focusGraceMinutes.present
          ? data.focusGraceMinutes.value
          : this.focusGraceMinutes,
      focusCycles: data.focusCycles.present
          ? data.focusCycles.value
          : this.focusCycles,
      focusLongBreakMinutes: data.focusLongBreakMinutes.present
          ? data.focusLongBreakMinutes.value
          : this.focusLongBreakMinutes,
      focusLongEvery: data.focusLongEvery.present
          ? data.focusLongEvery.value
          : this.focusLongEvery,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Activity(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('categoryId: $categoryId, ')
          ..write('rootCategoryKey: $rootCategoryKey, ')
          ..write('parentActivityId: $parentActivityId, ')
          ..write('variantId: $variantId, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('priority: $priority, ')
          ..write('requiresFocus: $requiresFocus, ')
          ..write('focusMode: $focusMode, ')
          ..write('focusBlockMinutes: $focusBlockMinutes, ')
          ..write('focusBreakMinutes: $focusBreakMinutes, ')
          ..write('focusSpread: $focusSpread, ')
          ..write('focusGraceMinutes: $focusGraceMinutes, ')
          ..write('focusCycles: $focusCycles, ')
          ..write('focusLongBreakMinutes: $focusLongBreakMinutes, ')
          ..write('focusLongEvery: $focusLongEvery, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    kind,
    title,
    notes,
    categoryId,
    rootCategoryKey,
    parentActivityId,
    variantId,
    estimatedMinutes,
    priority,
    requiresFocus,
    focusMode,
    focusBlockMinutes,
    focusBreakMinutes,
    focusSpread,
    focusGraceMinutes,
    focusCycles,
    focusLongBreakMinutes,
    focusLongEvery,
    sortOrder,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Activity &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.fieldVersions == this.fieldVersions &&
          other.kind == this.kind &&
          other.title == this.title &&
          other.notes == this.notes &&
          other.categoryId == this.categoryId &&
          other.rootCategoryKey == this.rootCategoryKey &&
          other.parentActivityId == this.parentActivityId &&
          other.variantId == this.variantId &&
          other.estimatedMinutes == this.estimatedMinutes &&
          other.priority == this.priority &&
          other.requiresFocus == this.requiresFocus &&
          other.focusMode == this.focusMode &&
          other.focusBlockMinutes == this.focusBlockMinutes &&
          other.focusBreakMinutes == this.focusBreakMinutes &&
          other.focusSpread == this.focusSpread &&
          other.focusGraceMinutes == this.focusGraceMinutes &&
          other.focusCycles == this.focusCycles &&
          other.focusLongBreakMinutes == this.focusLongBreakMinutes &&
          other.focusLongEvery == this.focusLongEvery &&
          other.sortOrder == this.sortOrder);
}

class ActivitiesCompanion extends UpdateCompanion<Activity> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<Map<String, String>> fieldVersions;
  final Value<String> kind;
  final Value<String> title;
  final Value<String?> notes;
  final Value<String?> categoryId;
  final Value<String?> rootCategoryKey;
  final Value<String?> parentActivityId;
  final Value<String?> variantId;
  final Value<int?> estimatedMinutes;
  final Value<int?> priority;
  final Value<bool?> requiresFocus;
  final Value<String?> focusMode;
  final Value<int?> focusBlockMinutes;
  final Value<int?> focusBreakMinutes;
  final Value<bool?> focusSpread;
  final Value<int?> focusGraceMinutes;
  final Value<int?> focusCycles;
  final Value<int?> focusLongBreakMinutes;
  final Value<int?> focusLongEvery;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const ActivitiesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.kind = const Value.absent(),
    this.title = const Value.absent(),
    this.notes = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rootCategoryKey = const Value.absent(),
    this.parentActivityId = const Value.absent(),
    this.variantId = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.priority = const Value.absent(),
    this.requiresFocus = const Value.absent(),
    this.focusMode = const Value.absent(),
    this.focusBlockMinutes = const Value.absent(),
    this.focusBreakMinutes = const Value.absent(),
    this.focusSpread = const Value.absent(),
    this.focusGraceMinutes = const Value.absent(),
    this.focusCycles = const Value.absent(),
    this.focusLongBreakMinutes = const Value.absent(),
    this.focusLongEvery = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivitiesCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    required String kind,
    required String title,
    this.notes = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rootCategoryKey = const Value.absent(),
    this.parentActivityId = const Value.absent(),
    this.variantId = const Value.absent(),
    this.estimatedMinutes = const Value.absent(),
    this.priority = const Value.absent(),
    this.requiresFocus = const Value.absent(),
    this.focusMode = const Value.absent(),
    this.focusBlockMinutes = const Value.absent(),
    this.focusBreakMinutes = const Value.absent(),
    this.focusSpread = const Value.absent(),
    this.focusGraceMinutes = const Value.absent(),
    this.focusCycles = const Value.absent(),
    this.focusLongBreakMinutes = const Value.absent(),
    this.focusLongEvery = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       kind = Value(kind),
       title = Value(title);
  static Insertable<Activity> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? fieldVersions,
    Expression<String>? kind,
    Expression<String>? title,
    Expression<String>? notes,
    Expression<String>? categoryId,
    Expression<String>? rootCategoryKey,
    Expression<String>? parentActivityId,
    Expression<String>? variantId,
    Expression<int>? estimatedMinutes,
    Expression<int>? priority,
    Expression<bool>? requiresFocus,
    Expression<String>? focusMode,
    Expression<int>? focusBlockMinutes,
    Expression<int>? focusBreakMinutes,
    Expression<bool>? focusSpread,
    Expression<int>? focusGraceMinutes,
    Expression<int>? focusCycles,
    Expression<int>? focusLongBreakMinutes,
    Expression<int>? focusLongEvery,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (fieldVersions != null) 'field_versions': fieldVersions,
      if (kind != null) 'kind': kind,
      if (title != null) 'title': title,
      if (notes != null) 'notes': notes,
      if (categoryId != null) 'category_id': categoryId,
      if (rootCategoryKey != null) 'root_category_key': rootCategoryKey,
      if (parentActivityId != null) 'parent_activity_id': parentActivityId,
      if (variantId != null) 'variant_id': variantId,
      if (estimatedMinutes != null) 'estimated_minutes': estimatedMinutes,
      if (priority != null) 'priority': priority,
      if (requiresFocus != null) 'requires_focus': requiresFocus,
      if (focusMode != null) 'focus_mode': focusMode,
      if (focusBlockMinutes != null) 'focus_block_minutes': focusBlockMinutes,
      if (focusBreakMinutes != null) 'focus_break_minutes': focusBreakMinutes,
      if (focusSpread != null) 'focus_spread': focusSpread,
      if (focusGraceMinutes != null) 'focus_grace_minutes': focusGraceMinutes,
      if (focusCycles != null) 'focus_cycles': focusCycles,
      if (focusLongBreakMinutes != null)
        'focus_long_break_minutes': focusLongBreakMinutes,
      if (focusLongEvery != null) 'focus_long_every': focusLongEvery,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivitiesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<Map<String, String>>? fieldVersions,
    Value<String>? kind,
    Value<String>? title,
    Value<String?>? notes,
    Value<String?>? categoryId,
    Value<String?>? rootCategoryKey,
    Value<String?>? parentActivityId,
    Value<String?>? variantId,
    Value<int?>? estimatedMinutes,
    Value<int?>? priority,
    Value<bool?>? requiresFocus,
    Value<String?>? focusMode,
    Value<int?>? focusBlockMinutes,
    Value<int?>? focusBreakMinutes,
    Value<bool?>? focusSpread,
    Value<int?>? focusGraceMinutes,
    Value<int?>? focusCycles,
    Value<int?>? focusLongBreakMinutes,
    Value<int?>? focusLongEvery,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return ActivitiesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      fieldVersions: fieldVersions ?? this.fieldVersions,
      kind: kind ?? this.kind,
      title: title ?? this.title,
      notes: notes ?? this.notes,
      categoryId: categoryId ?? this.categoryId,
      rootCategoryKey: rootCategoryKey ?? this.rootCategoryKey,
      parentActivityId: parentActivityId ?? this.parentActivityId,
      variantId: variantId ?? this.variantId,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      priority: priority ?? this.priority,
      requiresFocus: requiresFocus ?? this.requiresFocus,
      focusMode: focusMode ?? this.focusMode,
      focusBlockMinutes: focusBlockMinutes ?? this.focusBlockMinutes,
      focusBreakMinutes: focusBreakMinutes ?? this.focusBreakMinutes,
      focusSpread: focusSpread ?? this.focusSpread,
      focusGraceMinutes: focusGraceMinutes ?? this.focusGraceMinutes,
      focusCycles: focusCycles ?? this.focusCycles,
      focusLongBreakMinutes:
          focusLongBreakMinutes ?? this.focusLongBreakMinutes,
      focusLongEvery: focusLongEvery ?? this.focusLongEvery,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (fieldVersions.present) {
      map['field_versions'] = Variable<String>(
        $ActivitiesTable.$converterfieldVersions.toSql(fieldVersions.value),
      );
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (rootCategoryKey.present) {
      map['root_category_key'] = Variable<String>(rootCategoryKey.value);
    }
    if (parentActivityId.present) {
      map['parent_activity_id'] = Variable<String>(parentActivityId.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<String>(variantId.value);
    }
    if (estimatedMinutes.present) {
      map['estimated_minutes'] = Variable<int>(estimatedMinutes.value);
    }
    if (priority.present) {
      map['priority'] = Variable<int>(priority.value);
    }
    if (requiresFocus.present) {
      map['requires_focus'] = Variable<bool>(requiresFocus.value);
    }
    if (focusMode.present) {
      map['focus_mode'] = Variable<String>(focusMode.value);
    }
    if (focusBlockMinutes.present) {
      map['focus_block_minutes'] = Variable<int>(focusBlockMinutes.value);
    }
    if (focusBreakMinutes.present) {
      map['focus_break_minutes'] = Variable<int>(focusBreakMinutes.value);
    }
    if (focusSpread.present) {
      map['focus_spread'] = Variable<bool>(focusSpread.value);
    }
    if (focusGraceMinutes.present) {
      map['focus_grace_minutes'] = Variable<int>(focusGraceMinutes.value);
    }
    if (focusCycles.present) {
      map['focus_cycles'] = Variable<int>(focusCycles.value);
    }
    if (focusLongBreakMinutes.present) {
      map['focus_long_break_minutes'] = Variable<int>(
        focusLongBreakMinutes.value,
      );
    }
    if (focusLongEvery.present) {
      map['focus_long_every'] = Variable<int>(focusLongEvery.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivitiesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('kind: $kind, ')
          ..write('title: $title, ')
          ..write('notes: $notes, ')
          ..write('categoryId: $categoryId, ')
          ..write('rootCategoryKey: $rootCategoryKey, ')
          ..write('parentActivityId: $parentActivityId, ')
          ..write('variantId: $variantId, ')
          ..write('estimatedMinutes: $estimatedMinutes, ')
          ..write('priority: $priority, ')
          ..write('requiresFocus: $requiresFocus, ')
          ..write('focusMode: $focusMode, ')
          ..write('focusBlockMinutes: $focusBlockMinutes, ')
          ..write('focusBreakMinutes: $focusBreakMinutes, ')
          ..write('focusSpread: $focusSpread, ')
          ..write('focusGraceMinutes: $focusGraceMinutes, ')
          ..write('focusCycles: $focusCycles, ')
          ..write('focusLongBreakMinutes: $focusLongBreakMinutes, ')
          ..write('focusLongEvery: $focusLongEvery, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScheduleRulesTable extends ScheduleRules
    with TableInfo<$ScheduleRulesTable, ScheduleRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScheduleRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  fieldVersions =
      GeneratedColumn<String>(
        'field_versions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      ).withConverter<Map<String, String>>(
        $ScheduleRulesTable.$converterfieldVersions,
      );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id)',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Recurrence, String> recurrence =
      GeneratedColumn<String>(
        'recurrence',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<Recurrence>($ScheduleRulesTable.$converterrecurrence);
  @override
  late final GeneratedColumnWithTypeConverter<Timing, String> timing =
      GeneratedColumn<String>(
        'timing',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      ).withConverter<Timing>($ScheduleRulesTable.$convertertiming);
  static const VerificationMeta _durationMinMinutesMeta =
      const VerificationMeta('durationMinMinutes');
  @override
  late final GeneratedColumn<int> durationMinMinutes = GeneratedColumn<int>(
    'duration_min_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationMaxMinutesMeta =
      const VerificationMeta('durationMaxMinutes');
  @override
  late final GeneratedColumn<int> durationMaxMinutes = GeneratedColumn<int>(
    'duration_max_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _flexibilityMeta = const VerificationMeta(
    'flexibility',
  );
  @override
  late final GeneratedColumn<String> flexibility = GeneratedColumn<String>(
    'flexibility',
    aliasedName,
    false,
    check: () => flexibility.isIn(const ['fixed', 'shiftable', 'optional']),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('fixed'),
  );
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  @override
  late final GeneratedColumn<String> validFrom = GeneratedColumn<String>(
    'valid_from',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validUntilMeta = const VerificationMeta(
    'validUntil',
  );
  @override
  late final GeneratedColumn<String> validUntil = GeneratedColumn<String>(
    'valid_until',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String>
  exceptionDates = GeneratedColumn<String>(
    'exception_dates',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  ).withConverter<List<String>>($ScheduleRulesTable.$converterexceptionDates);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    activityId,
    recurrence,
    timing,
    durationMinMinutes,
    durationMaxMinutes,
    flexibility,
    validFrom,
    validUntil,
    exceptionDates,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schedule_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScheduleRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('duration_min_minutes')) {
      context.handle(
        _durationMinMinutesMeta,
        durationMinMinutes.isAcceptableOrUnknown(
          data['duration_min_minutes']!,
          _durationMinMinutesMeta,
        ),
      );
    }
    if (data.containsKey('duration_max_minutes')) {
      context.handle(
        _durationMaxMinutesMeta,
        durationMaxMinutes.isAcceptableOrUnknown(
          data['duration_max_minutes']!,
          _durationMaxMinutesMeta,
        ),
      );
    }
    if (data.containsKey('flexibility')) {
      context.handle(
        _flexibilityMeta,
        flexibility.isAcceptableOrUnknown(
          data['flexibility']!,
          _flexibilityMeta,
        ),
      );
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    }
    if (data.containsKey('valid_until')) {
      context.handle(
        _validUntilMeta,
        validUntil.isAcceptableOrUnknown(data['valid_until']!, _validUntilMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScheduleRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScheduleRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      fieldVersions: $ScheduleRulesTable.$converterfieldVersions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}field_versions'],
        )!,
      ),
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      recurrence: $ScheduleRulesTable.$converterrecurrence.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}recurrence'],
        )!,
      ),
      timing: $ScheduleRulesTable.$convertertiming.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}timing'],
        )!,
      ),
      durationMinMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_min_minutes'],
      ),
      durationMaxMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_max_minutes'],
      ),
      flexibility: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flexibility'],
      )!,
      validFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_from'],
      ),
      validUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_until'],
      ),
      exceptionDates: $ScheduleRulesTable.$converterexceptionDates.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}exception_dates'],
        )!,
      ),
    );
  }

  @override
  $ScheduleRulesTable createAlias(String alias) {
    return $ScheduleRulesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, String>, String, Object?>
  $converterfieldVersions = const FieldVersionsConverter();
  static JsonTypeConverter2<Recurrence, String, Map<String, Object?>>
  $converterrecurrence = const RecurrenceConverter();
  static JsonTypeConverter2<Timing, String, Map<String, Object?>>
  $convertertiming = const TimingConverter();
  static JsonTypeConverter2<List<String>, String, Object?>
  $converterexceptionDates = const StringListConverter();
}

class ScheduleRule extends DataClass implements Insertable<ScheduleRule> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Map<String, String> fieldVersions;
  final String activityId;
  final Recurrence recurrence;
  final Timing timing;
  final int? durationMinMinutes;
  final int? durationMaxMinutes;
  final String flexibility;
  final String? validFrom;
  final String? validUntil;
  final List<String> exceptionDates;
  const ScheduleRule({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.fieldVersions,
    required this.activityId,
    required this.recurrence,
    required this.timing,
    this.durationMinMinutes,
    this.durationMaxMinutes,
    required this.flexibility,
    this.validFrom,
    this.validUntil,
    required this.exceptionDates,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['field_versions'] = Variable<String>(
        $ScheduleRulesTable.$converterfieldVersions.toSql(fieldVersions),
      );
    }
    map['activity_id'] = Variable<String>(activityId);
    {
      map['recurrence'] = Variable<String>(
        $ScheduleRulesTable.$converterrecurrence.toSql(recurrence),
      );
    }
    {
      map['timing'] = Variable<String>(
        $ScheduleRulesTable.$convertertiming.toSql(timing),
      );
    }
    if (!nullToAbsent || durationMinMinutes != null) {
      map['duration_min_minutes'] = Variable<int>(durationMinMinutes);
    }
    if (!nullToAbsent || durationMaxMinutes != null) {
      map['duration_max_minutes'] = Variable<int>(durationMaxMinutes);
    }
    map['flexibility'] = Variable<String>(flexibility);
    if (!nullToAbsent || validFrom != null) {
      map['valid_from'] = Variable<String>(validFrom);
    }
    if (!nullToAbsent || validUntil != null) {
      map['valid_until'] = Variable<String>(validUntil);
    }
    {
      map['exception_dates'] = Variable<String>(
        $ScheduleRulesTable.$converterexceptionDates.toSql(exceptionDates),
      );
    }
    return map;
  }

  ScheduleRulesCompanion toCompanion(bool nullToAbsent) {
    return ScheduleRulesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      fieldVersions: Value(fieldVersions),
      activityId: Value(activityId),
      recurrence: Value(recurrence),
      timing: Value(timing),
      durationMinMinutes: durationMinMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMinMinutes),
      durationMaxMinutes: durationMaxMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(durationMaxMinutes),
      flexibility: Value(flexibility),
      validFrom: validFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(validFrom),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
      exceptionDates: Value(exceptionDates),
    );
  }

  factory ScheduleRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScheduleRule(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      fieldVersions: $ScheduleRulesTable.$converterfieldVersions.fromJson(
        serializer.fromJson<Object?>(json['field_versions']),
      ),
      activityId: serializer.fromJson<String>(json['activity_id']),
      recurrence: $ScheduleRulesTable.$converterrecurrence.fromJson(
        serializer.fromJson<Map<String, Object?>>(json['recurrence']),
      ),
      timing: $ScheduleRulesTable.$convertertiming.fromJson(
        serializer.fromJson<Map<String, Object?>>(json['timing']),
      ),
      durationMinMinutes: serializer.fromJson<int?>(
        json['duration_min_minutes'],
      ),
      durationMaxMinutes: serializer.fromJson<int?>(
        json['duration_max_minutes'],
      ),
      flexibility: serializer.fromJson<String>(json['flexibility']),
      validFrom: serializer.fromJson<String?>(json['valid_from']),
      validUntil: serializer.fromJson<String?>(json['valid_until']),
      exceptionDates: $ScheduleRulesTable.$converterexceptionDates.fromJson(
        serializer.fromJson<Object?>(json['exception_dates']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'field_versions': serializer.toJson<Object?>(
        $ScheduleRulesTable.$converterfieldVersions.toJson(fieldVersions),
      ),
      'activity_id': serializer.toJson<String>(activityId),
      'recurrence': serializer.toJson<Map<String, Object?>>(
        $ScheduleRulesTable.$converterrecurrence.toJson(recurrence),
      ),
      'timing': serializer.toJson<Map<String, Object?>>(
        $ScheduleRulesTable.$convertertiming.toJson(timing),
      ),
      'duration_min_minutes': serializer.toJson<int?>(durationMinMinutes),
      'duration_max_minutes': serializer.toJson<int?>(durationMaxMinutes),
      'flexibility': serializer.toJson<String>(flexibility),
      'valid_from': serializer.toJson<String?>(validFrom),
      'valid_until': serializer.toJson<String?>(validUntil),
      'exception_dates': serializer.toJson<Object?>(
        $ScheduleRulesTable.$converterexceptionDates.toJson(exceptionDates),
      ),
    };
  }

  ScheduleRule copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Map<String, String>? fieldVersions,
    String? activityId,
    Recurrence? recurrence,
    Timing? timing,
    Value<int?> durationMinMinutes = const Value.absent(),
    Value<int?> durationMaxMinutes = const Value.absent(),
    String? flexibility,
    Value<String?> validFrom = const Value.absent(),
    Value<String?> validUntil = const Value.absent(),
    List<String>? exceptionDates,
  }) => ScheduleRule(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    fieldVersions: fieldVersions ?? this.fieldVersions,
    activityId: activityId ?? this.activityId,
    recurrence: recurrence ?? this.recurrence,
    timing: timing ?? this.timing,
    durationMinMinutes: durationMinMinutes.present
        ? durationMinMinutes.value
        : this.durationMinMinutes,
    durationMaxMinutes: durationMaxMinutes.present
        ? durationMaxMinutes.value
        : this.durationMaxMinutes,
    flexibility: flexibility ?? this.flexibility,
    validFrom: validFrom.present ? validFrom.value : this.validFrom,
    validUntil: validUntil.present ? validUntil.value : this.validUntil,
    exceptionDates: exceptionDates ?? this.exceptionDates,
  );
  ScheduleRule copyWithCompanion(ScheduleRulesCompanion data) {
    return ScheduleRule(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      fieldVersions: data.fieldVersions.present
          ? data.fieldVersions.value
          : this.fieldVersions,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      recurrence: data.recurrence.present
          ? data.recurrence.value
          : this.recurrence,
      timing: data.timing.present ? data.timing.value : this.timing,
      durationMinMinutes: data.durationMinMinutes.present
          ? data.durationMinMinutes.value
          : this.durationMinMinutes,
      durationMaxMinutes: data.durationMaxMinutes.present
          ? data.durationMaxMinutes.value
          : this.durationMaxMinutes,
      flexibility: data.flexibility.present
          ? data.flexibility.value
          : this.flexibility,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validUntil: data.validUntil.present
          ? data.validUntil.value
          : this.validUntil,
      exceptionDates: data.exceptionDates.present
          ? data.exceptionDates.value
          : this.exceptionDates,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleRule(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('activityId: $activityId, ')
          ..write('recurrence: $recurrence, ')
          ..write('timing: $timing, ')
          ..write('durationMinMinutes: $durationMinMinutes, ')
          ..write('durationMaxMinutes: $durationMaxMinutes, ')
          ..write('flexibility: $flexibility, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('exceptionDates: $exceptionDates')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    activityId,
    recurrence,
    timing,
    durationMinMinutes,
    durationMaxMinutes,
    flexibility,
    validFrom,
    validUntil,
    exceptionDates,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScheduleRule &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.fieldVersions == this.fieldVersions &&
          other.activityId == this.activityId &&
          other.recurrence == this.recurrence &&
          other.timing == this.timing &&
          other.durationMinMinutes == this.durationMinMinutes &&
          other.durationMaxMinutes == this.durationMaxMinutes &&
          other.flexibility == this.flexibility &&
          other.validFrom == this.validFrom &&
          other.validUntil == this.validUntil &&
          other.exceptionDates == this.exceptionDates);
}

class ScheduleRulesCompanion extends UpdateCompanion<ScheduleRule> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<Map<String, String>> fieldVersions;
  final Value<String> activityId;
  final Value<Recurrence> recurrence;
  final Value<Timing> timing;
  final Value<int?> durationMinMinutes;
  final Value<int?> durationMaxMinutes;
  final Value<String> flexibility;
  final Value<String?> validFrom;
  final Value<String?> validUntil;
  final Value<List<String>> exceptionDates;
  final Value<int> rowid;
  const ScheduleRulesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.activityId = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.timing = const Value.absent(),
    this.durationMinMinutes = const Value.absent(),
    this.durationMaxMinutes = const Value.absent(),
    this.flexibility = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.exceptionDates = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScheduleRulesCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    required String activityId,
    required Recurrence recurrence,
    this.timing = const Value.absent(),
    this.durationMinMinutes = const Value.absent(),
    this.durationMaxMinutes = const Value.absent(),
    this.flexibility = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.exceptionDates = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       activityId = Value(activityId),
       recurrence = Value(recurrence);
  static Insertable<ScheduleRule> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? fieldVersions,
    Expression<String>? activityId,
    Expression<String>? recurrence,
    Expression<String>? timing,
    Expression<int>? durationMinMinutes,
    Expression<int>? durationMaxMinutes,
    Expression<String>? flexibility,
    Expression<String>? validFrom,
    Expression<String>? validUntil,
    Expression<String>? exceptionDates,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (fieldVersions != null) 'field_versions': fieldVersions,
      if (activityId != null) 'activity_id': activityId,
      if (recurrence != null) 'recurrence': recurrence,
      if (timing != null) 'timing': timing,
      if (durationMinMinutes != null)
        'duration_min_minutes': durationMinMinutes,
      if (durationMaxMinutes != null)
        'duration_max_minutes': durationMaxMinutes,
      if (flexibility != null) 'flexibility': flexibility,
      if (validFrom != null) 'valid_from': validFrom,
      if (validUntil != null) 'valid_until': validUntil,
      if (exceptionDates != null) 'exception_dates': exceptionDates,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScheduleRulesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<Map<String, String>>? fieldVersions,
    Value<String>? activityId,
    Value<Recurrence>? recurrence,
    Value<Timing>? timing,
    Value<int?>? durationMinMinutes,
    Value<int?>? durationMaxMinutes,
    Value<String>? flexibility,
    Value<String?>? validFrom,
    Value<String?>? validUntil,
    Value<List<String>>? exceptionDates,
    Value<int>? rowid,
  }) {
    return ScheduleRulesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      fieldVersions: fieldVersions ?? this.fieldVersions,
      activityId: activityId ?? this.activityId,
      recurrence: recurrence ?? this.recurrence,
      timing: timing ?? this.timing,
      durationMinMinutes: durationMinMinutes ?? this.durationMinMinutes,
      durationMaxMinutes: durationMaxMinutes ?? this.durationMaxMinutes,
      flexibility: flexibility ?? this.flexibility,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      exceptionDates: exceptionDates ?? this.exceptionDates,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (fieldVersions.present) {
      map['field_versions'] = Variable<String>(
        $ScheduleRulesTable.$converterfieldVersions.toSql(fieldVersions.value),
      );
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(
        $ScheduleRulesTable.$converterrecurrence.toSql(recurrence.value),
      );
    }
    if (timing.present) {
      map['timing'] = Variable<String>(
        $ScheduleRulesTable.$convertertiming.toSql(timing.value),
      );
    }
    if (durationMinMinutes.present) {
      map['duration_min_minutes'] = Variable<int>(durationMinMinutes.value);
    }
    if (durationMaxMinutes.present) {
      map['duration_max_minutes'] = Variable<int>(durationMaxMinutes.value);
    }
    if (flexibility.present) {
      map['flexibility'] = Variable<String>(flexibility.value);
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<String>(validFrom.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<String>(validUntil.value);
    }
    if (exceptionDates.present) {
      map['exception_dates'] = Variable<String>(
        $ScheduleRulesTable.$converterexceptionDates.toSql(
          exceptionDates.value,
        ),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScheduleRulesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('activityId: $activityId, ')
          ..write('recurrence: $recurrence, ')
          ..write('timing: $timing, ')
          ..write('durationMinMinutes: $durationMinMinutes, ')
          ..write('durationMaxMinutes: $durationMaxMinutes, ')
          ..write('flexibility: $flexibility, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('exceptionDates: $exceptionDates, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  fieldVersions = GeneratedColumn<String>(
    'field_versions',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  ).withConverter<Map<String, String>>($ProjectsTable.$converterfieldVersions);
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id)',
    ),
  );
  static const VerificationMeta _totalMinutesMeta = const VerificationMeta(
    'totalMinutes',
  );
  @override
  late final GeneratedColumn<int> totalMinutes = GeneratedColumn<int>(
    'total_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deadlineAtMeta = const VerificationMeta(
    'deadlineAt',
  );
  @override
  late final GeneratedColumn<DateTime> deadlineAt = GeneratedColumn<DateTime>(
    'deadline_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _splitModeMeta = const VerificationMeta(
    'splitMode',
  );
  @override
  late final GeneratedColumn<String> splitMode = GeneratedColumn<String>(
    'split_mode',
    aliasedName,
    false,
    check: () => splitMode.isIn(const ['auto', 'manual']),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('auto'),
  );
  static const VerificationMeta _minChunkMinutesMeta = const VerificationMeta(
    'minChunkMinutes',
  );
  @override
  late final GeneratedColumn<int> minChunkMinutes = GeneratedColumn<int>(
    'min_chunk_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _maxChunkMinutesMeta = const VerificationMeta(
    'maxChunkMinutes',
  );
  @override
  late final GeneratedColumn<int> maxChunkMinutes = GeneratedColumn<int>(
    'max_chunk_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dailyCapMinutesMeta = const VerificationMeta(
    'dailyCapMinutes',
  );
  @override
  late final GeneratedColumn<int> dailyCapMinutes = GeneratedColumn<int>(
    'daily_cap_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<Object?>?, String>
  preferredWindows = GeneratedColumn<String>(
    'preferred_windows',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  ).withConverter<List<Object?>?>($ProjectsTable.$converterpreferredWindowsn);
  static const VerificationMeta _safetyMarginMinutesMeta =
      const VerificationMeta('safetyMarginMinutes');
  @override
  late final GeneratedColumn<int> safetyMarginMinutes = GeneratedColumn<int>(
    'safety_margin_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    activityId,
    totalMinutes,
    deadlineAt,
    splitMode,
    minChunkMinutes,
    maxChunkMinutes,
    dailyCapMinutes,
    preferredWindows,
    safetyMarginMinutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<Project> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('total_minutes')) {
      context.handle(
        _totalMinutesMeta,
        totalMinutes.isAcceptableOrUnknown(
          data['total_minutes']!,
          _totalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('deadline_at')) {
      context.handle(
        _deadlineAtMeta,
        deadlineAt.isAcceptableOrUnknown(data['deadline_at']!, _deadlineAtMeta),
      );
    }
    if (data.containsKey('split_mode')) {
      context.handle(
        _splitModeMeta,
        splitMode.isAcceptableOrUnknown(data['split_mode']!, _splitModeMeta),
      );
    }
    if (data.containsKey('min_chunk_minutes')) {
      context.handle(
        _minChunkMinutesMeta,
        minChunkMinutes.isAcceptableOrUnknown(
          data['min_chunk_minutes']!,
          _minChunkMinutesMeta,
        ),
      );
    }
    if (data.containsKey('max_chunk_minutes')) {
      context.handle(
        _maxChunkMinutesMeta,
        maxChunkMinutes.isAcceptableOrUnknown(
          data['max_chunk_minutes']!,
          _maxChunkMinutesMeta,
        ),
      );
    }
    if (data.containsKey('daily_cap_minutes')) {
      context.handle(
        _dailyCapMinutesMeta,
        dailyCapMinutes.isAcceptableOrUnknown(
          data['daily_cap_minutes']!,
          _dailyCapMinutesMeta,
        ),
      );
    }
    if (data.containsKey('safety_margin_minutes')) {
      context.handle(
        _safetyMarginMinutesMeta,
        safetyMarginMinutes.isAcceptableOrUnknown(
          data['safety_margin_minutes']!,
          _safetyMarginMinutesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      fieldVersions: $ProjectsTable.$converterfieldVersions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}field_versions'],
        )!,
      ),
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      totalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_minutes'],
      ),
      deadlineAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deadline_at'],
      ),
      splitMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}split_mode'],
      )!,
      minChunkMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_chunk_minutes'],
      ),
      maxChunkMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_chunk_minutes'],
      ),
      dailyCapMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_cap_minutes'],
      ),
      preferredWindows: $ProjectsTable.$converterpreferredWindowsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}preferred_windows'],
        ),
      ),
      safetyMarginMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}safety_margin_minutes'],
      ),
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, String>, String, Object?>
  $converterfieldVersions = const FieldVersionsConverter();
  static JsonTypeConverter2<List<Object?>, String, Object?>
  $converterpreferredWindows = const JsonValueConverter<List<Object?>>();
  static JsonTypeConverter2<List<Object?>?, String?, Object?>
  $converterpreferredWindowsn = JsonTypeConverter2.asNullable(
    $converterpreferredWindows,
  );
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Map<String, String> fieldVersions;
  final String activityId;
  final int? totalMinutes;
  final DateTime? deadlineAt;
  final String splitMode;
  final int? minChunkMinutes;
  final int? maxChunkMinutes;
  final int? dailyCapMinutes;
  final List<Object?>? preferredWindows;
  final int? safetyMarginMinutes;
  const Project({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.fieldVersions,
    required this.activityId,
    this.totalMinutes,
    this.deadlineAt,
    required this.splitMode,
    this.minChunkMinutes,
    this.maxChunkMinutes,
    this.dailyCapMinutes,
    this.preferredWindows,
    this.safetyMarginMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['field_versions'] = Variable<String>(
        $ProjectsTable.$converterfieldVersions.toSql(fieldVersions),
      );
    }
    map['activity_id'] = Variable<String>(activityId);
    if (!nullToAbsent || totalMinutes != null) {
      map['total_minutes'] = Variable<int>(totalMinutes);
    }
    if (!nullToAbsent || deadlineAt != null) {
      map['deadline_at'] = Variable<DateTime>(deadlineAt);
    }
    map['split_mode'] = Variable<String>(splitMode);
    if (!nullToAbsent || minChunkMinutes != null) {
      map['min_chunk_minutes'] = Variable<int>(minChunkMinutes);
    }
    if (!nullToAbsent || maxChunkMinutes != null) {
      map['max_chunk_minutes'] = Variable<int>(maxChunkMinutes);
    }
    if (!nullToAbsent || dailyCapMinutes != null) {
      map['daily_cap_minutes'] = Variable<int>(dailyCapMinutes);
    }
    if (!nullToAbsent || preferredWindows != null) {
      map['preferred_windows'] = Variable<String>(
        $ProjectsTable.$converterpreferredWindowsn.toSql(preferredWindows),
      );
    }
    if (!nullToAbsent || safetyMarginMinutes != null) {
      map['safety_margin_minutes'] = Variable<int>(safetyMarginMinutes);
    }
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      fieldVersions: Value(fieldVersions),
      activityId: Value(activityId),
      totalMinutes: totalMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(totalMinutes),
      deadlineAt: deadlineAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deadlineAt),
      splitMode: Value(splitMode),
      minChunkMinutes: minChunkMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(minChunkMinutes),
      maxChunkMinutes: maxChunkMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(maxChunkMinutes),
      dailyCapMinutes: dailyCapMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(dailyCapMinutes),
      preferredWindows: preferredWindows == null && nullToAbsent
          ? const Value.absent()
          : Value(preferredWindows),
      safetyMarginMinutes: safetyMarginMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(safetyMarginMinutes),
    );
  }

  factory Project.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      fieldVersions: $ProjectsTable.$converterfieldVersions.fromJson(
        serializer.fromJson<Object?>(json['field_versions']),
      ),
      activityId: serializer.fromJson<String>(json['activity_id']),
      totalMinutes: serializer.fromJson<int?>(json['total_minutes']),
      deadlineAt: serializer.fromJson<DateTime?>(json['deadline_at']),
      splitMode: serializer.fromJson<String>(json['split_mode']),
      minChunkMinutes: serializer.fromJson<int?>(json['min_chunk_minutes']),
      maxChunkMinutes: serializer.fromJson<int?>(json['max_chunk_minutes']),
      dailyCapMinutes: serializer.fromJson<int?>(json['daily_cap_minutes']),
      preferredWindows: $ProjectsTable.$converterpreferredWindowsn.fromJson(
        serializer.fromJson<Object?>(json['preferred_windows']),
      ),
      safetyMarginMinutes: serializer.fromJson<int?>(
        json['safety_margin_minutes'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'field_versions': serializer.toJson<Object?>(
        $ProjectsTable.$converterfieldVersions.toJson(fieldVersions),
      ),
      'activity_id': serializer.toJson<String>(activityId),
      'total_minutes': serializer.toJson<int?>(totalMinutes),
      'deadline_at': serializer.toJson<DateTime?>(deadlineAt),
      'split_mode': serializer.toJson<String>(splitMode),
      'min_chunk_minutes': serializer.toJson<int?>(minChunkMinutes),
      'max_chunk_minutes': serializer.toJson<int?>(maxChunkMinutes),
      'daily_cap_minutes': serializer.toJson<int?>(dailyCapMinutes),
      'preferred_windows': serializer.toJson<Object?>(
        $ProjectsTable.$converterpreferredWindowsn.toJson(preferredWindows),
      ),
      'safety_margin_minutes': serializer.toJson<int?>(safetyMarginMinutes),
    };
  }

  Project copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Map<String, String>? fieldVersions,
    String? activityId,
    Value<int?> totalMinutes = const Value.absent(),
    Value<DateTime?> deadlineAt = const Value.absent(),
    String? splitMode,
    Value<int?> minChunkMinutes = const Value.absent(),
    Value<int?> maxChunkMinutes = const Value.absent(),
    Value<int?> dailyCapMinutes = const Value.absent(),
    Value<List<Object?>?> preferredWindows = const Value.absent(),
    Value<int?> safetyMarginMinutes = const Value.absent(),
  }) => Project(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    fieldVersions: fieldVersions ?? this.fieldVersions,
    activityId: activityId ?? this.activityId,
    totalMinutes: totalMinutes.present ? totalMinutes.value : this.totalMinutes,
    deadlineAt: deadlineAt.present ? deadlineAt.value : this.deadlineAt,
    splitMode: splitMode ?? this.splitMode,
    minChunkMinutes: minChunkMinutes.present
        ? minChunkMinutes.value
        : this.minChunkMinutes,
    maxChunkMinutes: maxChunkMinutes.present
        ? maxChunkMinutes.value
        : this.maxChunkMinutes,
    dailyCapMinutes: dailyCapMinutes.present
        ? dailyCapMinutes.value
        : this.dailyCapMinutes,
    preferredWindows: preferredWindows.present
        ? preferredWindows.value
        : this.preferredWindows,
    safetyMarginMinutes: safetyMarginMinutes.present
        ? safetyMarginMinutes.value
        : this.safetyMarginMinutes,
  );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      fieldVersions: data.fieldVersions.present
          ? data.fieldVersions.value
          : this.fieldVersions,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      totalMinutes: data.totalMinutes.present
          ? data.totalMinutes.value
          : this.totalMinutes,
      deadlineAt: data.deadlineAt.present
          ? data.deadlineAt.value
          : this.deadlineAt,
      splitMode: data.splitMode.present ? data.splitMode.value : this.splitMode,
      minChunkMinutes: data.minChunkMinutes.present
          ? data.minChunkMinutes.value
          : this.minChunkMinutes,
      maxChunkMinutes: data.maxChunkMinutes.present
          ? data.maxChunkMinutes.value
          : this.maxChunkMinutes,
      dailyCapMinutes: data.dailyCapMinutes.present
          ? data.dailyCapMinutes.value
          : this.dailyCapMinutes,
      preferredWindows: data.preferredWindows.present
          ? data.preferredWindows.value
          : this.preferredWindows,
      safetyMarginMinutes: data.safetyMarginMinutes.present
          ? data.safetyMarginMinutes.value
          : this.safetyMarginMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('activityId: $activityId, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('deadlineAt: $deadlineAt, ')
          ..write('splitMode: $splitMode, ')
          ..write('minChunkMinutes: $minChunkMinutes, ')
          ..write('maxChunkMinutes: $maxChunkMinutes, ')
          ..write('dailyCapMinutes: $dailyCapMinutes, ')
          ..write('preferredWindows: $preferredWindows, ')
          ..write('safetyMarginMinutes: $safetyMarginMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    activityId,
    totalMinutes,
    deadlineAt,
    splitMode,
    minChunkMinutes,
    maxChunkMinutes,
    dailyCapMinutes,
    preferredWindows,
    safetyMarginMinutes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.fieldVersions == this.fieldVersions &&
          other.activityId == this.activityId &&
          other.totalMinutes == this.totalMinutes &&
          other.deadlineAt == this.deadlineAt &&
          other.splitMode == this.splitMode &&
          other.minChunkMinutes == this.minChunkMinutes &&
          other.maxChunkMinutes == this.maxChunkMinutes &&
          other.dailyCapMinutes == this.dailyCapMinutes &&
          other.preferredWindows == this.preferredWindows &&
          other.safetyMarginMinutes == this.safetyMarginMinutes);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<Map<String, String>> fieldVersions;
  final Value<String> activityId;
  final Value<int?> totalMinutes;
  final Value<DateTime?> deadlineAt;
  final Value<String> splitMode;
  final Value<int?> minChunkMinutes;
  final Value<int?> maxChunkMinutes;
  final Value<int?> dailyCapMinutes;
  final Value<List<Object?>?> preferredWindows;
  final Value<int?> safetyMarginMinutes;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.activityId = const Value.absent(),
    this.totalMinutes = const Value.absent(),
    this.deadlineAt = const Value.absent(),
    this.splitMode = const Value.absent(),
    this.minChunkMinutes = const Value.absent(),
    this.maxChunkMinutes = const Value.absent(),
    this.dailyCapMinutes = const Value.absent(),
    this.preferredWindows = const Value.absent(),
    this.safetyMarginMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    required String activityId,
    this.totalMinutes = const Value.absent(),
    this.deadlineAt = const Value.absent(),
    this.splitMode = const Value.absent(),
    this.minChunkMinutes = const Value.absent(),
    this.maxChunkMinutes = const Value.absent(),
    this.dailyCapMinutes = const Value.absent(),
    this.preferredWindows = const Value.absent(),
    this.safetyMarginMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       activityId = Value(activityId);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? fieldVersions,
    Expression<String>? activityId,
    Expression<int>? totalMinutes,
    Expression<DateTime>? deadlineAt,
    Expression<String>? splitMode,
    Expression<int>? minChunkMinutes,
    Expression<int>? maxChunkMinutes,
    Expression<int>? dailyCapMinutes,
    Expression<String>? preferredWindows,
    Expression<int>? safetyMarginMinutes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (fieldVersions != null) 'field_versions': fieldVersions,
      if (activityId != null) 'activity_id': activityId,
      if (totalMinutes != null) 'total_minutes': totalMinutes,
      if (deadlineAt != null) 'deadline_at': deadlineAt,
      if (splitMode != null) 'split_mode': splitMode,
      if (minChunkMinutes != null) 'min_chunk_minutes': minChunkMinutes,
      if (maxChunkMinutes != null) 'max_chunk_minutes': maxChunkMinutes,
      if (dailyCapMinutes != null) 'daily_cap_minutes': dailyCapMinutes,
      if (preferredWindows != null) 'preferred_windows': preferredWindows,
      if (safetyMarginMinutes != null)
        'safety_margin_minutes': safetyMarginMinutes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<Map<String, String>>? fieldVersions,
    Value<String>? activityId,
    Value<int?>? totalMinutes,
    Value<DateTime?>? deadlineAt,
    Value<String>? splitMode,
    Value<int?>? minChunkMinutes,
    Value<int?>? maxChunkMinutes,
    Value<int?>? dailyCapMinutes,
    Value<List<Object?>?>? preferredWindows,
    Value<int?>? safetyMarginMinutes,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      fieldVersions: fieldVersions ?? this.fieldVersions,
      activityId: activityId ?? this.activityId,
      totalMinutes: totalMinutes ?? this.totalMinutes,
      deadlineAt: deadlineAt ?? this.deadlineAt,
      splitMode: splitMode ?? this.splitMode,
      minChunkMinutes: minChunkMinutes ?? this.minChunkMinutes,
      maxChunkMinutes: maxChunkMinutes ?? this.maxChunkMinutes,
      dailyCapMinutes: dailyCapMinutes ?? this.dailyCapMinutes,
      preferredWindows: preferredWindows ?? this.preferredWindows,
      safetyMarginMinutes: safetyMarginMinutes ?? this.safetyMarginMinutes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (fieldVersions.present) {
      map['field_versions'] = Variable<String>(
        $ProjectsTable.$converterfieldVersions.toSql(fieldVersions.value),
      );
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (totalMinutes.present) {
      map['total_minutes'] = Variable<int>(totalMinutes.value);
    }
    if (deadlineAt.present) {
      map['deadline_at'] = Variable<DateTime>(deadlineAt.value);
    }
    if (splitMode.present) {
      map['split_mode'] = Variable<String>(splitMode.value);
    }
    if (minChunkMinutes.present) {
      map['min_chunk_minutes'] = Variable<int>(minChunkMinutes.value);
    }
    if (maxChunkMinutes.present) {
      map['max_chunk_minutes'] = Variable<int>(maxChunkMinutes.value);
    }
    if (dailyCapMinutes.present) {
      map['daily_cap_minutes'] = Variable<int>(dailyCapMinutes.value);
    }
    if (preferredWindows.present) {
      map['preferred_windows'] = Variable<String>(
        $ProjectsTable.$converterpreferredWindowsn.toSql(
          preferredWindows.value,
        ),
      );
    }
    if (safetyMarginMinutes.present) {
      map['safety_margin_minutes'] = Variable<int>(safetyMarginMinutes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('activityId: $activityId, ')
          ..write('totalMinutes: $totalMinutes, ')
          ..write('deadlineAt: $deadlineAt, ')
          ..write('splitMode: $splitMode, ')
          ..write('minChunkMinutes: $minChunkMinutes, ')
          ..write('maxChunkMinutes: $maxChunkMinutes, ')
          ..write('dailyCapMinutes: $dailyCapMinutes, ')
          ..write('preferredWindows: $preferredWindows, ')
          ..write('safetyMarginMinutes: $safetyMarginMinutes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DayOverridesTable extends DayOverrides
    with TableInfo<$DayOverridesTable, DayOverride> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  fieldVersions =
      GeneratedColumn<String>(
        'field_versions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      ).withConverter<Map<String, String>>(
        $DayOverridesTable.$converterfieldVersions,
      );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Recurrence?, String> recurrence =
      GeneratedColumn<String>(
        'recurrence',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Recurrence?>($DayOverridesTable.$converterrecurrencen);
  static const VerificationMeta _validFromMeta = const VerificationMeta(
    'validFrom',
  );
  @override
  late final GeneratedColumn<String> validFrom = GeneratedColumn<String>(
    'valid_from',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _validUntilMeta = const VerificationMeta(
    'validUntil',
  );
  @override
  late final GeneratedColumn<String> validUntil = GeneratedColumn<String>(
    'valid_until',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _keepMeta = const VerificationMeta('keep');
  @override
  late final GeneratedColumn<String> keep = GeneratedColumn<String>(
    'keep',
    aliasedName,
    false,
    check: () => keep.isIn(const ['all', 'fixed_only', 'none']),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('all'),
  );
  static const VerificationMeta _autoPlacementMeta = const VerificationMeta(
    'autoPlacement',
  );
  @override
  late final GeneratedColumn<bool> autoPlacement = GeneratedColumn<bool>(
    'auto_placement',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_placement" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    date,
    recurrence,
    validFrom,
    validUntil,
    keep,
    autoPlacement,
    label,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayOverride> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    }
    if (data.containsKey('valid_from')) {
      context.handle(
        _validFromMeta,
        validFrom.isAcceptableOrUnknown(data['valid_from']!, _validFromMeta),
      );
    }
    if (data.containsKey('valid_until')) {
      context.handle(
        _validUntilMeta,
        validUntil.isAcceptableOrUnknown(data['valid_until']!, _validUntilMeta),
      );
    }
    if (data.containsKey('keep')) {
      context.handle(
        _keepMeta,
        keep.isAcceptableOrUnknown(data['keep']!, _keepMeta),
      );
    }
    if (data.containsKey('auto_placement')) {
      context.handle(
        _autoPlacementMeta,
        autoPlacement.isAcceptableOrUnknown(
          data['auto_placement']!,
          _autoPlacementMeta,
        ),
      );
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DayOverride map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayOverride(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      fieldVersions: $DayOverridesTable.$converterfieldVersions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}field_versions'],
        )!,
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      ),
      recurrence: $DayOverridesTable.$converterrecurrencen.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}recurrence'],
        ),
      ),
      validFrom: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_from'],
      ),
      validUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}valid_until'],
      ),
      keep: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}keep'],
      )!,
      autoPlacement: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_placement'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      ),
    );
  }

  @override
  $DayOverridesTable createAlias(String alias) {
    return $DayOverridesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, String>, String, Object?>
  $converterfieldVersions = const FieldVersionsConverter();
  static JsonTypeConverter2<Recurrence, String, Map<String, Object?>>
  $converterrecurrence = const RecurrenceConverter();
  static JsonTypeConverter2<Recurrence?, String?, Map<String, Object?>?>
  $converterrecurrencen = JsonTypeConverter2.asNullable($converterrecurrence);
}

class DayOverride extends DataClass implements Insertable<DayOverride> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Map<String, String> fieldVersions;
  final String? date;
  final Recurrence? recurrence;
  final String? validFrom;
  final String? validUntil;
  final String keep;
  final bool autoPlacement;
  final String? label;
  const DayOverride({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.fieldVersions,
    this.date,
    this.recurrence,
    this.validFrom,
    this.validUntil,
    required this.keep,
    required this.autoPlacement,
    this.label,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['field_versions'] = Variable<String>(
        $DayOverridesTable.$converterfieldVersions.toSql(fieldVersions),
      );
    }
    if (!nullToAbsent || date != null) {
      map['date'] = Variable<String>(date);
    }
    if (!nullToAbsent || recurrence != null) {
      map['recurrence'] = Variable<String>(
        $DayOverridesTable.$converterrecurrencen.toSql(recurrence),
      );
    }
    if (!nullToAbsent || validFrom != null) {
      map['valid_from'] = Variable<String>(validFrom);
    }
    if (!nullToAbsent || validUntil != null) {
      map['valid_until'] = Variable<String>(validUntil);
    }
    map['keep'] = Variable<String>(keep);
    map['auto_placement'] = Variable<bool>(autoPlacement);
    if (!nullToAbsent || label != null) {
      map['label'] = Variable<String>(label);
    }
    return map;
  }

  DayOverridesCompanion toCompanion(bool nullToAbsent) {
    return DayOverridesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      fieldVersions: Value(fieldVersions),
      date: date == null && nullToAbsent ? const Value.absent() : Value(date),
      recurrence: recurrence == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrence),
      validFrom: validFrom == null && nullToAbsent
          ? const Value.absent()
          : Value(validFrom),
      validUntil: validUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(validUntil),
      keep: Value(keep),
      autoPlacement: Value(autoPlacement),
      label: label == null && nullToAbsent
          ? const Value.absent()
          : Value(label),
    );
  }

  factory DayOverride.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayOverride(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      fieldVersions: $DayOverridesTable.$converterfieldVersions.fromJson(
        serializer.fromJson<Object?>(json['field_versions']),
      ),
      date: serializer.fromJson<String?>(json['date']),
      recurrence: $DayOverridesTable.$converterrecurrencen.fromJson(
        serializer.fromJson<Map<String, Object?>?>(json['recurrence']),
      ),
      validFrom: serializer.fromJson<String?>(json['valid_from']),
      validUntil: serializer.fromJson<String?>(json['valid_until']),
      keep: serializer.fromJson<String>(json['keep']),
      autoPlacement: serializer.fromJson<bool>(json['auto_placement']),
      label: serializer.fromJson<String?>(json['label']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'field_versions': serializer.toJson<Object?>(
        $DayOverridesTable.$converterfieldVersions.toJson(fieldVersions),
      ),
      'date': serializer.toJson<String?>(date),
      'recurrence': serializer.toJson<Map<String, Object?>?>(
        $DayOverridesTable.$converterrecurrencen.toJson(recurrence),
      ),
      'valid_from': serializer.toJson<String?>(validFrom),
      'valid_until': serializer.toJson<String?>(validUntil),
      'keep': serializer.toJson<String>(keep),
      'auto_placement': serializer.toJson<bool>(autoPlacement),
      'label': serializer.toJson<String?>(label),
    };
  }

  DayOverride copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Map<String, String>? fieldVersions,
    Value<String?> date = const Value.absent(),
    Value<Recurrence?> recurrence = const Value.absent(),
    Value<String?> validFrom = const Value.absent(),
    Value<String?> validUntil = const Value.absent(),
    String? keep,
    bool? autoPlacement,
    Value<String?> label = const Value.absent(),
  }) => DayOverride(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    fieldVersions: fieldVersions ?? this.fieldVersions,
    date: date.present ? date.value : this.date,
    recurrence: recurrence.present ? recurrence.value : this.recurrence,
    validFrom: validFrom.present ? validFrom.value : this.validFrom,
    validUntil: validUntil.present ? validUntil.value : this.validUntil,
    keep: keep ?? this.keep,
    autoPlacement: autoPlacement ?? this.autoPlacement,
    label: label.present ? label.value : this.label,
  );
  DayOverride copyWithCompanion(DayOverridesCompanion data) {
    return DayOverride(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      fieldVersions: data.fieldVersions.present
          ? data.fieldVersions.value
          : this.fieldVersions,
      date: data.date.present ? data.date.value : this.date,
      recurrence: data.recurrence.present
          ? data.recurrence.value
          : this.recurrence,
      validFrom: data.validFrom.present ? data.validFrom.value : this.validFrom,
      validUntil: data.validUntil.present
          ? data.validUntil.value
          : this.validUntil,
      keep: data.keep.present ? data.keep.value : this.keep,
      autoPlacement: data.autoPlacement.present
          ? data.autoPlacement.value
          : this.autoPlacement,
      label: data.label.present ? data.label.value : this.label,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayOverride(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('date: $date, ')
          ..write('recurrence: $recurrence, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('keep: $keep, ')
          ..write('autoPlacement: $autoPlacement, ')
          ..write('label: $label')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    date,
    recurrence,
    validFrom,
    validUntil,
    keep,
    autoPlacement,
    label,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayOverride &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.fieldVersions == this.fieldVersions &&
          other.date == this.date &&
          other.recurrence == this.recurrence &&
          other.validFrom == this.validFrom &&
          other.validUntil == this.validUntil &&
          other.keep == this.keep &&
          other.autoPlacement == this.autoPlacement &&
          other.label == this.label);
}

class DayOverridesCompanion extends UpdateCompanion<DayOverride> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<Map<String, String>> fieldVersions;
  final Value<String?> date;
  final Value<Recurrence?> recurrence;
  final Value<String?> validFrom;
  final Value<String?> validUntil;
  final Value<String> keep;
  final Value<bool> autoPlacement;
  final Value<String?> label;
  final Value<int> rowid;
  const DayOverridesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.date = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.keep = const Value.absent(),
    this.autoPlacement = const Value.absent(),
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DayOverridesCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.date = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.validFrom = const Value.absent(),
    this.validUntil = const Value.absent(),
    this.keep = const Value.absent(),
    this.autoPlacement = const Value.absent(),
    this.label = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id);
  static Insertable<DayOverride> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? fieldVersions,
    Expression<String>? date,
    Expression<String>? recurrence,
    Expression<String>? validFrom,
    Expression<String>? validUntil,
    Expression<String>? keep,
    Expression<bool>? autoPlacement,
    Expression<String>? label,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (fieldVersions != null) 'field_versions': fieldVersions,
      if (date != null) 'date': date,
      if (recurrence != null) 'recurrence': recurrence,
      if (validFrom != null) 'valid_from': validFrom,
      if (validUntil != null) 'valid_until': validUntil,
      if (keep != null) 'keep': keep,
      if (autoPlacement != null) 'auto_placement': autoPlacement,
      if (label != null) 'label': label,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DayOverridesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<Map<String, String>>? fieldVersions,
    Value<String?>? date,
    Value<Recurrence?>? recurrence,
    Value<String?>? validFrom,
    Value<String?>? validUntil,
    Value<String>? keep,
    Value<bool>? autoPlacement,
    Value<String?>? label,
    Value<int>? rowid,
  }) {
    return DayOverridesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      fieldVersions: fieldVersions ?? this.fieldVersions,
      date: date ?? this.date,
      recurrence: recurrence ?? this.recurrence,
      validFrom: validFrom ?? this.validFrom,
      validUntil: validUntil ?? this.validUntil,
      keep: keep ?? this.keep,
      autoPlacement: autoPlacement ?? this.autoPlacement,
      label: label ?? this.label,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (fieldVersions.present) {
      map['field_versions'] = Variable<String>(
        $DayOverridesTable.$converterfieldVersions.toSql(fieldVersions.value),
      );
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<String>(
        $DayOverridesTable.$converterrecurrencen.toSql(recurrence.value),
      );
    }
    if (validFrom.present) {
      map['valid_from'] = Variable<String>(validFrom.value);
    }
    if (validUntil.present) {
      map['valid_until'] = Variable<String>(validUntil.value);
    }
    if (keep.present) {
      map['keep'] = Variable<String>(keep.value);
    }
    if (autoPlacement.present) {
      map['auto_placement'] = Variable<bool>(autoPlacement.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayOverridesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('date: $date, ')
          ..write('recurrence: $recurrence, ')
          ..write('validFrom: $validFrom, ')
          ..write('validUntil: $validUntil, ')
          ..write('keep: $keep, ')
          ..write('autoPlacement: $autoPlacement, ')
          ..write('label: $label, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PlanInstancesTable extends PlanInstances
    with TableInfo<$PlanInstancesTable, PlanInstance> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PlanInstancesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  fieldVersions =
      GeneratedColumn<String>(
        'field_versions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      ).withConverter<Map<String, String>>(
        $PlanInstancesTable.$converterfieldVersions,
      );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id)',
    ),
  );
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  @override
  late final GeneratedColumn<String> ruleId = GeneratedColumn<String>(
    'rule_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES schedule_rules (id)',
    ),
  );
  static const VerificationMeta _occurrenceDateMeta = const VerificationMeta(
    'occurrenceDate',
  );
  @override
  late final GeneratedColumn<String> occurrenceDate = GeneratedColumn<String>(
    'occurrence_date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startAtMeta = const VerificationMeta(
    'startAt',
  );
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
    'start_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endAtMeta = const VerificationMeta('endAt');
  @override
  late final GeneratedColumn<DateTime> endAt = GeneratedColumn<DateTime>(
    'end_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    check: () =>
        status.isIn(const ['planned', 'done', 'skipped', 'moved', 'failed']),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('planned'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    check: () => source.isIn(const ['rule', 'auto', 'manual']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _variantIdMeta = const VerificationMeta(
    'variantId',
  );
  @override
  late final GeneratedColumn<String> variantId = GeneratedColumn<String>(
    'variant_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES variants (id)',
    ),
  );
  static const VerificationMeta _parentInstanceIdMeta = const VerificationMeta(
    'parentInstanceId',
  );
  @override
  late final GeneratedColumn<String> parentInstanceId = GeneratedColumn<String>(
    'parent_instance_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plan_instances (id)',
    ),
  );
  static const VerificationMeta _movedFromIdMeta = const VerificationMeta(
    'movedFromId',
  );
  @override
  late final GeneratedColumn<String> movedFromId = GeneratedColumn<String>(
    'moved_from_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plan_instances (id)',
    ),
  );
  static const VerificationMeta _isManualMeta = const VerificationMeta(
    'isManual',
  );
  @override
  late final GeneratedColumn<bool> isManual = GeneratedColumn<bool>(
    'is_manual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_manual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _engineVersionMeta = const VerificationMeta(
    'engineVersion',
  );
  @override
  late final GeneratedColumn<int> engineVersion = GeneratedColumn<int>(
    'engine_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _plannedMinutesMeta = const VerificationMeta(
    'plannedMinutes',
  );
  @override
  late final GeneratedColumn<int> plannedMinutes = GeneratedColumn<int>(
    'planned_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    activityId,
    ruleId,
    occurrenceDate,
    startAt,
    endAt,
    status,
    source,
    variantId,
    parentInstanceId,
    movedFromId,
    isManual,
    engineVersion,
    plannedMinutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'plan_instances';
  @override
  VerificationContext validateIntegrity(
    Insertable<PlanInstance> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_activityIdMeta);
    }
    if (data.containsKey('rule_id')) {
      context.handle(
        _ruleIdMeta,
        ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta),
      );
    }
    if (data.containsKey('occurrence_date')) {
      context.handle(
        _occurrenceDateMeta,
        occurrenceDate.isAcceptableOrUnknown(
          data['occurrence_date']!,
          _occurrenceDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_occurrenceDateMeta);
    }
    if (data.containsKey('start_at')) {
      context.handle(
        _startAtMeta,
        startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta),
      );
    }
    if (data.containsKey('end_at')) {
      context.handle(
        _endAtMeta,
        endAt.isAcceptableOrUnknown(data['end_at']!, _endAtMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(
        _variantIdMeta,
        variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta),
      );
    }
    if (data.containsKey('parent_instance_id')) {
      context.handle(
        _parentInstanceIdMeta,
        parentInstanceId.isAcceptableOrUnknown(
          data['parent_instance_id']!,
          _parentInstanceIdMeta,
        ),
      );
    }
    if (data.containsKey('moved_from_id')) {
      context.handle(
        _movedFromIdMeta,
        movedFromId.isAcceptableOrUnknown(
          data['moved_from_id']!,
          _movedFromIdMeta,
        ),
      );
    }
    if (data.containsKey('is_manual')) {
      context.handle(
        _isManualMeta,
        isManual.isAcceptableOrUnknown(data['is_manual']!, _isManualMeta),
      );
    }
    if (data.containsKey('engine_version')) {
      context.handle(
        _engineVersionMeta,
        engineVersion.isAcceptableOrUnknown(
          data['engine_version']!,
          _engineVersionMeta,
        ),
      );
    }
    if (data.containsKey('planned_minutes')) {
      context.handle(
        _plannedMinutesMeta,
        plannedMinutes.isAcceptableOrUnknown(
          data['planned_minutes']!,
          _plannedMinutesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PlanInstance map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PlanInstance(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      fieldVersions: $PlanInstancesTable.$converterfieldVersions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}field_versions'],
        )!,
      ),
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      )!,
      ruleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_id'],
      ),
      occurrenceDate: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occurrence_date'],
      )!,
      startAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_at'],
      ),
      endAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_at'],
      ),
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      variantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant_id'],
      ),
      parentInstanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_instance_id'],
      ),
      movedFromId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}moved_from_id'],
      ),
      isManual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_manual'],
      )!,
      engineVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}engine_version'],
      ),
      plannedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_minutes'],
      ),
    );
  }

  @override
  $PlanInstancesTable createAlias(String alias) {
    return $PlanInstancesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, String>, String, Object?>
  $converterfieldVersions = const FieldVersionsConverter();
}

class PlanInstance extends DataClass implements Insertable<PlanInstance> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Map<String, String> fieldVersions;
  final String activityId;
  final String? ruleId;
  final String occurrenceDate;
  final DateTime? startAt;
  final DateTime? endAt;
  final String status;
  final String source;
  final String? variantId;
  final String? parentInstanceId;
  final String? movedFromId;
  final bool isManual;
  final int? engineVersion;

  /// Molada bitirilen işin kalan saf odağı (D69); `parent_instance_id` asıl işi gösterir.
  final int? plannedMinutes;
  const PlanInstance({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.fieldVersions,
    required this.activityId,
    this.ruleId,
    required this.occurrenceDate,
    this.startAt,
    this.endAt,
    required this.status,
    required this.source,
    this.variantId,
    this.parentInstanceId,
    this.movedFromId,
    required this.isManual,
    this.engineVersion,
    this.plannedMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['field_versions'] = Variable<String>(
        $PlanInstancesTable.$converterfieldVersions.toSql(fieldVersions),
      );
    }
    map['activity_id'] = Variable<String>(activityId);
    if (!nullToAbsent || ruleId != null) {
      map['rule_id'] = Variable<String>(ruleId);
    }
    map['occurrence_date'] = Variable<String>(occurrenceDate);
    if (!nullToAbsent || startAt != null) {
      map['start_at'] = Variable<DateTime>(startAt);
    }
    if (!nullToAbsent || endAt != null) {
      map['end_at'] = Variable<DateTime>(endAt);
    }
    map['status'] = Variable<String>(status);
    map['source'] = Variable<String>(source);
    if (!nullToAbsent || variantId != null) {
      map['variant_id'] = Variable<String>(variantId);
    }
    if (!nullToAbsent || parentInstanceId != null) {
      map['parent_instance_id'] = Variable<String>(parentInstanceId);
    }
    if (!nullToAbsent || movedFromId != null) {
      map['moved_from_id'] = Variable<String>(movedFromId);
    }
    map['is_manual'] = Variable<bool>(isManual);
    if (!nullToAbsent || engineVersion != null) {
      map['engine_version'] = Variable<int>(engineVersion);
    }
    if (!nullToAbsent || plannedMinutes != null) {
      map['planned_minutes'] = Variable<int>(plannedMinutes);
    }
    return map;
  }

  PlanInstancesCompanion toCompanion(bool nullToAbsent) {
    return PlanInstancesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      fieldVersions: Value(fieldVersions),
      activityId: Value(activityId),
      ruleId: ruleId == null && nullToAbsent
          ? const Value.absent()
          : Value(ruleId),
      occurrenceDate: Value(occurrenceDate),
      startAt: startAt == null && nullToAbsent
          ? const Value.absent()
          : Value(startAt),
      endAt: endAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endAt),
      status: Value(status),
      source: Value(source),
      variantId: variantId == null && nullToAbsent
          ? const Value.absent()
          : Value(variantId),
      parentInstanceId: parentInstanceId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentInstanceId),
      movedFromId: movedFromId == null && nullToAbsent
          ? const Value.absent()
          : Value(movedFromId),
      isManual: Value(isManual),
      engineVersion: engineVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(engineVersion),
      plannedMinutes: plannedMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedMinutes),
    );
  }

  factory PlanInstance.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PlanInstance(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      fieldVersions: $PlanInstancesTable.$converterfieldVersions.fromJson(
        serializer.fromJson<Object?>(json['field_versions']),
      ),
      activityId: serializer.fromJson<String>(json['activity_id']),
      ruleId: serializer.fromJson<String?>(json['rule_id']),
      occurrenceDate: serializer.fromJson<String>(json['occurrence_date']),
      startAt: serializer.fromJson<DateTime?>(json['start_at']),
      endAt: serializer.fromJson<DateTime?>(json['end_at']),
      status: serializer.fromJson<String>(json['status']),
      source: serializer.fromJson<String>(json['source']),
      variantId: serializer.fromJson<String?>(json['variant_id']),
      parentInstanceId: serializer.fromJson<String?>(
        json['parent_instance_id'],
      ),
      movedFromId: serializer.fromJson<String?>(json['moved_from_id']),
      isManual: serializer.fromJson<bool>(json['is_manual']),
      engineVersion: serializer.fromJson<int?>(json['engine_version']),
      plannedMinutes: serializer.fromJson<int?>(json['planned_minutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'field_versions': serializer.toJson<Object?>(
        $PlanInstancesTable.$converterfieldVersions.toJson(fieldVersions),
      ),
      'activity_id': serializer.toJson<String>(activityId),
      'rule_id': serializer.toJson<String?>(ruleId),
      'occurrence_date': serializer.toJson<String>(occurrenceDate),
      'start_at': serializer.toJson<DateTime?>(startAt),
      'end_at': serializer.toJson<DateTime?>(endAt),
      'status': serializer.toJson<String>(status),
      'source': serializer.toJson<String>(source),
      'variant_id': serializer.toJson<String?>(variantId),
      'parent_instance_id': serializer.toJson<String?>(parentInstanceId),
      'moved_from_id': serializer.toJson<String?>(movedFromId),
      'is_manual': serializer.toJson<bool>(isManual),
      'engine_version': serializer.toJson<int?>(engineVersion),
      'planned_minutes': serializer.toJson<int?>(plannedMinutes),
    };
  }

  PlanInstance copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Map<String, String>? fieldVersions,
    String? activityId,
    Value<String?> ruleId = const Value.absent(),
    String? occurrenceDate,
    Value<DateTime?> startAt = const Value.absent(),
    Value<DateTime?> endAt = const Value.absent(),
    String? status,
    String? source,
    Value<String?> variantId = const Value.absent(),
    Value<String?> parentInstanceId = const Value.absent(),
    Value<String?> movedFromId = const Value.absent(),
    bool? isManual,
    Value<int?> engineVersion = const Value.absent(),
    Value<int?> plannedMinutes = const Value.absent(),
  }) => PlanInstance(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    fieldVersions: fieldVersions ?? this.fieldVersions,
    activityId: activityId ?? this.activityId,
    ruleId: ruleId.present ? ruleId.value : this.ruleId,
    occurrenceDate: occurrenceDate ?? this.occurrenceDate,
    startAt: startAt.present ? startAt.value : this.startAt,
    endAt: endAt.present ? endAt.value : this.endAt,
    status: status ?? this.status,
    source: source ?? this.source,
    variantId: variantId.present ? variantId.value : this.variantId,
    parentInstanceId: parentInstanceId.present
        ? parentInstanceId.value
        : this.parentInstanceId,
    movedFromId: movedFromId.present ? movedFromId.value : this.movedFromId,
    isManual: isManual ?? this.isManual,
    engineVersion: engineVersion.present
        ? engineVersion.value
        : this.engineVersion,
    plannedMinutes: plannedMinutes.present
        ? plannedMinutes.value
        : this.plannedMinutes,
  );
  PlanInstance copyWithCompanion(PlanInstancesCompanion data) {
    return PlanInstance(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      fieldVersions: data.fieldVersions.present
          ? data.fieldVersions.value
          : this.fieldVersions,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      occurrenceDate: data.occurrenceDate.present
          ? data.occurrenceDate.value
          : this.occurrenceDate,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      endAt: data.endAt.present ? data.endAt.value : this.endAt,
      status: data.status.present ? data.status.value : this.status,
      source: data.source.present ? data.source.value : this.source,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      parentInstanceId: data.parentInstanceId.present
          ? data.parentInstanceId.value
          : this.parentInstanceId,
      movedFromId: data.movedFromId.present
          ? data.movedFromId.value
          : this.movedFromId,
      isManual: data.isManual.present ? data.isManual.value : this.isManual,
      engineVersion: data.engineVersion.present
          ? data.engineVersion.value
          : this.engineVersion,
      plannedMinutes: data.plannedMinutes.present
          ? data.plannedMinutes.value
          : this.plannedMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PlanInstance(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('activityId: $activityId, ')
          ..write('ruleId: $ruleId, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('variantId: $variantId, ')
          ..write('parentInstanceId: $parentInstanceId, ')
          ..write('movedFromId: $movedFromId, ')
          ..write('isManual: $isManual, ')
          ..write('engineVersion: $engineVersion, ')
          ..write('plannedMinutes: $plannedMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    activityId,
    ruleId,
    occurrenceDate,
    startAt,
    endAt,
    status,
    source,
    variantId,
    parentInstanceId,
    movedFromId,
    isManual,
    engineVersion,
    plannedMinutes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PlanInstance &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.fieldVersions == this.fieldVersions &&
          other.activityId == this.activityId &&
          other.ruleId == this.ruleId &&
          other.occurrenceDate == this.occurrenceDate &&
          other.startAt == this.startAt &&
          other.endAt == this.endAt &&
          other.status == this.status &&
          other.source == this.source &&
          other.variantId == this.variantId &&
          other.parentInstanceId == this.parentInstanceId &&
          other.movedFromId == this.movedFromId &&
          other.isManual == this.isManual &&
          other.engineVersion == this.engineVersion &&
          other.plannedMinutes == this.plannedMinutes);
}

class PlanInstancesCompanion extends UpdateCompanion<PlanInstance> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<Map<String, String>> fieldVersions;
  final Value<String> activityId;
  final Value<String?> ruleId;
  final Value<String> occurrenceDate;
  final Value<DateTime?> startAt;
  final Value<DateTime?> endAt;
  final Value<String> status;
  final Value<String> source;
  final Value<String?> variantId;
  final Value<String?> parentInstanceId;
  final Value<String?> movedFromId;
  final Value<bool> isManual;
  final Value<int?> engineVersion;
  final Value<int?> plannedMinutes;
  final Value<int> rowid;
  const PlanInstancesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.activityId = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.occurrenceDate = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.status = const Value.absent(),
    this.source = const Value.absent(),
    this.variantId = const Value.absent(),
    this.parentInstanceId = const Value.absent(),
    this.movedFromId = const Value.absent(),
    this.isManual = const Value.absent(),
    this.engineVersion = const Value.absent(),
    this.plannedMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PlanInstancesCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    required String activityId,
    this.ruleId = const Value.absent(),
    required String occurrenceDate,
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.status = const Value.absent(),
    required String source,
    this.variantId = const Value.absent(),
    this.parentInstanceId = const Value.absent(),
    this.movedFromId = const Value.absent(),
    this.isManual = const Value.absent(),
    this.engineVersion = const Value.absent(),
    this.plannedMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       activityId = Value(activityId),
       occurrenceDate = Value(occurrenceDate),
       source = Value(source);
  static Insertable<PlanInstance> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? fieldVersions,
    Expression<String>? activityId,
    Expression<String>? ruleId,
    Expression<String>? occurrenceDate,
    Expression<DateTime>? startAt,
    Expression<DateTime>? endAt,
    Expression<String>? status,
    Expression<String>? source,
    Expression<String>? variantId,
    Expression<String>? parentInstanceId,
    Expression<String>? movedFromId,
    Expression<bool>? isManual,
    Expression<int>? engineVersion,
    Expression<int>? plannedMinutes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (fieldVersions != null) 'field_versions': fieldVersions,
      if (activityId != null) 'activity_id': activityId,
      if (ruleId != null) 'rule_id': ruleId,
      if (occurrenceDate != null) 'occurrence_date': occurrenceDate,
      if (startAt != null) 'start_at': startAt,
      if (endAt != null) 'end_at': endAt,
      if (status != null) 'status': status,
      if (source != null) 'source': source,
      if (variantId != null) 'variant_id': variantId,
      if (parentInstanceId != null) 'parent_instance_id': parentInstanceId,
      if (movedFromId != null) 'moved_from_id': movedFromId,
      if (isManual != null) 'is_manual': isManual,
      if (engineVersion != null) 'engine_version': engineVersion,
      if (plannedMinutes != null) 'planned_minutes': plannedMinutes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PlanInstancesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<Map<String, String>>? fieldVersions,
    Value<String>? activityId,
    Value<String?>? ruleId,
    Value<String>? occurrenceDate,
    Value<DateTime?>? startAt,
    Value<DateTime?>? endAt,
    Value<String>? status,
    Value<String>? source,
    Value<String?>? variantId,
    Value<String?>? parentInstanceId,
    Value<String?>? movedFromId,
    Value<bool>? isManual,
    Value<int?>? engineVersion,
    Value<int?>? plannedMinutes,
    Value<int>? rowid,
  }) {
    return PlanInstancesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      fieldVersions: fieldVersions ?? this.fieldVersions,
      activityId: activityId ?? this.activityId,
      ruleId: ruleId ?? this.ruleId,
      occurrenceDate: occurrenceDate ?? this.occurrenceDate,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      status: status ?? this.status,
      source: source ?? this.source,
      variantId: variantId ?? this.variantId,
      parentInstanceId: parentInstanceId ?? this.parentInstanceId,
      movedFromId: movedFromId ?? this.movedFromId,
      isManual: isManual ?? this.isManual,
      engineVersion: engineVersion ?? this.engineVersion,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (fieldVersions.present) {
      map['field_versions'] = Variable<String>(
        $PlanInstancesTable.$converterfieldVersions.toSql(fieldVersions.value),
      );
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<String>(ruleId.value);
    }
    if (occurrenceDate.present) {
      map['occurrence_date'] = Variable<String>(occurrenceDate.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (endAt.present) {
      map['end_at'] = Variable<DateTime>(endAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<String>(variantId.value);
    }
    if (parentInstanceId.present) {
      map['parent_instance_id'] = Variable<String>(parentInstanceId.value);
    }
    if (movedFromId.present) {
      map['moved_from_id'] = Variable<String>(movedFromId.value);
    }
    if (isManual.present) {
      map['is_manual'] = Variable<bool>(isManual.value);
    }
    if (engineVersion.present) {
      map['engine_version'] = Variable<int>(engineVersion.value);
    }
    if (plannedMinutes.present) {
      map['planned_minutes'] = Variable<int>(plannedMinutes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PlanInstancesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('activityId: $activityId, ')
          ..write('ruleId: $ruleId, ')
          ..write('occurrenceDate: $occurrenceDate, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('status: $status, ')
          ..write('source: $source, ')
          ..write('variantId: $variantId, ')
          ..write('parentInstanceId: $parentInstanceId, ')
          ..write('movedFromId: $movedFromId, ')
          ..write('isManual: $isManual, ')
          ..write('engineVersion: $engineVersion, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusSessionsTable extends FocusSessions
    with TableInfo<$FocusSessionsTable, FocusSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  fieldVersions =
      GeneratedColumn<String>(
        'field_versions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      ).withConverter<Map<String, String>>(
        $FocusSessionsTable.$converterfieldVersions,
      );
  static const VerificationMeta _planInstanceIdMeta = const VerificationMeta(
    'planInstanceId',
  );
  @override
  late final GeneratedColumn<String> planInstanceId = GeneratedColumn<String>(
    'plan_instance_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES plan_instances (id)',
    ),
  );
  static const VerificationMeta _activityIdMeta = const VerificationMeta(
    'activityId',
  );
  @override
  late final GeneratedColumn<String> activityId = GeneratedColumn<String>(
    'activity_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES activities (id)',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES user_categories (id)',
    ),
  );
  static const VerificationMeta _rootCategoryKeyMeta = const VerificationMeta(
    'rootCategoryKey',
  );
  @override
  late final GeneratedColumn<String> rootCategoryKey = GeneratedColumn<String>(
    'root_category_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES root_categories ("key")',
    ),
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    check: () => mode.isIn(const ['free', 'pomodoro', 'deep']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>?, String>
  settings =
      GeneratedColumn<String>(
        'settings',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<Map<String, Object?>?>(
        $FocusSessionsTable.$convertersettingsn,
      );
  static const VerificationMeta _plannedMinutesMeta = const VerificationMeta(
    'plannedMinutes',
  );
  @override
  late final GeneratedColumn<int> plannedMinutes = GeneratedColumn<int>(
    'planned_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _focusedSecondsMeta = const VerificationMeta(
    'focusedSeconds',
  );
  @override
  late final GeneratedColumn<int> focusedSeconds = GeneratedColumn<int>(
    'focused_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<Object?>, String> segments =
      GeneratedColumn<String>(
        'segments',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      ).withConverter<List<Object?>>($FocusSessionsTable.$convertersegments);
  static const VerificationMeta _outcomeMeta = const VerificationMeta(
    'outcome',
  );
  @override
  late final GeneratedColumn<String> outcome = GeneratedColumn<String>(
    'outcome',
    aliasedName,
    false,
    check: () => outcome.isIn(const ['in_progress', 'completed', 'broken']),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('in_progress'),
  );
  static const VerificationMeta _focusRatingMeta = const VerificationMeta(
    'focusRating',
  );
  @override
  late final GeneratedColumn<int> focusRating = GeneratedColumn<int>(
    'focus_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fatigueRatingMeta = const VerificationMeta(
    'fatigueRating',
  );
  @override
  late final GeneratedColumn<int> fatigueRating = GeneratedColumn<int>(
    'fatigue_rating',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    planInstanceId,
    activityId,
    categoryId,
    rootCategoryKey,
    mode,
    settings,
    plannedMinutes,
    startedAt,
    endedAt,
    focusedSeconds,
    segments,
    outcome,
    focusRating,
    fatigueRating,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('plan_instance_id')) {
      context.handle(
        _planInstanceIdMeta,
        planInstanceId.isAcceptableOrUnknown(
          data['plan_instance_id']!,
          _planInstanceIdMeta,
        ),
      );
    }
    if (data.containsKey('activity_id')) {
      context.handle(
        _activityIdMeta,
        activityId.isAcceptableOrUnknown(data['activity_id']!, _activityIdMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('root_category_key')) {
      context.handle(
        _rootCategoryKeyMeta,
        rootCategoryKey.isAcceptableOrUnknown(
          data['root_category_key']!,
          _rootCategoryKeyMeta,
        ),
      );
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('planned_minutes')) {
      context.handle(
        _plannedMinutesMeta,
        plannedMinutes.isAcceptableOrUnknown(
          data['planned_minutes']!,
          _plannedMinutesMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('focused_seconds')) {
      context.handle(
        _focusedSecondsMeta,
        focusedSeconds.isAcceptableOrUnknown(
          data['focused_seconds']!,
          _focusedSecondsMeta,
        ),
      );
    }
    if (data.containsKey('outcome')) {
      context.handle(
        _outcomeMeta,
        outcome.isAcceptableOrUnknown(data['outcome']!, _outcomeMeta),
      );
    }
    if (data.containsKey('focus_rating')) {
      context.handle(
        _focusRatingMeta,
        focusRating.isAcceptableOrUnknown(
          data['focus_rating']!,
          _focusRatingMeta,
        ),
      );
    }
    if (data.containsKey('fatigue_rating')) {
      context.handle(
        _fatigueRatingMeta,
        fatigueRating.isAcceptableOrUnknown(
          data['fatigue_rating']!,
          _fatigueRatingMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      fieldVersions: $FocusSessionsTable.$converterfieldVersions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}field_versions'],
        )!,
      ),
      planInstanceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plan_instance_id'],
      ),
      activityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_id'],
      ),
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      rootCategoryKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}root_category_key'],
      ),
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      settings: $FocusSessionsTable.$convertersettingsn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}settings'],
        ),
      ),
      plannedMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}planned_minutes'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      ),
      focusedSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focused_seconds'],
      )!,
      segments: $FocusSessionsTable.$convertersegments.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}segments'],
        )!,
      ),
      outcome: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}outcome'],
      )!,
      focusRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}focus_rating'],
      ),
      fatigueRating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}fatigue_rating'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $FocusSessionsTable createAlias(String alias) {
    return $FocusSessionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, String>, String, Object?>
  $converterfieldVersions = const FieldVersionsConverter();
  static JsonTypeConverter2<Map<String, Object?>, String, Object?>
  $convertersettings = const JsonValueConverter<Map<String, Object?>>();
  static JsonTypeConverter2<Map<String, Object?>?, String?, Object?>
  $convertersettingsn = JsonTypeConverter2.asNullable($convertersettings);
  static JsonTypeConverter2<List<Object?>, String, Object?> $convertersegments =
      const JsonValueConverter<List<Object?>>();
}

class FocusSession extends DataClass implements Insertable<FocusSession> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Map<String, String> fieldVersions;
  final String? planInstanceId;
  final String? activityId;
  final String? categoryId;
  final String? rootCategoryKey;
  final String mode;
  final Map<String, Object?>? settings;
  final int? plannedMinutes;
  final DateTime startedAt;
  final DateTime? endedAt;
  final int focusedSeconds;
  final List<Object?> segments;
  final String outcome;
  final int? focusRating;
  final int? fatigueRating;
  final String? note;
  const FocusSession({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.fieldVersions,
    this.planInstanceId,
    this.activityId,
    this.categoryId,
    this.rootCategoryKey,
    required this.mode,
    this.settings,
    this.plannedMinutes,
    required this.startedAt,
    this.endedAt,
    required this.focusedSeconds,
    required this.segments,
    required this.outcome,
    this.focusRating,
    this.fatigueRating,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['field_versions'] = Variable<String>(
        $FocusSessionsTable.$converterfieldVersions.toSql(fieldVersions),
      );
    }
    if (!nullToAbsent || planInstanceId != null) {
      map['plan_instance_id'] = Variable<String>(planInstanceId);
    }
    if (!nullToAbsent || activityId != null) {
      map['activity_id'] = Variable<String>(activityId);
    }
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    if (!nullToAbsent || rootCategoryKey != null) {
      map['root_category_key'] = Variable<String>(rootCategoryKey);
    }
    map['mode'] = Variable<String>(mode);
    if (!nullToAbsent || settings != null) {
      map['settings'] = Variable<String>(
        $FocusSessionsTable.$convertersettingsn.toSql(settings),
      );
    }
    if (!nullToAbsent || plannedMinutes != null) {
      map['planned_minutes'] = Variable<int>(plannedMinutes);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<DateTime>(endedAt);
    }
    map['focused_seconds'] = Variable<int>(focusedSeconds);
    {
      map['segments'] = Variable<String>(
        $FocusSessionsTable.$convertersegments.toSql(segments),
      );
    }
    map['outcome'] = Variable<String>(outcome);
    if (!nullToAbsent || focusRating != null) {
      map['focus_rating'] = Variable<int>(focusRating);
    }
    if (!nullToAbsent || fatigueRating != null) {
      map['fatigue_rating'] = Variable<int>(fatigueRating);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  FocusSessionsCompanion toCompanion(bool nullToAbsent) {
    return FocusSessionsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      fieldVersions: Value(fieldVersions),
      planInstanceId: planInstanceId == null && nullToAbsent
          ? const Value.absent()
          : Value(planInstanceId),
      activityId: activityId == null && nullToAbsent
          ? const Value.absent()
          : Value(activityId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      rootCategoryKey: rootCategoryKey == null && nullToAbsent
          ? const Value.absent()
          : Value(rootCategoryKey),
      mode: Value(mode),
      settings: settings == null && nullToAbsent
          ? const Value.absent()
          : Value(settings),
      plannedMinutes: plannedMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(plannedMinutes),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      focusedSeconds: Value(focusedSeconds),
      segments: Value(segments),
      outcome: Value(outcome),
      focusRating: focusRating == null && nullToAbsent
          ? const Value.absent()
          : Value(focusRating),
      fatigueRating: fatigueRating == null && nullToAbsent
          ? const Value.absent()
          : Value(fatigueRating),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory FocusSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusSession(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      fieldVersions: $FocusSessionsTable.$converterfieldVersions.fromJson(
        serializer.fromJson<Object?>(json['field_versions']),
      ),
      planInstanceId: serializer.fromJson<String?>(json['plan_instance_id']),
      activityId: serializer.fromJson<String?>(json['activity_id']),
      categoryId: serializer.fromJson<String?>(json['category_id']),
      rootCategoryKey: serializer.fromJson<String?>(json['root_category_key']),
      mode: serializer.fromJson<String>(json['mode']),
      settings: $FocusSessionsTable.$convertersettingsn.fromJson(
        serializer.fromJson<Object?>(json['settings']),
      ),
      plannedMinutes: serializer.fromJson<int?>(json['planned_minutes']),
      startedAt: serializer.fromJson<DateTime>(json['started_at']),
      endedAt: serializer.fromJson<DateTime?>(json['ended_at']),
      focusedSeconds: serializer.fromJson<int>(json['focused_seconds']),
      segments: $FocusSessionsTable.$convertersegments.fromJson(
        serializer.fromJson<Object?>(json['segments']),
      ),
      outcome: serializer.fromJson<String>(json['outcome']),
      focusRating: serializer.fromJson<int?>(json['focus_rating']),
      fatigueRating: serializer.fromJson<int?>(json['fatigue_rating']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'field_versions': serializer.toJson<Object?>(
        $FocusSessionsTable.$converterfieldVersions.toJson(fieldVersions),
      ),
      'plan_instance_id': serializer.toJson<String?>(planInstanceId),
      'activity_id': serializer.toJson<String?>(activityId),
      'category_id': serializer.toJson<String?>(categoryId),
      'root_category_key': serializer.toJson<String?>(rootCategoryKey),
      'mode': serializer.toJson<String>(mode),
      'settings': serializer.toJson<Object?>(
        $FocusSessionsTable.$convertersettingsn.toJson(settings),
      ),
      'planned_minutes': serializer.toJson<int?>(plannedMinutes),
      'started_at': serializer.toJson<DateTime>(startedAt),
      'ended_at': serializer.toJson<DateTime?>(endedAt),
      'focused_seconds': serializer.toJson<int>(focusedSeconds),
      'segments': serializer.toJson<Object?>(
        $FocusSessionsTable.$convertersegments.toJson(segments),
      ),
      'outcome': serializer.toJson<String>(outcome),
      'focus_rating': serializer.toJson<int?>(focusRating),
      'fatigue_rating': serializer.toJson<int?>(fatigueRating),
      'note': serializer.toJson<String?>(note),
    };
  }

  FocusSession copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Map<String, String>? fieldVersions,
    Value<String?> planInstanceId = const Value.absent(),
    Value<String?> activityId = const Value.absent(),
    Value<String?> categoryId = const Value.absent(),
    Value<String?> rootCategoryKey = const Value.absent(),
    String? mode,
    Value<Map<String, Object?>?> settings = const Value.absent(),
    Value<int?> plannedMinutes = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> endedAt = const Value.absent(),
    int? focusedSeconds,
    List<Object?>? segments,
    String? outcome,
    Value<int?> focusRating = const Value.absent(),
    Value<int?> fatigueRating = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => FocusSession(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    fieldVersions: fieldVersions ?? this.fieldVersions,
    planInstanceId: planInstanceId.present
        ? planInstanceId.value
        : this.planInstanceId,
    activityId: activityId.present ? activityId.value : this.activityId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    rootCategoryKey: rootCategoryKey.present
        ? rootCategoryKey.value
        : this.rootCategoryKey,
    mode: mode ?? this.mode,
    settings: settings.present ? settings.value : this.settings,
    plannedMinutes: plannedMinutes.present
        ? plannedMinutes.value
        : this.plannedMinutes,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    focusedSeconds: focusedSeconds ?? this.focusedSeconds,
    segments: segments ?? this.segments,
    outcome: outcome ?? this.outcome,
    focusRating: focusRating.present ? focusRating.value : this.focusRating,
    fatigueRating: fatigueRating.present
        ? fatigueRating.value
        : this.fatigueRating,
    note: note.present ? note.value : this.note,
  );
  FocusSession copyWithCompanion(FocusSessionsCompanion data) {
    return FocusSession(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      fieldVersions: data.fieldVersions.present
          ? data.fieldVersions.value
          : this.fieldVersions,
      planInstanceId: data.planInstanceId.present
          ? data.planInstanceId.value
          : this.planInstanceId,
      activityId: data.activityId.present
          ? data.activityId.value
          : this.activityId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      rootCategoryKey: data.rootCategoryKey.present
          ? data.rootCategoryKey.value
          : this.rootCategoryKey,
      mode: data.mode.present ? data.mode.value : this.mode,
      settings: data.settings.present ? data.settings.value : this.settings,
      plannedMinutes: data.plannedMinutes.present
          ? data.plannedMinutes.value
          : this.plannedMinutes,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      focusedSeconds: data.focusedSeconds.present
          ? data.focusedSeconds.value
          : this.focusedSeconds,
      segments: data.segments.present ? data.segments.value : this.segments,
      outcome: data.outcome.present ? data.outcome.value : this.outcome,
      focusRating: data.focusRating.present
          ? data.focusRating.value
          : this.focusRating,
      fatigueRating: data.fatigueRating.present
          ? data.fatigueRating.value
          : this.fatigueRating,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusSession(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('planInstanceId: $planInstanceId, ')
          ..write('activityId: $activityId, ')
          ..write('categoryId: $categoryId, ')
          ..write('rootCategoryKey: $rootCategoryKey, ')
          ..write('mode: $mode, ')
          ..write('settings: $settings, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('focusedSeconds: $focusedSeconds, ')
          ..write('segments: $segments, ')
          ..write('outcome: $outcome, ')
          ..write('focusRating: $focusRating, ')
          ..write('fatigueRating: $fatigueRating, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    planInstanceId,
    activityId,
    categoryId,
    rootCategoryKey,
    mode,
    settings,
    plannedMinutes,
    startedAt,
    endedAt,
    focusedSeconds,
    segments,
    outcome,
    focusRating,
    fatigueRating,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusSession &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.fieldVersions == this.fieldVersions &&
          other.planInstanceId == this.planInstanceId &&
          other.activityId == this.activityId &&
          other.categoryId == this.categoryId &&
          other.rootCategoryKey == this.rootCategoryKey &&
          other.mode == this.mode &&
          other.settings == this.settings &&
          other.plannedMinutes == this.plannedMinutes &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.focusedSeconds == this.focusedSeconds &&
          other.segments == this.segments &&
          other.outcome == this.outcome &&
          other.focusRating == this.focusRating &&
          other.fatigueRating == this.fatigueRating &&
          other.note == this.note);
}

class FocusSessionsCompanion extends UpdateCompanion<FocusSession> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<Map<String, String>> fieldVersions;
  final Value<String?> planInstanceId;
  final Value<String?> activityId;
  final Value<String?> categoryId;
  final Value<String?> rootCategoryKey;
  final Value<String> mode;
  final Value<Map<String, Object?>?> settings;
  final Value<int?> plannedMinutes;
  final Value<DateTime> startedAt;
  final Value<DateTime?> endedAt;
  final Value<int> focusedSeconds;
  final Value<List<Object?>> segments;
  final Value<String> outcome;
  final Value<int?> focusRating;
  final Value<int?> fatigueRating;
  final Value<String?> note;
  final Value<int> rowid;
  const FocusSessionsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.planInstanceId = const Value.absent(),
    this.activityId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rootCategoryKey = const Value.absent(),
    this.mode = const Value.absent(),
    this.settings = const Value.absent(),
    this.plannedMinutes = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.focusedSeconds = const Value.absent(),
    this.segments = const Value.absent(),
    this.outcome = const Value.absent(),
    this.focusRating = const Value.absent(),
    this.fatigueRating = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusSessionsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.planInstanceId = const Value.absent(),
    this.activityId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.rootCategoryKey = const Value.absent(),
    required String mode,
    this.settings = const Value.absent(),
    this.plannedMinutes = const Value.absent(),
    required DateTime startedAt,
    this.endedAt = const Value.absent(),
    this.focusedSeconds = const Value.absent(),
    this.segments = const Value.absent(),
    this.outcome = const Value.absent(),
    this.focusRating = const Value.absent(),
    this.fatigueRating = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       mode = Value(mode),
       startedAt = Value(startedAt);
  static Insertable<FocusSession> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? fieldVersions,
    Expression<String>? planInstanceId,
    Expression<String>? activityId,
    Expression<String>? categoryId,
    Expression<String>? rootCategoryKey,
    Expression<String>? mode,
    Expression<String>? settings,
    Expression<int>? plannedMinutes,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? focusedSeconds,
    Expression<String>? segments,
    Expression<String>? outcome,
    Expression<int>? focusRating,
    Expression<int>? fatigueRating,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (fieldVersions != null) 'field_versions': fieldVersions,
      if (planInstanceId != null) 'plan_instance_id': planInstanceId,
      if (activityId != null) 'activity_id': activityId,
      if (categoryId != null) 'category_id': categoryId,
      if (rootCategoryKey != null) 'root_category_key': rootCategoryKey,
      if (mode != null) 'mode': mode,
      if (settings != null) 'settings': settings,
      if (plannedMinutes != null) 'planned_minutes': plannedMinutes,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (focusedSeconds != null) 'focused_seconds': focusedSeconds,
      if (segments != null) 'segments': segments,
      if (outcome != null) 'outcome': outcome,
      if (focusRating != null) 'focus_rating': focusRating,
      if (fatigueRating != null) 'fatigue_rating': fatigueRating,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusSessionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<Map<String, String>>? fieldVersions,
    Value<String?>? planInstanceId,
    Value<String?>? activityId,
    Value<String?>? categoryId,
    Value<String?>? rootCategoryKey,
    Value<String>? mode,
    Value<Map<String, Object?>?>? settings,
    Value<int?>? plannedMinutes,
    Value<DateTime>? startedAt,
    Value<DateTime?>? endedAt,
    Value<int>? focusedSeconds,
    Value<List<Object?>>? segments,
    Value<String>? outcome,
    Value<int?>? focusRating,
    Value<int?>? fatigueRating,
    Value<String?>? note,
    Value<int>? rowid,
  }) {
    return FocusSessionsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      fieldVersions: fieldVersions ?? this.fieldVersions,
      planInstanceId: planInstanceId ?? this.planInstanceId,
      activityId: activityId ?? this.activityId,
      categoryId: categoryId ?? this.categoryId,
      rootCategoryKey: rootCategoryKey ?? this.rootCategoryKey,
      mode: mode ?? this.mode,
      settings: settings ?? this.settings,
      plannedMinutes: plannedMinutes ?? this.plannedMinutes,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      focusedSeconds: focusedSeconds ?? this.focusedSeconds,
      segments: segments ?? this.segments,
      outcome: outcome ?? this.outcome,
      focusRating: focusRating ?? this.focusRating,
      fatigueRating: fatigueRating ?? this.fatigueRating,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (fieldVersions.present) {
      map['field_versions'] = Variable<String>(
        $FocusSessionsTable.$converterfieldVersions.toSql(fieldVersions.value),
      );
    }
    if (planInstanceId.present) {
      map['plan_instance_id'] = Variable<String>(planInstanceId.value);
    }
    if (activityId.present) {
      map['activity_id'] = Variable<String>(activityId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (rootCategoryKey.present) {
      map['root_category_key'] = Variable<String>(rootCategoryKey.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (settings.present) {
      map['settings'] = Variable<String>(
        $FocusSessionsTable.$convertersettingsn.toSql(settings.value),
      );
    }
    if (plannedMinutes.present) {
      map['planned_minutes'] = Variable<int>(plannedMinutes.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (focusedSeconds.present) {
      map['focused_seconds'] = Variable<int>(focusedSeconds.value);
    }
    if (segments.present) {
      map['segments'] = Variable<String>(
        $FocusSessionsTable.$convertersegments.toSql(segments.value),
      );
    }
    if (outcome.present) {
      map['outcome'] = Variable<String>(outcome.value);
    }
    if (focusRating.present) {
      map['focus_rating'] = Variable<int>(focusRating.value);
    }
    if (fatigueRating.present) {
      map['fatigue_rating'] = Variable<int>(fatigueRating.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusSessionsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('planInstanceId: $planInstanceId, ')
          ..write('activityId: $activityId, ')
          ..write('categoryId: $categoryId, ')
          ..write('rootCategoryKey: $rootCategoryKey, ')
          ..write('mode: $mode, ')
          ..write('settings: $settings, ')
          ..write('plannedMinutes: $plannedMinutes, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('focusedSeconds: $focusedSeconds, ')
          ..write('segments: $segments, ')
          ..write('outcome: $outcome, ')
          ..write('focusRating: $focusRating, ')
          ..write('fatigueRating: $fatigueRating, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FocusInterruptionsTable extends FocusInterruptions
    with TableInfo<$FocusInterruptionsTable, FocusInterruption> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FocusInterruptionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  fieldVersions =
      GeneratedColumn<String>(
        'field_versions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      ).withConverter<Map<String, String>>(
        $FocusInterruptionsTable.$converterfieldVersions,
      );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES focus_sessions (id)',
    ),
  );
  static const VerificationMeta _leftAtMeta = const VerificationMeta('leftAt');
  @override
  late final GeneratedColumn<DateTime> leftAt = GeneratedColumn<DateTime>(
    'left_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _awayMsMeta = const VerificationMeta('awayMs');
  @override
  late final GeneratedColumn<int> awayMs = GeneratedColumn<int>(
    'away_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    false,
    check: () => reason.isIn(const [
      'app_left',
      'notification_shade',
      'screen_off',
      'phone_call',
      'alarm',
      'other',
    ]),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recoveredMeta = const VerificationMeta(
    'recovered',
  );
  @override
  late final GeneratedColumn<bool> recovered = GeneratedColumn<bool>(
    'recovered',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("recovered" IN (0, 1))',
    ),
  );
  static const VerificationMeta _countedMeta = const VerificationMeta(
    'counted',
  );
  @override
  late final GeneratedColumn<bool> counted = GeneratedColumn<bool>(
    'counted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("counted" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    sessionId,
    leftAt,
    awayMs,
    reason,
    recovered,
    counted,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'focus_interruptions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FocusInterruption> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('left_at')) {
      context.handle(
        _leftAtMeta,
        leftAt.isAcceptableOrUnknown(data['left_at']!, _leftAtMeta),
      );
    } else if (isInserting) {
      context.missing(_leftAtMeta);
    }
    if (data.containsKey('away_ms')) {
      context.handle(
        _awayMsMeta,
        awayMs.isAcceptableOrUnknown(data['away_ms']!, _awayMsMeta),
      );
    } else if (isInserting) {
      context.missing(_awayMsMeta);
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    } else if (isInserting) {
      context.missing(_reasonMeta);
    }
    if (data.containsKey('recovered')) {
      context.handle(
        _recoveredMeta,
        recovered.isAcceptableOrUnknown(data['recovered']!, _recoveredMeta),
      );
    } else if (isInserting) {
      context.missing(_recoveredMeta);
    }
    if (data.containsKey('counted')) {
      context.handle(
        _countedMeta,
        counted.isAcceptableOrUnknown(data['counted']!, _countedMeta),
      );
    } else if (isInserting) {
      context.missing(_countedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FocusInterruption map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FocusInterruption(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      fieldVersions: $FocusInterruptionsTable.$converterfieldVersions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}field_versions'],
        )!,
      ),
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      leftAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}left_at'],
      )!,
      awayMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}away_ms'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      )!,
      recovered: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}recovered'],
      )!,
      counted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}counted'],
      )!,
    );
  }

  @override
  $FocusInterruptionsTable createAlias(String alias) {
    return $FocusInterruptionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, String>, String, Object?>
  $converterfieldVersions = const FieldVersionsConverter();
}

class FocusInterruption extends DataClass
    implements Insertable<FocusInterruption> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Map<String, String> fieldVersions;
  final String sessionId;
  final DateTime leftAt;
  final int awayMs;
  final String reason;
  final bool recovered;
  final bool counted;
  const FocusInterruption({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.fieldVersions,
    required this.sessionId,
    required this.leftAt,
    required this.awayMs,
    required this.reason,
    required this.recovered,
    required this.counted,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['field_versions'] = Variable<String>(
        $FocusInterruptionsTable.$converterfieldVersions.toSql(fieldVersions),
      );
    }
    map['session_id'] = Variable<String>(sessionId);
    map['left_at'] = Variable<DateTime>(leftAt);
    map['away_ms'] = Variable<int>(awayMs);
    map['reason'] = Variable<String>(reason);
    map['recovered'] = Variable<bool>(recovered);
    map['counted'] = Variable<bool>(counted);
    return map;
  }

  FocusInterruptionsCompanion toCompanion(bool nullToAbsent) {
    return FocusInterruptionsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      fieldVersions: Value(fieldVersions),
      sessionId: Value(sessionId),
      leftAt: Value(leftAt),
      awayMs: Value(awayMs),
      reason: Value(reason),
      recovered: Value(recovered),
      counted: Value(counted),
    );
  }

  factory FocusInterruption.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FocusInterruption(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      fieldVersions: $FocusInterruptionsTable.$converterfieldVersions.fromJson(
        serializer.fromJson<Object?>(json['field_versions']),
      ),
      sessionId: serializer.fromJson<String>(json['session_id']),
      leftAt: serializer.fromJson<DateTime>(json['left_at']),
      awayMs: serializer.fromJson<int>(json['away_ms']),
      reason: serializer.fromJson<String>(json['reason']),
      recovered: serializer.fromJson<bool>(json['recovered']),
      counted: serializer.fromJson<bool>(json['counted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'field_versions': serializer.toJson<Object?>(
        $FocusInterruptionsTable.$converterfieldVersions.toJson(fieldVersions),
      ),
      'session_id': serializer.toJson<String>(sessionId),
      'left_at': serializer.toJson<DateTime>(leftAt),
      'away_ms': serializer.toJson<int>(awayMs),
      'reason': serializer.toJson<String>(reason),
      'recovered': serializer.toJson<bool>(recovered),
      'counted': serializer.toJson<bool>(counted),
    };
  }

  FocusInterruption copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Map<String, String>? fieldVersions,
    String? sessionId,
    DateTime? leftAt,
    int? awayMs,
    String? reason,
    bool? recovered,
    bool? counted,
  }) => FocusInterruption(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    fieldVersions: fieldVersions ?? this.fieldVersions,
    sessionId: sessionId ?? this.sessionId,
    leftAt: leftAt ?? this.leftAt,
    awayMs: awayMs ?? this.awayMs,
    reason: reason ?? this.reason,
    recovered: recovered ?? this.recovered,
    counted: counted ?? this.counted,
  );
  FocusInterruption copyWithCompanion(FocusInterruptionsCompanion data) {
    return FocusInterruption(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      fieldVersions: data.fieldVersions.present
          ? data.fieldVersions.value
          : this.fieldVersions,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      leftAt: data.leftAt.present ? data.leftAt.value : this.leftAt,
      awayMs: data.awayMs.present ? data.awayMs.value : this.awayMs,
      reason: data.reason.present ? data.reason.value : this.reason,
      recovered: data.recovered.present ? data.recovered.value : this.recovered,
      counted: data.counted.present ? data.counted.value : this.counted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FocusInterruption(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('sessionId: $sessionId, ')
          ..write('leftAt: $leftAt, ')
          ..write('awayMs: $awayMs, ')
          ..write('reason: $reason, ')
          ..write('recovered: $recovered, ')
          ..write('counted: $counted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    sessionId,
    leftAt,
    awayMs,
    reason,
    recovered,
    counted,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FocusInterruption &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.fieldVersions == this.fieldVersions &&
          other.sessionId == this.sessionId &&
          other.leftAt == this.leftAt &&
          other.awayMs == this.awayMs &&
          other.reason == this.reason &&
          other.recovered == this.recovered &&
          other.counted == this.counted);
}

class FocusInterruptionsCompanion extends UpdateCompanion<FocusInterruption> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<Map<String, String>> fieldVersions;
  final Value<String> sessionId;
  final Value<DateTime> leftAt;
  final Value<int> awayMs;
  final Value<String> reason;
  final Value<bool> recovered;
  final Value<bool> counted;
  final Value<int> rowid;
  const FocusInterruptionsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.leftAt = const Value.absent(),
    this.awayMs = const Value.absent(),
    this.reason = const Value.absent(),
    this.recovered = const Value.absent(),
    this.counted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FocusInterruptionsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    required String sessionId,
    required DateTime leftAt,
    required int awayMs,
    required String reason,
    required bool recovered,
    required bool counted,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       leftAt = Value(leftAt),
       awayMs = Value(awayMs),
       reason = Value(reason),
       recovered = Value(recovered),
       counted = Value(counted);
  static Insertable<FocusInterruption> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? fieldVersions,
    Expression<String>? sessionId,
    Expression<DateTime>? leftAt,
    Expression<int>? awayMs,
    Expression<String>? reason,
    Expression<bool>? recovered,
    Expression<bool>? counted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (fieldVersions != null) 'field_versions': fieldVersions,
      if (sessionId != null) 'session_id': sessionId,
      if (leftAt != null) 'left_at': leftAt,
      if (awayMs != null) 'away_ms': awayMs,
      if (reason != null) 'reason': reason,
      if (recovered != null) 'recovered': recovered,
      if (counted != null) 'counted': counted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FocusInterruptionsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<Map<String, String>>? fieldVersions,
    Value<String>? sessionId,
    Value<DateTime>? leftAt,
    Value<int>? awayMs,
    Value<String>? reason,
    Value<bool>? recovered,
    Value<bool>? counted,
    Value<int>? rowid,
  }) {
    return FocusInterruptionsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      fieldVersions: fieldVersions ?? this.fieldVersions,
      sessionId: sessionId ?? this.sessionId,
      leftAt: leftAt ?? this.leftAt,
      awayMs: awayMs ?? this.awayMs,
      reason: reason ?? this.reason,
      recovered: recovered ?? this.recovered,
      counted: counted ?? this.counted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (fieldVersions.present) {
      map['field_versions'] = Variable<String>(
        $FocusInterruptionsTable.$converterfieldVersions.toSql(
          fieldVersions.value,
        ),
      );
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (leftAt.present) {
      map['left_at'] = Variable<DateTime>(leftAt.value);
    }
    if (awayMs.present) {
      map['away_ms'] = Variable<int>(awayMs.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (recovered.present) {
      map['recovered'] = Variable<bool>(recovered.value);
    }
    if (counted.present) {
      map['counted'] = Variable<bool>(counted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FocusInterruptionsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('sessionId: $sessionId, ')
          ..write('leftAt: $leftAt, ')
          ..write('awayMs: $awayMs, ')
          ..write('reason: $reason, ')
          ..write('recovered: $recovered, ')
          ..write('counted: $counted, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BrainEventsTable extends BrainEvents
    with TableInfo<$BrainEventsTable, BrainEvent> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrainEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    clientDefault: () => DateTime.now().toUtc(),
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, String>, String>
  fieldVersions =
      GeneratedColumn<String>(
        'field_versions',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      ).withConverter<Map<String, String>>(
        $BrainEventsTable.$converterfieldVersions,
      );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    check: () =>
        type.isIn(const ['neuron_gain', 'connection_gain', 'fade', 'penalty']),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _regionKeyMeta = const VerificationMeta(
    'regionKey',
  );
  @override
  late final GeneratedColumn<String> regionKey = GeneratedColumn<String>(
    'region_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES brain_regions ("key")',
    ),
  );
  static const VerificationMeta _regionBKeyMeta = const VerificationMeta(
    'regionBKey',
  );
  @override
  late final GeneratedColumn<String> regionBKey = GeneratedColumn<String>(
    'region_b_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES brain_regions ("key")',
    ),
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredAtMeta = const VerificationMeta(
    'occurredAt',
  );
  @override
  late final GeneratedColumn<DateTime> occurredAt = GeneratedColumn<DateTime>(
    'occurred_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES focus_sessions (id)',
    ),
  );
  static const VerificationMeta _dedupeKeyMeta = const VerificationMeta(
    'dedupeKey',
  );
  @override
  late final GeneratedColumn<String> dedupeKey = GeneratedColumn<String>(
    'dedupe_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _engineVersionMeta = const VerificationMeta(
    'engineVersion',
  );
  @override
  late final GeneratedColumn<int> engineVersion = GeneratedColumn<int>(
    'engine_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    type,
    regionKey,
    regionBKey,
    amount,
    occurredAt,
    sessionId,
    dedupeKey,
    engineVersion,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brain_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<BrainEvent> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('region_key')) {
      context.handle(
        _regionKeyMeta,
        regionKey.isAcceptableOrUnknown(data['region_key']!, _regionKeyMeta),
      );
    }
    if (data.containsKey('region_b_key')) {
      context.handle(
        _regionBKeyMeta,
        regionBKey.isAcceptableOrUnknown(
          data['region_b_key']!,
          _regionBKeyMeta,
        ),
      );
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('occurred_at')) {
      context.handle(
        _occurredAtMeta,
        occurredAt.isAcceptableOrUnknown(data['occurred_at']!, _occurredAtMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredAtMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    }
    if (data.containsKey('dedupe_key')) {
      context.handle(
        _dedupeKeyMeta,
        dedupeKey.isAcceptableOrUnknown(data['dedupe_key']!, _dedupeKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_dedupeKeyMeta);
    }
    if (data.containsKey('engine_version')) {
      context.handle(
        _engineVersionMeta,
        engineVersion.isAcceptableOrUnknown(
          data['engine_version']!,
          _engineVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_engineVersionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BrainEvent map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BrainEvent(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
      fieldVersions: $BrainEventsTable.$converterfieldVersions.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}field_versions'],
        )!,
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      regionKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_key'],
      ),
      regionBKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region_b_key'],
      ),
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      occurredAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}occurred_at'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      ),
      dedupeKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}dedupe_key'],
      )!,
      engineVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}engine_version'],
      )!,
    );
  }

  @override
  $BrainEventsTable createAlias(String alias) {
    return $BrainEventsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, String>, String, Object?>
  $converterfieldVersions = const FieldVersionsConverter();
}

class BrainEvent extends DataClass implements Insertable<BrainEvent> {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  final Map<String, String> fieldVersions;
  final String type;
  final String? regionKey;
  final String? regionBKey;
  final int amount;
  final DateTime occurredAt;
  final String? sessionId;
  final String dedupeKey;
  final int engineVersion;
  const BrainEvent({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    required this.fieldVersions,
    required this.type,
    this.regionKey,
    this.regionBKey,
    required this.amount,
    required this.occurredAt,
    this.sessionId,
    required this.dedupeKey,
    required this.engineVersion,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    {
      map['field_versions'] = Variable<String>(
        $BrainEventsTable.$converterfieldVersions.toSql(fieldVersions),
      );
    }
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || regionKey != null) {
      map['region_key'] = Variable<String>(regionKey);
    }
    if (!nullToAbsent || regionBKey != null) {
      map['region_b_key'] = Variable<String>(regionBKey);
    }
    map['amount'] = Variable<int>(amount);
    map['occurred_at'] = Variable<DateTime>(occurredAt);
    if (!nullToAbsent || sessionId != null) {
      map['session_id'] = Variable<String>(sessionId);
    }
    map['dedupe_key'] = Variable<String>(dedupeKey);
    map['engine_version'] = Variable<int>(engineVersion);
    return map;
  }

  BrainEventsCompanion toCompanion(bool nullToAbsent) {
    return BrainEventsCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      fieldVersions: Value(fieldVersions),
      type: Value(type),
      regionKey: regionKey == null && nullToAbsent
          ? const Value.absent()
          : Value(regionKey),
      regionBKey: regionBKey == null && nullToAbsent
          ? const Value.absent()
          : Value(regionBKey),
      amount: Value(amount),
      occurredAt: Value(occurredAt),
      sessionId: sessionId == null && nullToAbsent
          ? const Value.absent()
          : Value(sessionId),
      dedupeKey: Value(dedupeKey),
      engineVersion: Value(engineVersion),
    );
  }

  factory BrainEvent.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BrainEvent(
      id: serializer.fromJson<String>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      updatedAt: serializer.fromJson<DateTime>(json['updated_at']),
      deletedAt: serializer.fromJson<DateTime?>(json['deleted_at']),
      fieldVersions: $BrainEventsTable.$converterfieldVersions.fromJson(
        serializer.fromJson<Object?>(json['field_versions']),
      ),
      type: serializer.fromJson<String>(json['type']),
      regionKey: serializer.fromJson<String?>(json['region_key']),
      regionBKey: serializer.fromJson<String?>(json['region_b_key']),
      amount: serializer.fromJson<int>(json['amount']),
      occurredAt: serializer.fromJson<DateTime>(json['occurred_at']),
      sessionId: serializer.fromJson<String?>(json['session_id']),
      dedupeKey: serializer.fromJson<String>(json['dedupe_key']),
      engineVersion: serializer.fromJson<int>(json['engine_version']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'updated_at': serializer.toJson<DateTime>(updatedAt),
      'deleted_at': serializer.toJson<DateTime?>(deletedAt),
      'field_versions': serializer.toJson<Object?>(
        $BrainEventsTable.$converterfieldVersions.toJson(fieldVersions),
      ),
      'type': serializer.toJson<String>(type),
      'region_key': serializer.toJson<String?>(regionKey),
      'region_b_key': serializer.toJson<String?>(regionBKey),
      'amount': serializer.toJson<int>(amount),
      'occurred_at': serializer.toJson<DateTime>(occurredAt),
      'session_id': serializer.toJson<String?>(sessionId),
      'dedupe_key': serializer.toJson<String>(dedupeKey),
      'engine_version': serializer.toJson<int>(engineVersion),
    };
  }

  BrainEvent copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
    Map<String, String>? fieldVersions,
    String? type,
    Value<String?> regionKey = const Value.absent(),
    Value<String?> regionBKey = const Value.absent(),
    int? amount,
    DateTime? occurredAt,
    Value<String?> sessionId = const Value.absent(),
    String? dedupeKey,
    int? engineVersion,
  }) => BrainEvent(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    fieldVersions: fieldVersions ?? this.fieldVersions,
    type: type ?? this.type,
    regionKey: regionKey.present ? regionKey.value : this.regionKey,
    regionBKey: regionBKey.present ? regionBKey.value : this.regionBKey,
    amount: amount ?? this.amount,
    occurredAt: occurredAt ?? this.occurredAt,
    sessionId: sessionId.present ? sessionId.value : this.sessionId,
    dedupeKey: dedupeKey ?? this.dedupeKey,
    engineVersion: engineVersion ?? this.engineVersion,
  );
  BrainEvent copyWithCompanion(BrainEventsCompanion data) {
    return BrainEvent(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      fieldVersions: data.fieldVersions.present
          ? data.fieldVersions.value
          : this.fieldVersions,
      type: data.type.present ? data.type.value : this.type,
      regionKey: data.regionKey.present ? data.regionKey.value : this.regionKey,
      regionBKey: data.regionBKey.present
          ? data.regionBKey.value
          : this.regionBKey,
      amount: data.amount.present ? data.amount.value : this.amount,
      occurredAt: data.occurredAt.present
          ? data.occurredAt.value
          : this.occurredAt,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      dedupeKey: data.dedupeKey.present ? data.dedupeKey.value : this.dedupeKey,
      engineVersion: data.engineVersion.present
          ? data.engineVersion.value
          : this.engineVersion,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BrainEvent(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('type: $type, ')
          ..write('regionKey: $regionKey, ')
          ..write('regionBKey: $regionBKey, ')
          ..write('amount: $amount, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('sessionId: $sessionId, ')
          ..write('dedupeKey: $dedupeKey, ')
          ..write('engineVersion: $engineVersion')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    updatedAt,
    deletedAt,
    fieldVersions,
    type,
    regionKey,
    regionBKey,
    amount,
    occurredAt,
    sessionId,
    dedupeKey,
    engineVersion,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrainEvent &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.fieldVersions == this.fieldVersions &&
          other.type == this.type &&
          other.regionKey == this.regionKey &&
          other.regionBKey == this.regionBKey &&
          other.amount == this.amount &&
          other.occurredAt == this.occurredAt &&
          other.sessionId == this.sessionId &&
          other.dedupeKey == this.dedupeKey &&
          other.engineVersion == this.engineVersion);
}

class BrainEventsCompanion extends UpdateCompanion<BrainEvent> {
  final Value<String> id;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<Map<String, String>> fieldVersions;
  final Value<String> type;
  final Value<String?> regionKey;
  final Value<String?> regionBKey;
  final Value<int> amount;
  final Value<DateTime> occurredAt;
  final Value<String?> sessionId;
  final Value<String> dedupeKey;
  final Value<int> engineVersion;
  final Value<int> rowid;
  const BrainEventsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    this.type = const Value.absent(),
    this.regionKey = const Value.absent(),
    this.regionBKey = const Value.absent(),
    this.amount = const Value.absent(),
    this.occurredAt = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.dedupeKey = const Value.absent(),
    this.engineVersion = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BrainEventsCompanion.insert({
    required String id,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.fieldVersions = const Value.absent(),
    required String type,
    this.regionKey = const Value.absent(),
    this.regionBKey = const Value.absent(),
    required int amount,
    required DateTime occurredAt,
    this.sessionId = const Value.absent(),
    required String dedupeKey,
    required int engineVersion,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       type = Value(type),
       amount = Value(amount),
       occurredAt = Value(occurredAt),
       dedupeKey = Value(dedupeKey),
       engineVersion = Value(engineVersion);
  static Insertable<BrainEvent> custom({
    Expression<String>? id,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<String>? fieldVersions,
    Expression<String>? type,
    Expression<String>? regionKey,
    Expression<String>? regionBKey,
    Expression<int>? amount,
    Expression<DateTime>? occurredAt,
    Expression<String>? sessionId,
    Expression<String>? dedupeKey,
    Expression<int>? engineVersion,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (fieldVersions != null) 'field_versions': fieldVersions,
      if (type != null) 'type': type,
      if (regionKey != null) 'region_key': regionKey,
      if (regionBKey != null) 'region_b_key': regionBKey,
      if (amount != null) 'amount': amount,
      if (occurredAt != null) 'occurred_at': occurredAt,
      if (sessionId != null) 'session_id': sessionId,
      if (dedupeKey != null) 'dedupe_key': dedupeKey,
      if (engineVersion != null) 'engine_version': engineVersion,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BrainEventsCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<Map<String, String>>? fieldVersions,
    Value<String>? type,
    Value<String?>? regionKey,
    Value<String?>? regionBKey,
    Value<int>? amount,
    Value<DateTime>? occurredAt,
    Value<String?>? sessionId,
    Value<String>? dedupeKey,
    Value<int>? engineVersion,
    Value<int>? rowid,
  }) {
    return BrainEventsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      fieldVersions: fieldVersions ?? this.fieldVersions,
      type: type ?? this.type,
      regionKey: regionKey ?? this.regionKey,
      regionBKey: regionBKey ?? this.regionBKey,
      amount: amount ?? this.amount,
      occurredAt: occurredAt ?? this.occurredAt,
      sessionId: sessionId ?? this.sessionId,
      dedupeKey: dedupeKey ?? this.dedupeKey,
      engineVersion: engineVersion ?? this.engineVersion,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (fieldVersions.present) {
      map['field_versions'] = Variable<String>(
        $BrainEventsTable.$converterfieldVersions.toSql(fieldVersions.value),
      );
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (regionKey.present) {
      map['region_key'] = Variable<String>(regionKey.value);
    }
    if (regionBKey.present) {
      map['region_b_key'] = Variable<String>(regionBKey.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (occurredAt.present) {
      map['occurred_at'] = Variable<DateTime>(occurredAt.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (dedupeKey.present) {
      map['dedupe_key'] = Variable<String>(dedupeKey.value);
    }
    if (engineVersion.present) {
      map['engine_version'] = Variable<int>(engineVersion.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrainEventsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('fieldVersions: $fieldVersions, ')
          ..write('type: $type, ')
          ..write('regionKey: $regionKey, ')
          ..write('regionBKey: $regionBKey, ')
          ..write('amount: $amount, ')
          ..write('occurredAt: $occurredAt, ')
          ..write('sessionId: $sessionId, ')
          ..write('dedupeKey: $dedupeKey, ')
          ..write('engineVersion: $engineVersion, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BrainSnapshotsTable extends BrainSnapshots
    with TableInfo<$BrainSnapshotsTable, BrainSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrainSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _engineVersionMeta = const VerificationMeta(
    'engineVersion',
  );
  @override
  late final GeneratedColumn<int> engineVersion = GeneratedColumn<int>(
    'engine_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _asOfMeta = const VerificationMeta('asOf');
  @override
  late final GeneratedColumn<DateTime> asOf = GeneratedColumn<DateTime>(
    'as_of',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _eventsHashMeta = const VerificationMeta(
    'eventsHash',
  );
  @override
  late final GeneratedColumn<String> eventsHash = GeneratedColumn<String>(
    'events_hash',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Map<String, Object?>, String>
  state = GeneratedColumn<String>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  ).withConverter<Map<String, Object?>>($BrainSnapshotsTable.$converterstate);
  @override
  List<GeneratedColumn> get $columns => [
    engineVersion,
    asOf,
    eventsHash,
    state,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'brain_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<BrainSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('engine_version')) {
      context.handle(
        _engineVersionMeta,
        engineVersion.isAcceptableOrUnknown(
          data['engine_version']!,
          _engineVersionMeta,
        ),
      );
    }
    if (data.containsKey('as_of')) {
      context.handle(
        _asOfMeta,
        asOf.isAcceptableOrUnknown(data['as_of']!, _asOfMeta),
      );
    } else if (isInserting) {
      context.missing(_asOfMeta);
    }
    if (data.containsKey('events_hash')) {
      context.handle(
        _eventsHashMeta,
        eventsHash.isAcceptableOrUnknown(data['events_hash']!, _eventsHashMeta),
      );
    } else if (isInserting) {
      context.missing(_eventsHashMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {engineVersion};
  @override
  BrainSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BrainSnapshot(
      engineVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}engine_version'],
      )!,
      asOf: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}as_of'],
      )!,
      eventsHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}events_hash'],
      )!,
      state: $BrainSnapshotsTable.$converterstate.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}state'],
        )!,
      ),
    );
  }

  @override
  $BrainSnapshotsTable createAlias(String alias) {
    return $BrainSnapshotsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<Map<String, Object?>, String, Object?>
  $converterstate = const JsonValueConverter<Map<String, Object?>>();
}

class BrainSnapshot extends DataClass implements Insertable<BrainSnapshot> {
  final int engineVersion;
  final DateTime asOf;
  final String eventsHash;
  final Map<String, Object?> state;
  const BrainSnapshot({
    required this.engineVersion,
    required this.asOf,
    required this.eventsHash,
    required this.state,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['engine_version'] = Variable<int>(engineVersion);
    map['as_of'] = Variable<DateTime>(asOf);
    map['events_hash'] = Variable<String>(eventsHash);
    {
      map['state'] = Variable<String>(
        $BrainSnapshotsTable.$converterstate.toSql(state),
      );
    }
    return map;
  }

  BrainSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return BrainSnapshotsCompanion(
      engineVersion: Value(engineVersion),
      asOf: Value(asOf),
      eventsHash: Value(eventsHash),
      state: Value(state),
    );
  }

  factory BrainSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BrainSnapshot(
      engineVersion: serializer.fromJson<int>(json['engine_version']),
      asOf: serializer.fromJson<DateTime>(json['as_of']),
      eventsHash: serializer.fromJson<String>(json['events_hash']),
      state: $BrainSnapshotsTable.$converterstate.fromJson(
        serializer.fromJson<Object?>(json['state']),
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'engine_version': serializer.toJson<int>(engineVersion),
      'as_of': serializer.toJson<DateTime>(asOf),
      'events_hash': serializer.toJson<String>(eventsHash),
      'state': serializer.toJson<Object?>(
        $BrainSnapshotsTable.$converterstate.toJson(state),
      ),
    };
  }

  BrainSnapshot copyWith({
    int? engineVersion,
    DateTime? asOf,
    String? eventsHash,
    Map<String, Object?>? state,
  }) => BrainSnapshot(
    engineVersion: engineVersion ?? this.engineVersion,
    asOf: asOf ?? this.asOf,
    eventsHash: eventsHash ?? this.eventsHash,
    state: state ?? this.state,
  );
  BrainSnapshot copyWithCompanion(BrainSnapshotsCompanion data) {
    return BrainSnapshot(
      engineVersion: data.engineVersion.present
          ? data.engineVersion.value
          : this.engineVersion,
      asOf: data.asOf.present ? data.asOf.value : this.asOf,
      eventsHash: data.eventsHash.present
          ? data.eventsHash.value
          : this.eventsHash,
      state: data.state.present ? data.state.value : this.state,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BrainSnapshot(')
          ..write('engineVersion: $engineVersion, ')
          ..write('asOf: $asOf, ')
          ..write('eventsHash: $eventsHash, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(engineVersion, asOf, eventsHash, state);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrainSnapshot &&
          other.engineVersion == this.engineVersion &&
          other.asOf == this.asOf &&
          other.eventsHash == this.eventsHash &&
          other.state == this.state);
}

class BrainSnapshotsCompanion extends UpdateCompanion<BrainSnapshot> {
  final Value<int> engineVersion;
  final Value<DateTime> asOf;
  final Value<String> eventsHash;
  final Value<Map<String, Object?>> state;
  const BrainSnapshotsCompanion({
    this.engineVersion = const Value.absent(),
    this.asOf = const Value.absent(),
    this.eventsHash = const Value.absent(),
    this.state = const Value.absent(),
  });
  BrainSnapshotsCompanion.insert({
    this.engineVersion = const Value.absent(),
    required DateTime asOf,
    required String eventsHash,
    required Map<String, Object?> state,
  }) : asOf = Value(asOf),
       eventsHash = Value(eventsHash),
       state = Value(state);
  static Insertable<BrainSnapshot> custom({
    Expression<int>? engineVersion,
    Expression<DateTime>? asOf,
    Expression<String>? eventsHash,
    Expression<String>? state,
  }) {
    return RawValuesInsertable({
      if (engineVersion != null) 'engine_version': engineVersion,
      if (asOf != null) 'as_of': asOf,
      if (eventsHash != null) 'events_hash': eventsHash,
      if (state != null) 'state': state,
    });
  }

  BrainSnapshotsCompanion copyWith({
    Value<int>? engineVersion,
    Value<DateTime>? asOf,
    Value<String>? eventsHash,
    Value<Map<String, Object?>>? state,
  }) {
    return BrainSnapshotsCompanion(
      engineVersion: engineVersion ?? this.engineVersion,
      asOf: asOf ?? this.asOf,
      eventsHash: eventsHash ?? this.eventsHash,
      state: state ?? this.state,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (engineVersion.present) {
      map['engine_version'] = Variable<int>(engineVersion.value);
    }
    if (asOf.present) {
      map['as_of'] = Variable<DateTime>(asOf.value);
    }
    if (eventsHash.present) {
      map['events_hash'] = Variable<String>(eventsHash.value);
    }
    if (state.present) {
      map['state'] = Variable<String>(
        $BrainSnapshotsTable.$converterstate.toSql(state.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrainSnapshotsCompanion(')
          ..write('engineVersion: $engineVersion, ')
          ..write('asOf: $asOf, ')
          ..write('eventsHash: $eventsHash, ')
          ..write('state: $state')
          ..write(')'))
        .toString();
  }
}

class $SyncOutboxTable extends SyncOutbox
    with TableInfo<$SyncOutboxTable, OutboxEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _targetTableMeta = const VerificationMeta(
    'targetTable',
  );
  @override
  late final GeneratedColumn<String> targetTable = GeneratedColumn<String>(
    'target_table',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetIdMeta = const VerificationMeta(
    'targetId',
  );
  @override
  late final GeneratedColumn<String> targetId = GeneratedColumn<String>(
    'target_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _patchMeta = const VerificationMeta('patch');
  @override
  late final GeneratedColumn<String> patch = GeneratedColumn<String>(
    'patch',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _hlcMeta = const VerificationMeta('hlc');
  @override
  late final GeneratedColumn<String> hlc = GeneratedColumn<String>(
    'hlc',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _deadMeta = const VerificationMeta('dead');
  @override
  late final GeneratedColumn<bool> dead = GeneratedColumn<bool>(
    'dead',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dead" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    seq,
    targetTable,
    targetId,
    patch,
    hlc,
    createdAt,
    attempts,
    lastError,
    dead,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<OutboxEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    }
    if (data.containsKey('target_table')) {
      context.handle(
        _targetTableMeta,
        targetTable.isAcceptableOrUnknown(
          data['target_table']!,
          _targetTableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetTableMeta);
    }
    if (data.containsKey('target_id')) {
      context.handle(
        _targetIdMeta,
        targetId.isAcceptableOrUnknown(data['target_id']!, _targetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_targetIdMeta);
    }
    if (data.containsKey('patch')) {
      context.handle(
        _patchMeta,
        patch.isAcceptableOrUnknown(data['patch']!, _patchMeta),
      );
    } else if (isInserting) {
      context.missing(_patchMeta);
    }
    if (data.containsKey('hlc')) {
      context.handle(
        _hlcMeta,
        hlc.isAcceptableOrUnknown(data['hlc']!, _hlcMeta),
      );
    } else if (isInserting) {
      context.missing(_hlcMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    if (data.containsKey('dead')) {
      context.handle(
        _deadMeta,
        dead.isAcceptableOrUnknown(data['dead']!, _deadMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seq};
  @override
  OutboxEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OutboxEntry(
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      targetTable: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_table'],
      )!,
      targetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_id'],
      )!,
      patch: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}patch'],
      )!,
      hlc: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hlc'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
      dead: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dead'],
      )!,
    );
  }

  @override
  $SyncOutboxTable createAlias(String alias) {
    return $SyncOutboxTable(attachedDatabase, alias);
  }
}

class OutboxEntry extends DataClass implements Insertable<OutboxEntry> {
  final int seq;
  final String targetTable;
  final String targetId;

  /// Yalnız değişen alanlar, sunucu sütun adlarıyla (JSON).
  final String patch;
  final String hlc;
  final DateTime createdAt;
  final int attempts;
  final String? lastError;

  /// Sunucu kalıcı olarak reddetti; veri silinmez, kullanıcıya gösterilir.
  final bool dead;
  const OutboxEntry({
    required this.seq,
    required this.targetTable,
    required this.targetId,
    required this.patch,
    required this.hlc,
    required this.createdAt,
    required this.attempts,
    this.lastError,
    required this.dead,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seq'] = Variable<int>(seq);
    map['target_table'] = Variable<String>(targetTable);
    map['target_id'] = Variable<String>(targetId);
    map['patch'] = Variable<String>(patch);
    map['hlc'] = Variable<String>(hlc);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    map['dead'] = Variable<bool>(dead);
    return map;
  }

  SyncOutboxCompanion toCompanion(bool nullToAbsent) {
    return SyncOutboxCompanion(
      seq: Value(seq),
      targetTable: Value(targetTable),
      targetId: Value(targetId),
      patch: Value(patch),
      hlc: Value(hlc),
      createdAt: Value(createdAt),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent
          ? const Value.absent()
          : Value(lastError),
      dead: Value(dead),
    );
  }

  factory OutboxEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OutboxEntry(
      seq: serializer.fromJson<int>(json['seq']),
      targetTable: serializer.fromJson<String>(json['target_table']),
      targetId: serializer.fromJson<String>(json['target_id']),
      patch: serializer.fromJson<String>(json['patch']),
      hlc: serializer.fromJson<String>(json['hlc']),
      createdAt: serializer.fromJson<DateTime>(json['created_at']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['last_error']),
      dead: serializer.fromJson<bool>(json['dead']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seq': serializer.toJson<int>(seq),
      'target_table': serializer.toJson<String>(targetTable),
      'target_id': serializer.toJson<String>(targetId),
      'patch': serializer.toJson<String>(patch),
      'hlc': serializer.toJson<String>(hlc),
      'created_at': serializer.toJson<DateTime>(createdAt),
      'attempts': serializer.toJson<int>(attempts),
      'last_error': serializer.toJson<String?>(lastError),
      'dead': serializer.toJson<bool>(dead),
    };
  }

  OutboxEntry copyWith({
    int? seq,
    String? targetTable,
    String? targetId,
    String? patch,
    String? hlc,
    DateTime? createdAt,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
    bool? dead,
  }) => OutboxEntry(
    seq: seq ?? this.seq,
    targetTable: targetTable ?? this.targetTable,
    targetId: targetId ?? this.targetId,
    patch: patch ?? this.patch,
    hlc: hlc ?? this.hlc,
    createdAt: createdAt ?? this.createdAt,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
    dead: dead ?? this.dead,
  );
  OutboxEntry copyWithCompanion(SyncOutboxCompanion data) {
    return OutboxEntry(
      seq: data.seq.present ? data.seq.value : this.seq,
      targetTable: data.targetTable.present
          ? data.targetTable.value
          : this.targetTable,
      targetId: data.targetId.present ? data.targetId.value : this.targetId,
      patch: data.patch.present ? data.patch.value : this.patch,
      hlc: data.hlc.present ? data.hlc.value : this.hlc,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
      dead: data.dead.present ? data.dead.value : this.dead,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OutboxEntry(')
          ..write('seq: $seq, ')
          ..write('targetTable: $targetTable, ')
          ..write('targetId: $targetId, ')
          ..write('patch: $patch, ')
          ..write('hlc: $hlc, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('dead: $dead')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    seq,
    targetTable,
    targetId,
    patch,
    hlc,
    createdAt,
    attempts,
    lastError,
    dead,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OutboxEntry &&
          other.seq == this.seq &&
          other.targetTable == this.targetTable &&
          other.targetId == this.targetId &&
          other.patch == this.patch &&
          other.hlc == this.hlc &&
          other.createdAt == this.createdAt &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError &&
          other.dead == this.dead);
}

class SyncOutboxCompanion extends UpdateCompanion<OutboxEntry> {
  final Value<int> seq;
  final Value<String> targetTable;
  final Value<String> targetId;
  final Value<String> patch;
  final Value<String> hlc;
  final Value<DateTime> createdAt;
  final Value<int> attempts;
  final Value<String?> lastError;
  final Value<bool> dead;
  const SyncOutboxCompanion({
    this.seq = const Value.absent(),
    this.targetTable = const Value.absent(),
    this.targetId = const Value.absent(),
    this.patch = const Value.absent(),
    this.hlc = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.dead = const Value.absent(),
  });
  SyncOutboxCompanion.insert({
    this.seq = const Value.absent(),
    required String targetTable,
    required String targetId,
    required String patch,
    required String hlc,
    required DateTime createdAt,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.dead = const Value.absent(),
  }) : targetTable = Value(targetTable),
       targetId = Value(targetId),
       patch = Value(patch),
       hlc = Value(hlc),
       createdAt = Value(createdAt);
  static Insertable<OutboxEntry> custom({
    Expression<int>? seq,
    Expression<String>? targetTable,
    Expression<String>? targetId,
    Expression<String>? patch,
    Expression<String>? hlc,
    Expression<DateTime>? createdAt,
    Expression<int>? attempts,
    Expression<String>? lastError,
    Expression<bool>? dead,
  }) {
    return RawValuesInsertable({
      if (seq != null) 'seq': seq,
      if (targetTable != null) 'target_table': targetTable,
      if (targetId != null) 'target_id': targetId,
      if (patch != null) 'patch': patch,
      if (hlc != null) 'hlc': hlc,
      if (createdAt != null) 'created_at': createdAt,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
      if (dead != null) 'dead': dead,
    });
  }

  SyncOutboxCompanion copyWith({
    Value<int>? seq,
    Value<String>? targetTable,
    Value<String>? targetId,
    Value<String>? patch,
    Value<String>? hlc,
    Value<DateTime>? createdAt,
    Value<int>? attempts,
    Value<String?>? lastError,
    Value<bool>? dead,
  }) {
    return SyncOutboxCompanion(
      seq: seq ?? this.seq,
      targetTable: targetTable ?? this.targetTable,
      targetId: targetId ?? this.targetId,
      patch: patch ?? this.patch,
      hlc: hlc ?? this.hlc,
      createdAt: createdAt ?? this.createdAt,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
      dead: dead ?? this.dead,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (targetTable.present) {
      map['target_table'] = Variable<String>(targetTable.value);
    }
    if (targetId.present) {
      map['target_id'] = Variable<String>(targetId.value);
    }
    if (patch.present) {
      map['patch'] = Variable<String>(patch.value);
    }
    if (hlc.present) {
      map['hlc'] = Variable<String>(hlc.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (dead.present) {
      map['dead'] = Variable<bool>(dead.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOutboxCompanion(')
          ..write('seq: $seq, ')
          ..write('targetTable: $targetTable, ')
          ..write('targetId: $targetId, ')
          ..write('patch: $patch, ')
          ..write('hlc: $hlc, ')
          ..write('createdAt: $createdAt, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError, ')
          ..write('dead: $dead')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState
    with TableInfo<$SyncStateTable, SyncStateEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncStateEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateEntry extends DataClass implements Insertable<SyncStateEntry> {
  final String key;
  final String value;
  const SyncStateEntry({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(key: Value(key), value: Value(value));
  }

  factory SyncStateEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SyncStateEntry copyWith({String? key, String? value}) =>
      SyncStateEntry(key: key ?? this.key, value: value ?? this.value);
  SyncStateEntry copyWithCompanion(SyncStateCompanion data) {
    return SyncStateEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateEntry(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncStateEntry &&
          other.key == this.key &&
          other.value == this.value);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncStateCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStateCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SyncStateEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStateCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SyncStateCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RootCategoriesTable rootCategories = $RootCategoriesTable(this);
  late final $BrainRegionsTable brainRegions = $BrainRegionsTable(this);
  late final $CategoryRegionWeightsTable categoryRegionWeights =
      $CategoryRegionWeightsTable(this);
  late final $ProfilesTable profiles = $ProfilesTable(this);
  late final $UserCategoriesTable userCategories = $UserCategoriesTable(this);
  late final $VariantGroupsTable variantGroups = $VariantGroupsTable(this);
  late final $VariantsTable variants = $VariantsTable(this);
  late final $ActivitiesTable activities = $ActivitiesTable(this);
  late final $ScheduleRulesTable scheduleRules = $ScheduleRulesTable(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $DayOverridesTable dayOverrides = $DayOverridesTable(this);
  late final $PlanInstancesTable planInstances = $PlanInstancesTable(this);
  late final $FocusSessionsTable focusSessions = $FocusSessionsTable(this);
  late final $FocusInterruptionsTable focusInterruptions =
      $FocusInterruptionsTable(this);
  late final $BrainEventsTable brainEvents = $BrainEventsTable(this);
  late final $BrainSnapshotsTable brainSnapshots = $BrainSnapshotsTable(this);
  late final $SyncOutboxTable syncOutbox = $SyncOutboxTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    rootCategories,
    brainRegions,
    categoryRegionWeights,
    profiles,
    userCategories,
    variantGroups,
    variants,
    activities,
    scheduleRules,
    projects,
    dayOverrides,
    planInstances,
    focusSessions,
    focusInterruptions,
    brainEvents,
    brainSnapshots,
    syncOutbox,
    syncState,
  ];
  @override
  DriftDatabaseOptions get options =>
      const DriftDatabaseOptions(storeDateTimeAsText: true);
}

typedef $$RootCategoriesTableCreateCompanionBuilder =
    RootCategoriesCompanion Function({
      required String key,
      required int sortOrder,
      required String nameTr,
      required String nameEn,
      required String descriptionTr,
      required String descriptionEn,
      required String icon,
      required String color,
      Value<int> rowid,
    });
typedef $$RootCategoriesTableUpdateCompanionBuilder =
    RootCategoriesCompanion Function({
      Value<String> key,
      Value<int> sortOrder,
      Value<String> nameTr,
      Value<String> nameEn,
      Value<String> descriptionTr,
      Value<String> descriptionEn,
      Value<String> icon,
      Value<String> color,
      Value<int> rowid,
    });

final class $$RootCategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $RootCategoriesTable, RootCategory> {
  $$RootCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $CategoryRegionWeightsTable,
    List<CategoryRegionWeight>
  >
  _categoryRegionWeightsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.categoryRegionWeights,
        aliasName:
            'root_categories__key__category_region_weights__root_category_key',
      );

  $$CategoryRegionWeightsTableProcessedTableManager
  get categoryRegionWeightsRefs {
    final manager =
        $$CategoryRegionWeightsTableTableManager(
          $_db,
          $_db.categoryRegionWeights,
        ).filter(
          (f) => f.rootCategoryKey.key.sqlEquals($_itemColumn<String>('key')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _categoryRegionWeightsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$UserCategoriesTable, List<UserCategory>>
  _userCategoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.userCategories,
    aliasName: 'root_categories__key__user_categories__root_category_key',
  );

  $$UserCategoriesTableProcessedTableManager get userCategoriesRefs {
    final manager = $$UserCategoriesTableTableManager($_db, $_db.userCategories)
        .filter(
          (f) => f.rootCategoryKey.key.sqlEquals($_itemColumn<String>('key')!),
        );

    final cache = $_typedResult.readTableOrNull(_userCategoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ActivitiesTable, List<Activity>>
  _activitiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.activities,
    aliasName: 'root_categories__key__activities__root_category_key',
  );

  $$ActivitiesTableProcessedTableManager get activitiesRefs {
    final manager = $$ActivitiesTableTableManager($_db, $_db.activities).filter(
      (f) => f.rootCategoryKey.key.sqlEquals($_itemColumn<String>('key')!),
    );

    final cache = $_typedResult.readTableOrNull(_activitiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FocusSessionsTable, List<FocusSession>>
  _focusSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.focusSessions,
    aliasName: 'root_categories__key__focus_sessions__root_category_key',
  );

  $$FocusSessionsTableProcessedTableManager get focusSessionsRefs {
    final manager = $$FocusSessionsTableTableManager($_db, $_db.focusSessions)
        .filter(
          (f) => f.rootCategoryKey.key.sqlEquals($_itemColumn<String>('key')!),
        );

    final cache = $_typedResult.readTableOrNull(_focusSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RootCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $RootCategoriesTable> {
  $$RootCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameTr => $composableBuilder(
    column: $table.nameTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionTr => $composableBuilder(
    column: $table.descriptionTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> categoryRegionWeightsRefs(
    Expression<bool> Function($$CategoryRegionWeightsTableFilterComposer f) f,
  ) {
    final $$CategoryRegionWeightsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.key,
          referencedTable: $db.categoryRegionWeights,
          getReferencedColumn: (t) => t.rootCategoryKey,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CategoryRegionWeightsTableFilterComposer(
                $db: $db,
                $table: $db.categoryRegionWeights,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> userCategoriesRefs(
    Expression<bool> Function($$UserCategoriesTableFilterComposer f) f,
  ) {
    final $$UserCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.key,
      referencedTable: $db.userCategories,
      getReferencedColumn: (t) => t.rootCategoryKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.userCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> activitiesRefs(
    Expression<bool> Function($$ActivitiesTableFilterComposer f) f,
  ) {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.key,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.rootCategoryKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> focusSessionsRefs(
    Expression<bool> Function($$FocusSessionsTableFilterComposer f) f,
  ) {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.key,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.rootCategoryKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RootCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $RootCategoriesTable> {
  $$RootCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameTr => $composableBuilder(
    column: $table.nameTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionTr => $composableBuilder(
    column: $table.descriptionTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RootCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RootCategoriesTable> {
  $$RootCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get nameTr =>
      $composableBuilder(column: $table.nameTr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get descriptionTr => $composableBuilder(
    column: $table.descriptionTr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get descriptionEn => $composableBuilder(
    column: $table.descriptionEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  Expression<T> categoryRegionWeightsRefs<T extends Object>(
    Expression<T> Function($$CategoryRegionWeightsTableAnnotationComposer a) f,
  ) {
    final $$CategoryRegionWeightsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.key,
          referencedTable: $db.categoryRegionWeights,
          getReferencedColumn: (t) => t.rootCategoryKey,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CategoryRegionWeightsTableAnnotationComposer(
                $db: $db,
                $table: $db.categoryRegionWeights,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> userCategoriesRefs<T extends Object>(
    Expression<T> Function($$UserCategoriesTableAnnotationComposer a) f,
  ) {
    final $$UserCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.key,
      referencedTable: $db.userCategories,
      getReferencedColumn: (t) => t.rootCategoryKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.userCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> activitiesRefs<T extends Object>(
    Expression<T> Function($$ActivitiesTableAnnotationComposer a) f,
  ) {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.key,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.rootCategoryKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> focusSessionsRefs<T extends Object>(
    Expression<T> Function($$FocusSessionsTableAnnotationComposer a) f,
  ) {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.key,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.rootCategoryKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RootCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RootCategoriesTable,
          RootCategory,
          $$RootCategoriesTableFilterComposer,
          $$RootCategoriesTableOrderingComposer,
          $$RootCategoriesTableAnnotationComposer,
          $$RootCategoriesTableCreateCompanionBuilder,
          $$RootCategoriesTableUpdateCompanionBuilder,
          (RootCategory, $$RootCategoriesTableReferences),
          RootCategory,
          PrefetchHooks Function({
            bool categoryRegionWeightsRefs,
            bool userCategoriesRefs,
            bool activitiesRefs,
            bool focusSessionsRefs,
          })
        > {
  $$RootCategoriesTableTableManager(
    _$AppDatabase db,
    $RootCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RootCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RootCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RootCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> nameTr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> descriptionTr = const Value.absent(),
                Value<String> descriptionEn = const Value.absent(),
                Value<String> icon = const Value.absent(),
                Value<String> color = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RootCategoriesCompanion(
                key: key,
                sortOrder: sortOrder,
                nameTr: nameTr,
                nameEn: nameEn,
                descriptionTr: descriptionTr,
                descriptionEn: descriptionEn,
                icon: icon,
                color: color,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required int sortOrder,
                required String nameTr,
                required String nameEn,
                required String descriptionTr,
                required String descriptionEn,
                required String icon,
                required String color,
                Value<int> rowid = const Value.absent(),
              }) => RootCategoriesCompanion.insert(
                key: key,
                sortOrder: sortOrder,
                nameTr: nameTr,
                nameEn: nameEn,
                descriptionTr: descriptionTr,
                descriptionEn: descriptionEn,
                icon: icon,
                color: color,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RootCategoriesTable, RootCategory>(table),
                  $$RootCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryRegionWeightsRefs = false,
                userCategoriesRefs = false,
                activitiesRefs = false,
                focusSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (categoryRegionWeightsRefs) db.categoryRegionWeights,
                    if (userCategoriesRefs) db.userCategories,
                    if (activitiesRefs) db.activities,
                    if (focusSessionsRefs) db.focusSessions,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (categoryRegionWeightsRefs)
                        await $_getPrefetchedDataByColumns<
                          RootCategory,
                          $RootCategoriesTable,
                          CategoryRegionWeight,
                          $CategoryRegionWeightsTable
                        >(
                          currentTable: table,
                          referencedTable: $$RootCategoriesTableReferences
                              ._categoryRegionWeightsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RootCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).categoryRegionWeightsRefs,
                          currentColumn: 'key',
                          referencedColumn: 'root_category_key',
                          typedResults: items,
                        ),
                      if (userCategoriesRefs)
                        await $_getPrefetchedDataByColumns<
                          RootCategory,
                          $RootCategoriesTable,
                          UserCategory,
                          $UserCategoriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$RootCategoriesTableReferences
                              ._userCategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RootCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).userCategoriesRefs,
                          currentColumn: 'key',
                          referencedColumn: 'root_category_key',
                          typedResults: items,
                        ),
                      if (activitiesRefs)
                        await $_getPrefetchedDataByColumns<
                          RootCategory,
                          $RootCategoriesTable,
                          Activity,
                          $ActivitiesTable
                        >(
                          currentTable: table,
                          referencedTable: $$RootCategoriesTableReferences
                              ._activitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RootCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).activitiesRefs,
                          currentColumn: 'key',
                          referencedColumn: 'root_category_key',
                          typedResults: items,
                        ),
                      if (focusSessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          RootCategory,
                          $RootCategoriesTable,
                          FocusSession,
                          $FocusSessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$RootCategoriesTableReferences
                              ._focusSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RootCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).focusSessionsRefs,
                          currentColumn: 'key',
                          referencedColumn: 'root_category_key',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RootCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RootCategoriesTable,
      RootCategory,
      $$RootCategoriesTableFilterComposer,
      $$RootCategoriesTableOrderingComposer,
      $$RootCategoriesTableAnnotationComposer,
      $$RootCategoriesTableCreateCompanionBuilder,
      $$RootCategoriesTableUpdateCompanionBuilder,
      (RootCategory, $$RootCategoriesTableReferences),
      RootCategory,
      PrefetchHooks Function({
        bool categoryRegionWeightsRefs,
        bool userCategoriesRefs,
        bool activitiesRefs,
        bool focusSessionsRefs,
      })
    >;
typedef $$BrainRegionsTableCreateCompanionBuilder =
    BrainRegionsCompanion Function({
      required String key,
      required int sortOrder,
      required String nameTr,
      required String nameEn,
      required String hemisphere,
      required String meshName,
      Value<bool> isInner,
      Value<int> rowid,
    });
typedef $$BrainRegionsTableUpdateCompanionBuilder =
    BrainRegionsCompanion Function({
      Value<String> key,
      Value<int> sortOrder,
      Value<String> nameTr,
      Value<String> nameEn,
      Value<String> hemisphere,
      Value<String> meshName,
      Value<bool> isInner,
      Value<int> rowid,
    });

final class $$BrainRegionsTableReferences
    extends BaseReferences<_$AppDatabase, $BrainRegionsTable, BrainRegion> {
  $$BrainRegionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<
    $CategoryRegionWeightsTable,
    List<CategoryRegionWeight>
  >
  _categoryRegionWeightsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.categoryRegionWeights,
        aliasName: 'brain_regions__key__category_region_weights__region_key',
      );

  $$CategoryRegionWeightsTableProcessedTableManager
  get categoryRegionWeightsRefs {
    final manager = $$CategoryRegionWeightsTableTableManager(
      $_db,
      $_db.categoryRegionWeights,
    ).filter((f) => f.regionKey.key.sqlEquals($_itemColumn<String>('key')!));

    final cache = $_typedResult.readTableOrNull(
      _categoryRegionWeightsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BrainEventsTable, List<BrainEvent>>
  _eventsAsRegionTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.brainEvents,
    aliasName: 'brain_regions__key__brain_events__region_key',
  );

  $$BrainEventsTableProcessedTableManager get eventsAsRegion {
    final manager = $$BrainEventsTableTableManager(
      $_db,
      $_db.brainEvents,
    ).filter((f) => f.regionKey.key.sqlEquals($_itemColumn<String>('key')!));

    final cache = $_typedResult.readTableOrNull(_eventsAsRegionTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BrainEventsTable, List<BrainEvent>>
  _eventsAsRegionBTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.brainEvents,
    aliasName: 'brain_regions__key__brain_events__region_b_key',
  );

  $$BrainEventsTableProcessedTableManager get eventsAsRegionB {
    final manager = $$BrainEventsTableTableManager(
      $_db,
      $_db.brainEvents,
    ).filter((f) => f.regionBKey.key.sqlEquals($_itemColumn<String>('key')!));

    final cache = $_typedResult.readTableOrNull(_eventsAsRegionBTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BrainRegionsTableFilterComposer
    extends Composer<_$AppDatabase, $BrainRegionsTable> {
  $$BrainRegionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameTr => $composableBuilder(
    column: $table.nameTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hemisphere => $composableBuilder(
    column: $table.hemisphere,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meshName => $composableBuilder(
    column: $table.meshName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInner => $composableBuilder(
    column: $table.isInner,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> categoryRegionWeightsRefs(
    Expression<bool> Function($$CategoryRegionWeightsTableFilterComposer f) f,
  ) {
    final $$CategoryRegionWeightsTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.key,
          referencedTable: $db.categoryRegionWeights,
          getReferencedColumn: (t) => t.regionKey,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CategoryRegionWeightsTableFilterComposer(
                $db: $db,
                $table: $db.categoryRegionWeights,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> eventsAsRegion(
    Expression<bool> Function($$BrainEventsTableFilterComposer f) f,
  ) {
    final $$BrainEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.key,
      referencedTable: $db.brainEvents,
      getReferencedColumn: (t) => t.regionKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainEventsTableFilterComposer(
            $db: $db,
            $table: $db.brainEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> eventsAsRegionB(
    Expression<bool> Function($$BrainEventsTableFilterComposer f) f,
  ) {
    final $$BrainEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.key,
      referencedTable: $db.brainEvents,
      getReferencedColumn: (t) => t.regionBKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainEventsTableFilterComposer(
            $db: $db,
            $table: $db.brainEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BrainRegionsTableOrderingComposer
    extends Composer<_$AppDatabase, $BrainRegionsTable> {
  $$BrainRegionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameTr => $composableBuilder(
    column: $table.nameTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameEn => $composableBuilder(
    column: $table.nameEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hemisphere => $composableBuilder(
    column: $table.hemisphere,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meshName => $composableBuilder(
    column: $table.meshName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInner => $composableBuilder(
    column: $table.isInner,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrainRegionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BrainRegionsTable> {
  $$BrainRegionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get nameTr =>
      $composableBuilder(column: $table.nameTr, builder: (column) => column);

  GeneratedColumn<String> get nameEn =>
      $composableBuilder(column: $table.nameEn, builder: (column) => column);

  GeneratedColumn<String> get hemisphere => $composableBuilder(
    column: $table.hemisphere,
    builder: (column) => column,
  );

  GeneratedColumn<String> get meshName =>
      $composableBuilder(column: $table.meshName, builder: (column) => column);

  GeneratedColumn<bool> get isInner =>
      $composableBuilder(column: $table.isInner, builder: (column) => column);

  Expression<T> categoryRegionWeightsRefs<T extends Object>(
    Expression<T> Function($$CategoryRegionWeightsTableAnnotationComposer a) f,
  ) {
    final $$CategoryRegionWeightsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.key,
          referencedTable: $db.categoryRegionWeights,
          getReferencedColumn: (t) => t.regionKey,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CategoryRegionWeightsTableAnnotationComposer(
                $db: $db,
                $table: $db.categoryRegionWeights,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> eventsAsRegion<T extends Object>(
    Expression<T> Function($$BrainEventsTableAnnotationComposer a) f,
  ) {
    final $$BrainEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.key,
      referencedTable: $db.brainEvents,
      getReferencedColumn: (t) => t.regionKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.brainEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> eventsAsRegionB<T extends Object>(
    Expression<T> Function($$BrainEventsTableAnnotationComposer a) f,
  ) {
    final $$BrainEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.key,
      referencedTable: $db.brainEvents,
      getReferencedColumn: (t) => t.regionBKey,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.brainEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BrainRegionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BrainRegionsTable,
          BrainRegion,
          $$BrainRegionsTableFilterComposer,
          $$BrainRegionsTableOrderingComposer,
          $$BrainRegionsTableAnnotationComposer,
          $$BrainRegionsTableCreateCompanionBuilder,
          $$BrainRegionsTableUpdateCompanionBuilder,
          (BrainRegion, $$BrainRegionsTableReferences),
          BrainRegion,
          PrefetchHooks Function({
            bool categoryRegionWeightsRefs,
            bool eventsAsRegion,
            bool eventsAsRegionB,
          })
        > {
  $$BrainRegionsTableTableManager(_$AppDatabase db, $BrainRegionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrainRegionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrainRegionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrainRegionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> nameTr = const Value.absent(),
                Value<String> nameEn = const Value.absent(),
                Value<String> hemisphere = const Value.absent(),
                Value<String> meshName = const Value.absent(),
                Value<bool> isInner = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BrainRegionsCompanion(
                key: key,
                sortOrder: sortOrder,
                nameTr: nameTr,
                nameEn: nameEn,
                hemisphere: hemisphere,
                meshName: meshName,
                isInner: isInner,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required int sortOrder,
                required String nameTr,
                required String nameEn,
                required String hemisphere,
                required String meshName,
                Value<bool> isInner = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BrainRegionsCompanion.insert(
                key: key,
                sortOrder: sortOrder,
                nameTr: nameTr,
                nameEn: nameEn,
                hemisphere: hemisphere,
                meshName: meshName,
                isInner: isInner,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BrainRegionsTable, BrainRegion>(table),
                  $$BrainRegionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryRegionWeightsRefs = false,
                eventsAsRegion = false,
                eventsAsRegionB = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (categoryRegionWeightsRefs) db.categoryRegionWeights,
                    if (eventsAsRegion) db.brainEvents,
                    if (eventsAsRegionB) db.brainEvents,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (categoryRegionWeightsRefs)
                        await $_getPrefetchedDataByColumns<
                          BrainRegion,
                          $BrainRegionsTable,
                          CategoryRegionWeight,
                          $CategoryRegionWeightsTable
                        >(
                          currentTable: table,
                          referencedTable: $$BrainRegionsTableReferences
                              ._categoryRegionWeightsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BrainRegionsTableReferences(
                                db,
                                table,
                                p0,
                              ).categoryRegionWeightsRefs,
                          currentColumn: 'key',
                          referencedColumn: 'region_key',
                          typedResults: items,
                        ),
                      if (eventsAsRegion)
                        await $_getPrefetchedDataByColumns<
                          BrainRegion,
                          $BrainRegionsTable,
                          BrainEvent,
                          $BrainEventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$BrainRegionsTableReferences
                              ._eventsAsRegionTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BrainRegionsTableReferences(
                                db,
                                table,
                                p0,
                              ).eventsAsRegion,
                          currentColumn: 'key',
                          referencedColumn: 'region_key',
                          typedResults: items,
                        ),
                      if (eventsAsRegionB)
                        await $_getPrefetchedDataByColumns<
                          BrainRegion,
                          $BrainRegionsTable,
                          BrainEvent,
                          $BrainEventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$BrainRegionsTableReferences
                              ._eventsAsRegionBTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BrainRegionsTableReferences(
                                db,
                                table,
                                p0,
                              ).eventsAsRegionB,
                          currentColumn: 'key',
                          referencedColumn: 'region_b_key',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BrainRegionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BrainRegionsTable,
      BrainRegion,
      $$BrainRegionsTableFilterComposer,
      $$BrainRegionsTableOrderingComposer,
      $$BrainRegionsTableAnnotationComposer,
      $$BrainRegionsTableCreateCompanionBuilder,
      $$BrainRegionsTableUpdateCompanionBuilder,
      (BrainRegion, $$BrainRegionsTableReferences),
      BrainRegion,
      PrefetchHooks Function({
        bool categoryRegionWeightsRefs,
        bool eventsAsRegion,
        bool eventsAsRegionB,
      })
    >;
typedef $$CategoryRegionWeightsTableCreateCompanionBuilder =
    CategoryRegionWeightsCompanion Function({
      required String rootCategoryKey,
      required String regionKey,
      required double weight,
      required String evidenceLevel,
      required List<String> sourceIds,
      required List<String> sourceUrls,
      Value<String> detailTr,
      Value<String> detailEn,
      Value<int> rowid,
    });
typedef $$CategoryRegionWeightsTableUpdateCompanionBuilder =
    CategoryRegionWeightsCompanion Function({
      Value<String> rootCategoryKey,
      Value<String> regionKey,
      Value<double> weight,
      Value<String> evidenceLevel,
      Value<List<String>> sourceIds,
      Value<List<String>> sourceUrls,
      Value<String> detailTr,
      Value<String> detailEn,
      Value<int> rowid,
    });

final class $$CategoryRegionWeightsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CategoryRegionWeightsTable,
          CategoryRegionWeight
        > {
  $$CategoryRegionWeightsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $RootCategoriesTable _rootCategoryKeyTable(_$AppDatabase db) =>
      db.rootCategories.createAlias(
        'category_region_weights__root_category_key__root_categories__key',
      );

  $$RootCategoriesTableProcessedTableManager get rootCategoryKey {
    final $_column = $_itemColumn<String>('root_category_key')!;

    final manager = $$RootCategoriesTableTableManager(
      $_db,
      $_db.rootCategories,
    ).filter((f) => f.key.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rootCategoryKeyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BrainRegionsTable _regionKeyTable(_$AppDatabase db) => db.brainRegions
      .createAlias('category_region_weights__region_key__brain_regions__key');

  $$BrainRegionsTableProcessedTableManager get regionKey {
    final $_column = $_itemColumn<String>('region_key')!;

    final manager = $$BrainRegionsTableTableManager(
      $_db,
      $_db.brainRegions,
    ).filter((f) => f.key.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_regionKeyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CategoryRegionWeightsTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryRegionWeightsTable> {
  $$CategoryRegionWeightsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get evidenceLevel => $composableBuilder(
    column: $table.evidenceLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get sourceIds => $composableBuilder(
    column: $table.sourceIds,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get sourceUrls => $composableBuilder(
    column: $table.sourceUrls,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get detailTr => $composableBuilder(
    column: $table.detailTr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get detailEn => $composableBuilder(
    column: $table.detailEn,
    builder: (column) => ColumnFilters(column),
  );

  $$RootCategoriesTableFilterComposer get rootCategoryKey {
    final $$RootCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootCategoryKey,
      referencedTable: $db.rootCategories,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.rootCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BrainRegionsTableFilterComposer get regionKey {
    final $$BrainRegionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.regionKey,
      referencedTable: $db.brainRegions,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainRegionsTableFilterComposer(
            $db: $db,
            $table: $db.brainRegions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryRegionWeightsTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryRegionWeightsTable> {
  $$CategoryRegionWeightsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get evidenceLevel => $composableBuilder(
    column: $table.evidenceLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceIds => $composableBuilder(
    column: $table.sourceIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceUrls => $composableBuilder(
    column: $table.sourceUrls,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailTr => $composableBuilder(
    column: $table.detailTr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get detailEn => $composableBuilder(
    column: $table.detailEn,
    builder: (column) => ColumnOrderings(column),
  );

  $$RootCategoriesTableOrderingComposer get rootCategoryKey {
    final $$RootCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootCategoryKey,
      referencedTable: $db.rootCategories,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.rootCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BrainRegionsTableOrderingComposer get regionKey {
    final $$BrainRegionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.regionKey,
      referencedTable: $db.brainRegions,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainRegionsTableOrderingComposer(
            $db: $db,
            $table: $db.brainRegions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryRegionWeightsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryRegionWeightsTable> {
  $$CategoryRegionWeightsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<String> get evidenceLevel => $composableBuilder(
    column: $table.evidenceLevel,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get sourceIds =>
      $composableBuilder(column: $table.sourceIds, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get sourceUrls =>
      $composableBuilder(
        column: $table.sourceUrls,
        builder: (column) => column,
      );

  GeneratedColumn<String> get detailTr =>
      $composableBuilder(column: $table.detailTr, builder: (column) => column);

  GeneratedColumn<String> get detailEn =>
      $composableBuilder(column: $table.detailEn, builder: (column) => column);

  $$RootCategoriesTableAnnotationComposer get rootCategoryKey {
    final $$RootCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootCategoryKey,
      referencedTable: $db.rootCategories,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.rootCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BrainRegionsTableAnnotationComposer get regionKey {
    final $$BrainRegionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.regionKey,
      referencedTable: $db.brainRegions,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainRegionsTableAnnotationComposer(
            $db: $db,
            $table: $db.brainRegions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoryRegionWeightsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoryRegionWeightsTable,
          CategoryRegionWeight,
          $$CategoryRegionWeightsTableFilterComposer,
          $$CategoryRegionWeightsTableOrderingComposer,
          $$CategoryRegionWeightsTableAnnotationComposer,
          $$CategoryRegionWeightsTableCreateCompanionBuilder,
          $$CategoryRegionWeightsTableUpdateCompanionBuilder,
          (CategoryRegionWeight, $$CategoryRegionWeightsTableReferences),
          CategoryRegionWeight,
          PrefetchHooks Function({bool rootCategoryKey, bool regionKey})
        > {
  $$CategoryRegionWeightsTableTableManager(
    _$AppDatabase db,
    $CategoryRegionWeightsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryRegionWeightsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$CategoryRegionWeightsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CategoryRegionWeightsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> rootCategoryKey = const Value.absent(),
                Value<String> regionKey = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<String> evidenceLevel = const Value.absent(),
                Value<List<String>> sourceIds = const Value.absent(),
                Value<List<String>> sourceUrls = const Value.absent(),
                Value<String> detailTr = const Value.absent(),
                Value<String> detailEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryRegionWeightsCompanion(
                rootCategoryKey: rootCategoryKey,
                regionKey: regionKey,
                weight: weight,
                evidenceLevel: evidenceLevel,
                sourceIds: sourceIds,
                sourceUrls: sourceUrls,
                detailTr: detailTr,
                detailEn: detailEn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String rootCategoryKey,
                required String regionKey,
                required double weight,
                required String evidenceLevel,
                required List<String> sourceIds,
                required List<String> sourceUrls,
                Value<String> detailTr = const Value.absent(),
                Value<String> detailEn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryRegionWeightsCompanion.insert(
                rootCategoryKey: rootCategoryKey,
                regionKey: regionKey,
                weight: weight,
                evidenceLevel: evidenceLevel,
                sourceIds: sourceIds,
                sourceUrls: sourceUrls,
                detailTr: detailTr,
                detailEn: detailEn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $CategoryRegionWeightsTable,
                    CategoryRegionWeight
                  >(table),
                  $$CategoryRegionWeightsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({rootCategoryKey = false, regionKey = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (rootCategoryKey) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.rootCategoryKey,
                            referencedTable:
                                $$CategoryRegionWeightsTableReferences
                                    ._rootCategoryKeyTable(db),
                            referencedColumn:
                                $$CategoryRegionWeightsTableReferences
                                    ._rootCategoryKeyTable(db)
                                    .key,
                          ) as T;
                        }
                        if (regionKey) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.regionKey,
                            referencedTable:
                                $$CategoryRegionWeightsTableReferences
                                    ._regionKeyTable(db),
                            referencedColumn:
                                $$CategoryRegionWeightsTableReferences
                                    ._regionKeyTable(db)
                                    .key,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$CategoryRegionWeightsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoryRegionWeightsTable,
      CategoryRegionWeight,
      $$CategoryRegionWeightsTableFilterComposer,
      $$CategoryRegionWeightsTableOrderingComposer,
      $$CategoryRegionWeightsTableAnnotationComposer,
      $$CategoryRegionWeightsTableCreateCompanionBuilder,
      $$CategoryRegionWeightsTableUpdateCompanionBuilder,
      (CategoryRegionWeight, $$CategoryRegionWeightsTableReferences),
      CategoryRegionWeight,
      PrefetchHooks Function({bool rootCategoryKey, bool regionKey})
    >;
typedef $$ProfilesTableCreateCompanionBuilder = ProfilesCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<Map<String, String>> fieldVersions,
  Value<String?> displayName,
  Value<String?> locale,
  Value<String?> theme,
  Value<String> themeMode,
  required String timezone,
  Value<int?> sleepGoalMinutes,
  Value<int?> birthYear,
  Value<DateTime?> onboardingCompletedAt,
  Value<double?> locationLat,
  Value<double?> locationLon,
  Value<String?> locationLabel,
  Value<String?> prayerMethod,
  Value<String?> prayerMadhab,
  Value<int?> minChunkMinutes,
  Value<int?> chunkBufferMinutes,
  Value<int?> dailyFocusCapMinutes,
  Value<bool> hapticsEnabled,
  Value<int> rowid,
});
typedef $$ProfilesTableUpdateCompanionBuilder = ProfilesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<Map<String, String>> fieldVersions,
  Value<String?> displayName,
  Value<String?> locale,
  Value<String?> theme,
  Value<String> themeMode,
  Value<String> timezone,
  Value<int?> sleepGoalMinutes,
  Value<int?> birthYear,
  Value<DateTime?> onboardingCompletedAt,
  Value<double?> locationLat,
  Value<double?> locationLon,
  Value<String?> locationLabel,
  Value<String?> prayerMethod,
  Value<String?> prayerMadhab,
  Value<int?> minChunkMinutes,
  Value<int?> chunkBufferMinutes,
  Value<int?> dailyFocusCapMinutes,
  Value<bool> hapticsEnabled,
  Value<int> rowid,
});

class $$ProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sleepGoalMinutes => $composableBuilder(
    column: $table.sleepGoalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get onboardingCompletedAt => $composableBuilder(
    column: $table.onboardingCompletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get locationLat => $composableBuilder(
    column: $table.locationLat,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get locationLon => $composableBuilder(
    column: $table.locationLon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locationLabel => $composableBuilder(
    column: $table.locationLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prayerMethod => $composableBuilder(
    column: $table.prayerMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prayerMadhab => $composableBuilder(
    column: $table.prayerMadhab,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minChunkMinutes => $composableBuilder(
    column: $table.minChunkMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get chunkBufferMinutes => $composableBuilder(
    column: $table.chunkBufferMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyFocusCapMinutes => $composableBuilder(
    column: $table.dailyFocusCapMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get theme => $composableBuilder(
    column: $table.theme,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timezone => $composableBuilder(
    column: $table.timezone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sleepGoalMinutes => $composableBuilder(
    column: $table.sleepGoalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get birthYear => $composableBuilder(
    column: $table.birthYear,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get onboardingCompletedAt => $composableBuilder(
    column: $table.onboardingCompletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get locationLat => $composableBuilder(
    column: $table.locationLat,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get locationLon => $composableBuilder(
    column: $table.locationLon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locationLabel => $composableBuilder(
    column: $table.locationLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prayerMethod => $composableBuilder(
    column: $table.prayerMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prayerMadhab => $composableBuilder(
    column: $table.prayerMadhab,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minChunkMinutes => $composableBuilder(
    column: $table.minChunkMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get chunkBufferMinutes => $composableBuilder(
    column: $table.chunkBufferMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyFocusCapMinutes => $composableBuilder(
    column: $table.dailyFocusCapMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProfilesTable> {
  $$ProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>, String>
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);

  GeneratedColumn<String> get theme =>
      $composableBuilder(column: $table.theme, builder: (column) => column);

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get timezone =>
      $composableBuilder(column: $table.timezone, builder: (column) => column);

  GeneratedColumn<int> get sleepGoalMinutes => $composableBuilder(
    column: $table.sleepGoalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get birthYear =>
      $composableBuilder(column: $table.birthYear, builder: (column) => column);

  GeneratedColumn<DateTime> get onboardingCompletedAt => $composableBuilder(
    column: $table.onboardingCompletedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get locationLat => $composableBuilder(
    column: $table.locationLat,
    builder: (column) => column,
  );

  GeneratedColumn<double> get locationLon => $composableBuilder(
    column: $table.locationLon,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locationLabel => $composableBuilder(
    column: $table.locationLabel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prayerMethod => $composableBuilder(
    column: $table.prayerMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get prayerMadhab => $composableBuilder(
    column: $table.prayerMadhab,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minChunkMinutes => $composableBuilder(
    column: $table.minChunkMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get chunkBufferMinutes => $composableBuilder(
    column: $table.chunkBufferMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyFocusCapMinutes => $composableBuilder(
    column: $table.dailyFocusCapMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get hapticsEnabled => $composableBuilder(
    column: $table.hapticsEnabled,
    builder: (column) => column,
  );
}

class $$ProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProfilesTable,
          Profile,
          $$ProfilesTableFilterComposer,
          $$ProfilesTableOrderingComposer,
          $$ProfilesTableAnnotationComposer,
          $$ProfilesTableCreateCompanionBuilder,
          $$ProfilesTableUpdateCompanionBuilder,
          (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
          Profile,
          PrefetchHooks Function()
        > {
  $$ProfilesTableTableManager(_$AppDatabase db, $ProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> locale = const Value.absent(),
                Value<String?> theme = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String> timezone = const Value.absent(),
                Value<int?> sleepGoalMinutes = const Value.absent(),
                Value<int?> birthYear = const Value.absent(),
                Value<DateTime?> onboardingCompletedAt = const Value.absent(),
                Value<double?> locationLat = const Value.absent(),
                Value<double?> locationLon = const Value.absent(),
                Value<String?> locationLabel = const Value.absent(),
                Value<String?> prayerMethod = const Value.absent(),
                Value<String?> prayerMadhab = const Value.absent(),
                Value<int?> minChunkMinutes = const Value.absent(),
                Value<int?> chunkBufferMinutes = const Value.absent(),
                Value<int?> dailyFocusCapMinutes = const Value.absent(),
                Value<bool> hapticsEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                displayName: displayName,
                locale: locale,
                theme: theme,
                themeMode: themeMode,
                timezone: timezone,
                sleepGoalMinutes: sleepGoalMinutes,
                birthYear: birthYear,
                onboardingCompletedAt: onboardingCompletedAt,
                locationLat: locationLat,
                locationLon: locationLon,
                locationLabel: locationLabel,
                prayerMethod: prayerMethod,
                prayerMadhab: prayerMadhab,
                minChunkMinutes: minChunkMinutes,
                chunkBufferMinutes: chunkBufferMinutes,
                dailyFocusCapMinutes: dailyFocusCapMinutes,
                hapticsEnabled: hapticsEnabled,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<String?> locale = const Value.absent(),
                Value<String?> theme = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                required String timezone,
                Value<int?> sleepGoalMinutes = const Value.absent(),
                Value<int?> birthYear = const Value.absent(),
                Value<DateTime?> onboardingCompletedAt = const Value.absent(),
                Value<double?> locationLat = const Value.absent(),
                Value<double?> locationLon = const Value.absent(),
                Value<String?> locationLabel = const Value.absent(),
                Value<String?> prayerMethod = const Value.absent(),
                Value<String?> prayerMadhab = const Value.absent(),
                Value<int?> minChunkMinutes = const Value.absent(),
                Value<int?> chunkBufferMinutes = const Value.absent(),
                Value<int?> dailyFocusCapMinutes = const Value.absent(),
                Value<bool> hapticsEnabled = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProfilesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                displayName: displayName,
                locale: locale,
                theme: theme,
                themeMode: themeMode,
                timezone: timezone,
                sleepGoalMinutes: sleepGoalMinutes,
                birthYear: birthYear,
                onboardingCompletedAt: onboardingCompletedAt,
                locationLat: locationLat,
                locationLon: locationLon,
                locationLabel: locationLabel,
                prayerMethod: prayerMethod,
                prayerMadhab: prayerMadhab,
                minChunkMinutes: minChunkMinutes,
                chunkBufferMinutes: chunkBufferMinutes,
                dailyFocusCapMinutes: dailyFocusCapMinutes,
                hapticsEnabled: hapticsEnabled,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProfilesTable, Profile>(table),
                  BaseReferences<_$AppDatabase, $ProfilesTable, Profile>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProfilesTable,
      Profile,
      $$ProfilesTableFilterComposer,
      $$ProfilesTableOrderingComposer,
      $$ProfilesTableAnnotationComposer,
      $$ProfilesTableCreateCompanionBuilder,
      $$ProfilesTableUpdateCompanionBuilder,
      (Profile, BaseReferences<_$AppDatabase, $ProfilesTable, Profile>),
      Profile,
      PrefetchHooks Function()
    >;
typedef $$UserCategoriesTableCreateCompanionBuilder =
    UserCategoriesCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      Value<String?> parentId,
      required String rootCategoryKey,
      required String name,
      Value<String?> color,
      Value<String?> icon,
      Value<bool?> requiresFocus,
      Value<String?> defaultFocusMode,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$UserCategoriesTableUpdateCompanionBuilder =
    UserCategoriesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      Value<String?> parentId,
      Value<String> rootCategoryKey,
      Value<String> name,
      Value<String?> color,
      Value<String?> icon,
      Value<bool?> requiresFocus,
      Value<String?> defaultFocusMode,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$UserCategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $UserCategoriesTable, UserCategory> {
  $$UserCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $UserCategoriesTable _parentIdTable(_$AppDatabase db) => db
      .userCategories
      .createAlias('user_categories__parent_id__user_categories__id');

  $$UserCategoriesTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $$UserCategoriesTableTableManager(
      $_db,
      $_db.userCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RootCategoriesTable _rootCategoryKeyTable(_$AppDatabase db) => db
      .rootCategories
      .createAlias('user_categories__root_category_key__root_categories__key');

  $$RootCategoriesTableProcessedTableManager get rootCategoryKey {
    final $_column = $_itemColumn<String>('root_category_key')!;

    final manager = $$RootCategoriesTableTableManager(
      $_db,
      $_db.rootCategories,
    ).filter((f) => f.key.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rootCategoryKeyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ActivitiesTable, List<Activity>>
  _activitiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.activities,
    aliasName: 'user_categories__id__activities__category_id',
  );

  $$ActivitiesTableProcessedTableManager get activitiesRefs {
    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_activitiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FocusSessionsTable, List<FocusSession>>
  _focusSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.focusSessions,
    aliasName: 'user_categories__id__focus_sessions__category_id',
  );

  $$FocusSessionsTableProcessedTableManager get focusSessionsRefs {
    final manager = $$FocusSessionsTableTableManager(
      $_db,
      $_db.focusSessions,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_focusSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$UserCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $UserCategoriesTable> {
  $$UserCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresFocus => $composableBuilder(
    column: $table.requiresFocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defaultFocusMode => $composableBuilder(
    column: $table.defaultFocusMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$UserCategoriesTableFilterComposer get parentId {
    final $$UserCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.userCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.userCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RootCategoriesTableFilterComposer get rootCategoryKey {
    final $$RootCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootCategoryKey,
      referencedTable: $db.rootCategories,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.rootCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> activitiesRefs(
    Expression<bool> Function($$ActivitiesTableFilterComposer f) f,
  ) {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> focusSessionsRefs(
    Expression<bool> Function($$FocusSessionsTableFilterComposer f) f,
  ) {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserCategoriesTable> {
  $$UserCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get icon => $composableBuilder(
    column: $table.icon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresFocus => $composableBuilder(
    column: $table.requiresFocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defaultFocusMode => $composableBuilder(
    column: $table.defaultFocusMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserCategoriesTableOrderingComposer get parentId {
    final $$UserCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.userCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.userCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RootCategoriesTableOrderingComposer get rootCategoryKey {
    final $$RootCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootCategoryKey,
      referencedTable: $db.rootCategories,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.rootCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$UserCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserCategoriesTable> {
  $$UserCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>, String>
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get icon =>
      $composableBuilder(column: $table.icon, builder: (column) => column);

  GeneratedColumn<bool> get requiresFocus => $composableBuilder(
    column: $table.requiresFocus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get defaultFocusMode => $composableBuilder(
    column: $table.defaultFocusMode,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$UserCategoriesTableAnnotationComposer get parentId {
    final $$UserCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.userCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.userCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RootCategoriesTableAnnotationComposer get rootCategoryKey {
    final $$RootCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootCategoryKey,
      referencedTable: $db.rootCategories,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.rootCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> activitiesRefs<T extends Object>(
    Expression<T> Function($$ActivitiesTableAnnotationComposer a) f,
  ) {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> focusSessionsRefs<T extends Object>(
    Expression<T> Function($$FocusSessionsTableAnnotationComposer a) f,
  ) {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$UserCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserCategoriesTable,
          UserCategory,
          $$UserCategoriesTableFilterComposer,
          $$UserCategoriesTableOrderingComposer,
          $$UserCategoriesTableAnnotationComposer,
          $$UserCategoriesTableCreateCompanionBuilder,
          $$UserCategoriesTableUpdateCompanionBuilder,
          (UserCategory, $$UserCategoriesTableReferences),
          UserCategory,
          PrefetchHooks Function({
            bool parentId,
            bool rootCategoryKey,
            bool activitiesRefs,
            bool focusSessionsRefs,
          })
        > {
  $$UserCategoriesTableTableManager(
    _$AppDatabase db,
    $UserCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<String> rootCategoryKey = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<bool?> requiresFocus = const Value.absent(),
                Value<String?> defaultFocusMode = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserCategoriesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                parentId: parentId,
                rootCategoryKey: rootCategoryKey,
                name: name,
                color: color,
                icon: icon,
                requiresFocus: requiresFocus,
                defaultFocusMode: defaultFocusMode,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                required String rootCategoryKey,
                required String name,
                Value<String?> color = const Value.absent(),
                Value<String?> icon = const Value.absent(),
                Value<bool?> requiresFocus = const Value.absent(),
                Value<String?> defaultFocusMode = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserCategoriesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                parentId: parentId,
                rootCategoryKey: rootCategoryKey,
                name: name,
                color: color,
                icon: icon,
                requiresFocus: requiresFocus,
                defaultFocusMode: defaultFocusMode,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserCategoriesTable, UserCategory>(table),
                  $$UserCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentId = false,
                rootCategoryKey = false,
                activitiesRefs = false,
                focusSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (activitiesRefs) db.activities,
                    if (focusSessionsRefs) db.focusSessions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.parentId,
                            referencedTable: $$UserCategoriesTableReferences
                                ._parentIdTable(db),
                            referencedColumn: $$UserCategoriesTableReferences
                                ._parentIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (rootCategoryKey) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.rootCategoryKey,
                            referencedTable: $$UserCategoriesTableReferences
                                ._rootCategoryKeyTable(db),
                            referencedColumn: $$UserCategoriesTableReferences
                                ._rootCategoryKeyTable(db)
                                .key,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (activitiesRefs)
                        await $_getPrefetchedDataByColumns<
                          UserCategory,
                          $UserCategoriesTable,
                          Activity,
                          $ActivitiesTable
                        >(
                          currentTable: table,
                          referencedTable: $$UserCategoriesTableReferences
                              ._activitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).activitiesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (focusSessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          UserCategory,
                          $UserCategoriesTable,
                          FocusSession,
                          $FocusSessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$UserCategoriesTableReferences
                              ._focusSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$UserCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).focusSessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$UserCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserCategoriesTable,
      UserCategory,
      $$UserCategoriesTableFilterComposer,
      $$UserCategoriesTableOrderingComposer,
      $$UserCategoriesTableAnnotationComposer,
      $$UserCategoriesTableCreateCompanionBuilder,
      $$UserCategoriesTableUpdateCompanionBuilder,
      (UserCategory, $$UserCategoriesTableReferences),
      UserCategory,
      PrefetchHooks Function({
        bool parentId,
        bool rootCategoryKey,
        bool activitiesRefs,
        bool focusSessionsRefs,
      })
    >;
typedef $$VariantGroupsTableCreateCompanionBuilder =
    VariantGroupsCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      required String activityId,
      Value<String?> name,
      Value<Recurrence?> appliesOn,
      Value<String?> defaultVariantId,
      Value<int> rowid,
    });
typedef $$VariantGroupsTableUpdateCompanionBuilder =
    VariantGroupsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      Value<String> activityId,
      Value<String?> name,
      Value<Recurrence?> appliesOn,
      Value<String?> defaultVariantId,
      Value<int> rowid,
    });

final class $$VariantGroupsTableReferences
    extends BaseReferences<_$AppDatabase, $VariantGroupsTable, VariantGroup> {
  $$VariantGroupsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivitiesTable _activityIdTable(_$AppDatabase db) =>
      db.activities.createAlias('variant_groups__activity_id__activities__id');

  $$ActivitiesTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VariantsTable _defaultVariantIdTable(_$AppDatabase db) => db.variants
      .createAlias('variant_groups__default_variant_id__variants__id');

  $$VariantsTableProcessedTableManager? get defaultVariantId {
    final $_column = $_itemColumn<String>('default_variant_id');
    if ($_column == null) return null;
    final manager = $$VariantsTableTableManager(
      $_db,
      $_db.variants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_defaultVariantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$VariantsTable, List<Variant>> _variantsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.variants,
    aliasName: 'variant_groups__id__variants__group_id',
  );

  $$VariantsTableProcessedTableManager get variantsRefs {
    final manager = $$VariantsTableTableManager(
      $_db,
      $_db.variants,
    ).filter((f) => f.groupId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_variantsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VariantGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $VariantGroupsTable> {
  $$VariantGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Recurrence?, Recurrence, String>
  get appliesOn => $composableBuilder(
    column: $table.appliesOn,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$ActivitiesTableFilterComposer get activityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VariantsTableFilterComposer get defaultVariantId {
    final $$VariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultVariantId,
      referencedTable: $db.variants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantsTableFilterComposer(
            $db: $db,
            $table: $db.variants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> variantsRefs(
    Expression<bool> Function($$VariantsTableFilterComposer f) f,
  ) {
    final $$VariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.variants,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantsTableFilterComposer(
            $db: $db,
            $table: $db.variants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VariantGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $VariantGroupsTable> {
  $$VariantGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appliesOn => $composableBuilder(
    column: $table.appliesOn,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableOrderingComposer get activityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VariantsTableOrderingComposer get defaultVariantId {
    final $$VariantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultVariantId,
      referencedTable: $db.variants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantsTableOrderingComposer(
            $db: $db,
            $table: $db.variants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VariantGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VariantGroupsTable> {
  $$VariantGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>, String>
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Recurrence?, String> get appliesOn =>
      $composableBuilder(column: $table.appliesOn, builder: (column) => column);

  $$ActivitiesTableAnnotationComposer get activityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VariantsTableAnnotationComposer get defaultVariantId {
    final $$VariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.defaultVariantId,
      referencedTable: $db.variants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.variants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> variantsRefs<T extends Object>(
    Expression<T> Function($$VariantsTableAnnotationComposer a) f,
  ) {
    final $$VariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.variants,
      getReferencedColumn: (t) => t.groupId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.variants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VariantGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VariantGroupsTable,
          VariantGroup,
          $$VariantGroupsTableFilterComposer,
          $$VariantGroupsTableOrderingComposer,
          $$VariantGroupsTableAnnotationComposer,
          $$VariantGroupsTableCreateCompanionBuilder,
          $$VariantGroupsTableUpdateCompanionBuilder,
          (VariantGroup, $$VariantGroupsTableReferences),
          VariantGroup,
          PrefetchHooks Function({
            bool activityId,
            bool defaultVariantId,
            bool variantsRefs,
          })
        > {
  $$VariantGroupsTableTableManager(_$AppDatabase db, $VariantGroupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VariantGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VariantGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VariantGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<Recurrence?> appliesOn = const Value.absent(),
                Value<String?> defaultVariantId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VariantGroupsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                activityId: activityId,
                name: name,
                appliesOn: appliesOn,
                defaultVariantId: defaultVariantId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                required String activityId,
                Value<String?> name = const Value.absent(),
                Value<Recurrence?> appliesOn = const Value.absent(),
                Value<String?> defaultVariantId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VariantGroupsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                activityId: activityId,
                name: name,
                appliesOn: appliesOn,
                defaultVariantId: defaultVariantId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VariantGroupsTable, VariantGroup>(table),
                  $$VariantGroupsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                activityId = false,
                defaultVariantId = false,
                variantsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (variantsRefs) db.variants],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (activityId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.activityId,
                            referencedTable: $$VariantGroupsTableReferences
                                ._activityIdTable(db),
                            referencedColumn: $$VariantGroupsTableReferences
                                ._activityIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (defaultVariantId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.defaultVariantId,
                            referencedTable: $$VariantGroupsTableReferences
                                ._defaultVariantIdTable(db),
                            referencedColumn: $$VariantGroupsTableReferences
                                ._defaultVariantIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (variantsRefs)
                        await $_getPrefetchedDataByColumns<
                          VariantGroup,
                          $VariantGroupsTable,
                          Variant,
                          $VariantsTable
                        >(
                          currentTable: table,
                          referencedTable: $$VariantGroupsTableReferences
                              ._variantsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VariantGroupsTableReferences(
                                db,
                                table,
                                p0,
                              ).variantsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'group_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VariantGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VariantGroupsTable,
      VariantGroup,
      $$VariantGroupsTableFilterComposer,
      $$VariantGroupsTableOrderingComposer,
      $$VariantGroupsTableAnnotationComposer,
      $$VariantGroupsTableCreateCompanionBuilder,
      $$VariantGroupsTableUpdateCompanionBuilder,
      (VariantGroup, $$VariantGroupsTableReferences),
      VariantGroup,
      PrefetchHooks Function({
        bool activityId,
        bool defaultVariantId,
        bool variantsRefs,
      })
    >;
typedef $$VariantsTableCreateCompanionBuilder = VariantsCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<Map<String, String>> fieldVersions,
  required String groupId,
  required String name,
  Value<int> sortOrder,
  Value<Timing?> timing,
  Value<int?> durationMinMinutes,
  Value<int?> durationMaxMinutes,
  Value<bool> cancelsOccurrence,
  Value<int> rowid,
});
typedef $$VariantsTableUpdateCompanionBuilder = VariantsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<Map<String, String>> fieldVersions,
  Value<String> groupId,
  Value<String> name,
  Value<int> sortOrder,
  Value<Timing?> timing,
  Value<int?> durationMinMinutes,
  Value<int?> durationMaxMinutes,
  Value<bool> cancelsOccurrence,
  Value<int> rowid,
});

final class $$VariantsTableReferences
    extends BaseReferences<_$AppDatabase, $VariantsTable, Variant> {
  $$VariantsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $VariantGroupsTable _groupIdTable(_$AppDatabase db) =>
      db.variantGroups.createAlias('variants__group_id__variant_groups__id');

  $$VariantGroupsTableProcessedTableManager get groupId {
    final $_column = $_itemColumn<String>('group_id')!;

    final manager = $$VariantGroupsTableTableManager(
      $_db,
      $_db.variantGroups,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_groupIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$VariantGroupsTable, List<VariantGroup>>
  _variantGroupsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.variantGroups,
    aliasName: 'variants__id__variant_groups__default_variant_id',
  );

  $$VariantGroupsTableProcessedTableManager get variantGroupsRefs {
    final manager = $$VariantGroupsTableTableManager($_db, $_db.variantGroups)
        .filter(
          (f) => f.defaultVariantId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_variantGroupsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ActivitiesTable, List<Activity>>
  _activitiesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.activities,
    aliasName: 'variants__id__activities__variant_id',
  );

  $$ActivitiesTableProcessedTableManager get activitiesRefs {
    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.variantId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_activitiesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlanInstancesTable, List<PlanInstance>>
  _planInstancesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.planInstances,
    aliasName: 'variants__id__plan_instances__variant_id',
  );

  $$PlanInstancesTableProcessedTableManager get planInstancesRefs {
    final manager = $$PlanInstancesTableTableManager(
      $_db,
      $_db.planInstances,
    ).filter((f) => f.variantId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_planInstancesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$VariantsTableFilterComposer
    extends Composer<_$AppDatabase, $VariantsTable> {
  $$VariantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Timing?, Timing, String> get timing =>
      $composableBuilder(
        column: $table.timing,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get durationMinMinutes => $composableBuilder(
    column: $table.durationMinMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMaxMinutes => $composableBuilder(
    column: $table.durationMaxMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get cancelsOccurrence => $composableBuilder(
    column: $table.cancelsOccurrence,
    builder: (column) => ColumnFilters(column),
  );

  $$VariantGroupsTableFilterComposer get groupId {
    final $$VariantGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.variantGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantGroupsTableFilterComposer(
            $db: $db,
            $table: $db.variantGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> variantGroupsRefs(
    Expression<bool> Function($$VariantGroupsTableFilterComposer f) f,
  ) {
    final $$VariantGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.variantGroups,
      getReferencedColumn: (t) => t.defaultVariantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantGroupsTableFilterComposer(
            $db: $db,
            $table: $db.variantGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> activitiesRefs(
    Expression<bool> Function($$ActivitiesTableFilterComposer f) f,
  ) {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.variantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> planInstancesRefs(
    Expression<bool> Function($$PlanInstancesTableFilterComposer f) f,
  ) {
    final $$PlanInstancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.variantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableFilterComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VariantsTableOrderingComposer
    extends Composer<_$AppDatabase, $VariantsTable> {
  $$VariantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timing => $composableBuilder(
    column: $table.timing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinMinutes => $composableBuilder(
    column: $table.durationMinMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMaxMinutes => $composableBuilder(
    column: $table.durationMaxMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get cancelsOccurrence => $composableBuilder(
    column: $table.cancelsOccurrence,
    builder: (column) => ColumnOrderings(column),
  );

  $$VariantGroupsTableOrderingComposer get groupId {
    final $$VariantGroupsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.variantGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantGroupsTableOrderingComposer(
            $db: $db,
            $table: $db.variantGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$VariantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $VariantsTable> {
  $$VariantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>, String>
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Timing?, String> get timing =>
      $composableBuilder(column: $table.timing, builder: (column) => column);

  GeneratedColumn<int> get durationMinMinutes => $composableBuilder(
    column: $table.durationMinMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMaxMinutes => $composableBuilder(
    column: $table.durationMaxMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get cancelsOccurrence => $composableBuilder(
    column: $table.cancelsOccurrence,
    builder: (column) => column,
  );

  $$VariantGroupsTableAnnotationComposer get groupId {
    final $$VariantGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.groupId,
      referencedTable: $db.variantGroups,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.variantGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> variantGroupsRefs<T extends Object>(
    Expression<T> Function($$VariantGroupsTableAnnotationComposer a) f,
  ) {
    final $$VariantGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.variantGroups,
      getReferencedColumn: (t) => t.defaultVariantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.variantGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> activitiesRefs<T extends Object>(
    Expression<T> Function($$ActivitiesTableAnnotationComposer a) f,
  ) {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.variantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> planInstancesRefs<T extends Object>(
    Expression<T> Function($$PlanInstancesTableAnnotationComposer a) f,
  ) {
    final $$PlanInstancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.variantId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableAnnotationComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$VariantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $VariantsTable,
          Variant,
          $$VariantsTableFilterComposer,
          $$VariantsTableOrderingComposer,
          $$VariantsTableAnnotationComposer,
          $$VariantsTableCreateCompanionBuilder,
          $$VariantsTableUpdateCompanionBuilder,
          (Variant, $$VariantsTableReferences),
          Variant,
          PrefetchHooks Function({
            bool groupId,
            bool variantGroupsRefs,
            bool activitiesRefs,
            bool planInstancesRefs,
          })
        > {
  $$VariantsTableTableManager(_$AppDatabase db, $VariantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$VariantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$VariantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$VariantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String> groupId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<Timing?> timing = const Value.absent(),
                Value<int?> durationMinMinutes = const Value.absent(),
                Value<int?> durationMaxMinutes = const Value.absent(),
                Value<bool> cancelsOccurrence = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VariantsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                groupId: groupId,
                name: name,
                sortOrder: sortOrder,
                timing: timing,
                durationMinMinutes: durationMinMinutes,
                durationMaxMinutes: durationMaxMinutes,
                cancelsOccurrence: cancelsOccurrence,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                required String groupId,
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<Timing?> timing = const Value.absent(),
                Value<int?> durationMinMinutes = const Value.absent(),
                Value<int?> durationMaxMinutes = const Value.absent(),
                Value<bool> cancelsOccurrence = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => VariantsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                groupId: groupId,
                name: name,
                sortOrder: sortOrder,
                timing: timing,
                durationMinMinutes: durationMinMinutes,
                durationMaxMinutes: durationMaxMinutes,
                cancelsOccurrence: cancelsOccurrence,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$VariantsTable, Variant>(table),
                  $$VariantsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                groupId = false,
                variantGroupsRefs = false,
                activitiesRefs = false,
                planInstancesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (variantGroupsRefs) db.variantGroups,
                    if (activitiesRefs) db.activities,
                    if (planInstancesRefs) db.planInstances,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (groupId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.groupId,
                            referencedTable: $$VariantsTableReferences
                                ._groupIdTable(db),
                            referencedColumn: $$VariantsTableReferences
                                ._groupIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (variantGroupsRefs)
                        await $_getPrefetchedDataByColumns<
                          Variant,
                          $VariantsTable,
                          VariantGroup,
                          $VariantGroupsTable
                        >(
                          currentTable: table,
                          referencedTable: $$VariantsTableReferences
                              ._variantGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VariantsTableReferences(
                                db,
                                table,
                                p0,
                              ).variantGroupsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'default_variant_id',
                          typedResults: items,
                        ),
                      if (activitiesRefs)
                        await $_getPrefetchedDataByColumns<
                          Variant,
                          $VariantsTable,
                          Activity,
                          $ActivitiesTable
                        >(
                          currentTable: table,
                          referencedTable: $$VariantsTableReferences
                              ._activitiesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VariantsTableReferences(
                                db,
                                table,
                                p0,
                              ).activitiesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'variant_id',
                          typedResults: items,
                        ),
                      if (planInstancesRefs)
                        await $_getPrefetchedDataByColumns<
                          Variant,
                          $VariantsTable,
                          PlanInstance,
                          $PlanInstancesTable
                        >(
                          currentTable: table,
                          referencedTable: $$VariantsTableReferences
                              ._planInstancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$VariantsTableReferences(
                                db,
                                table,
                                p0,
                              ).planInstancesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'variant_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$VariantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $VariantsTable,
      Variant,
      $$VariantsTableFilterComposer,
      $$VariantsTableOrderingComposer,
      $$VariantsTableAnnotationComposer,
      $$VariantsTableCreateCompanionBuilder,
      $$VariantsTableUpdateCompanionBuilder,
      (Variant, $$VariantsTableReferences),
      Variant,
      PrefetchHooks Function({
        bool groupId,
        bool variantGroupsRefs,
        bool activitiesRefs,
        bool planInstancesRefs,
      })
    >;
typedef $$ActivitiesTableCreateCompanionBuilder = ActivitiesCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<Map<String, String>> fieldVersions,
  required String kind,
  required String title,
  Value<String?> notes,
  Value<String?> categoryId,
  Value<String?> rootCategoryKey,
  Value<String?> parentActivityId,
  Value<String?> variantId,
  Value<int?> estimatedMinutes,
  Value<int?> priority,
  Value<bool?> requiresFocus,
  Value<String?> focusMode,
  Value<int?> focusBlockMinutes,
  Value<int?> focusBreakMinutes,
  Value<bool?> focusSpread,
  Value<int?> focusGraceMinutes,
  Value<int?> focusCycles,
  Value<int?> focusLongBreakMinutes,
  Value<int?> focusLongEvery,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$ActivitiesTableUpdateCompanionBuilder = ActivitiesCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<Map<String, String>> fieldVersions,
  Value<String> kind,
  Value<String> title,
  Value<String?> notes,
  Value<String?> categoryId,
  Value<String?> rootCategoryKey,
  Value<String?> parentActivityId,
  Value<String?> variantId,
  Value<int?> estimatedMinutes,
  Value<int?> priority,
  Value<bool?> requiresFocus,
  Value<String?> focusMode,
  Value<int?> focusBlockMinutes,
  Value<int?> focusBreakMinutes,
  Value<bool?> focusSpread,
  Value<int?> focusGraceMinutes,
  Value<int?> focusCycles,
  Value<int?> focusLongBreakMinutes,
  Value<int?> focusLongEvery,
  Value<int> sortOrder,
  Value<int> rowid,
});

final class $$ActivitiesTableReferences
    extends BaseReferences<_$AppDatabase, $ActivitiesTable, Activity> {
  $$ActivitiesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $UserCategoriesTable _categoryIdTable(_$AppDatabase db) => db
      .userCategories
      .createAlias('activities__category_id__user_categories__id');

  $$UserCategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$UserCategoriesTableTableManager(
      $_db,
      $_db.userCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RootCategoriesTable _rootCategoryKeyTable(_$AppDatabase db) => db
      .rootCategories
      .createAlias('activities__root_category_key__root_categories__key');

  $$RootCategoriesTableProcessedTableManager? get rootCategoryKey {
    final $_column = $_itemColumn<String>('root_category_key');
    if ($_column == null) return null;
    final manager = $$RootCategoriesTableTableManager(
      $_db,
      $_db.rootCategories,
    ).filter((f) => f.key.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rootCategoryKeyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ActivitiesTable _parentActivityIdTable(_$AppDatabase db) => db
      .activities
      .createAlias('activities__parent_activity_id__activities__id');

  $$ActivitiesTableProcessedTableManager? get parentActivityId {
    final $_column = $_itemColumn<String>('parent_activity_id');
    if ($_column == null) return null;
    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentActivityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VariantsTable _variantIdTable(_$AppDatabase db) =>
      db.variants.createAlias('activities__variant_id__variants__id');

  $$VariantsTableProcessedTableManager? get variantId {
    final $_column = $_itemColumn<String>('variant_id');
    if ($_column == null) return null;
    final manager = $$VariantsTableTableManager(
      $_db,
      $_db.variants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_variantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$VariantGroupsTable, List<VariantGroup>>
  _variantGroupsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.variantGroups,
    aliasName: 'activities__id__variant_groups__activity_id',
  );

  $$VariantGroupsTableProcessedTableManager get variantGroupsRefs {
    final manager = $$VariantGroupsTableTableManager(
      $_db,
      $_db.variantGroups,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_variantGroupsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ScheduleRulesTable, List<ScheduleRule>>
  _scheduleRulesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.scheduleRules,
    aliasName: 'activities__id__schedule_rules__activity_id',
  );

  $$ScheduleRulesTableProcessedTableManager get scheduleRulesRefs {
    final manager = $$ScheduleRulesTableTableManager(
      $_db,
      $_db.scheduleRules,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_scheduleRulesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectsTable, List<Project>> _projectsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.projects,
    aliasName: 'activities__id__projects__activity_id',
  );

  $$ProjectsTableProcessedTableManager get projectsRefs {
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$PlanInstancesTable, List<PlanInstance>>
  _planInstancesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.planInstances,
    aliasName: 'activities__id__plan_instances__activity_id',
  );

  $$PlanInstancesTableProcessedTableManager get planInstancesRefs {
    final manager = $$PlanInstancesTableTableManager(
      $_db,
      $_db.planInstances,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_planInstancesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$FocusSessionsTable, List<FocusSession>>
  _focusSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.focusSessions,
    aliasName: 'activities__id__focus_sessions__activity_id',
  );

  $$FocusSessionsTableProcessedTableManager get focusSessionsRefs {
    final manager = $$FocusSessionsTableTableManager(
      $_db,
      $_db.focusSessions,
    ).filter((f) => f.activityId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_focusSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ActivitiesTableFilterComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get requiresFocus => $composableBuilder(
    column: $table.requiresFocus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get focusMode => $composableBuilder(
    column: $table.focusMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusBlockMinutes => $composableBuilder(
    column: $table.focusBlockMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusBreakMinutes => $composableBuilder(
    column: $table.focusBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get focusSpread => $composableBuilder(
    column: $table.focusSpread,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusGraceMinutes => $composableBuilder(
    column: $table.focusGraceMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusCycles => $composableBuilder(
    column: $table.focusCycles,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusLongBreakMinutes => $composableBuilder(
    column: $table.focusLongBreakMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusLongEvery => $composableBuilder(
    column: $table.focusLongEvery,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$UserCategoriesTableFilterComposer get categoryId {
    final $$UserCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.userCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.userCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RootCategoriesTableFilterComposer get rootCategoryKey {
    final $$RootCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootCategoryKey,
      referencedTable: $db.rootCategories,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.rootCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActivitiesTableFilterComposer get parentActivityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentActivityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VariantsTableFilterComposer get variantId {
    final $$VariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.variants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantsTableFilterComposer(
            $db: $db,
            $table: $db.variants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> variantGroupsRefs(
    Expression<bool> Function($$VariantGroupsTableFilterComposer f) f,
  ) {
    final $$VariantGroupsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.variantGroups,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantGroupsTableFilterComposer(
            $db: $db,
            $table: $db.variantGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> scheduleRulesRefs(
    Expression<bool> Function($$ScheduleRulesTableFilterComposer f) f,
  ) {
    final $$ScheduleRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleRules,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleRulesTableFilterComposer(
            $db: $db,
            $table: $db.scheduleRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectsRefs(
    Expression<bool> Function($$ProjectsTableFilterComposer f) f,
  ) {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> planInstancesRefs(
    Expression<bool> Function($$PlanInstancesTableFilterComposer f) f,
  ) {
    final $$PlanInstancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableFilterComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> focusSessionsRefs(
    Expression<bool> Function($$FocusSessionsTableFilterComposer f) f,
  ) {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActivitiesTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get requiresFocus => $composableBuilder(
    column: $table.requiresFocus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get focusMode => $composableBuilder(
    column: $table.focusMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusBlockMinutes => $composableBuilder(
    column: $table.focusBlockMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusBreakMinutes => $composableBuilder(
    column: $table.focusBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get focusSpread => $composableBuilder(
    column: $table.focusSpread,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusGraceMinutes => $composableBuilder(
    column: $table.focusGraceMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusCycles => $composableBuilder(
    column: $table.focusCycles,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusLongBreakMinutes => $composableBuilder(
    column: $table.focusLongBreakMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusLongEvery => $composableBuilder(
    column: $table.focusLongEvery,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$UserCategoriesTableOrderingComposer get categoryId {
    final $$UserCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.userCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.userCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RootCategoriesTableOrderingComposer get rootCategoryKey {
    final $$RootCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootCategoryKey,
      referencedTable: $db.rootCategories,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.rootCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActivitiesTableOrderingComposer get parentActivityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentActivityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VariantsTableOrderingComposer get variantId {
    final $$VariantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.variants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantsTableOrderingComposer(
            $db: $db,
            $table: $db.variants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ActivitiesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivitiesTable> {
  $$ActivitiesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>, String>
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get estimatedMinutes => $composableBuilder(
    column: $table.estimatedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<bool> get requiresFocus => $composableBuilder(
    column: $table.requiresFocus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get focusMode =>
      $composableBuilder(column: $table.focusMode, builder: (column) => column);

  GeneratedColumn<int> get focusBlockMinutes => $composableBuilder(
    column: $table.focusBlockMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get focusBreakMinutes => $composableBuilder(
    column: $table.focusBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get focusSpread => $composableBuilder(
    column: $table.focusSpread,
    builder: (column) => column,
  );

  GeneratedColumn<int> get focusGraceMinutes => $composableBuilder(
    column: $table.focusGraceMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get focusCycles => $composableBuilder(
    column: $table.focusCycles,
    builder: (column) => column,
  );

  GeneratedColumn<int> get focusLongBreakMinutes => $composableBuilder(
    column: $table.focusLongBreakMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get focusLongEvery => $composableBuilder(
    column: $table.focusLongEvery,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$UserCategoriesTableAnnotationComposer get categoryId {
    final $$UserCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.userCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.userCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RootCategoriesTableAnnotationComposer get rootCategoryKey {
    final $$RootCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootCategoryKey,
      referencedTable: $db.rootCategories,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.rootCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActivitiesTableAnnotationComposer get parentActivityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentActivityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VariantsTableAnnotationComposer get variantId {
    final $$VariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.variants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.variants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> variantGroupsRefs<T extends Object>(
    Expression<T> Function($$VariantGroupsTableAnnotationComposer a) f,
  ) {
    final $$VariantGroupsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.variantGroups,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantGroupsTableAnnotationComposer(
            $db: $db,
            $table: $db.variantGroups,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> scheduleRulesRefs<T extends Object>(
    Expression<T> Function($$ScheduleRulesTableAnnotationComposer a) f,
  ) {
    final $$ScheduleRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.scheduleRules,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.scheduleRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectsRefs<T extends Object>(
    Expression<T> Function($$ProjectsTableAnnotationComposer a) f,
  ) {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> planInstancesRefs<T extends Object>(
    Expression<T> Function($$PlanInstancesTableAnnotationComposer a) f,
  ) {
    final $$PlanInstancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableAnnotationComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> focusSessionsRefs<T extends Object>(
    Expression<T> Function($$FocusSessionsTableAnnotationComposer a) f,
  ) {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.activityId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ActivitiesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivitiesTable,
          Activity,
          $$ActivitiesTableFilterComposer,
          $$ActivitiesTableOrderingComposer,
          $$ActivitiesTableAnnotationComposer,
          $$ActivitiesTableCreateCompanionBuilder,
          $$ActivitiesTableUpdateCompanionBuilder,
          (Activity, $$ActivitiesTableReferences),
          Activity,
          PrefetchHooks Function({
            bool categoryId,
            bool rootCategoryKey,
            bool parentActivityId,
            bool variantId,
            bool variantGroupsRefs,
            bool scheduleRulesRefs,
            bool projectsRefs,
            bool planInstancesRefs,
            bool focusSessionsRefs,
          })
        > {
  $$ActivitiesTableTableManager(_$AppDatabase db, $ActivitiesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivitiesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivitiesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivitiesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> rootCategoryKey = const Value.absent(),
                Value<String?> parentActivityId = const Value.absent(),
                Value<String?> variantId = const Value.absent(),
                Value<int?> estimatedMinutes = const Value.absent(),
                Value<int?> priority = const Value.absent(),
                Value<bool?> requiresFocus = const Value.absent(),
                Value<String?> focusMode = const Value.absent(),
                Value<int?> focusBlockMinutes = const Value.absent(),
                Value<int?> focusBreakMinutes = const Value.absent(),
                Value<bool?> focusSpread = const Value.absent(),
                Value<int?> focusGraceMinutes = const Value.absent(),
                Value<int?> focusCycles = const Value.absent(),
                Value<int?> focusLongBreakMinutes = const Value.absent(),
                Value<int?> focusLongEvery = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                kind: kind,
                title: title,
                notes: notes,
                categoryId: categoryId,
                rootCategoryKey: rootCategoryKey,
                parentActivityId: parentActivityId,
                variantId: variantId,
                estimatedMinutes: estimatedMinutes,
                priority: priority,
                requiresFocus: requiresFocus,
                focusMode: focusMode,
                focusBlockMinutes: focusBlockMinutes,
                focusBreakMinutes: focusBreakMinutes,
                focusSpread: focusSpread,
                focusGraceMinutes: focusGraceMinutes,
                focusCycles: focusCycles,
                focusLongBreakMinutes: focusLongBreakMinutes,
                focusLongEvery: focusLongEvery,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                required String kind,
                required String title,
                Value<String?> notes = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> rootCategoryKey = const Value.absent(),
                Value<String?> parentActivityId = const Value.absent(),
                Value<String?> variantId = const Value.absent(),
                Value<int?> estimatedMinutes = const Value.absent(),
                Value<int?> priority = const Value.absent(),
                Value<bool?> requiresFocus = const Value.absent(),
                Value<String?> focusMode = const Value.absent(),
                Value<int?> focusBlockMinutes = const Value.absent(),
                Value<int?> focusBreakMinutes = const Value.absent(),
                Value<bool?> focusSpread = const Value.absent(),
                Value<int?> focusGraceMinutes = const Value.absent(),
                Value<int?> focusCycles = const Value.absent(),
                Value<int?> focusLongBreakMinutes = const Value.absent(),
                Value<int?> focusLongEvery = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivitiesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                kind: kind,
                title: title,
                notes: notes,
                categoryId: categoryId,
                rootCategoryKey: rootCategoryKey,
                parentActivityId: parentActivityId,
                variantId: variantId,
                estimatedMinutes: estimatedMinutes,
                priority: priority,
                requiresFocus: requiresFocus,
                focusMode: focusMode,
                focusBlockMinutes: focusBlockMinutes,
                focusBreakMinutes: focusBreakMinutes,
                focusSpread: focusSpread,
                focusGraceMinutes: focusGraceMinutes,
                focusCycles: focusCycles,
                focusLongBreakMinutes: focusLongBreakMinutes,
                focusLongEvery: focusLongEvery,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ActivitiesTable, Activity>(table),
                  $$ActivitiesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                rootCategoryKey = false,
                parentActivityId = false,
                variantId = false,
                variantGroupsRefs = false,
                scheduleRulesRefs = false,
                projectsRefs = false,
                planInstancesRefs = false,
                focusSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (variantGroupsRefs) db.variantGroups,
                    if (scheduleRulesRefs) db.scheduleRules,
                    if (projectsRefs) db.projects,
                    if (planInstancesRefs) db.planInstances,
                    if (focusSessionsRefs) db.focusSessions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$ActivitiesTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$ActivitiesTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (rootCategoryKey) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.rootCategoryKey,
                            referencedTable: $$ActivitiesTableReferences
                                ._rootCategoryKeyTable(db),
                            referencedColumn: $$ActivitiesTableReferences
                                ._rootCategoryKeyTable(db)
                                .key,
                          ) as T;
                        }
                        if (parentActivityId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.parentActivityId,
                            referencedTable: $$ActivitiesTableReferences
                                ._parentActivityIdTable(db),
                            referencedColumn: $$ActivitiesTableReferences
                                ._parentActivityIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (variantId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.variantId,
                            referencedTable: $$ActivitiesTableReferences
                                ._variantIdTable(db),
                            referencedColumn: $$ActivitiesTableReferences
                                ._variantIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (variantGroupsRefs)
                        await $_getPrefetchedDataByColumns<
                          Activity,
                          $ActivitiesTable,
                          VariantGroup,
                          $VariantGroupsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableReferences
                              ._variantGroupsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).variantGroupsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'activity_id',
                          typedResults: items,
                        ),
                      if (scheduleRulesRefs)
                        await $_getPrefetchedDataByColumns<
                          Activity,
                          $ActivitiesTable,
                          ScheduleRule,
                          $ScheduleRulesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableReferences
                              ._scheduleRulesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).scheduleRulesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'activity_id',
                          typedResults: items,
                        ),
                      if (projectsRefs)
                        await $_getPrefetchedDataByColumns<
                          Activity,
                          $ActivitiesTable,
                          Project,
                          $ProjectsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableReferences
                              ._projectsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).projectsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'activity_id',
                          typedResults: items,
                        ),
                      if (planInstancesRefs)
                        await $_getPrefetchedDataByColumns<
                          Activity,
                          $ActivitiesTable,
                          PlanInstance,
                          $PlanInstancesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableReferences
                              ._planInstancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).planInstancesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'activity_id',
                          typedResults: items,
                        ),
                      if (focusSessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          Activity,
                          $ActivitiesTable,
                          FocusSession,
                          $FocusSessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$ActivitiesTableReferences
                              ._focusSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ActivitiesTableReferences(
                                db,
                                table,
                                p0,
                              ).focusSessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'activity_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ActivitiesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivitiesTable,
      Activity,
      $$ActivitiesTableFilterComposer,
      $$ActivitiesTableOrderingComposer,
      $$ActivitiesTableAnnotationComposer,
      $$ActivitiesTableCreateCompanionBuilder,
      $$ActivitiesTableUpdateCompanionBuilder,
      (Activity, $$ActivitiesTableReferences),
      Activity,
      PrefetchHooks Function({
        bool categoryId,
        bool rootCategoryKey,
        bool parentActivityId,
        bool variantId,
        bool variantGroupsRefs,
        bool scheduleRulesRefs,
        bool projectsRefs,
        bool planInstancesRefs,
        bool focusSessionsRefs,
      })
    >;
typedef $$ScheduleRulesTableCreateCompanionBuilder =
    ScheduleRulesCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      required String activityId,
      required Recurrence recurrence,
      Value<Timing> timing,
      Value<int?> durationMinMinutes,
      Value<int?> durationMaxMinutes,
      Value<String> flexibility,
      Value<String?> validFrom,
      Value<String?> validUntil,
      Value<List<String>> exceptionDates,
      Value<int> rowid,
    });
typedef $$ScheduleRulesTableUpdateCompanionBuilder =
    ScheduleRulesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      Value<String> activityId,
      Value<Recurrence> recurrence,
      Value<Timing> timing,
      Value<int?> durationMinMinutes,
      Value<int?> durationMaxMinutes,
      Value<String> flexibility,
      Value<String?> validFrom,
      Value<String?> validUntil,
      Value<List<String>> exceptionDates,
      Value<int> rowid,
    });

final class $$ScheduleRulesTableReferences
    extends BaseReferences<_$AppDatabase, $ScheduleRulesTable, ScheduleRule> {
  $$ScheduleRulesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivitiesTable _activityIdTable(_$AppDatabase db) =>
      db.activities.createAlias('schedule_rules__activity_id__activities__id');

  $$ActivitiesTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$PlanInstancesTable, List<PlanInstance>>
  _planInstancesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.planInstances,
    aliasName: 'schedule_rules__id__plan_instances__rule_id',
  );

  $$PlanInstancesTableProcessedTableManager get planInstancesRefs {
    final manager = $$PlanInstancesTableTableManager(
      $_db,
      $_db.planInstances,
    ).filter((f) => f.ruleId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_planInstancesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ScheduleRulesTableFilterComposer
    extends Composer<_$AppDatabase, $ScheduleRulesTable> {
  $$ScheduleRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Recurrence, Recurrence, String>
  get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<Timing, Timing, String> get timing =>
      $composableBuilder(
        column: $table.timing,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get durationMinMinutes => $composableBuilder(
    column: $table.durationMinMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMaxMinutes => $composableBuilder(
    column: $table.durationMaxMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flexibility => $composableBuilder(
    column: $table.flexibility,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get exceptionDates => $composableBuilder(
    column: $table.exceptionDates,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  $$ActivitiesTableFilterComposer get activityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> planInstancesRefs(
    Expression<bool> Function($$PlanInstancesTableFilterComposer f) f,
  ) {
    final $$PlanInstancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.ruleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableFilterComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScheduleRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $ScheduleRulesTable> {
  $$ScheduleRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get timing => $composableBuilder(
    column: $table.timing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMinMinutes => $composableBuilder(
    column: $table.durationMinMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMaxMinutes => $composableBuilder(
    column: $table.durationMaxMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flexibility => $composableBuilder(
    column: $table.flexibility,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exceptionDates => $composableBuilder(
    column: $table.exceptionDates,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableOrderingComposer get activityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScheduleRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScheduleRulesTable> {
  $$ScheduleRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>, String>
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Recurrence, String> get recurrence =>
      $composableBuilder(
        column: $table.recurrence,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Timing, String> get timing =>
      $composableBuilder(column: $table.timing, builder: (column) => column);

  GeneratedColumn<int> get durationMinMinutes => $composableBuilder(
    column: $table.durationMinMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get durationMaxMinutes => $composableBuilder(
    column: $table.durationMaxMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<String> get flexibility => $composableBuilder(
    column: $table.flexibility,
    builder: (column) => column,
  );

  GeneratedColumn<String> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<String> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<String>, String> get exceptionDates =>
      $composableBuilder(
        column: $table.exceptionDates,
        builder: (column) => column,
      );

  $$ActivitiesTableAnnotationComposer get activityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> planInstancesRefs<T extends Object>(
    Expression<T> Function($$PlanInstancesTableAnnotationComposer a) f,
  ) {
    final $$PlanInstancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.ruleId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableAnnotationComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ScheduleRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScheduleRulesTable,
          ScheduleRule,
          $$ScheduleRulesTableFilterComposer,
          $$ScheduleRulesTableOrderingComposer,
          $$ScheduleRulesTableAnnotationComposer,
          $$ScheduleRulesTableCreateCompanionBuilder,
          $$ScheduleRulesTableUpdateCompanionBuilder,
          (ScheduleRule, $$ScheduleRulesTableReferences),
          ScheduleRule,
          PrefetchHooks Function({bool activityId, bool planInstancesRefs})
        > {
  $$ScheduleRulesTableTableManager(_$AppDatabase db, $ScheduleRulesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScheduleRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScheduleRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScheduleRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<Recurrence> recurrence = const Value.absent(),
                Value<Timing> timing = const Value.absent(),
                Value<int?> durationMinMinutes = const Value.absent(),
                Value<int?> durationMaxMinutes = const Value.absent(),
                Value<String> flexibility = const Value.absent(),
                Value<String?> validFrom = const Value.absent(),
                Value<String?> validUntil = const Value.absent(),
                Value<List<String>> exceptionDates = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduleRulesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                activityId: activityId,
                recurrence: recurrence,
                timing: timing,
                durationMinMinutes: durationMinMinutes,
                durationMaxMinutes: durationMaxMinutes,
                flexibility: flexibility,
                validFrom: validFrom,
                validUntil: validUntil,
                exceptionDates: exceptionDates,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                required String activityId,
                required Recurrence recurrence,
                Value<Timing> timing = const Value.absent(),
                Value<int?> durationMinMinutes = const Value.absent(),
                Value<int?> durationMaxMinutes = const Value.absent(),
                Value<String> flexibility = const Value.absent(),
                Value<String?> validFrom = const Value.absent(),
                Value<String?> validUntil = const Value.absent(),
                Value<List<String>> exceptionDates = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScheduleRulesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                activityId: activityId,
                recurrence: recurrence,
                timing: timing,
                durationMinMinutes: durationMinMinutes,
                durationMaxMinutes: durationMaxMinutes,
                flexibility: flexibility,
                validFrom: validFrom,
                validUntil: validUntil,
                exceptionDates: exceptionDates,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ScheduleRulesTable, ScheduleRule>(table),
                  $$ScheduleRulesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({activityId = false, planInstancesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (planInstancesRefs) db.planInstances,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (activityId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.activityId,
                            referencedTable: $$ScheduleRulesTableReferences
                                ._activityIdTable(db),
                            referencedColumn: $$ScheduleRulesTableReferences
                                ._activityIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (planInstancesRefs)
                        await $_getPrefetchedDataByColumns<
                          ScheduleRule,
                          $ScheduleRulesTable,
                          PlanInstance,
                          $PlanInstancesTable
                        >(
                          currentTable: table,
                          referencedTable: $$ScheduleRulesTableReferences
                              ._planInstancesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ScheduleRulesTableReferences(
                                db,
                                table,
                                p0,
                              ).planInstancesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'rule_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ScheduleRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScheduleRulesTable,
      ScheduleRule,
      $$ScheduleRulesTableFilterComposer,
      $$ScheduleRulesTableOrderingComposer,
      $$ScheduleRulesTableAnnotationComposer,
      $$ScheduleRulesTableCreateCompanionBuilder,
      $$ScheduleRulesTableUpdateCompanionBuilder,
      (ScheduleRule, $$ScheduleRulesTableReferences),
      ScheduleRule,
      PrefetchHooks Function({bool activityId, bool planInstancesRefs})
    >;
typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  required String id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<Map<String, String>> fieldVersions,
  required String activityId,
  Value<int?> totalMinutes,
  Value<DateTime?> deadlineAt,
  Value<String> splitMode,
  Value<int?> minChunkMinutes,
  Value<int?> maxChunkMinutes,
  Value<int?> dailyCapMinutes,
  Value<List<Object?>?> preferredWindows,
  Value<int?> safetyMarginMinutes,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<String> id,
  Value<DateTime> createdAt,
  Value<DateTime> updatedAt,
  Value<DateTime?> deletedAt,
  Value<Map<String, String>> fieldVersions,
  Value<String> activityId,
  Value<int?> totalMinutes,
  Value<DateTime?> deadlineAt,
  Value<String> splitMode,
  Value<int?> minChunkMinutes,
  Value<int?> maxChunkMinutes,
  Value<int?> dailyCapMinutes,
  Value<List<Object?>?> preferredWindows,
  Value<int?> safetyMarginMinutes,
  Value<int> rowid,
});

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, Project> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ActivitiesTable _activityIdTable(_$AppDatabase db) =>
      db.activities.createAlias('projects__activity_id__activities__id');

  $$ActivitiesTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deadlineAt => $composableBuilder(
    column: $table.deadlineAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get splitMode => $composableBuilder(
    column: $table.splitMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minChunkMinutes => $composableBuilder(
    column: $table.minChunkMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxChunkMinutes => $composableBuilder(
    column: $table.maxChunkMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyCapMinutes => $composableBuilder(
    column: $table.dailyCapMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Object?>?, List<Object>?, String>
  get preferredWindows => $composableBuilder(
    column: $table.preferredWindows,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get safetyMarginMinutes => $composableBuilder(
    column: $table.safetyMarginMinutes,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableFilterComposer get activityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deadlineAt => $composableBuilder(
    column: $table.deadlineAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get splitMode => $composableBuilder(
    column: $table.splitMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minChunkMinutes => $composableBuilder(
    column: $table.minChunkMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxChunkMinutes => $composableBuilder(
    column: $table.maxChunkMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyCapMinutes => $composableBuilder(
    column: $table.dailyCapMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get preferredWindows => $composableBuilder(
    column: $table.preferredWindows,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get safetyMarginMinutes => $composableBuilder(
    column: $table.safetyMarginMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableOrderingComposer get activityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>, String>
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalMinutes => $composableBuilder(
    column: $table.totalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get deadlineAt => $composableBuilder(
    column: $table.deadlineAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get splitMode =>
      $composableBuilder(column: $table.splitMode, builder: (column) => column);

  GeneratedColumn<int> get minChunkMinutes => $composableBuilder(
    column: $table.minChunkMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get maxChunkMinutes => $composableBuilder(
    column: $table.maxChunkMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyCapMinutes => $composableBuilder(
    column: $table.dailyCapMinutes,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<Object?>?, String>
  get preferredWindows => $composableBuilder(
    column: $table.preferredWindows,
    builder: (column) => column,
  );

  GeneratedColumn<int> get safetyMarginMinutes => $composableBuilder(
    column: $table.safetyMarginMinutes,
    builder: (column) => column,
  );

  $$ActivitiesTableAnnotationComposer get activityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          Project,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (Project, $$ProjectsTableReferences),
          Project,
          PrefetchHooks Function({bool activityId})
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<int?> totalMinutes = const Value.absent(),
                Value<DateTime?> deadlineAt = const Value.absent(),
                Value<String> splitMode = const Value.absent(),
                Value<int?> minChunkMinutes = const Value.absent(),
                Value<int?> maxChunkMinutes = const Value.absent(),
                Value<int?> dailyCapMinutes = const Value.absent(),
                Value<List<Object?>?> preferredWindows = const Value.absent(),
                Value<int?> safetyMarginMinutes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                activityId: activityId,
                totalMinutes: totalMinutes,
                deadlineAt: deadlineAt,
                splitMode: splitMode,
                minChunkMinutes: minChunkMinutes,
                maxChunkMinutes: maxChunkMinutes,
                dailyCapMinutes: dailyCapMinutes,
                preferredWindows: preferredWindows,
                safetyMarginMinutes: safetyMarginMinutes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                required String activityId,
                Value<int?> totalMinutes = const Value.absent(),
                Value<DateTime?> deadlineAt = const Value.absent(),
                Value<String> splitMode = const Value.absent(),
                Value<int?> minChunkMinutes = const Value.absent(),
                Value<int?> maxChunkMinutes = const Value.absent(),
                Value<int?> dailyCapMinutes = const Value.absent(),
                Value<List<Object?>?> preferredWindows = const Value.absent(),
                Value<int?> safetyMarginMinutes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                activityId: activityId,
                totalMinutes: totalMinutes,
                deadlineAt: deadlineAt,
                splitMode: splitMode,
                minChunkMinutes: minChunkMinutes,
                maxChunkMinutes: maxChunkMinutes,
                dailyCapMinutes: dailyCapMinutes,
                preferredWindows: preferredWindows,
                safetyMarginMinutes: safetyMarginMinutes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProjectsTable, Project>(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({activityId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (activityId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.activityId,
                        referencedTable: $$ProjectsTableReferences
                            ._activityIdTable(db),
                        referencedColumn: $$ProjectsTableReferences
                            ._activityIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      Project,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (Project, $$ProjectsTableReferences),
      Project,
      PrefetchHooks Function({bool activityId})
    >;
typedef $$DayOverridesTableCreateCompanionBuilder =
    DayOverridesCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      Value<String?> date,
      Value<Recurrence?> recurrence,
      Value<String?> validFrom,
      Value<String?> validUntil,
      Value<String> keep,
      Value<bool> autoPlacement,
      Value<String?> label,
      Value<int> rowid,
    });
typedef $$DayOverridesTableUpdateCompanionBuilder =
    DayOverridesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      Value<String?> date,
      Value<Recurrence?> recurrence,
      Value<String?> validFrom,
      Value<String?> validUntil,
      Value<String> keep,
      Value<bool> autoPlacement,
      Value<String?> label,
      Value<int> rowid,
    });

class $$DayOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $DayOverridesTable> {
  $$DayOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Recurrence?, Recurrence, String>
  get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keep => $composableBuilder(
    column: $table.keep,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoPlacement => $composableBuilder(
    column: $table.autoPlacement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DayOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $DayOverridesTable> {
  $$DayOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validFrom => $composableBuilder(
    column: $table.validFrom,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keep => $composableBuilder(
    column: $table.keep,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoPlacement => $composableBuilder(
    column: $table.autoPlacement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DayOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayOverridesTable> {
  $$DayOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>, String>
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Recurrence?, String> get recurrence =>
      $composableBuilder(
        column: $table.recurrence,
        builder: (column) => column,
      );

  GeneratedColumn<String> get validFrom =>
      $composableBuilder(column: $table.validFrom, builder: (column) => column);

  GeneratedColumn<String> get validUntil => $composableBuilder(
    column: $table.validUntil,
    builder: (column) => column,
  );

  GeneratedColumn<String> get keep =>
      $composableBuilder(column: $table.keep, builder: (column) => column);

  GeneratedColumn<bool> get autoPlacement => $composableBuilder(
    column: $table.autoPlacement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);
}

class $$DayOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayOverridesTable,
          DayOverride,
          $$DayOverridesTableFilterComposer,
          $$DayOverridesTableOrderingComposer,
          $$DayOverridesTableAnnotationComposer,
          $$DayOverridesTableCreateCompanionBuilder,
          $$DayOverridesTableUpdateCompanionBuilder,
          (
            DayOverride,
            BaseReferences<_$AppDatabase, $DayOverridesTable, DayOverride>,
          ),
          DayOverride,
          PrefetchHooks Function()
        > {
  $$DayOverridesTableTableManager(_$AppDatabase db, $DayOverridesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayOverridesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String?> date = const Value.absent(),
                Value<Recurrence?> recurrence = const Value.absent(),
                Value<String?> validFrom = const Value.absent(),
                Value<String?> validUntil = const Value.absent(),
                Value<String> keep = const Value.absent(),
                Value<bool> autoPlacement = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayOverridesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                date: date,
                recurrence: recurrence,
                validFrom: validFrom,
                validUntil: validUntil,
                keep: keep,
                autoPlacement: autoPlacement,
                label: label,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String?> date = const Value.absent(),
                Value<Recurrence?> recurrence = const Value.absent(),
                Value<String?> validFrom = const Value.absent(),
                Value<String?> validUntil = const Value.absent(),
                Value<String> keep = const Value.absent(),
                Value<bool> autoPlacement = const Value.absent(),
                Value<String?> label = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DayOverridesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                date: date,
                recurrence: recurrence,
                validFrom: validFrom,
                validUntil: validUntil,
                keep: keep,
                autoPlacement: autoPlacement,
                label: label,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DayOverridesTable, DayOverride>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DayOverridesTable,
                    DayOverride
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DayOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayOverridesTable,
      DayOverride,
      $$DayOverridesTableFilterComposer,
      $$DayOverridesTableOrderingComposer,
      $$DayOverridesTableAnnotationComposer,
      $$DayOverridesTableCreateCompanionBuilder,
      $$DayOverridesTableUpdateCompanionBuilder,
      (
        DayOverride,
        BaseReferences<_$AppDatabase, $DayOverridesTable, DayOverride>,
      ),
      DayOverride,
      PrefetchHooks Function()
    >;
typedef $$PlanInstancesTableCreateCompanionBuilder =
    PlanInstancesCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      required String activityId,
      Value<String?> ruleId,
      required String occurrenceDate,
      Value<DateTime?> startAt,
      Value<DateTime?> endAt,
      Value<String> status,
      required String source,
      Value<String?> variantId,
      Value<String?> parentInstanceId,
      Value<String?> movedFromId,
      Value<bool> isManual,
      Value<int?> engineVersion,
      Value<int?> plannedMinutes,
      Value<int> rowid,
    });
typedef $$PlanInstancesTableUpdateCompanionBuilder =
    PlanInstancesCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      Value<String> activityId,
      Value<String?> ruleId,
      Value<String> occurrenceDate,
      Value<DateTime?> startAt,
      Value<DateTime?> endAt,
      Value<String> status,
      Value<String> source,
      Value<String?> variantId,
      Value<String?> parentInstanceId,
      Value<String?> movedFromId,
      Value<bool> isManual,
      Value<int?> engineVersion,
      Value<int?> plannedMinutes,
      Value<int> rowid,
    });

final class $$PlanInstancesTableReferences
    extends BaseReferences<_$AppDatabase, $PlanInstancesTable, PlanInstance> {
  $$PlanInstancesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ActivitiesTable _activityIdTable(_$AppDatabase db) =>
      db.activities.createAlias('plan_instances__activity_id__activities__id');

  $$ActivitiesTableProcessedTableManager get activityId {
    final $_column = $_itemColumn<String>('activity_id')!;

    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ScheduleRulesTable _ruleIdTable(_$AppDatabase db) => db.scheduleRules
      .createAlias('plan_instances__rule_id__schedule_rules__id');

  $$ScheduleRulesTableProcessedTableManager? get ruleId {
    final $_column = $_itemColumn<String>('rule_id');
    if ($_column == null) return null;
    final manager = $$ScheduleRulesTableTableManager(
      $_db,
      $_db.scheduleRules,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_ruleIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $VariantsTable _variantIdTable(_$AppDatabase db) =>
      db.variants.createAlias('plan_instances__variant_id__variants__id');

  $$VariantsTableProcessedTableManager? get variantId {
    final $_column = $_itemColumn<String>('variant_id');
    if ($_column == null) return null;
    final manager = $$VariantsTableTableManager(
      $_db,
      $_db.variants,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_variantIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlanInstancesTable _parentInstanceIdTable(_$AppDatabase db) => db
      .planInstances
      .createAlias('plan_instances__parent_instance_id__plan_instances__id');

  $$PlanInstancesTableProcessedTableManager? get parentInstanceId {
    final $_column = $_itemColumn<String>('parent_instance_id');
    if ($_column == null) return null;
    final manager = $$PlanInstancesTableTableManager(
      $_db,
      $_db.planInstances,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentInstanceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $PlanInstancesTable _movedFromIdTable(_$AppDatabase db) => db
      .planInstances
      .createAlias('plan_instances__moved_from_id__plan_instances__id');

  $$PlanInstancesTableProcessedTableManager? get movedFromId {
    final $_column = $_itemColumn<String>('moved_from_id');
    if ($_column == null) return null;
    final manager = $$PlanInstancesTableTableManager(
      $_db,
      $_db.planInstances,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_movedFromIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FocusSessionsTable, List<FocusSession>>
  _focusSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.focusSessions,
    aliasName: 'plan_instances__id__focus_sessions__plan_instance_id',
  );

  $$FocusSessionsTableProcessedTableManager get focusSessionsRefs {
    final manager = $$FocusSessionsTableTableManager(
      $_db,
      $_db.focusSessions,
    ).filter((f) => f.planInstanceId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_focusSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PlanInstancesTableFilterComposer
    extends Composer<_$AppDatabase, $PlanInstancesTable> {
  $$PlanInstancesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isManual => $composableBuilder(
    column: $table.isManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get engineVersion => $composableBuilder(
    column: $table.engineVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  $$ActivitiesTableFilterComposer get activityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ScheduleRulesTableFilterComposer get ruleId {
    final $$ScheduleRulesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.scheduleRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleRulesTableFilterComposer(
            $db: $db,
            $table: $db.scheduleRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VariantsTableFilterComposer get variantId {
    final $$VariantsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.variants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantsTableFilterComposer(
            $db: $db,
            $table: $db.variants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlanInstancesTableFilterComposer get parentInstanceId {
    final $$PlanInstancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentInstanceId,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableFilterComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlanInstancesTableFilterComposer get movedFromId {
    final $$PlanInstancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movedFromId,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableFilterComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> focusSessionsRefs(
    Expression<bool> Function($$FocusSessionsTableFilterComposer f) f,
  ) {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.planInstanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlanInstancesTableOrderingComposer
    extends Composer<_$AppDatabase, $PlanInstancesTable> {
  $$PlanInstancesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isManual => $composableBuilder(
    column: $table.isManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get engineVersion => $composableBuilder(
    column: $table.engineVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ActivitiesTableOrderingComposer get activityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ScheduleRulesTableOrderingComposer get ruleId {
    final $$ScheduleRulesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.scheduleRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleRulesTableOrderingComposer(
            $db: $db,
            $table: $db.scheduleRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VariantsTableOrderingComposer get variantId {
    final $$VariantsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.variants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantsTableOrderingComposer(
            $db: $db,
            $table: $db.variants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlanInstancesTableOrderingComposer get parentInstanceId {
    final $$PlanInstancesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentInstanceId,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableOrderingComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlanInstancesTableOrderingComposer get movedFromId {
    final $$PlanInstancesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movedFromId,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableOrderingComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PlanInstancesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PlanInstancesTable> {
  $$PlanInstancesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>, String>
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get occurrenceDate => $composableBuilder(
    column: $table.occurrenceDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endAt =>
      $composableBuilder(column: $table.endAt, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isManual =>
      $composableBuilder(column: $table.isManual, builder: (column) => column);

  GeneratedColumn<int> get engineVersion => $composableBuilder(
    column: $table.engineVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => column,
  );

  $$ActivitiesTableAnnotationComposer get activityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ScheduleRulesTableAnnotationComposer get ruleId {
    final $$ScheduleRulesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.ruleId,
      referencedTable: $db.scheduleRules,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScheduleRulesTableAnnotationComposer(
            $db: $db,
            $table: $db.scheduleRules,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$VariantsTableAnnotationComposer get variantId {
    final $$VariantsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.variantId,
      referencedTable: $db.variants,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$VariantsTableAnnotationComposer(
            $db: $db,
            $table: $db.variants,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlanInstancesTableAnnotationComposer get parentInstanceId {
    final $$PlanInstancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentInstanceId,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableAnnotationComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$PlanInstancesTableAnnotationComposer get movedFromId {
    final $$PlanInstancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.movedFromId,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableAnnotationComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> focusSessionsRefs<T extends Object>(
    Expression<T> Function($$FocusSessionsTableAnnotationComposer a) f,
  ) {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.planInstanceId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PlanInstancesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PlanInstancesTable,
          PlanInstance,
          $$PlanInstancesTableFilterComposer,
          $$PlanInstancesTableOrderingComposer,
          $$PlanInstancesTableAnnotationComposer,
          $$PlanInstancesTableCreateCompanionBuilder,
          $$PlanInstancesTableUpdateCompanionBuilder,
          (PlanInstance, $$PlanInstancesTableReferences),
          PlanInstance,
          PrefetchHooks Function({
            bool activityId,
            bool ruleId,
            bool variantId,
            bool parentInstanceId,
            bool movedFromId,
            bool focusSessionsRefs,
          })
        > {
  $$PlanInstancesTableTableManager(_$AppDatabase db, $PlanInstancesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PlanInstancesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PlanInstancesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PlanInstancesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String> activityId = const Value.absent(),
                Value<String?> ruleId = const Value.absent(),
                Value<String> occurrenceDate = const Value.absent(),
                Value<DateTime?> startAt = const Value.absent(),
                Value<DateTime?> endAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<String?> variantId = const Value.absent(),
                Value<String?> parentInstanceId = const Value.absent(),
                Value<String?> movedFromId = const Value.absent(),
                Value<bool> isManual = const Value.absent(),
                Value<int?> engineVersion = const Value.absent(),
                Value<int?> plannedMinutes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanInstancesCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                activityId: activityId,
                ruleId: ruleId,
                occurrenceDate: occurrenceDate,
                startAt: startAt,
                endAt: endAt,
                status: status,
                source: source,
                variantId: variantId,
                parentInstanceId: parentInstanceId,
                movedFromId: movedFromId,
                isManual: isManual,
                engineVersion: engineVersion,
                plannedMinutes: plannedMinutes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                required String activityId,
                Value<String?> ruleId = const Value.absent(),
                required String occurrenceDate,
                Value<DateTime?> startAt = const Value.absent(),
                Value<DateTime?> endAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                required String source,
                Value<String?> variantId = const Value.absent(),
                Value<String?> parentInstanceId = const Value.absent(),
                Value<String?> movedFromId = const Value.absent(),
                Value<bool> isManual = const Value.absent(),
                Value<int?> engineVersion = const Value.absent(),
                Value<int?> plannedMinutes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PlanInstancesCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                activityId: activityId,
                ruleId: ruleId,
                occurrenceDate: occurrenceDate,
                startAt: startAt,
                endAt: endAt,
                status: status,
                source: source,
                variantId: variantId,
                parentInstanceId: parentInstanceId,
                movedFromId: movedFromId,
                isManual: isManual,
                engineVersion: engineVersion,
                plannedMinutes: plannedMinutes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PlanInstancesTable, PlanInstance>(table),
                  $$PlanInstancesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                activityId = false,
                ruleId = false,
                variantId = false,
                parentInstanceId = false,
                movedFromId = false,
                focusSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (focusSessionsRefs) db.focusSessions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (activityId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.activityId,
                            referencedTable: $$PlanInstancesTableReferences
                                ._activityIdTable(db),
                            referencedColumn: $$PlanInstancesTableReferences
                                ._activityIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (ruleId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.ruleId,
                            referencedTable: $$PlanInstancesTableReferences
                                ._ruleIdTable(db),
                            referencedColumn: $$PlanInstancesTableReferences
                                ._ruleIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (variantId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.variantId,
                            referencedTable: $$PlanInstancesTableReferences
                                ._variantIdTable(db),
                            referencedColumn: $$PlanInstancesTableReferences
                                ._variantIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (parentInstanceId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.parentInstanceId,
                            referencedTable: $$PlanInstancesTableReferences
                                ._parentInstanceIdTable(db),
                            referencedColumn: $$PlanInstancesTableReferences
                                ._parentInstanceIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (movedFromId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.movedFromId,
                            referencedTable: $$PlanInstancesTableReferences
                                ._movedFromIdTable(db),
                            referencedColumn: $$PlanInstancesTableReferences
                                ._movedFromIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (focusSessionsRefs)
                        await $_getPrefetchedDataByColumns<
                          PlanInstance,
                          $PlanInstancesTable,
                          FocusSession,
                          $FocusSessionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$PlanInstancesTableReferences
                              ._focusSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PlanInstancesTableReferences(
                                db,
                                table,
                                p0,
                              ).focusSessionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'plan_instance_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PlanInstancesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PlanInstancesTable,
      PlanInstance,
      $$PlanInstancesTableFilterComposer,
      $$PlanInstancesTableOrderingComposer,
      $$PlanInstancesTableAnnotationComposer,
      $$PlanInstancesTableCreateCompanionBuilder,
      $$PlanInstancesTableUpdateCompanionBuilder,
      (PlanInstance, $$PlanInstancesTableReferences),
      PlanInstance,
      PrefetchHooks Function({
        bool activityId,
        bool ruleId,
        bool variantId,
        bool parentInstanceId,
        bool movedFromId,
        bool focusSessionsRefs,
      })
    >;
typedef $$FocusSessionsTableCreateCompanionBuilder =
    FocusSessionsCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      Value<String?> planInstanceId,
      Value<String?> activityId,
      Value<String?> categoryId,
      Value<String?> rootCategoryKey,
      required String mode,
      Value<Map<String, Object?>?> settings,
      Value<int?> plannedMinutes,
      required DateTime startedAt,
      Value<DateTime?> endedAt,
      Value<int> focusedSeconds,
      Value<List<Object?>> segments,
      Value<String> outcome,
      Value<int?> focusRating,
      Value<int?> fatigueRating,
      Value<String?> note,
      Value<int> rowid,
    });
typedef $$FocusSessionsTableUpdateCompanionBuilder =
    FocusSessionsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      Value<String?> planInstanceId,
      Value<String?> activityId,
      Value<String?> categoryId,
      Value<String?> rootCategoryKey,
      Value<String> mode,
      Value<Map<String, Object?>?> settings,
      Value<int?> plannedMinutes,
      Value<DateTime> startedAt,
      Value<DateTime?> endedAt,
      Value<int> focusedSeconds,
      Value<List<Object?>> segments,
      Value<String> outcome,
      Value<int?> focusRating,
      Value<int?> fatigueRating,
      Value<String?> note,
      Value<int> rowid,
    });

final class $$FocusSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $FocusSessionsTable, FocusSession> {
  $$FocusSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PlanInstancesTable _planInstanceIdTable(_$AppDatabase db) => db
      .planInstances
      .createAlias('focus_sessions__plan_instance_id__plan_instances__id');

  $$PlanInstancesTableProcessedTableManager? get planInstanceId {
    final $_column = $_itemColumn<String>('plan_instance_id');
    if ($_column == null) return null;
    final manager = $$PlanInstancesTableTableManager(
      $_db,
      $_db.planInstances,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_planInstanceIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ActivitiesTable _activityIdTable(_$AppDatabase db) =>
      db.activities.createAlias('focus_sessions__activity_id__activities__id');

  $$ActivitiesTableProcessedTableManager? get activityId {
    final $_column = $_itemColumn<String>('activity_id');
    if ($_column == null) return null;
    final manager = $$ActivitiesTableTableManager(
      $_db,
      $_db.activities,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_activityIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $UserCategoriesTable _categoryIdTable(_$AppDatabase db) => db
      .userCategories
      .createAlias('focus_sessions__category_id__user_categories__id');

  $$UserCategoriesTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$UserCategoriesTableTableManager(
      $_db,
      $_db.userCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RootCategoriesTable _rootCategoryKeyTable(_$AppDatabase db) => db
      .rootCategories
      .createAlias('focus_sessions__root_category_key__root_categories__key');

  $$RootCategoriesTableProcessedTableManager? get rootCategoryKey {
    final $_column = $_itemColumn<String>('root_category_key');
    if ($_column == null) return null;
    final manager = $$RootCategoriesTableTableManager(
      $_db,
      $_db.rootCategories,
    ).filter((f) => f.key.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rootCategoryKeyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$FocusInterruptionsTable, List<FocusInterruption>>
  _focusInterruptionsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.focusInterruptions,
        aliasName: 'focus_sessions__id__focus_interruptions__session_id',
      );

  $$FocusInterruptionsTableProcessedTableManager get focusInterruptionsRefs {
    final manager = $$FocusInterruptionsTableTableManager(
      $_db,
      $_db.focusInterruptions,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _focusInterruptionsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BrainEventsTable, List<BrainEvent>>
  _brainEventsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.brainEvents,
    aliasName: 'focus_sessions__id__brain_events__session_id',
  );

  $$BrainEventsTableProcessedTableManager get brainEventsRefs {
    final manager = $$BrainEventsTableTableManager(
      $_db,
      $_db.brainEvents,
    ).filter((f) => f.sessionId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_brainEventsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FocusSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>?,
    Map<String, Object>?,
    String
  >
  get settings => $composableBuilder(
    column: $table.settings,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusedSeconds => $composableBuilder(
    column: $table.focusedSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<Object?>, List<Object>, String>
  get segments => $composableBuilder(
    column: $table.segments,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get focusRating => $composableBuilder(
    column: $table.focusRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fatigueRating => $composableBuilder(
    column: $table.fatigueRating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$PlanInstancesTableFilterComposer get planInstanceId {
    final $$PlanInstancesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planInstanceId,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableFilterComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActivitiesTableFilterComposer get activityId {
    final $$ActivitiesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableFilterComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UserCategoriesTableFilterComposer get categoryId {
    final $$UserCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.userCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.userCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RootCategoriesTableFilterComposer get rootCategoryKey {
    final $$RootCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootCategoryKey,
      referencedTable: $db.rootCategories,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.rootCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> focusInterruptionsRefs(
    Expression<bool> Function($$FocusInterruptionsTableFilterComposer f) f,
  ) {
    final $$FocusInterruptionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.focusInterruptions,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusInterruptionsTableFilterComposer(
            $db: $db,
            $table: $db.focusInterruptions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> brainEventsRefs(
    Expression<bool> Function($$BrainEventsTableFilterComposer f) f,
  ) {
    final $$BrainEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.brainEvents,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainEventsTableFilterComposer(
            $db: $db,
            $table: $db.brainEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FocusSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get settings => $composableBuilder(
    column: $table.settings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusedSeconds => $composableBuilder(
    column: $table.focusedSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get segments => $composableBuilder(
    column: $table.segments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get outcome => $composableBuilder(
    column: $table.outcome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get focusRating => $composableBuilder(
    column: $table.focusRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fatigueRating => $composableBuilder(
    column: $table.fatigueRating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$PlanInstancesTableOrderingComposer get planInstanceId {
    final $$PlanInstancesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planInstanceId,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableOrderingComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActivitiesTableOrderingComposer get activityId {
    final $$ActivitiesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableOrderingComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UserCategoriesTableOrderingComposer get categoryId {
    final $$UserCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.userCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.userCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RootCategoriesTableOrderingComposer get rootCategoryKey {
    final $$RootCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootCategoryKey,
      referencedTable: $db.rootCategories,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.rootCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusSessionsTable> {
  $$FocusSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>, String>
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, Object?>?, String>
  get settings =>
      $composableBuilder(column: $table.settings, builder: (column) => column);

  GeneratedColumn<int> get plannedMinutes => $composableBuilder(
    column: $table.plannedMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get focusedSeconds => $composableBuilder(
    column: $table.focusedSeconds,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<List<Object?>, String> get segments =>
      $composableBuilder(column: $table.segments, builder: (column) => column);

  GeneratedColumn<String> get outcome =>
      $composableBuilder(column: $table.outcome, builder: (column) => column);

  GeneratedColumn<int> get focusRating => $composableBuilder(
    column: $table.focusRating,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fatigueRating => $composableBuilder(
    column: $table.fatigueRating,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$PlanInstancesTableAnnotationComposer get planInstanceId {
    final $$PlanInstancesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.planInstanceId,
      referencedTable: $db.planInstances,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PlanInstancesTableAnnotationComposer(
            $db: $db,
            $table: $db.planInstances,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ActivitiesTableAnnotationComposer get activityId {
    final $$ActivitiesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.activityId,
      referencedTable: $db.activities,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ActivitiesTableAnnotationComposer(
            $db: $db,
            $table: $db.activities,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$UserCategoriesTableAnnotationComposer get categoryId {
    final $$UserCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.userCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$UserCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.userCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RootCategoriesTableAnnotationComposer get rootCategoryKey {
    final $$RootCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootCategoryKey,
      referencedTable: $db.rootCategories,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RootCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.rootCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> focusInterruptionsRefs<T extends Object>(
    Expression<T> Function($$FocusInterruptionsTableAnnotationComposer a) f,
  ) {
    final $$FocusInterruptionsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.focusInterruptions,
          getReferencedColumn: (t) => t.sessionId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FocusInterruptionsTableAnnotationComposer(
                $db: $db,
                $table: $db.focusInterruptions,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> brainEventsRefs<T extends Object>(
    Expression<T> Function($$BrainEventsTableAnnotationComposer a) f,
  ) {
    final $$BrainEventsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.brainEvents,
      getReferencedColumn: (t) => t.sessionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainEventsTableAnnotationComposer(
            $db: $db,
            $table: $db.brainEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$FocusSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusSessionsTable,
          FocusSession,
          $$FocusSessionsTableFilterComposer,
          $$FocusSessionsTableOrderingComposer,
          $$FocusSessionsTableAnnotationComposer,
          $$FocusSessionsTableCreateCompanionBuilder,
          $$FocusSessionsTableUpdateCompanionBuilder,
          (FocusSession, $$FocusSessionsTableReferences),
          FocusSession,
          PrefetchHooks Function({
            bool planInstanceId,
            bool activityId,
            bool categoryId,
            bool rootCategoryKey,
            bool focusInterruptionsRefs,
            bool brainEventsRefs,
          })
        > {
  $$FocusSessionsTableTableManager(_$AppDatabase db, $FocusSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String?> planInstanceId = const Value.absent(),
                Value<String?> activityId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> rootCategoryKey = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<Map<String, Object?>?> settings = const Value.absent(),
                Value<int?> plannedMinutes = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> focusedSeconds = const Value.absent(),
                Value<List<Object?>> segments = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<int?> focusRating = const Value.absent(),
                Value<int?> fatigueRating = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                planInstanceId: planInstanceId,
                activityId: activityId,
                categoryId: categoryId,
                rootCategoryKey: rootCategoryKey,
                mode: mode,
                settings: settings,
                plannedMinutes: plannedMinutes,
                startedAt: startedAt,
                endedAt: endedAt,
                focusedSeconds: focusedSeconds,
                segments: segments,
                outcome: outcome,
                focusRating: focusRating,
                fatigueRating: fatigueRating,
                note: note,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String?> planInstanceId = const Value.absent(),
                Value<String?> activityId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String?> rootCategoryKey = const Value.absent(),
                required String mode,
                Value<Map<String, Object?>?> settings = const Value.absent(),
                Value<int?> plannedMinutes = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> endedAt = const Value.absent(),
                Value<int> focusedSeconds = const Value.absent(),
                Value<List<Object?>> segments = const Value.absent(),
                Value<String> outcome = const Value.absent(),
                Value<int?> focusRating = const Value.absent(),
                Value<int?> fatigueRating = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusSessionsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                planInstanceId: planInstanceId,
                activityId: activityId,
                categoryId: categoryId,
                rootCategoryKey: rootCategoryKey,
                mode: mode,
                settings: settings,
                plannedMinutes: plannedMinutes,
                startedAt: startedAt,
                endedAt: endedAt,
                focusedSeconds: focusedSeconds,
                segments: segments,
                outcome: outcome,
                focusRating: focusRating,
                fatigueRating: fatigueRating,
                note: note,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FocusSessionsTable, FocusSession>(table),
                  $$FocusSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                planInstanceId = false,
                activityId = false,
                categoryId = false,
                rootCategoryKey = false,
                focusInterruptionsRefs = false,
                brainEventsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (focusInterruptionsRefs) db.focusInterruptions,
                    if (brainEventsRefs) db.brainEvents,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (planInstanceId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.planInstanceId,
                            referencedTable: $$FocusSessionsTableReferences
                                ._planInstanceIdTable(db),
                            referencedColumn: $$FocusSessionsTableReferences
                                ._planInstanceIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (activityId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.activityId,
                            referencedTable: $$FocusSessionsTableReferences
                                ._activityIdTable(db),
                            referencedColumn: $$FocusSessionsTableReferences
                                ._activityIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$FocusSessionsTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$FocusSessionsTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (rootCategoryKey) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.rootCategoryKey,
                            referencedTable: $$FocusSessionsTableReferences
                                ._rootCategoryKeyTable(db),
                            referencedColumn: $$FocusSessionsTableReferences
                                ._rootCategoryKeyTable(db)
                                .key,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (focusInterruptionsRefs)
                        await $_getPrefetchedDataByColumns<
                          FocusSession,
                          $FocusSessionsTable,
                          FocusInterruption,
                          $FocusInterruptionsTable
                        >(
                          currentTable: table,
                          referencedTable: $$FocusSessionsTableReferences
                              ._focusInterruptionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FocusSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).focusInterruptionsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'session_id',
                          typedResults: items,
                        ),
                      if (brainEventsRefs)
                        await $_getPrefetchedDataByColumns<
                          FocusSession,
                          $FocusSessionsTable,
                          BrainEvent,
                          $BrainEventsTable
                        >(
                          currentTable: table,
                          referencedTable: $$FocusSessionsTableReferences
                              ._brainEventsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FocusSessionsTableReferences(
                                db,
                                table,
                                p0,
                              ).brainEventsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'session_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FocusSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusSessionsTable,
      FocusSession,
      $$FocusSessionsTableFilterComposer,
      $$FocusSessionsTableOrderingComposer,
      $$FocusSessionsTableAnnotationComposer,
      $$FocusSessionsTableCreateCompanionBuilder,
      $$FocusSessionsTableUpdateCompanionBuilder,
      (FocusSession, $$FocusSessionsTableReferences),
      FocusSession,
      PrefetchHooks Function({
        bool planInstanceId,
        bool activityId,
        bool categoryId,
        bool rootCategoryKey,
        bool focusInterruptionsRefs,
        bool brainEventsRefs,
      })
    >;
typedef $$FocusInterruptionsTableCreateCompanionBuilder =
    FocusInterruptionsCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      required String sessionId,
      required DateTime leftAt,
      required int awayMs,
      required String reason,
      required bool recovered,
      required bool counted,
      Value<int> rowid,
    });
typedef $$FocusInterruptionsTableUpdateCompanionBuilder =
    FocusInterruptionsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      Value<String> sessionId,
      Value<DateTime> leftAt,
      Value<int> awayMs,
      Value<String> reason,
      Value<bool> recovered,
      Value<bool> counted,
      Value<int> rowid,
    });

final class $$FocusInterruptionsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FocusInterruptionsTable,
          FocusInterruption
        > {
  $$FocusInterruptionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FocusSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .focusSessions
      .createAlias('focus_interruptions__session_id__focus_sessions__id');

  $$FocusSessionsTableProcessedTableManager get sessionId {
    final $_column = $_itemColumn<String>('session_id')!;

    final manager = $$FocusSessionsTableTableManager(
      $_db,
      $_db.focusSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FocusInterruptionsTableFilterComposer
    extends Composer<_$AppDatabase, $FocusInterruptionsTable> {
  $$FocusInterruptionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<DateTime> get leftAt => $composableBuilder(
    column: $table.leftAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awayMs => $composableBuilder(
    column: $table.awayMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get recovered => $composableBuilder(
    column: $table.recovered,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get counted => $composableBuilder(
    column: $table.counted,
    builder: (column) => ColumnFilters(column),
  );

  $$FocusSessionsTableFilterComposer get sessionId {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusInterruptionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FocusInterruptionsTable> {
  $$FocusInterruptionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get leftAt => $composableBuilder(
    column: $table.leftAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awayMs => $composableBuilder(
    column: $table.awayMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get recovered => $composableBuilder(
    column: $table.recovered,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get counted => $composableBuilder(
    column: $table.counted,
    builder: (column) => ColumnOrderings(column),
  );

  $$FocusSessionsTableOrderingComposer get sessionId {
    final $$FocusSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusInterruptionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FocusInterruptionsTable> {
  $$FocusInterruptionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>, String>
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get leftAt =>
      $composableBuilder(column: $table.leftAt, builder: (column) => column);

  GeneratedColumn<int> get awayMs =>
      $composableBuilder(column: $table.awayMs, builder: (column) => column);

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);

  GeneratedColumn<bool> get recovered =>
      $composableBuilder(column: $table.recovered, builder: (column) => column);

  GeneratedColumn<bool> get counted =>
      $composableBuilder(column: $table.counted, builder: (column) => column);

  $$FocusSessionsTableAnnotationComposer get sessionId {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FocusInterruptionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FocusInterruptionsTable,
          FocusInterruption,
          $$FocusInterruptionsTableFilterComposer,
          $$FocusInterruptionsTableOrderingComposer,
          $$FocusInterruptionsTableAnnotationComposer,
          $$FocusInterruptionsTableCreateCompanionBuilder,
          $$FocusInterruptionsTableUpdateCompanionBuilder,
          (FocusInterruption, $$FocusInterruptionsTableReferences),
          FocusInterruption,
          PrefetchHooks Function({bool sessionId})
        > {
  $$FocusInterruptionsTableTableManager(
    _$AppDatabase db,
    $FocusInterruptionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FocusInterruptionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FocusInterruptionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FocusInterruptionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<DateTime> leftAt = const Value.absent(),
                Value<int> awayMs = const Value.absent(),
                Value<String> reason = const Value.absent(),
                Value<bool> recovered = const Value.absent(),
                Value<bool> counted = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FocusInterruptionsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                sessionId: sessionId,
                leftAt: leftAt,
                awayMs: awayMs,
                reason: reason,
                recovered: recovered,
                counted: counted,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                required String sessionId,
                required DateTime leftAt,
                required int awayMs,
                required String reason,
                required bool recovered,
                required bool counted,
                Value<int> rowid = const Value.absent(),
              }) => FocusInterruptionsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                sessionId: sessionId,
                leftAt: leftAt,
                awayMs: awayMs,
                reason: reason,
                recovered: recovered,
                counted: counted,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FocusInterruptionsTable, FocusInterruption>(
                    table,
                  ),
                  $$FocusInterruptionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({sessionId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (sessionId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.sessionId,
                        referencedTable: $$FocusInterruptionsTableReferences
                            ._sessionIdTable(db),
                        referencedColumn: $$FocusInterruptionsTableReferences
                            ._sessionIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FocusInterruptionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FocusInterruptionsTable,
      FocusInterruption,
      $$FocusInterruptionsTableFilterComposer,
      $$FocusInterruptionsTableOrderingComposer,
      $$FocusInterruptionsTableAnnotationComposer,
      $$FocusInterruptionsTableCreateCompanionBuilder,
      $$FocusInterruptionsTableUpdateCompanionBuilder,
      (FocusInterruption, $$FocusInterruptionsTableReferences),
      FocusInterruption,
      PrefetchHooks Function({bool sessionId})
    >;
typedef $$BrainEventsTableCreateCompanionBuilder =
    BrainEventsCompanion Function({
      required String id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      required String type,
      Value<String?> regionKey,
      Value<String?> regionBKey,
      required int amount,
      required DateTime occurredAt,
      Value<String?> sessionId,
      required String dedupeKey,
      required int engineVersion,
      Value<int> rowid,
    });
typedef $$BrainEventsTableUpdateCompanionBuilder =
    BrainEventsCompanion Function({
      Value<String> id,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<Map<String, String>> fieldVersions,
      Value<String> type,
      Value<String?> regionKey,
      Value<String?> regionBKey,
      Value<int> amount,
      Value<DateTime> occurredAt,
      Value<String?> sessionId,
      Value<String> dedupeKey,
      Value<int> engineVersion,
      Value<int> rowid,
    });

final class $$BrainEventsTableReferences
    extends BaseReferences<_$AppDatabase, $BrainEventsTable, BrainEvent> {
  $$BrainEventsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $BrainRegionsTable _regionKeyTable(_$AppDatabase db) => db.brainRegions
      .createAlias('brain_events__region_key__brain_regions__key');

  $$BrainRegionsTableProcessedTableManager? get regionKey {
    final $_column = $_itemColumn<String>('region_key');
    if ($_column == null) return null;
    final manager = $$BrainRegionsTableTableManager(
      $_db,
      $_db.brainRegions,
    ).filter((f) => f.key.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_regionKeyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BrainRegionsTable _regionBKeyTable(_$AppDatabase db) => db
      .brainRegions
      .createAlias('brain_events__region_b_key__brain_regions__key');

  $$BrainRegionsTableProcessedTableManager? get regionBKey {
    final $_column = $_itemColumn<String>('region_b_key');
    if ($_column == null) return null;
    final manager = $$BrainRegionsTableTableManager(
      $_db,
      $_db.brainRegions,
    ).filter((f) => f.key.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_regionBKeyTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FocusSessionsTable _sessionIdTable(_$AppDatabase db) => db
      .focusSessions
      .createAlias('brain_events__session_id__focus_sessions__id');

  $$FocusSessionsTableProcessedTableManager? get sessionId {
    final $_column = $_itemColumn<String>('session_id');
    if ($_column == null) return null;
    final manager = $$FocusSessionsTableTableManager(
      $_db,
      $_db.focusSessions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sessionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BrainEventsTableFilterComposer
    extends Composer<_$AppDatabase, $BrainEventsTable> {
  $$BrainEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, String>,
    Map<String, String>,
    String
  >
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dedupeKey => $composableBuilder(
    column: $table.dedupeKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get engineVersion => $composableBuilder(
    column: $table.engineVersion,
    builder: (column) => ColumnFilters(column),
  );

  $$BrainRegionsTableFilterComposer get regionKey {
    final $$BrainRegionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.regionKey,
      referencedTable: $db.brainRegions,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainRegionsTableFilterComposer(
            $db: $db,
            $table: $db.brainRegions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BrainRegionsTableFilterComposer get regionBKey {
    final $$BrainRegionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.regionBKey,
      referencedTable: $db.brainRegions,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainRegionsTableFilterComposer(
            $db: $db,
            $table: $db.brainRegions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FocusSessionsTableFilterComposer get sessionId {
    final $$FocusSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableFilterComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BrainEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $BrainEventsTable> {
  $$BrainEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dedupeKey => $composableBuilder(
    column: $table.dedupeKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get engineVersion => $composableBuilder(
    column: $table.engineVersion,
    builder: (column) => ColumnOrderings(column),
  );

  $$BrainRegionsTableOrderingComposer get regionKey {
    final $$BrainRegionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.regionKey,
      referencedTable: $db.brainRegions,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainRegionsTableOrderingComposer(
            $db: $db,
            $table: $db.brainRegions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BrainRegionsTableOrderingComposer get regionBKey {
    final $$BrainRegionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.regionBKey,
      referencedTable: $db.brainRegions,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainRegionsTableOrderingComposer(
            $db: $db,
            $table: $db.brainRegions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FocusSessionsTableOrderingComposer get sessionId {
    final $$FocusSessionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableOrderingComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BrainEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BrainEventsTable> {
  $$BrainEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Map<String, String>, String>
  get fieldVersions => $composableBuilder(
    column: $table.fieldVersions,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get occurredAt => $composableBuilder(
    column: $table.occurredAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dedupeKey =>
      $composableBuilder(column: $table.dedupeKey, builder: (column) => column);

  GeneratedColumn<int> get engineVersion => $composableBuilder(
    column: $table.engineVersion,
    builder: (column) => column,
  );

  $$BrainRegionsTableAnnotationComposer get regionKey {
    final $$BrainRegionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.regionKey,
      referencedTable: $db.brainRegions,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainRegionsTableAnnotationComposer(
            $db: $db,
            $table: $db.brainRegions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BrainRegionsTableAnnotationComposer get regionBKey {
    final $$BrainRegionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.regionBKey,
      referencedTable: $db.brainRegions,
      getReferencedColumn: (t) => t.key,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BrainRegionsTableAnnotationComposer(
            $db: $db,
            $table: $db.brainRegions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FocusSessionsTableAnnotationComposer get sessionId {
    final $$FocusSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sessionId,
      referencedTable: $db.focusSessions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FocusSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.focusSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BrainEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BrainEventsTable,
          BrainEvent,
          $$BrainEventsTableFilterComposer,
          $$BrainEventsTableOrderingComposer,
          $$BrainEventsTableAnnotationComposer,
          $$BrainEventsTableCreateCompanionBuilder,
          $$BrainEventsTableUpdateCompanionBuilder,
          (BrainEvent, $$BrainEventsTableReferences),
          BrainEvent,
          PrefetchHooks Function({
            bool regionKey,
            bool regionBKey,
            bool sessionId,
          })
        > {
  $$BrainEventsTableTableManager(_$AppDatabase db, $BrainEventsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrainEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrainEventsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrainEventsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> regionKey = const Value.absent(),
                Value<String?> regionBKey = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<DateTime> occurredAt = const Value.absent(),
                Value<String?> sessionId = const Value.absent(),
                Value<String> dedupeKey = const Value.absent(),
                Value<int> engineVersion = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BrainEventsCompanion(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                type: type,
                regionKey: regionKey,
                regionBKey: regionBKey,
                amount: amount,
                occurredAt: occurredAt,
                sessionId: sessionId,
                dedupeKey: dedupeKey,
                engineVersion: engineVersion,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<Map<String, String>> fieldVersions = const Value.absent(),
                required String type,
                Value<String?> regionKey = const Value.absent(),
                Value<String?> regionBKey = const Value.absent(),
                required int amount,
                required DateTime occurredAt,
                Value<String?> sessionId = const Value.absent(),
                required String dedupeKey,
                required int engineVersion,
                Value<int> rowid = const Value.absent(),
              }) => BrainEventsCompanion.insert(
                id: id,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                fieldVersions: fieldVersions,
                type: type,
                regionKey: regionKey,
                regionBKey: regionBKey,
                amount: amount,
                occurredAt: occurredAt,
                sessionId: sessionId,
                dedupeKey: dedupeKey,
                engineVersion: engineVersion,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BrainEventsTable, BrainEvent>(table),
                  $$BrainEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({regionKey = false, regionBKey = false, sessionId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (regionKey) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.regionKey,
                            referencedTable: $$BrainEventsTableReferences
                                ._regionKeyTable(db),
                            referencedColumn: $$BrainEventsTableReferences
                                ._regionKeyTable(db)
                                .key,
                          ) as T;
                        }
                        if (regionBKey) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.regionBKey,
                            referencedTable: $$BrainEventsTableReferences
                                ._regionBKeyTable(db),
                            referencedColumn: $$BrainEventsTableReferences
                                ._regionBKeyTable(db)
                                .key,
                          ) as T;
                        }
                        if (sessionId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sessionId,
                            referencedTable: $$BrainEventsTableReferences
                                ._sessionIdTable(db),
                            referencedColumn: $$BrainEventsTableReferences
                                ._sessionIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$BrainEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BrainEventsTable,
      BrainEvent,
      $$BrainEventsTableFilterComposer,
      $$BrainEventsTableOrderingComposer,
      $$BrainEventsTableAnnotationComposer,
      $$BrainEventsTableCreateCompanionBuilder,
      $$BrainEventsTableUpdateCompanionBuilder,
      (BrainEvent, $$BrainEventsTableReferences),
      BrainEvent,
      PrefetchHooks Function({bool regionKey, bool regionBKey, bool sessionId})
    >;
typedef $$BrainSnapshotsTableCreateCompanionBuilder =
    BrainSnapshotsCompanion Function({
      Value<int> engineVersion,
      required DateTime asOf,
      required String eventsHash,
      required Map<String, Object?> state,
    });
typedef $$BrainSnapshotsTableUpdateCompanionBuilder =
    BrainSnapshotsCompanion Function({
      Value<int> engineVersion,
      Value<DateTime> asOf,
      Value<String> eventsHash,
      Value<Map<String, Object?>> state,
    });

class $$BrainSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $BrainSnapshotsTable> {
  $$BrainSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get engineVersion => $composableBuilder(
    column: $table.engineVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get asOf => $composableBuilder(
    column: $table.asOf,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get eventsHash => $composableBuilder(
    column: $table.eventsHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<
    Map<String, Object?>,
    Map<String, Object>,
    String
  >
  get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );
}

class $$BrainSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $BrainSnapshotsTable> {
  $$BrainSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get engineVersion => $composableBuilder(
    column: $table.engineVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get asOf => $composableBuilder(
    column: $table.asOf,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get eventsHash => $composableBuilder(
    column: $table.eventsHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrainSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BrainSnapshotsTable> {
  $$BrainSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get engineVersion => $composableBuilder(
    column: $table.engineVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get asOf =>
      $composableBuilder(column: $table.asOf, builder: (column) => column);

  GeneratedColumn<String> get eventsHash => $composableBuilder(
    column: $table.eventsHash,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<Map<String, Object?>, String> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);
}

class $$BrainSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BrainSnapshotsTable,
          BrainSnapshot,
          $$BrainSnapshotsTableFilterComposer,
          $$BrainSnapshotsTableOrderingComposer,
          $$BrainSnapshotsTableAnnotationComposer,
          $$BrainSnapshotsTableCreateCompanionBuilder,
          $$BrainSnapshotsTableUpdateCompanionBuilder,
          (
            BrainSnapshot,
            BaseReferences<_$AppDatabase, $BrainSnapshotsTable, BrainSnapshot>,
          ),
          BrainSnapshot,
          PrefetchHooks Function()
        > {
  $$BrainSnapshotsTableTableManager(
    _$AppDatabase db,
    $BrainSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrainSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrainSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrainSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> engineVersion = const Value.absent(),
                Value<DateTime> asOf = const Value.absent(),
                Value<String> eventsHash = const Value.absent(),
                Value<Map<String, Object?>> state = const Value.absent(),
              }) => BrainSnapshotsCompanion(
                engineVersion: engineVersion,
                asOf: asOf,
                eventsHash: eventsHash,
                state: state,
              ),
          createCompanionCallback:
              ({
                Value<int> engineVersion = const Value.absent(),
                required DateTime asOf,
                required String eventsHash,
                required Map<String, Object?> state,
              }) => BrainSnapshotsCompanion.insert(
                engineVersion: engineVersion,
                asOf: asOf,
                eventsHash: eventsHash,
                state: state,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BrainSnapshotsTable, BrainSnapshot>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $BrainSnapshotsTable,
                    BrainSnapshot
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BrainSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BrainSnapshotsTable,
      BrainSnapshot,
      $$BrainSnapshotsTableFilterComposer,
      $$BrainSnapshotsTableOrderingComposer,
      $$BrainSnapshotsTableAnnotationComposer,
      $$BrainSnapshotsTableCreateCompanionBuilder,
      $$BrainSnapshotsTableUpdateCompanionBuilder,
      (
        BrainSnapshot,
        BaseReferences<_$AppDatabase, $BrainSnapshotsTable, BrainSnapshot>,
      ),
      BrainSnapshot,
      PrefetchHooks Function()
    >;
typedef $$SyncOutboxTableCreateCompanionBuilder = SyncOutboxCompanion Function({
  Value<int> seq,
  required String targetTable,
  required String targetId,
  required String patch,
  required String hlc,
  required DateTime createdAt,
  Value<int> attempts,
  Value<String?> lastError,
  Value<bool> dead,
});
typedef $$SyncOutboxTableUpdateCompanionBuilder = SyncOutboxCompanion Function({
  Value<int> seq,
  Value<String> targetTable,
  Value<String> targetId,
  Value<String> patch,
  Value<String> hlc,
  Value<DateTime> createdAt,
  Value<int> attempts,
  Value<String?> lastError,
  Value<bool> dead,
});

class $$SyncOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get patch => $composableBuilder(
    column: $table.patch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dead => $composableBuilder(
    column: $table.dead,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetId => $composableBuilder(
    column: $table.targetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get patch => $composableBuilder(
    column: $table.patch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hlc => $composableBuilder(
    column: $table.hlc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dead => $composableBuilder(
    column: $table.dead,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOutboxTable> {
  $$SyncOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get targetTable => $composableBuilder(
    column: $table.targetTable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetId =>
      $composableBuilder(column: $table.targetId, builder: (column) => column);

  GeneratedColumn<String> get patch =>
      $composableBuilder(column: $table.patch, builder: (column) => column);

  GeneratedColumn<String> get hlc =>
      $composableBuilder(column: $table.hlc, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError =>
      $composableBuilder(column: $table.lastError, builder: (column) => column);

  GeneratedColumn<bool> get dead =>
      $composableBuilder(column: $table.dead, builder: (column) => column);
}

class $$SyncOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOutboxTable,
          OutboxEntry,
          $$SyncOutboxTableFilterComposer,
          $$SyncOutboxTableOrderingComposer,
          $$SyncOutboxTableAnnotationComposer,
          $$SyncOutboxTableCreateCompanionBuilder,
          $$SyncOutboxTableUpdateCompanionBuilder,
          (
            OutboxEntry,
            BaseReferences<_$AppDatabase, $SyncOutboxTable, OutboxEntry>,
          ),
          OutboxEntry,
          PrefetchHooks Function()
        > {
  $$SyncOutboxTableTableManager(_$AppDatabase db, $SyncOutboxTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                Value<String> targetTable = const Value.absent(),
                Value<String> targetId = const Value.absent(),
                Value<String> patch = const Value.absent(),
                Value<String> hlc = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<bool> dead = const Value.absent(),
              }) => SyncOutboxCompanion(
                seq: seq,
                targetTable: targetTable,
                targetId: targetId,
                patch: patch,
                hlc: hlc,
                createdAt: createdAt,
                attempts: attempts,
                lastError: lastError,
                dead: dead,
              ),
          createCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                required String targetTable,
                required String targetId,
                required String patch,
                required String hlc,
                required DateTime createdAt,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<bool> dead = const Value.absent(),
              }) => SyncOutboxCompanion.insert(
                seq: seq,
                targetTable: targetTable,
                targetId: targetId,
                patch: patch,
                hlc: hlc,
                createdAt: createdAt,
                attempts: attempts,
                lastError: lastError,
                dead: dead,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncOutboxTable, OutboxEntry>(table),
                  BaseReferences<_$AppDatabase, $SyncOutboxTable, OutboxEntry>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOutboxTable,
      OutboxEntry,
      $$SyncOutboxTableFilterComposer,
      $$SyncOutboxTableOrderingComposer,
      $$SyncOutboxTableAnnotationComposer,
      $$SyncOutboxTableCreateCompanionBuilder,
      $$SyncOutboxTableUpdateCompanionBuilder,
      (
        OutboxEntry,
        BaseReferences<_$AppDatabase, $SyncOutboxTable, OutboxEntry>,
      ),
      OutboxEntry,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder = SyncStateCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$SyncStateTableUpdateCompanionBuilder = SyncStateCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$SyncStateTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStateTable,
          SyncStateEntry,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateEntry,
            BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateEntry>,
          ),
          SyncStateEntry,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$AppDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SyncStateCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SyncStateCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncStateTable, SyncStateEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $SyncStateTable,
                    SyncStateEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStateTable,
      SyncStateEntry,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateEntry,
        BaseReferences<_$AppDatabase, $SyncStateTable, SyncStateEntry>,
      ),
      SyncStateEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RootCategoriesTableTableManager get rootCategories =>
      $$RootCategoriesTableTableManager(_db, _db.rootCategories);
  $$BrainRegionsTableTableManager get brainRegions =>
      $$BrainRegionsTableTableManager(_db, _db.brainRegions);
  $$CategoryRegionWeightsTableTableManager get categoryRegionWeights =>
      $$CategoryRegionWeightsTableTableManager(_db, _db.categoryRegionWeights);
  $$ProfilesTableTableManager get profiles =>
      $$ProfilesTableTableManager(_db, _db.profiles);
  $$UserCategoriesTableTableManager get userCategories =>
      $$UserCategoriesTableTableManager(_db, _db.userCategories);
  $$VariantGroupsTableTableManager get variantGroups =>
      $$VariantGroupsTableTableManager(_db, _db.variantGroups);
  $$VariantsTableTableManager get variants =>
      $$VariantsTableTableManager(_db, _db.variants);
  $$ActivitiesTableTableManager get activities =>
      $$ActivitiesTableTableManager(_db, _db.activities);
  $$ScheduleRulesTableTableManager get scheduleRules =>
      $$ScheduleRulesTableTableManager(_db, _db.scheduleRules);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$DayOverridesTableTableManager get dayOverrides =>
      $$DayOverridesTableTableManager(_db, _db.dayOverrides);
  $$PlanInstancesTableTableManager get planInstances =>
      $$PlanInstancesTableTableManager(_db, _db.planInstances);
  $$FocusSessionsTableTableManager get focusSessions =>
      $$FocusSessionsTableTableManager(_db, _db.focusSessions);
  $$FocusInterruptionsTableTableManager get focusInterruptions =>
      $$FocusInterruptionsTableTableManager(_db, _db.focusInterruptions);
  $$BrainEventsTableTableManager get brainEvents =>
      $$BrainEventsTableTableManager(_db, _db.brainEvents);
  $$BrainSnapshotsTableTableManager get brainSnapshots =>
      $$BrainSnapshotsTableTableManager(_db, _db.brainSnapshots);
  $$SyncOutboxTableTableManager get syncOutbox =>
      $$SyncOutboxTableTableManager(_db, _db.syncOutbox);
  $$SyncStateTableTableManager get syncState =>
      $$SyncStateTableTableManager(_db, _db.syncState);
}
