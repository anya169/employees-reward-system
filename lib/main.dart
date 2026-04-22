import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:individual_project/repositories/auth_repository.dart';
import 'package:individual_project/repositories/events_repository.dart';
import 'package:individual_project/repositories/shop_repository.dart';
import 'package:individual_project/screens/auth_screen_provider.dart';
import 'package:individual_project/screens/cubits/account_screen_cubit.dart';
import 'package:individual_project/screens/cubits/auth_screen_cubit.dart';
import 'package:individual_project/screens/cubits/events_screen_cubit.dart';
import 'package:individual_project/screens/cubits/shop_screen_cubit.dart';
import 'package:individual_project/styles/theme.dart';
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
    final eventsRepository = EventRepository();
    final shopRepository = ShopRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(authRepository)),
        BlocProvider(create: (context) => AccountCubit(user: {})),
        BlocProvider(create: (context) => EventsCubit(eventsRepository)),
        BlocProvider(create: (context) => ShopCubit(shopRepository))
      ],
      child:
      MaterialApp(
        themeMode: ThemeMode.system,
        theme: AppTheme.lightTheme,
        home: AuthScreenProvider(authRepository: authRepository),
      )
    );
  }
}