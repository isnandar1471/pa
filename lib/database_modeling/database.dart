import 'dart:io';

import 'package:pa/main.dart';
import 'package:path_provider/path_provider.dart' as ppvd;
import 'package:path/path.dart' as p;

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'semaphore_activity_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [
  SemaphoreActivityTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<void> deleteEverything() {
    return transaction(() async {
      // you only need this if you've manually enabled foreign keys
      // await customStatement('PRAGMA foreign_keys = OFF');
      for (final table in allTables) {
        await delete(table).go();
      }
    });
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    // final dbFolder = await ppvd.getDownloadsDirectory();
    final dbFolder = '/storage/emulated/0';

    // final file = File(p.join(dbFolder!.path, 'db.sqlite'));
    final file = File(p.join(dbFolder, 'pa.db.sqlite'));

    logger.i(file.path);

    return NativeDatabase.createInBackground(file, logStatements: true);
  });
}
