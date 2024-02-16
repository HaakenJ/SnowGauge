import 'package:SnowGauge/dao/recording_dao.dart';
import 'package:floor/floor.dart';
import 'dao/user_dao.dart';
import 'entities/recording_entity.dart';
import 'entities/user_entity.dart';
import 'utilities/datetime_converter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'dart:async';

part 'database.g.dart'; // the generated code will be there

@TypeConverters([DateTimeConverter])
@Database(version: 1, entities: [User, Recording])
abstract class SnowGaugeDatabase extends FloorDatabase {
  UserDao get userDao;
  RecordingDao get recordingDao;
}
