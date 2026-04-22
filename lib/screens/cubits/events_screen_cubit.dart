import 'package:individual_project/repositories/events_repository.dart';
import 'package:individual_project/screens/cubits/events_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventCubit extends Cubit<EventState> {
  final EventRepository _eventsRepository;

  EventCubit(this._eventsRepository) : super(EventLoadingState()) {
    _getCurrentEvents();
  }

  // Получение текущих мероприятий из бд
  Future<void> _getCurrentEvents() async {
    final events = await _eventsRepository.getCurrentEvents();
    emit(EventInfoState(eventsArray: events));
  }
}