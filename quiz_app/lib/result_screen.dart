import 'package:flutter/material.dart';
import 'package:quiz_app/data/questions.dart';
import 'package:quiz_app/question_summary.dart';
import 'package:google_fonts/google_fonts.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({super.key, required this.chosenAnswer});
  final List<String> chosenAnswer;

  List<Map<String, Object>> get getSummaryData {
    List<Map<String, Object>> summary = [];

    for (var i = 0; i < chosenAnswer.length; i++) {
      summary.add({
        'question_index': i,
        'question': questions[i].text,
        'correct_answer': questions[i].answers[0],
        'user_answer': chosenAnswer[i]
      });
    }

    return summary;
  }

  @override
  Widget build(context) {
    final numTotalQuestions = questions.length;
    final numCorrectQuestions = getSummaryData
        .where((data) => data['user_answer'] == data['correct_answer'])
        .length;

    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'You answered $numCorrectQuestions out of $numTotalQuestions questions correctly',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            QuestionSummary(getSummaryData),
            const SizedBox(
              height: 30,
            ),
            OutlinedButton.icon(
              onPressed: () {},
              style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
              icon: const Icon(Icons.restart_alt_sharp),
              label: const Text(
                'Quiz Restart !',
              ),
            )
          ],
        ),
      ),
    );
  }
}
