import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:individual_project/screens/cubits/auth_screen_cubit.dart';
import 'package:individual_project/screens/auth_screen.dart';
import '../repositories/auth_repository.dart';

class AuthScreenProvider extends StatelessWidget {
  final AuthRepository authRepository;

  const AuthScreenProvider({super.key, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(authRepository),
      child: AuthScreen(),
    );
  }
}