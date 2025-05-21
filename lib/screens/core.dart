import 'package:flutter/material.dart';
import 'package:spending_app/screens/welcome.dart';

class Task {
  String title;
  DateTime dueDate;
  Task(this.title, this.dueDate);
}

class CorePage extends StatefulWidget {
  @override
  State<CorePage> createState() => _CorePageState();
}

class _CorePageState extends State<CorePage> {
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) => MyWelcomePage(),
                      ),
                    );
                  },
                  child: const Text('Sign out'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Tasks', style: TextStyle(fontSize: 24)),
            Expanded(
              child: Expanded(
                child: ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Checkbox(
                        value: false,
                        onChanged: (bool? value) {
                          setState(() {
                            tasks.removeAt(index);
                          });
                        },
                      ),
                      title: Text(tasks[index].title),
                      subtitle: Text(
                        'Due on: ${tasks[index].dueDate.toLocal().toString().split(' ')[0]}',
                      ),
                      onTap: () => _showTaskDetails(index),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: FloatingActionButton(
                onPressed: _addTask,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTask() {
    String newTitle = '';
    DateTime? newDate;
    TextEditingController titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Add Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Task Title'),
                    onChanged: (val) => newTitle = val,
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          newDate = picked;
                        });
                      }
                    },
                    child: Text(
                      newDate == null
                          ? 'Select Due Date'
                          : newDate!.toLocal().toString().split(' ')[0],
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (newTitle.isNotEmpty && newDate != null) {
                      setState(() {
                        tasks.add(Task(newTitle, newDate!));
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTaskDetails(int index) {
    final task = tasks[index];
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Task Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title: ${task.title}'),
                SizedBox(height: 10),
                Text(
                  'Due Date: ${task.dueDate.toLocal().toString().split(' ')[0]}',
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _editTask(index);
                },
                child: Text('Edit'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Close'),
              ),
            ],
          ),
    );
  }

  void _editTask(int index) {
    String updatedTitle = tasks[index].title;
    DateTime? updatedDate = tasks[index].dueDate;
    TextEditingController titleController = TextEditingController(
      text: updatedTitle,
    );

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text('Edit Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: 'Task Title'),
                    onChanged: (val) => updatedTitle = val,
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: updatedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setDialogState(() {
                          updatedDate = picked;
                        });
                      }
                    },
                    child: Text(
                      updatedDate == null
                          ? 'Select Due Date'
                          : updatedDate!.toLocal().toString().split(' ')[0],
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (updatedTitle.isNotEmpty && updatedDate != null) {
                      setState(() {
                        tasks[index] = Task(updatedTitle, updatedDate!);
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteTask(int index) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Delete Task'),
            content: Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    tasks.removeAt(index);
                  });
                  Navigator.pop(context);
                },
                child: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
    );
  }
}
