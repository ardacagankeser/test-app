class TestQuestion {
  String question;
  List<String> options;
  int? selectedAnswer;

  TestQuestion({
    required this.question, 
    required this.options, 
    this.selectedAnswer}
  );

  TestQuestion copy() {
    return TestQuestion(
      question: question,
      options: List.from(options),
      selectedAnswer: selectedAnswer,
    );
  }
}