// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorSnowGaugeDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$SnowGaugeDatabaseBuilder databaseBuilder(String name) =>
      _$SnowGaugeDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$SnowGaugeDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$SnowGaugeDatabaseBuilder(null);
}

class _$SnowGaugeDatabaseBuilder {
  _$SnowGaugeDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$SnowGaugeDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$SnowGaugeDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<SnowGaugeDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$SnowGaugeDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$SnowGaugeDatabase extends SnowGaugeDatabase {
  _$SnowGaugeDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  UserDao? _userDaoInstance;

  RecordingDao? _recordingDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `User` (`id` INTEGER NOT NULL, `user_name` TEXT NOT NULL, `email` TEXT NOT NULL, `password` TEXT NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Recording` (`id` INTEGER NOT NULL, `user_id` INTEGER NOT NULL, `recording_date` INTEGER NOT NULL, `number_of_runs` INTEGER NOT NULL, `max_speed` REAL NOT NULL, `average_speed` REAL NOT NULL, `total_distance` REAL NOT NULL, `total_vertical` INTEGER NOT NULL, `duration` REAL NOT NULL, FOREIGN KEY (`user_id`) REFERENCES `User` (`id`) ON UPDATE NO ACTION ON DELETE NO ACTION, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  RecordingDao get recordingDao {
    return _recordingDaoInstance ??= _$RecordingDao(database, changeListener);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'User',
            (User item) => <String, Object?>{
                  'id': item.id,
                  'user_name': item.userName,
                  'email': item.email,
                  'password': item.password
                },
            changeListener),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'user_name': item.userName,
                  'email': item.email,
                  'password': item.password
                },
            changeListener),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'User',
            ['id'],
            (User item) => <String, Object?>{
                  'id': item.id,
                  'user_name': item.userName,
                  'email': item.email,
                  'password': item.password
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<List<User>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM User',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int,
            row['user_name'] as String,
            row['email'] as String,
            row['password'] as String));
  }

  @override
  Stream<User?> watchUserById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM User WHERE id = ?1',
        mapper: (Map<String, Object?> row) => User(
            row['id'] as int,
            row['user_name'] as String,
            row['email'] as String,
            row['password'] as String),
        arguments: [id],
        queryableName: 'User',
        isView: false);
  }

  @override
  Future<int?> getUserIdByName(String userName) async {
    return _queryAdapter.query('SELECT id FROM User WHERE user_name = ?1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [userName]);
  }

  @override
  Future<void> insertUser(User user) async {
    await _userInsertionAdapter.insert(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(User user) async {
    await _userUpdateAdapter.update(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteUser(User user) async {
    await _userDeletionAdapter.delete(user);
  }
}

class _$RecordingDao extends RecordingDao {
  _$RecordingDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _recordingInsertionAdapter = InsertionAdapter(
            database,
            'Recording',
            (Recording item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'recording_date':
                      _dateTimeConverter.encode(item.recordingDate),
                  'number_of_runs': item.numberOfRuns,
                  'max_speed': item.maxSpeed,
                  'average_speed': item.averageSpeed,
                  'total_distance': item.totalDistance,
                  'total_vertical': item.totalVertical,
                  'duration': item.duration
                },
            changeListener),
        _recordingUpdateAdapter = UpdateAdapter(
            database,
            'Recording',
            ['id'],
            (Recording item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'recording_date':
                      _dateTimeConverter.encode(item.recordingDate),
                  'number_of_runs': item.numberOfRuns,
                  'max_speed': item.maxSpeed,
                  'average_speed': item.averageSpeed,
                  'total_distance': item.totalDistance,
                  'total_vertical': item.totalVertical,
                  'duration': item.duration
                },
            changeListener),
        _recordingDeletionAdapter = DeletionAdapter(
            database,
            'Recording',
            ['id'],
            (Recording item) => <String, Object?>{
                  'id': item.id,
                  'user_id': item.userId,
                  'recording_date':
                      _dateTimeConverter.encode(item.recordingDate),
                  'number_of_runs': item.numberOfRuns,
                  'max_speed': item.maxSpeed,
                  'average_speed': item.averageSpeed,
                  'total_distance': item.totalDistance,
                  'total_vertical': item.totalVertical,
                  'duration': item.duration
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Recording> _recordingInsertionAdapter;

  final UpdateAdapter<Recording> _recordingUpdateAdapter;

  final DeletionAdapter<Recording> _recordingDeletionAdapter;

  @override
  Future<List<Recording>> getAllRecordings() async {
    return _queryAdapter.queryList('SELECT * FROM Recording',
        mapper: (Map<String, Object?> row) => Recording(
            row['id'] as int,
            row['user_id'] as int,
            _dateTimeConverter.decode(row['recording_date'] as int),
            row['number_of_runs'] as int,
            row['max_speed'] as double,
            row['average_speed'] as double,
            row['total_distance'] as double,
            row['total_vertical'] as int,
            row['duration'] as double));
  }

  @override
  Stream<Recording?> watchRecordingById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM Recording WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Recording(
            row['id'] as int,
            row['user_id'] as int,
            _dateTimeConverter.decode(row['recording_date'] as int),
            row['number_of_runs'] as int,
            row['max_speed'] as double,
            row['average_speed'] as double,
            row['total_distance'] as double,
            row['total_vertical'] as int,
            row['duration'] as double),
        arguments: [id],
        queryableName: 'Recording',
        isView: false);
  }

  @override
  Future<void> insertRecording(Recording recording) async {
    await _recordingInsertionAdapter.insert(
        recording, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateRecording(Recording user) async {
    await _recordingUpdateAdapter.update(user, OnConflictStrategy.replace);
  }

  @override
  Future<void> deleteRecording(Recording user) async {
    await _recordingDeletionAdapter.delete(user);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
