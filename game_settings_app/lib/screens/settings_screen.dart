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
  bool isSaving = false;

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
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        /// 🔊 ÂM THANH
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.volume_up, color: Colors.deepPurple),
                                SizedBox(width: 8),
                                Text("Âm thanh", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            Checkbox(
                              value: sound,
                              onChanged: (val) {
                                setState(() {
                                  sound = val!;
                                });
                              },
                            ),
                          ],
                        ),
                        /// 💾 AUTO SAVE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.save, color: Colors.deepPurple),
                                SizedBox(width: 8),
                                Text("Tự động lưu game", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            Checkbox(
                              value: autoSave,
                              onChanged: (val) {
                                setState(() {
                                  autoSave = val!;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        /// 🔊 VOLUME
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.speaker, color: Colors.deepPurple),
                                SizedBox(width: 8),
                                Text("Âm lượng", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            Text(volume.toInt().toString(), style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Slider(
                          value: volume,
                          min: 0,
                          max: 100,
                          divisions: 20,
                          label: volume.toInt().toString(),
                          activeColor: Colors.deepPurple,
                          onChanged: (val) {
                            setState(() {
                              volume = val;
                            });
                          },
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: Icon(Icons.save_alt),
                            label: isSaving
                                ? SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text("Lưu lại", style: TextStyle(fontSize: 16)),
                            onPressed: isSaving
                                ? null
                                : () async {
                                    setState(() {
                                      isSaving = true;
                                    });
                                    await saveData();
                                    setState(() {
                                      isSaving = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Đã lưu thành công!"),
                                        backgroundColor: Colors.deepPurple,
                                      ),
                                    );
                                  },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}