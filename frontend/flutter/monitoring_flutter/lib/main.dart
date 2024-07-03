import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monitoring_test/components/major/side_panel.dart';
import 'package:monitoring_test/services/data_generate.dart';
import 'package:monitoring_test/services/publish_data.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'blocs/data_bloc.dart';
import 'blocs/data_event.dart';
import 'blocs/data_state.dart';
import 'components/minor/real_time_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final publishDataService = PublishDataService("http://10.0.2.2:5033/myHub");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => DataBloc(
          DataService(),
          publishDataService,
        ),
        child: AppBarHome(publishDataService: publishDataService),
      ),
    );
  }
}

class AppBarHome extends StatefulWidget {
  final PublishDataService publishDataService;

  const AppBarHome({super.key, required this.publishDataService});

  @override
  State<AppBarHome> createState() => _AppBarHomeState();
}

class _AppBarHomeState extends State<AppBarHome>
    with SingleTickerProviderStateMixin {
  late bool _showSettingPanel;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _showSettingPanel = false;

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  void toggleSettingsPage() {
    setState(() {
      _showSettingPanel = !_showSettingPanel;
      if (_showSettingPanel) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Monitoring Test"),
        actions: <Widget>[
          AnimatedSwitcher(
            duration: Duration(milliseconds: 400),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: IconButton(
              key: ValueKey<bool>(_showSettingPanel),
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                toggleSettingsPage();
              },
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          IgnorePointer(
            ignoring: _showSettingPanel,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                    child: LineChartSample10(
                  chartNumber: 1,
                )),
                Expanded(
                    child: LineChartSample10(
                  chartNumber: 2,
                )),
                Expanded(
                    child: LineChartSample10(
                  chartNumber: 3,
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BlocBuilder<DataBloc, DataState>(
                      builder: (context, state) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blue,
                              child: GestureDetector(
                                onTap: () {
                                  final bloc = context.read<DataBloc>();
                                  if (state.isStreaming) {
                                    bloc.add(PauseDataStream());
                                  } else {
                                    bloc.add(StartDataStream());
                                  }
                                },
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 400),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return ScaleTransition(
                                        scale: animation, child: child);
                                  },
                                  child: Icon(
                                    key: ValueKey<bool>(state.isStreaming),
                                    state.isStreaming
                                        ? Icons.stop
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.blue,
                              child: GestureDetector(
                                onTap: () {
                                  final bloc = context.read<DataBloc>();
                                  if (state.isPublishing) {
                                    bloc.add(PausePublishData());
                                  } else {
                                    bloc.add(StartPublishData());
                                  }
                                },
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 400),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return ScaleTransition(
                                        scale: animation, child: child);
                                  },
                                  child: Icon(
                                    key: ValueKey<bool>(state.isPublishing),
                                    state.isPublishing
                                        ? Icons.shape_line
                                        : Icons.shape_line_outlined,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  child: ValueListenableBuilder<HubConnectionState>(
                    valueListenable:
                        widget.publishDataService.connectionStateNotifier,
                    builder: (context, connectionState, child) {
                      String statusText;
                      Color statusColor;
                      if (connectionState == HubConnectionState.Connected) {
                        statusText = "Connected";
                        statusColor = Colors.green;
                      } else if (connectionState ==
                          HubConnectionState.Reconnecting) {
                        statusText = "Reconnecting...";
                        statusColor = Colors.yellow;
                      } else {
                        statusText = "Not Connected";
                        statusColor = Colors.red;
                      }
                      return Column(
                        children: [
                          Text(
                            "Connection Status: $statusText",
                            style: TextStyle(
                              color: statusColor,
                            ),
                          ),
                          Text(
                            "Address: ${connectionState == HubConnectionState.Connected ? 'http://localhost:5033' : 'Not Connect'}",
                            style: TextStyle(
                              color: statusColor,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (_showSettingPanel)
            GestureDetector(
              onTap: toggleSettingsPage,
              child: Container(
                color: Colors.black54,
              ),
            ),
          Align(
            alignment: Alignment.centerRight,
            child: SlideTransition(
              position: _slideAnimation,
              child: SidePanel(),
            ),
          ),
        ],
      ),
    );
  }
}
