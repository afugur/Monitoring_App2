// lib/services/data_service.dart
import 'dart:async';
import 'dart:math';
import '../models/data_model.dart';

class DataService {
  final Random _random = Random();
  StreamSubscription? _subscription;

  void startStreaming(
      Function(List<TimeSeriesData>, List<TimeSeriesData>, List<TimeSeriesData>)
          onData) {
    _subscription = Stream.periodic(Duration(seconds: 1), (count) {
      final now = DateTime.now();
      final data1 = List.generate(
          1, (_) => TimeSeriesData(now, _random.nextDouble() * 2 - 1));
      final data2 = List.generate(
          1, (_) => TimeSeriesData(now, _random.nextDouble() * 2 - 1));
      final data3 = List.generate(
          1, (_) => TimeSeriesData(now, _random.nextDouble() * 2 - 1));
      return [data1, data2, data3];
    }).listen((data) {
      onData(data[0], data[1], data[2]);
    });
  }

  void stopStreaming() {
    _subscription?.cancel();
  }
}
