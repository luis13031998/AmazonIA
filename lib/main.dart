import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:provider/provider.dart';
import 'package:spotifymusic_app/Presentacion/choose_mode/bloc/theme_cubit.dart';
import 'package:spotifymusic_app/Presentacion/splash/pages/splash.dart';
import 'package:spotifymusic_app/Provider/cart_provider.dart';
import 'package:spotifymusic_app/Provider/favorite_provider.dart';
import 'package:spotifymusic_app/constants.dart';
import 'package:spotifymusic_app/core/configs/theme/app_theme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:spotifymusic_app/firebase_options.dart';
import 'package:spotifymusic_app/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = stripePublishablekey;

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory(
            (await getApplicationDocumentsDirectory()).path,
          ),
  );

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        /// BLoC Providers
        BlocProvider(create: (_) => ThemeCubit()),

        /// ChangeNotifier Providers
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
      ],

      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: mode,
            home: const SplashPage(),
          );
        },
      ),
    );
  }
}
