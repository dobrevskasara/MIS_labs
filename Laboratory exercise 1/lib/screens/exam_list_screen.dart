import 'package:flutter/material.dart';
import '../models/exam.dart';
import '../widgets/exam_card.dart';

class ExamListScreen extends StatelessWidget {
  const ExamListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final exams = [
      Exam(subjectName: "Структурно програмирање", dateTime: DateTime(2022, 2, 12, 8, 30), rooms: ["Лаб 3"]),
      Exam(subjectName: "Интегрирани Системи", dateTime: DateTime(2025, 12, 25, 10, 0), rooms: ["Лаб 12"]),
      Exam(subjectName: "Етичко Хакирање", dateTime: DateTime(2026, 1, 10, 15, 0), rooms: ["Лаб 2"]),
      Exam(subjectName: "Медиуми и комуникации", dateTime: DateTime(2024, 7, 5, 11, 0), rooms: ["138"]),
      Exam(subjectName: "Софтверски квалитет и тестирање", dateTime: DateTime(2025, 5, 30, 9, 30), rooms: ["200аб"]),
      Exam(subjectName: "Објектно-ориентирано програмирање", dateTime: DateTime(2023, 6, 25, 13, 0), rooms: ["200аб"]),
      Exam(subjectName: "Бази на податоци", dateTime: DateTime(2025, 11, 19, 14, 0), rooms: ["Лаб 12"]),
      Exam(subjectName: "Мобилни информациски системи", dateTime: DateTime(2025, 12, 15, 16, 0), rooms: ["138"]),
      Exam(subjectName: "Оперативни системи", dateTime: DateTime(2024, 5, 27, 9, 0), rooms: ["Лаб 12"]),
      Exam(subjectName: "Веројатност и статистика", dateTime: DateTime(2024, 7, 2, 10, 0), rooms: ["Амф МФ"]),
      Exam(subjectName: "Вештачка интелигенција", dateTime: DateTime(2025, 12, 5, 10, 0), rooms: ["Лаб 3"]),
      Exam(subjectName: "Машинско учење", dateTime: DateTime(2025, 7, 15, 9, 0), rooms: ["200в"]),
    ];

    exams.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    final totalExams = exams.length;
    final pastExams = exams.where((e) => e.dateTime.isBefore(DateTime.now())).length;
    final upcomingExams = totalExams - pastExams;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Распоред за испити - 221125"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.9,
          children: exams.map((exam) => ExamCard(exam: exam)).toList(),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        color: Colors.blue,
        child: Text(
          "Вкупно испити: $totalExams | Поминати: $pastExams | Преостанати: $upcomingExams",
          style: const TextStyle(color: Colors.white, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
