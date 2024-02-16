import 'package:SnowGauge/view_models/recording_view_model.dart';
import 'package:SnowGauge/view_models/user_view_model.dart';
import 'package:SnowGauge/views/scaffold_nav_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dao/recording_dao.dart';
import 'dao/user_dao.dart';
import 'database.dart';
import 'views/login_view.dart';
import 'views/registration_view.dart';
import 'views/leaderboard_view.dart';
import 'views/history_view.dart';
import 'views/user_account_view.dart';
import 'views/record_activity_view.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:SnowGauge/common/theme.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (context) => LocationModel()),
      ],
      child: MaterialApp.router(
        title: 'SnowGauge',
        theme: appTheme,
        routerConfig: router(),
      )
    );
    return MaterialApp(
      title: 'Snow Gauge App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // Redirect to LoginPage initially
      home: const RecordActivityView(),
      // home: const LoginPage(),
      routes: {
        '/login': (context) => LoginView(),
        '/register': (context) => RegistrationView(),
        '/leaderboard': (context) => LeaderboardView(),
        '/history': (context) => HistoryView(),
        '/user_account': (context) => const UserAccountView(),
        '/record_activity': (context) => RecordActivityView(),
      },
    );
  }
}

void main() {
  GetIt getIt = GetIt.instance;

  // register database with getIt
  getIt.registerSingletonAsync<SnowGaugeDatabase>(
      () async => $FloorAppDatabase.databaseBuilder('snow_gauge_database').build()
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

  runApp(const MyApp());
}

GoRouter router() {
  return GoRouter(
      initialLocation: '/login',
      navigatorKey: _rootNavigatorKey,
      routes: [
        ShellRoute(
            navigatorKey: _shellNavigatorKey,
            pageBuilder: (context, state, child) {
              return NoTransitionPage(
                  child: ScaffoldNavBar(
                    location: state.matchedLocation,
                    child: child,
                  )
              );
            },
            routes: [
              GoRoute(
                  path: '/record-activity',
                  parentNavigatorKey: _shellNavigatorKey,
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                        child: FutureBuilder(
                            future: GetIt.instance.allReady(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return const RecordActivityView();
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            }
                        )
                    );
                  }
              ),
              GoRoute(
                  path: '/leaderboard',
                  parentNavigatorKey: _shellNavigatorKey,
                  pageBuilder: (context, state) {
                    return const NoTransitionPage(
                      child: LeaderboardView(),
                    );
                  }
              ),
              GoRoute(
                  path: '/history',
                  parentNavigatorKey: _shellNavigatorKey,
                  pageBuilder: (context, state) {
                    return const NoTransitionPage(
                      child: HistoryView(),
                    );
                  }
              ),
              GoRoute(
                  path: '/user-account',
                  parentNavigatorKey: _shellNavigatorKey,
                  pageBuilder: (context, state) {
                    return const NoTransitionPage(
                      child: UserAccountView(),
                    );
                  }
              ),
            ]
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/login',
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: UniqueKey(),
              child: const LoginView(),
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/register',
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: UniqueKey(),
              child: const RegistrationView(),
            );
          },
        ),
      ]
  );
}
