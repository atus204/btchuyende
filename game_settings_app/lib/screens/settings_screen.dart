import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool sound = false;
  bool autoSave = false;
  double volume = 50;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  /// 📥 LOAD DATA
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      sound = prefs.getBool('sound') ?? false;
      autoSave = prefs.getBool('autoSave') ?? false;
      volume = prefs.getDouble('volume') ?? 50;
    });
  }

  /// 💾 SAVE DATA
  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('sound', sound);
    await prefs.setBool('autoSave', autoSave);
    await prefs.setDouble('volume', volume);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cấu hình game đố vui"),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔊 ÂM THANH
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Âm thanh"),
                Checkbox(
                  value: sound,
                  onChanged: (val) {
                    setState(() {
                      sound = val!;
                    });
                    saveData();
                  },
                ),
              ],
            ),

            /// 💾 AUTO SAVE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tự động lưu game"),
                Checkbox(
                  value: autoSave,
                  onChanged: (val) {
                    setState(() {
                      autoSave = val!;
                    });
                    saveData();
                  },
                ),
              ],
            ),

            SizedBox(height: 20),

            /// 🔊 VOLUME
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Volume"),
                Text(volume.toInt().toString()),
              ],
            ),

            Slider(
              value: volume,
              min: 0,
              max: 100,
              divisions: 10,
              label: volume.toInt().toString(),
              onChanged: (val) {
                setState(() {
                  volume = val;
                });
              },
              onChangeEnd: (val) {
                saveData();
              },
            ),
          ],
        ),
      ),
    );
  }
}