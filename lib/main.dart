import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
          leading: BackButton(
            onPressed: () {},
          ),
          title: const Text(
            "Set Goals",
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
          ),
        ),
        body: const CalendarScreen(),
      ),
    );
  }
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();
  Map<DateTime, List<Goal>> goalsMap = {
    DateTime.now(): [Goal()] // Initial goals for today
  };
  List<String> months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July',
    'August', 'September', 'October', 'November', 'December'
  ];
  List<String> daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  bool tickMarkClicked = false;
  bool isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "  Plan your day",
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.grey, fontSize: 20, fontWeight: FontWeight.w400),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Calendar',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Text(
                        'Month:',
                        style: TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        value: months[selectedDate.month - 1],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedDate = DateTime(selectedDate.year, months.indexOf(newValue!) + 1);
                          });
                        },
                        items: months.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(daysInMonth(selectedDate.year, selectedDate.month), (index) {
                    DateTime date = DateTime(selectedDate.year, selectedDate.month, index + 1);
                    String dayOfWeek = DateFormat('EEE').format(date).substring(0, 3);
                    bool isCurrentDate = isSameDay(date, DateTime.now());
                    bool isSelectedDate = isSameDay(date, selectedDate);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                          if (!goalsMap.containsKey(date)) {
                            goalsMap[date] = [];
                          }
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 70,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isSelectedDate ? Colors.blue[100] : isCurrentDate ? Colors.blue[50] : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Card(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayOfWeek,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text('${index + 1}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "  Goals",
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              ...goalsMap[selectedDate]!.asMap().entries.map((entry) => buildGoalRow(entry.key, entry.value)),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    if (!goalsMap.containsKey(selectedDate)) {
                      goalsMap[selectedDate] = [];
                    }
                    goalsMap[selectedDate]!.add(Goal());
                  });
                },
                child: Center(
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: const Color.fromARGB(255, 6, 150, 80),
                    ),
                    child: const Center(
                      child: Text(
                        "Add New",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  setState(() {
                    // Save the current state of goals to the map here
                    // You can implement the actual save logic as needed
                    // For now, just logging the goals for demonstration
                    goalsMap[selectedDate]?.forEach((goal) {
                      print('Goal: ${goal.text}, Time: ${goal.time}');
                    });
                  });
                },
                child: Center(
                  child: Container(
                    width: 150,
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.lightBlue,
                    ),
                    child: const Center(
                      child: Text(
                        "Update",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGoalRow(int index, Goal goal) {
    return Column(
      children: [
        const SizedBox(height: 8), // Space between rows
        Row(
          children: [
            Container(
              width: 100,
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: TextEditingController(text: goal.time),
                readOnly: !isEditing,
                onChanged: (newValue) {
                  goal.time = newValue;
                },
                onSubmitted: (newValue) {
                  setState(() {
                    isEditing = false;
                  });
                },
                decoration: const InputDecoration(
                  hintText: 'time',
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(width: 8), // Small space
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isEditing = true;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(153, 108, 106, 106),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: TextEditingController(text: goal.text),
                                readOnly: !isEditing,
                                onChanged: (newValue) {
                                  goal.text = newValue;
                                },
                                onSubmitted: (newValue) {
                                  setState(() {
                                    isEditing = false;
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Type a goal',
                                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert),
                              onSelected: (String value) {
                                if (value == 'Remove') {
                                  setState(() {
                                    goalsMap[selectedDate]!.removeAt(index); // Remove the goal at index
                                  });
                                } else if (value == 'Edit') {
                                  setState(() {
                                    isEditing = true;
                                  });
                                }
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'Edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'Remove',
                                  child: Text('Remove'),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8), // Small space
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  tickMarkClicked = !tickMarkClicked;
                                });
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: tickMarkClicked ? Colors.green : Colors.grey[300],
                                ),
                                child: Icon(
                                  Icons.check,
                                  color: tickMarkClicked ? Colors.white : Colors.green,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  int daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}

class Goal {
  String time;
  String text;

  Goal({this.time = '', this.text = ''});
}
