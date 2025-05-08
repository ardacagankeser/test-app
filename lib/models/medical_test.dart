import 'test_question.dart';

class MedicalTest {
  String id;
  String title;
  String description;
  List<TestQuestion> questions;
  DateTime createdAt;

  MedicalTest({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    required this.createdAt,
  });
}