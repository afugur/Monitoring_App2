import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_netcore/hub_connection.dart';

import '../models/data_model.dart';

import '../services/data_generate.dart';
import '../services/publish_data.dart';
import 'data_event.dart';
import 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final DataService dataService;
  final PublishDataService publishDataService;
  static const int maxQueueLength = 100;

  DataBloc(this.dataService, this.publishDataService)
      : super(DataState(
            isStreaming: false,
            isPublishing: false,
            dataQueue1: Queue<TimeSeriesData>(),
            dataQueue2: Queue<TimeSeriesData>(),
            dataQueue3: Queue<TimeSeriesData>())) {
    on<StartDataStream>((event, emit) async {
      emit(state.copyWith(isStreaming: true));
      _startStreaming();
    });

    on<PauseDataStream>((event, emit) {
      emit(state.copyWith(isStreaming: false));
      dataService.stopStreaming();
    });

    on<StartPublishData>((event, emit) async {
      emit(state.copyWith(isPublishing: true));
      await _startPublishing();
    });

    on<PausePublishData>((event, emit) {
      emit(state.copyWith(isPublishing: false));
      publishDataService.stopPublishing();
    });

    on<UpdateData>((event, emit) {
      final newQueue1 = Queue<TimeSeriesData>.from(state.dataQueue1);
      final newQueue2 = Queue<TimeSeriesData>.from(state.dataQueue2);
      final newQueue3 = Queue<TimeSeriesData>.from(state.dataQueue3);

      for (var dataPoint in event.data1) {
        newQueue1.add(dataPoint);
        if (newQueue1.length > maxQueueLength) {
          newQueue1.removeFirst();
        }
      }
      for (var dataPoint in event.data2) {
        newQueue2.add(dataPoint);
        if (newQueue2.length > maxQueueLength) {
          newQueue2.removeFirst();
        }
      }
      for (var dataPoint in event.data3) {
        newQueue3.add(dataPoint);
        if (newQueue3.length > maxQueueLength) {
          newQueue3.removeFirst();
        }
      }

      emit(state.copyWith(
          dataQueue1: newQueue1, dataQueue2: newQueue2, dataQueue3: newQueue3));

      if (state.isPublishing) {
        publishDataService.sendData(event.data1, event.data2, event.data3);
      }
    });
  }

  void _startStreaming() {
    dataService.startStreaming((data1, data2, data3) {
      add(UpdateData(data1, data2, data3));
    });
  }

  Future<void> _startPublishing() async {
    if (publishDataService.hubConnection.state !=
        HubConnectionState.Connected) {
      await publishDataService.startConnection();
    }
  }
}
