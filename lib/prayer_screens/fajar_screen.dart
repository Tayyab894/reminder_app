import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:learn_hive/boxes/boxes.dart';
import 'package:learn_hive/models/notes_model.dart';

class FajarScreen extends StatefulWidget {
  const FajarScreen({super.key});

  @override
  State<FajarScreen> createState() => _FajarScreenState();
}

class _FajarScreenState extends State<FajarScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  DateTime date = DateTime.now();
  DateTime time = DateTime.now();
  final uptoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Fajar Prayer")),
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.where((note) => note.title == 'Fajar').toList();

          if (data.isEmpty) {
            return const Center(
              child: Text('No Fajar prayers available.'),
            );
          }

          return ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final note = data[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ' ${note.description}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${note.date.day} - ${note.date.month} - ${note.date.year}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ' ${note.time.hour} :${note.time.minute}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              delete(note);
                            },
                            child: const Icon(Icons.delete, color: Colors.red),
                          ),
                          InkWell(
                            onTap: () {
                              _editDialog(note);
                            },
                            child: const Icon(Icons.more_vert),
                          ),
                          const SizedBox(width: 5),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _showMyDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

  Future<void> _editDialog(NotesModel note) async {
    titleController.text = note.title;
    descriptionController.text = note.description;
    date = note.date;
    time = note.time;

    await showDialog(
      context: context,
      builder: (context) {
        bool isComplete = note.description == 'Complete';

        return AlertDialog(
          title: const Text("Edit Fajar Prayer Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatefulBuilder(
                builder: (context, setState) {
                  return DropdownButton(
                    value: isComplete ? 'Complete' : 'Incomplete',
                    onChanged: (value) {
                      setState(() {
                        isComplete = value == 'Complete';
                      });
                    },
                    items: ['Complete', 'Incomplete'].map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 25),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Choose Time',
                  filled: true,
                  prefixIcon: Icon(Icons.timer),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                ),
                readOnly: true,
                onTap: () {
                  _selectTime();
                },
              ),
              const SizedBox(height: 25),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                  labelText: "Date",
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue)),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate();
                },
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (isComplete) {
                  note.description = 'Complete';
                } else {
                  note.description = 'Incomplete';
                }

                note.date = date;
                note.time = time;

                note.save();
                Navigator.pop(context);
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Add Fajar Prayer Details"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton(
                    value: 'Fajar',
                    onChanged: (newValue) {
                      setState(() {});
                    },
                    items: ['Fajar'].map((valueItem) {
                      return DropdownMenuItem(
                        value: valueItem,
                        child: Text(valueItem),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'Incomplete',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: timeController,
                    decoration: const InputDecoration(
                      labelText: 'Choose Time',
                      filled: true,
                      prefixIcon: Icon(Icons.timer),
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectTime();
                    },
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: dateController,
                    decoration: const InputDecoration(
                      labelText: "Date",
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today),
                      enabledBorder:
                          OutlineInputBorder(borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: uptoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'No of Rcords',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue)),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final box = Boxes.getData();

                    for (var i = 0; i < int.parse(uptoController.text); i++) {
                      final data = NotesModel(
                        title: 'Fajar',
                        description: "Incomplete",
                        date: date,
                        time: time,
                      );

                      box.add(data);
                    }

                    titleController.clear();
                    descriptionController.clear();
                    dateController.clear();
                    timeController.clear();
                    uptoController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (_picked != null) {
      date = _picked;
      dateController.text = "${_picked.day} ${_picked.month} ${_picked.year}";
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? _picker =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (_picker != null) {
      time = DateTime(
          date.year, date.month, date.day, _picker.hour, _picker.minute);
      timeController.text = "${_picker.hour}:${_picker.minute}";
    }
  }
}
