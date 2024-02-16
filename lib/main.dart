import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'views/login_view.dart';
import 'views/registration_view.dart';
import 'views/leaderboard_view.dart';
import 'views/history_view.dart';
import 'views/user_account_view.dart';
import 'views/record_activity_view.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

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
      home: const RecordActivityPage(),
      // home: const LoginPage(),
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegistrationPage(),
        '/leaderboard': (context) => LeaderboardPage(),
        '/history': (context) => HistoryPage(),
        '/user_account': (context) => const UserAccountPage(),
        '/record_activity': (context) => RecordActivityPage(),
      },
    );
  }
}

void main() {
  GetIt getIt = GetIt.instance;

  // register database with getIt
  getIt.registerSingletonAsync<SnowGaugeDatabase>(
      () async => $FloorAppDatabase.databaseBuilder('snow_gauge_database').build();
  );

  // register userDao
  getIt.registerSingletonWithDependencies<UserDao>(() {
    return GetIt.instance.get<SnowGaugeDatabase>().userDao;
  }, dependsOn: [SnowGaugeDatabase]);

  // register location dao
  getIt.registerSingletonWithDependencies<LocationDao>(() {
    return GetIt.instance.get<SnowGaugeDatabase>().locationDao;
  }, dependsOn: [SnowGaugeDatabase]);

  // register UserModel
  getIt.registerSingletonWithDependencies<UserModelView>(
          () => UserModelView(),
      dependsOn: [SnowGaugeDatabase, UserDao]
  );

  // register LocationModelView
  getIt.registerSingletonWithDependencies<LocationModelView>(
          () => LocationModelView(),
      dependsOn: [SnowGaugeDatabase, LocationDao]
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
                  child: ScaffoldWithNavBar(
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
                      child: HistoryView()),
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
              child: LoginView(),
            );
          },
        ),
        GoRoute(
          parentNavigatorKey: _rootNavigatorKey,
          path: '/register',
          pageBuilder: (context, state) {
            return NoTransitionPage(
              key: UniqueKey(),
              child: RegistrationView(),
            );
          },
        ),
      ]
  );
}
