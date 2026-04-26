import 'package:individual_project/repositories/events_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calendar_screen_state.dart';

class CalendarCubit extends Cubit<CalendarState> {
  final EventRepository _eventsRepository;

  CalendarCubit(this._eventsRepository) : super(CalendarLoadingState()) {
    getUserEvents();
  }

  // Получение мероприятий пользователя из бд
  Future<void> getUserEvents() async {
    final events = await _eventsRepository.getUserEvents();
    emit(CalendarInfoState(eventsArray: events));
  }
}