// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moor_database.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class Location extends DataClass implements Insertable<Location> {
  final int? id;
  final double latitude;
  final double longitude;
  final String name;
  final String description;
  final int? ranking;
  Location(
      {this.id,
      required this.latitude,
      required this.longitude,
      required this.name,
      required this.description,
      this.ranking});
  factory Location.fromData(Map<String, dynamic> data, GeneratedDatabase db,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return Location(
      id: const IntType().mapFromDatabaseResponse(data['${effectivePrefix}id']),
      latitude: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}latitude'])!,
      longitude: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}longitude'])!,
      name: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}name'])!,
      description: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}description'])!,
      ranking: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}ranking']),
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<int?>(id);
    }
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || ranking != null) {
      map['ranking'] = Variable<int?>(ranking);
    }
    return map;
  }

  LocationsCompanion toCompanion(bool nullToAbsent) {
    return LocationsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      latitude: Value(latitude),
      longitude: Value(longitude),
      name: Value(name),
      description: Value(description),
      ranking: ranking == null && nullToAbsent
          ? const Value.absent()
          : Value(ranking),
    );
  }

  factory Location.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return Location(
      id: serializer.fromJson<int?>(json['id']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      ranking: serializer.fromJson<int?>(json['ranking']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= moorRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int?>(id),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'ranking': serializer.toJson<int?>(ranking),
    };
  }

  Location copyWith(
          {int? id,
          double? latitude,
          double? longitude,
          String? name,
          String? description,
          int? ranking}) =>
      Location(
        id: id ?? this.id,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        name: name ?? this.name,
        description: description ?? this.description,
        ranking: ranking ?? this.ranking,
      );
  @override
  String toString() {
    return (StringBuffer('Location(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('ranking: $ranking')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => $mrjf($mrjc(
      id.hashCode,
      $mrjc(
          latitude.hashCode,
          $mrjc(
              longitude.hashCode,
              $mrjc(name.hashCode,
                  $mrjc(description.hashCode, ranking.hashCode))))));
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Location &&
          other.id == this.id &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.name == this.name &&
          other.description == this.description &&
          other.ranking == this.ranking);
}

class LocationsCompanion extends UpdateCompanion<Location> {
  final Value<int?> id;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<String> name;
  final Value<String> description;
  final Value<int?> ranking;
  const LocationsCompanion({
    this.id = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.ranking = const Value.absent(),
  });
  LocationsCompanion.insert({
    this.id = const Value.absent(),
    required double latitude,
    required double longitude,
    required String name,
    required String description,
    this.ranking = const Value.absent(),
  })  : latitude = Value(latitude),
        longitude = Value(longitude),
        name = Value(name),
        description = Value(description);
  static Insertable<Location> custom({
    Expression<int?>? id,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int?>? ranking,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (ranking != null) 'ranking': ranking,
    });
  }

  LocationsCompanion copyWith(
      {Value<int?>? id,
      Value<double>? latitude,
      Value<double>? longitude,
      Value<String>? name,
      Value<String>? description,
      Value<int?>? ranking}) {
    return LocationsCompanion(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      name: name ?? this.name,
      description: description ?? this.description,
      ranking: ranking ?? this.ranking,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int?>(id.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (ranking.present) {
      map['ranking'] = Variable<int?>(ranking.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationsCompanion(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('ranking: $ranking')
          ..write(')'))
        .toString();
  }
}

class $LocationsTable extends Locations
    with TableInfo<$LocationsTable, Location> {
  final GeneratedDatabase _db;
  final String? _alias;
  $LocationsTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, true,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _latitudeMeta = const VerificationMeta('latitude');
  late final GeneratedColumn<double?> latitude = GeneratedColumn<double?>(
      'latitude', aliasedName, false,
      typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _longitudeMeta = const VerificationMeta('longitude');
  late final GeneratedColumn<double?> longitude = GeneratedColumn<double?>(
      'longitude', aliasedName, false,
      typeName: 'REAL', requiredDuringInsert: true);
  final VerificationMeta _nameMeta = const VerificationMeta('name');
  late final GeneratedColumn<String?> name = GeneratedColumn<String?>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 30),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  late final GeneratedColumn<String?> description = GeneratedColumn<String?>(
      'description', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 0, maxTextLength: 100),
      typeName: 'TEXT',
      requiredDuringInsert: true);
  final VerificationMeta _rankingMeta = const VerificationMeta('ranking');
  late final GeneratedColumn<int?> ranking = GeneratedColumn<int?>(
      'ranking', aliasedName, true,
      typeName: 'INTEGER', requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, latitude, longitude, name, description, ranking];
  @override
  String get aliasedName => _alias ?? 'locations';
  @override
  String get actualTableName => 'locations';
  @override
  VerificationContext validateIntegrity(Insertable<Location> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(_latitudeMeta,
          latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta));
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(_longitudeMeta,
          longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta));
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('ranking')) {
      context.handle(_rankingMeta,
          ranking.isAcceptableOrUnknown(data['ranking']!, _rankingMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Location map(Map<String, dynamic> data, {String? tablePrefix}) {
    return Location.fromData(data, _db,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $LocationsTable createAlias(String alias) {
    return $LocationsTable(_db, alias);
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $LocationsTable locations = $LocationsTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [locations];
}
