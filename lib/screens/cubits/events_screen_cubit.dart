import 'package:individual_project/repositories/events_repository.dart';
import 'package:individual_project/screens/cubits/events_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsCubit extends Cubit<EventsState> {
  final EventRepository _eventsRepository;

  EventsCubit(this._eventsRepository) : super(EventsLoadingState()) {
    _getCurrentEvents();
  }

  // Получение текущих мероприятий из бд
  Future<void> _getCurrentEvents() async {
    final events = await _eventsRepository.getCurrentEvents();
    emit(EventsInfoState(eventsArray: events));
  }
}