import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_architecture_e1/common/app_colors.dart';
import 'package:flutter_architecture_e1/core/app_router.dart';
import 'package:flutter_architecture_e1/core/di.dart' as di;
import 'package:flutter_architecture_e1/presentation/home/bloc/popular_destination_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      log(
        record.message,
        name: '${record.level.name} - ${record.loggerName}',
        error: record.error,
        stackTrace: record.stackTrace,
      );
    });
  }

  await di.init();

  if (Platform.isAndroid || Platform.isIOS) {
    // Set preferred orientations for mobile devices
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, // Lock to portrait mode, upright
      // DeviceOrientation.portraitDown, // Optional: if you also want upside down portrait
    ]);
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PopularDestinationBloc>(create: (context) => di.sl()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: ColorScheme.fromSeed(
            primary: AppColors.primary,
            seedColor: AppColors.primary,
          ),
          dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
        ),
        routerConfig: AppRouter().config,
      ),
    );
  }
}
