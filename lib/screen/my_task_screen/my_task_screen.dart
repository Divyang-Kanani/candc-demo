import 'dart:async';
import 'dart:developer';
import 'package:candc_demo_flutter/dialog/custom_progress_dialog.dart';
import 'package:candc_demo_flutter/screen/login_screen.dart';
import 'package:candc_demo_flutter/utils/internet_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../utils/location_helper.dart';
import '../../utils/notification_helper.dart';
import '../../utils/shared_pref_helper.dart';

class MyTaskScreen extends StatefulWidget {
  const MyTaskScreen({super.key});

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen> {
  late Future<String?> _cityFuture;

  /// 🧩 Static task list (added duration key)
  final List<Map<String, String>> _tasks = [
    {
      'name': 'Inventory Check',
      'description': 'Verify all items in warehouse stock.',
      'time': '09:00 AM',
      'priority': 'High',
      'duration': '00:01:30', // 1 minute 30 seconds
    },
    {
      'name': 'Customer Visit',
      'description': 'Meet client at their office to collect feedback.',
      'time': '11:30 AM',
      'priority': 'Medium',
      'duration': '00:02:15', // 2 min 15 sec
    },
    {
      'name': 'Report Update',
      'description': 'Submit daily report to manager.',
      'time': '02:00 PM',
      'priority': 'Urgent',
      'duration': '00:01:00', // 1 min
    },
    {
      'name': 'System Audit',
      'description': 'Run audit for security and performance.',
      'time': '04:00 PM',
      'priority': 'High',
      'duration': '00:03:00', // 3 minutes
    },
  ];

  int? _selectedIndex;
  bool _isClockInStarted = false;
  int _remainingSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _cityFuture = _getCityName();
  }

  Future<String?> _getCityName() async {
    try {
      Position position = await LocationHelper.getCurrentPosition();
      String? city = await LocationHelper.getDistrictName(position);
      log('📍 City: $city');
      return city;
    } catch (e) {
      log('❌ Error fetching city: $e');
      throw Exception(e.toString());
    }
  }

  /// ✅ Parse "hh:mm:ss" to total seconds
  int _parseDurationToSeconds(String duration) {
    final parts = duration.split(':');
    if (parts.length != 3) return 0;
    final hours = int.tryParse(parts[0]) ?? 0;
    final minutes = int.tryParse(parts[1]) ?? 0;
    final seconds = int.tryParse(parts[2]) ?? 0;
    return (hours * 3600) + (minutes * 60) + seconds;
  }

  void _startCountdown() {
    if (_selectedIndex == null) return;
    final durationStr = _tasks[_selectedIndex!]['duration']!;
    final totalSeconds = _parseDurationToSeconds(durationStr);
    final taskName = _tasks[_selectedIndex!]['name']!;

    setState(() {
      _isClockInStarted = true;
      _remainingSeconds = totalSeconds;
    });

    // 🔔 Show initial notification (Android only)
    NotificationHelper.showCountdown(taskName, _formatTime(_remainingSeconds));

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
        // 🔔 Update countdown notification text each second
        NotificationHelper.updateCountdown(
          taskName,
          _formatTime(_remainingSeconds),
        );
      } else {
        timer.cancel();
        // 🔕 Auto dismiss notification
        NotificationHelper.cancelCountdown();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('⏰ Time’s up!')));
      }
    });
  }

  void _stopCountdown() {
    _timer?.cancel();
    NotificationHelper.cancelCountdown();
    setState(() => _isClockInStarted = false);
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) =>
            ScaleTransition(scale: anim, child: child),
        child: (_selectedIndex != null && !_isClockInStarted)
            ? FloatingActionButton(
                key: const ValueKey('visibleFab'),
                shape: const CircleBorder(),
                backgroundColor: Colors.purple,
                onPressed: _startCountdown,
                child: const Text(
                  'Clock In',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              )
            : (_isClockInStarted)
            ? FloatingActionButton(
                shape: const CircleBorder(),
                backgroundColor: Colors.purple,
                onPressed: _stopCountdown,
                child: const Text(
                  'Clock Out',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
              )
            : const SizedBox.shrink(key: ValueKey('hiddenFab')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text('My Task'),
        actions: [
          TextButton.icon(
            onPressed: () async {
              if (await InternetConnection.instance.hasConnection()) {
                CustomProgressDialog.show();
                await SharedPrefHelper().setBool('isUserLoggedIn', false);
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            label: const Text('Logout'),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: FutureBuilder<String?>(
        future: _cityFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 5),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                '⚠️ Failed to get location\n${snapshot.error}',
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            );
          }

          if (snapshot.hasData && snapshot.data == 'Ahmedabad') {
            if (_isClockInStarted) {
              final taskName = _tasks[_selectedIndex!]['name']!;
              final total = _parseDurationToSeconds(
                _tasks[_selectedIndex!]['duration']!,
              );

              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        taskName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        _formatTime(_remainingSeconds),
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Show task list normally
            return Padding(
              padding: const EdgeInsets.all(10),
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  final task = _tasks[index];
                  final isSelected = _selectedIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = _selectedIndex == index ? null : index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? Colors.blueAccent
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                        ],
                      ),
                      child: ListTile(
                        leading: isSelected
                            ? const Icon(
                                Icons.radio_button_checked,
                                color: Colors.blueAccent,
                              )
                            : const Icon(
                                Icons.radio_button_unchecked,
                                color: Colors.grey,
                              ),
                        title: Row(
                          children: [
                            Expanded(
                              child: Text(
                                task['name']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (isSelected)
                              Chip(
                                label: Text(
                                  task['priority']!,
                                  style: const TextStyle(
                                    color: Colors.indigo,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                backgroundColor: Colors.purple.withOpacity(0.2),
                              ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(task['description']!),
                            // Text("⏱ Duration: ${task['duration']}"),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return const Center(child: Text('Location Not Verified'));
        },
      ),
    );
  }
}
