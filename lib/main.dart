import 'dart:collection';

import 'package:SnowGauge/utilities/dependencies.dart';
import 'package:SnowGauge/utilities/firebase_initializer.dart';
import 'package:SnowGauge/view_models/recording_view_model.dart';
import 'package:SnowGauge/view_models/user_view_model.dart';
import 'package:SnowGauge/views/map_location_view.dart';
import 'package:SnowGauge/views/scaffold_nav_bar_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dao/recording_dao.dart';
import 'dao/user_dao.dart';
import 'database.dart';
import 'firebase_options.dart';
import 'views/login_view.dart';
import 'views/registration_view.dart';
import 'views/leaderboard_view.dart';
import 'views/history_view.dart';
import 'views/user_account_view.dart';
import 'views/recording_view.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:SnowGauge/common/theme.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();
final FirebaseAuth auth = FirebaseAuth.instance;


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // hardcoding a userId until login is set up
        ChangeNotifierProvider(create: (context) => RecordingViewModel()),
        ChangeNotifierProvider(create: (context) => UserViewModel()),
      ],
      child: MaterialApp.router(
        title: 'SnowGauge',
        theme: appTheme,
        routerConfig: router(),
      )
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  registerDependencies();
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
                  path: '/login',
                  parentNavigatorKey: _shellNavigatorKey,
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                        child: FutureBuilder(
                            future: GetIt.instance.allReady(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return FirebaseInitializer(auth: auth,);
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            }
                        )
                    );
                  }
              ),
              GoRoute(
                  path: '/record-activity',
                  parentNavigatorKey: _shellNavigatorKey,
                  pageBuilder: (context, state) {
                    return NoTransitionPage(
                        child: FutureBuilder(
                            future: GetIt.instance.allReady(),
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return RecordActivityView(auth: auth,);
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            }
                        )
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
              GoRoute(
                  path: '/map',
                  parentNavigatorKey: _shellNavigatorKey,
                  pageBuilder: (context, state) {
                    return const NoTransitionPage(
                      child: MapLocationView(),
                    );
                  }
              ),
            ]
        ),
      ]
  );
}
