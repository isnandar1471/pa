// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $SemaphoreActivityTableTable extends SemaphoreActivityTable
    with TableInfo<$SemaphoreActivityTableTable, SemaphoreActivityTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SemaphoreActivityTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumnWithTypeConverter<ActivityType, int> type =
      GeneratedColumn<int>('type', aliasedName, false,
              type: DriftSqlType.int, requiredDuringInsert: true)
          .withConverter<ActivityType>(
              $SemaphoreActivityTableTable.$convertertype);
  static const VerificationMeta _jsonRankingMeta =
      const VerificationMeta('jsonRanking');
  @override
  late final GeneratedColumn<String> jsonRanking = GeneratedColumn<String>(
      'json_ranking', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
      'created_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, type, jsonRanking, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'semaphore_activity_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SemaphoreActivityTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    context.handle(_typeMeta, const VerificationResult.success());
    if (data.containsKey('json_ranking')) {
      context.handle(
          _jsonRankingMeta,
          jsonRanking.isAcceptableOrUnknown(
              data['json_ranking']!, _jsonRankingMeta));
    } else if (isInserting) {
      context.missing(_jsonRankingMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SemaphoreActivityTableData map(Map<String, dynamic> data,
      {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SemaphoreActivityTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      type: $SemaphoreActivityTableTable.$convertertype.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}type'])!),
      jsonRanking: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}json_ranking'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $SemaphoreActivityTableTable createAlias(String alias) {
    return $SemaphoreActivityTableTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ActivityType, int, int> $convertertype =
      const EnumIndexConverter<ActivityType>(ActivityType.values);
}

class SemaphoreActivityTableData extends DataClass
    implements Insertable<SemaphoreActivityTableData> {
  final int id;
  final ActivityType type;
  final String jsonRanking;
  final int createdAt;
  const SemaphoreActivityTableData(
      {required this.id,
      required this.type,
      required this.jsonRanking,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      final converter = $SemaphoreActivityTableTable.$convertertype;
      map['type'] = Variable<int>(converter.toSql(type));
    }
    map['json_ranking'] = Variable<String>(jsonRanking);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  SemaphoreActivityTableCompanion toCompanion(bool nullToAbsent) {
    return SemaphoreActivityTableCompanion(
      id: Value(id),
      type: Value(type),
      jsonRanking: Value(jsonRanking),
      createdAt: Value(createdAt),
    );
  }

  factory SemaphoreActivityTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SemaphoreActivityTableData(
      id: serializer.fromJson<int>(json['id']),
      type: $SemaphoreActivityTableTable.$convertertype
          .fromJson(serializer.fromJson<int>(json['type'])),
      jsonRanking: serializer.fromJson<String>(json['jsonRanking']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<int>(
          $SemaphoreActivityTableTable.$convertertype.toJson(type)),
      'jsonRanking': serializer.toJson<String>(jsonRanking),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  SemaphoreActivityTableData copyWith(
          {int? id, ActivityType? type, String? jsonRanking, int? createdAt}) =>
      SemaphoreActivityTableData(
        id: id ?? this.id,
        type: type ?? this.type,
        jsonRanking: jsonRanking ?? this.jsonRanking,
        createdAt: createdAt ?? this.createdAt,
      );
  @override
  String toString() {
    return (StringBuffer('SemaphoreActivityTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('jsonRanking: $jsonRanking, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, jsonRanking, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SemaphoreActivityTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.jsonRanking == this.jsonRanking &&
          other.createdAt == this.createdAt);
}

class SemaphoreActivityTableCompanion
    extends UpdateCompanion<SemaphoreActivityTableData> {
  final Value<int> id;
  final Value<ActivityType> type;
  final Value<String> jsonRanking;
  final Value<int> createdAt;
  const SemaphoreActivityTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.jsonRanking = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SemaphoreActivityTableCompanion.insert({
    this.id = const Value.absent(),
    required ActivityType type,
    required String jsonRanking,
    required int createdAt,
  })  : type = Value(type),
        jsonRanking = Value(jsonRanking),
        createdAt = Value(createdAt);
  static Insertable<SemaphoreActivityTableData> custom({
    Expression<int>? id,
    Expression<int>? type,
    Expression<String>? jsonRanking,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (jsonRanking != null) 'json_ranking': jsonRanking,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SemaphoreActivityTableCompanion copyWith(
      {Value<int>? id,
      Value<ActivityType>? type,
      Value<String>? jsonRanking,
      Value<int>? createdAt}) {
    return SemaphoreActivityTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      jsonRanking: jsonRanking ?? this.jsonRanking,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      final converter = $SemaphoreActivityTableTable.$convertertype;
      map['type'] = Variable<int>(converter.toSql(type.value));
    }
    if (jsonRanking.present) {
      map['json_ranking'] = Variable<String>(jsonRanking.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SemaphoreActivityTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('jsonRanking: $jsonRanking, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  late final $SemaphoreActivityTableTable semaphoreActivityTable =
      $SemaphoreActivityTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [semaphoreActivityTable];
}
