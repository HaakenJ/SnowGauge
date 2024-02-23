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
class Recording {
  @primaryKey
  final int id;
  @ColumnInfo(name: 'user_id')
  final int userId;
  // stored as millisecondsFromEpoch
  @ColumnInfo(name: 'recording_date')
  DateTime recordingDate;
  @ColumnInfo(name: 'number_of_runs')
  int numberOfRuns;
  // speed stored in km/h
  @ColumnInfo(name: 'max_speed')
  double maxSpeed;
  @ColumnInfo(name: 'average_speed')
  double averageSpeed;
  // stored in meters
  @ColumnInfo(name: 'total_distance')
  double totalDistance;
  // stored in meters
  @ColumnInfo(name: 'total_vertical')
  double totalVertical;
  @ColumnInfo(name: 'max_elevation')
  double maxElevation;
  @ColumnInfo(name: 'min_elevation')
  double minElevation;
  // stored in whole seconds
  int duration;

  Recording(
      this.id,
      this.userId,
      this.recordingDate,
      this.numberOfRuns,
      this.maxSpeed,
      this.averageSpeed,
      this.totalDistance,
      this.totalVertical,
      this.maxElevation,
      this.minElevation,
      this.duration
      );
}
