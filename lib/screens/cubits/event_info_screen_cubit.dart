import 'package:individual_project/screens/cubits/event_info_screen_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventCubit extends Cubit<EventState> {

  EventCubit() : super(EventLoadingState());

}