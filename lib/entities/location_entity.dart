import 'package:SnowGauge/entities/user_entity.dart';
import 'package:floor/floor.dart';

@Entity(
  foreignKeys: [
    ForeignKey(
      childColumns: ['user_id'],
      parentColumns: ['id'],
      entity: User,
    )
  ],
)
class Location {
  @primaryKey
  final int id;
  @ColumnInfo(name: 'user_id')
  final int userId;
  // stored as millisecondsFromEpoch
  @ColumnInfo(name: 'recording_date')
  DateTime recordingDate;
  @ColumnInfo(name: 'number_of_runs')
  int numberOfRuns;
  // speed stored in mph
  @ColumnInfo(name: 'max_speed')
  double maxSpeed;
  @ColumnInfo(name: 'average_speed')
  double averageSpeed;
  // stored in miles
  @ColumnInfo(name: 'total_distance')
  double totalDistance;
  // stored in ft
  @ColumnInfo(name: 'total_vertical')
  int totalVertical;
  // probably stored in milliseconds to be converted later
  double duration;

  Location(
      this.id,
      this.userId,
      this.recordingDate,
      this.numberOfRuns,
      this.maxSpeed,
      this.averageSpeed,
      this.totalDistance,
      this.totalVertical,
      this.duration
      );
}
