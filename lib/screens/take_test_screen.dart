import 'package:flutter/material.dart';
import "package:test_app_rev/models/test_question.dart";
import "package:test_app_rev/models/medical_test.dart";

class TakeTestScreen extends StatefulWidget {
  final MedicalTest test;

  const TakeTestScreen({super.key, required this.test});

  @override
  State<TakeTestScreen> createState() => _TakeTestScreenState();
}

class _TakeTestScreenState extends State<TakeTestScreen> {
  late List<TestQuestion> _questions;
  int _currentQuestionIndex = 0;
  bool _testCompleted = false;

  @override
  void initState() {
    super.initState();
    _questions = widget.test.questions
        .map((q) => TestQuestion(question: q.question, options: q.options, selectedAnswer: q.selectedAnswer))
        .toList();
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) setState(() => _currentQuestionIndex--);
  }

  void _goToNextQuestion() {
    if (_questions[_currentQuestionIndex].selectedAnswer != null) {
      if (_currentQuestionIndex < _questions.length - 1) {
        setState(() => _currentQuestionIndex++);
      } else { 
        setState(() => _testCompleted = true);
      }
    }
  }

  Widget _buildQuestionView() {
    final q = _questions[_currentQuestionIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Soru ${_currentQuestionIndex + 1}/${_questions.length}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Card(elevation: 2, child: Padding(padding: const EdgeInsets.all(16), child: Text(q.question, style: const TextStyle(fontSize: 18)))),
        const SizedBox(height: 16),
        const Text('Cevap Seçenekleri:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        Expanded(
          child: ListView.builder(
            itemCount: q.options.length,
            itemBuilder: (_, i) => RadioListTile<int>(
              title: Text(q.options[i]),
              value: i,
              groupValue: q.selectedAnswer,
              onChanged: (val) => setState(() => q.selectedAnswer = val),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentQuestionIndex > 0) ElevatedButton(
              onPressed: _goToPreviousQuestion, 
              child: const Text(
                'Önceki Soru', 
                style: TextStyle(
                  color: Color.fromRGBO(80,100,130,1), 
                  fontWeight: FontWeight.bold
                )
              )
            ) else const SizedBox(),

            ElevatedButton(
              onPressed: q.selectedAnswer != null ? _goToNextQuestion : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentQuestionIndex == _questions.length - 1 ? Colors.green : null),
              child: Text(_currentQuestionIndex == _questions.length - 1 ? 'Testi Tamamla' : 'Sonraki Soru',
                style: TextStyle(
                  color: _currentQuestionIndex == _questions.length - 1 ? Colors.white : Color.fromRGBO(80,100,130,1), 
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCompletedView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.check_circle, color: Colors.green, size: 80),
        const SizedBox(height: 24),
        const Text('Test Tamamlandı!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
        const SizedBox(height: 16),
        const Text('Tüm soruları yanıtladınız. Test sonuçları kaydedildi.', textAlign: TextAlign.center),
        const SizedBox(height: 32),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(), 
          child: const Text('Ana Ekrana Dön')
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.test.title), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _testCompleted ? _buildCompletedView() : _buildQuestionView(),
      ),
    );
  }
}