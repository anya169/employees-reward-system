import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:individual_project/repositories/auth_repository.dart';
import 'package:individual_project/repositories/code_repository.dart';
import 'package:individual_project/repositories/events_repository.dart';
import 'package:individual_project/repositories/ranking_repository.dart';
import 'package:individual_project/repositories/shop_repository.dart';
import 'package:individual_project/screens/auth_screen_provider.dart';
import 'package:individual_project/screens/cubits/account_screen_cubit.dart';
import 'package:individual_project/screens/cubits/auth_screen_cubit.dart';
import 'package:individual_project/screens/cubits/calendar_screen_cubit.dart';
import 'package:individual_project/screens/cubits/events_screen_cubit.dart';
import 'package:individual_project/screens/cubits/ranking_screen_cubit.dart';
import 'package:individual_project/screens/cubits/shop_screen_cubit.dart';
import 'package:individual_project/styles/theme.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ktyqgybblienbsylocst.supabase.co',
    anonKey: 'sb_publishable_nIDtkm0noSjzM9GKCdfNew_RD56VUA8',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final eventsRepository = EventRepository(authRepository);
    final shopRepository = ShopRepository();
    final codeRepository = CodeRepository();
    final rankingRepository = RankingRepository(authRepository);

    return MultiProvider(
        providers: [
          Provider<EventRepository>.value(value: eventsRepository),
          Provider<CodeRepository>.value(value: codeRepository),
          Provider<ShopRepository>.value(value: shopRepository),
          Provider<RankingRepository>.value(value: rankingRepository),
        ],
        child:
        MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => AuthCubit(authRepository)),
            BlocProvider(create: (context) => EventsCubit(eventsRepository)),
            BlocProvider(create: (context) => ShopCubit(shopRepository)),
            BlocProvider(create: (context) => CalendarCubit(eventsRepository)),
            BlocProvider(create: (context) => RankingCubit(rankingRepository)),
          ],
          child:
          MaterialApp(
            themeMode: ThemeMode.system,
            theme: AppTheme.lightTheme,
            home: AuthScreenProvider(authRepository: authRepository),
          )
        )
    );
  }
}