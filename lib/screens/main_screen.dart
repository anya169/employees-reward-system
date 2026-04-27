import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:individual_project/screens/account_screen.dart';
import 'package:individual_project/screens/cubits/account_screen_cubit.dart';
import 'package:individual_project/screens/shop_screen.dart';
import '../styles/app_colors.dart';
import 'calendar_screen.dart';
import 'events_screen.dart';

class MainScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final AccountCubit accountCubit;

  const MainScreen({super.key, required this.user, required this.accountCubit});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 4;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const EventScreen(),
      const CalendarScreen(),
      ShopScreen(accountCubit: widget.accountCubit),
      const RewardsScreen(),
      BlocProvider.value(
        value: widget.accountCubit,
        child: const AccountScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.blue,
        selectedItemColor: AppColors.white,
        unselectedItemColor: AppColors.blueExtraLight,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.card_membership),
            label: 'События',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'Календарь',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Магазин',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grade),
            label: 'Рейтинг',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Профиль',
          ),
        ],
      ),
    );
  }
}



class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Рейтинги'));
  }
}