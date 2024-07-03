import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SidePanel extends StatefulWidget {
  const SidePanel({super.key});

  @override
  _SidePanelState createState() => _SidePanelState();
}

class _SidePanelState extends State<SidePanel> {
  final List<int> _samplist = [50, 100, 200, 500];
  int? _selectedValue;
  final Uri _url =
      Uri.parse('https://www.linkedin.com/in/ahmet-furkan-ugur-730236205/');
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      width: MediaQuery.of(context).size.width / 2,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(children: [
              const Text(
                "Sampling Rate (hz)",
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "sans-serif",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              DropdownButton<int>(
                value: _selectedValue,
                items: _samplist.map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedValue = newValue;
                  });
                },
              ),
            ]),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage('assets/pp.jpg'),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A.Furkan UGUR',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'sans-serif',
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(height: 4),
                        Container(
                          width: 100,
                          height: 2,
                          color: Colors.white,
                        ),
                        SizedBox(height: 2),
                        Text(
                          'MSc. Engineer',
                          style: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'sans-serif',
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 7),
                ElevatedButton(
                  onPressed: _launchUrl,
                  child: Text('Contact Me'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.blue,
                    textStyle: TextStyle(
                      fontFamily: 'sans-serif',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
