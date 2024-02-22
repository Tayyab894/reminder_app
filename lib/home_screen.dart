import 'package:flutter/material.dart';
import 'package:learn_hive/prayer_screens/asr_screen.dart';
import 'package:learn_hive/prayer_screens/fajar_screen.dart';
import 'package:learn_hive/prayer_screens/isha_screen.dart';
import 'package:learn_hive/prayer_screens/magrib_screen.dart';
import 'package:learn_hive/prayer_screens/zohr_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedPrayerTime = '';
  List<String> prayerTimes = ['Fajar', 'Zohr', 'Asr', 'Magrib', 'Isha'];

  void navigateToPrayerScreen(String prayerTime) {
    switch (prayerTime) {
      case 'Fajar':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const FajarScreen()));
        break;
      case 'Zohr':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ZohrScreen()));
        break;
      case 'Asr':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AsrScreen()));
        break;
      case 'Magrib':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MagribScreen()));
        break;
      case 'Isha':
        Navigator.push(context, MaterialPageRoute(builder: (context) => const IshaScreen()));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Prayer Reminder",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
          ),
        ),
      ),
      body: ListView(
        children: prayerTimes.map((prayerTime) {
          return InkWell(
            onTap: () {
              setState(() {
                selectedPrayerTime = prayerTime;
              });
              navigateToPrayerScreen(prayerTime);
            },
              child: Container(
                decoration: BoxDecoration(
                  color: selectedPrayerTime == prayerTime ? Colors.blue : Colors.white,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(40),
                ),
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Text(
                    prayerTime,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: selectedPrayerTime == prayerTime ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
          );
        }).toList(),
      ),
    );
  }
}
