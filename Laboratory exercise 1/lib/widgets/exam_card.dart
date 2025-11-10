import 'package:flutter/material.dart';
import '../models/exam.dart';
import '../screens/exam_detail_screen.dart';
import 'package:intl/intl.dart';

class ExamCard extends StatelessWidget {
  final Exam exam;

  const ExamCard({super.key, required this.exam});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final isPast = exam.dateTime.isBefore(now);
    final dateFormat = DateFormat('dd.MM.yyyy');
    final timeFormat = DateFormat('HH:mm');

    final Color cardColor = isPast ? Colors.grey.shade300 : Colors.lightBlue.shade100;
    final Color iconColor = isPast ? Colors.green.shade700 : Colors.blueAccent;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ExamDetailScreen(exam: exam)),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 160,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          color: cardColor,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    exam.subjectName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis
                ),
                // Row(
                //   children: [
                //     const Icon(Icons.calendar_today, size: 14),
                //     const SizedBox(width: 4),
                //     Text("${dateFormat.format(exam.dateTime)} ${timeFormat.format(exam.dateTime)}",
                //         style: const TextStyle(fontSize: 13)),
                //   ],
                // ),
                // Row(
                //   children: [
                //     const Icon(Icons.room, size: 14),
                //     const SizedBox(width: 4),
                //     Expanded(
                //       child: Text(
                //         exam.rooms.join(', '),
                //         style: const TextStyle(fontSize: 13),
                //         overflow: TextOverflow.ellipsis,
                //       ),
                //     ),
                //   ],
                // ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Icon(
                    isPast ? Icons.check_circle : Icons.access_time,
                    color: iconColor,
                    size: 22,
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
