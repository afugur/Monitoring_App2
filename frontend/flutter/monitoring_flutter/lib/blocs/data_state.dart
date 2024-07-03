import '../models/data_model.dart';
import 'dart:collection';

class DataState {
  final bool isStreaming;
  final bool isPublishing;
  final Queue<TimeSeriesData> dataQueue1;
  final Queue<TimeSeriesData> dataQueue2;
  final Queue<TimeSeriesData> dataQueue3;

  DataState({
    required this.isStreaming,
    required this.isPublishing,
    required this.dataQueue1,
    required this.dataQueue2,
    required this.dataQueue3,
  });

  DataState copyWith({
    bool? isStreaming,
    bool? isPublishing,
    Queue<TimeSeriesData>? dataQueue1,
    Queue<TimeSeriesData>? dataQueue2,
    Queue<TimeSeriesData>? dataQueue3,
  }) {
    return DataState(
      isStreaming: isStreaming ?? this.isStreaming,
      isPublishing: isPublishing ?? this.isPublishing,
      dataQueue1: dataQueue1 ?? this.dataQueue1,
      dataQueue2: dataQueue2 ?? this.dataQueue2,
      dataQueue3: dataQueue3 ?? this.dataQueue3,
    );
  }
}
