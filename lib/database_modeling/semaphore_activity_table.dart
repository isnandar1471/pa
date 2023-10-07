part of 'database.dart';

enum ActivityType {
  semaphore,
}

class SemaphoreActivityTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get type => intEnum<ActivityType>()();
  TextColumn get jsonRanking => text()();
  IntColumn get createdAt => integer()();
}
