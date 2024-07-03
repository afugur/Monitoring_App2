import 'package:flutter/cupertino.dart';
import 'package:signalr_netcore/signalr_client.dart';
import '../models/data_model.dart';

class PublishDataService {
  final HubConnection hubConnection;
  final ValueNotifier<HubConnectionState> connectionStateNotifier =
      ValueNotifier(HubConnectionState.Disconnected);

  PublishDataService(String url)
      : hubConnection = HubConnectionBuilder().withUrl(url).build() {
    hubConnection.onclose(({Exception? error}) {
      connectionStateNotifier.value = HubConnectionState.Disconnected;
      print("Bağlantı kapandı: $error");
    });
  }

  Future<void> startConnection() async {
    try {
      await hubConnection.start();
      connectionStateNotifier.value = HubConnectionState.Connected;
      print("SignalR bağlantısı kuruldu.");
    } catch (e) {
      connectionStateNotifier.value = HubConnectionState.Disconnected;
      print("Bağlantı hatası: $e");
    }
  }

  void sendData(List<TimeSeriesData> data1, List<TimeSeriesData> data2,
      List<TimeSeriesData> data3) {
    if (hubConnection.state == HubConnectionState.Connected) {
      final data = {
        'data1': data1
            .map((d) => {'time': d.time.toIso8601String(), 'value': d.data})
            .toList(),
        'data2': data2
            .map((d) => {'time': d.time.toIso8601String(), 'value': d.data})
            .toList(),
        'data3': data3
            .map((d) => {'time': d.time.toIso8601String(), 'value': d.data})
            .toList(),
      };
      hubConnection.invoke("SendMessage", args: [data]);
    } else {
      print("Bağlantı durumu: ${hubConnection.state}");
    }
  }

  void stopPublishing() {}
}
