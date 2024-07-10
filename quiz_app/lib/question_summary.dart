import 'package:flutter/material.dart';

class QuestionSummary extends StatelessWidget {
  const QuestionSummary(this.summaryData, {super.key});
  final List<Map<String, Object>> summaryData;
  @override
  Widget build(context) {
    double size = 50.0;
    return SizedBox(
      height: 200,
      child: SingleChildScrollView(
        child: Column(
          children: summaryData.map((data) {
            return Row(
              children: [
                InkResponse(
                  onTap: () {},
                  child: Container(
                    width: size,
                    height: size,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                  ),
                ),
                Text(
                  ((data['question_index'] as int) + 1).toString(),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text((data['question'] as String)),
                      const SizedBox(
                        height: 5,
                      ),
                      Text((data['user_answer'] as String)),
                      Text((data['correct_answer'] as String)),
                    ],
                  ),
                )
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
