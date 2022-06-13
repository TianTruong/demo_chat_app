import 'package:bloc/bloc.dart';
import 'package:demo_chat_app/model/model.dart';
import 'package:meta/meta.dart';

part 'data_event.dart';
part 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  DataBloc() : super(DataState()) {
    on<DataMessageEvent>(_onCreateUserEvent);
  }

  Future<void> _onCreateUserEvent(
      DataMessageEvent event, Emitter<DataState> emit) async {
    Messages mess = Messages(
      createdOn: event.data['createdOn'],
      friendName: event.data['friendName'],
      friendUid: event.data['friendUid'],
      image: event.data['image'],
      message: event.data['message'],
      voice: event.data['voice'],
      uid: event.data['uid'],
    );
    // state.mess = mess;

    // emit(event.mess);

    // emit(DataMessageState(mess).dataMess());

    emit(state.dataMess(mess));
  }
}
