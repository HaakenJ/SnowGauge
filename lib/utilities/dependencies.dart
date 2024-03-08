import 'package:get_it/get_it.dart';

import '../dao/recording_dao.dart';
import '../dao/user_dao.dart';
import '../database.dart';
import '../view_models/recording_view_model.dart';
import '../view_models/user_view_model.dart';

final getIt = GetIt.instance;

void registerDependencies() {
  // register database with getIt
  getIt.registerSingletonAsync<SnowGaugeDatabase>(
          () async => $FloorSnowGaugeDatabase.databaseBuilder('snow_gauge_database').build()
  );

  // register userDao
  getIt.registerSingletonWithDependencies<UserDao>(() {
    return GetIt.instance.get<SnowGaugeDatabase>().userDao;
  }, dependsOn: [SnowGaugeDatabase]);

  // register recording dao
  getIt.registerSingletonWithDependencies<RecordingDao>(() {
    return GetIt.instance.get<SnowGaugeDatabase>().recordingDao;
  }, dependsOn: [SnowGaugeDatabase]);

  // register UserViewModel
  getIt.registerSingletonWithDependencies<UserViewModel>(
          () => UserViewModel(),
      dependsOn: [SnowGaugeDatabase, UserDao]
  );

  // register RecordingViewModel
  getIt.registerSingletonWithDependencies<RecordingViewModel>(
          () => RecordingViewModel(),
      dependsOn: [SnowGaugeDatabase, RecordingDao]
  );
}