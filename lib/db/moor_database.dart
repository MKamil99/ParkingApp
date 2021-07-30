import 'package:moor_flutter/moor_flutter.dart';
part 'moor_database.g.dart';

// SQLite table:
class Locations extends Table {
  IntColumn get id => integer().autoIncrement().nullable()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get name => text().withLength(min: 1, max: 20)();
  TextColumn get description => text().withLength(min: 0, max: 50)();
  IntColumn get rating => integer().nullable()();
}

// Database:
@UseMoor(tables: [Locations])
class AppDatabase extends _$AppDatabase {
  // Creating database (saving it in file):
  AppDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(path: 'db.sqlite'));

  // Version of database:
  int get schemaVersion => 1;

  // Database methods:
  Stream<List<Location>> watchAllLocations() => select(locations).watch();
  Future insertLocation(Location location) => into(locations).insert(location);
  Future deleteLocation(Location location) => delete(locations).delete(location);
}
