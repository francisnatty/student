import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  DateTime _startDate = DateTime(2024, 2, 22);
  TimeOfDay _startTime = TimeOfDay(hour: 18, minute: 0);
  DateTime _endDate = DateTime(2024, 2, 22);
  TimeOfDay _endTime = TimeOfDay(hour: 18, minute: 0);
  String _timezone = "West Africa Standard Time";
  String _repeatOption = "No repeat";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Title Input
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "Add Title",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
                hintStyle: TextStyle(color: Colors.grey.shade600),
              ),
            ),
          ),
          SizedBox(height: 16),

          // Time Section
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 20, color: Colors.grey.shade600),
                      SizedBox(width: 8),
                      Text(
                        "Time",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildTimeSelector(true),
                  SizedBox(height: 12),
                  _buildTimeSelector(false),
                  Divider(height: 24),
                  _buildOptionRow(
                    Icons.language,
                    _timezone,
                    () {/* Implement timezone selection */},
                  ),
                  _buildOptionRow(
                    Icons.repeat,
                    _repeatOption,
                    () {/* Implement repeat selection */},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Add People Section
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Add people",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage:
                            NetworkImage("https://picsum.photos/200"),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          "Aisha Tukura",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Add"),
                            SizedBox(width: 4),
                            Icon(Icons.add, size: 16),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),

          // Additional Options
          _buildActionItem("Add video conferencing", Icons.videocam_outlined),
          _buildActionItem("Add location", Icons.location_on_outlined),
          _buildActionItem("Add Description", Icons.description_outlined),
          _buildActionItem("Add attachment", Icons.attach_file),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(bool isStart) {
    final date = isStart ? _startDate : _endDate;
    final time = isStart ? _startTime : _endTime;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(2024),
                lastDate: DateTime(2025),
              );
              if (picked != null) {
                setState(() {
                  if (isStart)
                    _startDate = picked;
                  else
                    _endDate = picked;
                });
              }
            },
            child: Row(
              children: [
                Text(
                  DateFormat('E, dd MMM yyyy').format(date),
                  style: TextStyle(fontSize: 14),
                ),
                Icon(Icons.keyboard_arrow_down, size: 20),
              ],
            ),
          ),
        ),
        SizedBox(width: 16),
        GestureDetector(
          onTap: () async {
            final TimeOfDay? picked = await showTimePicker(
              context: context,
              initialTime: time,
            );
            if (picked != null) {
              setState(() {
                if (isStart)
                  _startTime = picked;
                else
                  _endTime = picked;
              });
            }
          },
          child: Row(
            children: [
              Text(
                time.format(context),
                style: TextStyle(fontSize: 14),
              ),
              Icon(Icons.keyboard_arrow_down, size: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptionRow(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: Colors.grey.shade600),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(fontSize: 14),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem(String title, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade600),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        onTap: () {},
      ),
    );
  }
}
