import '../models/data_model.dart';

// lib/bloc/data_event.dart
abstract class DataEvent {}

class StartDataStream extends DataEvent {}

class PauseDataStream extends DataEvent {}

class StartPublishData extends DataEvent {}

class PausePublishData extends DataEvent {}

class UpdateData extends DataEvent {
  final List<TimeSeriesData> data1;
  final List<TimeSeriesData> data2;
  final List<TimeSeriesData> data3;

  UpdateData(this.data1, this.data2, this.data3);
}
