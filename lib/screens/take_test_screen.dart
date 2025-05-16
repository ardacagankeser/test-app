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

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Text(
          'Soru ${_currentQuestionIndex + 1}/${_questions.length}', 
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold
          ),
        ),

        SizedBox(height: 8),

        Card(
          elevation: 2, 
          color: colorScheme.primaryContainer,

          child: Padding(
            padding: EdgeInsets.all(16),
            
            child: Text(
              q.question, 
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        SizedBox(height: 16),

        Text(
          'Cevap Seçenekleri:', 
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold
          ),
        ),

        Expanded(
          child: ListView.builder(
            itemCount: q.options.length,
            itemBuilder: (_, i) => RadioListTile<int>(
              title: Text(
                q.options[i],

                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
              value: i,
              groupValue: q.selectedAnswer,
              onChanged: (val) => setState(() => q.selectedAnswer = val),
              selectedTileColor: colorScheme.primary,
              splashRadius: 16,
            ),
          ),
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_currentQuestionIndex > 0) ElevatedButton(
              onPressed: _goToPreviousQuestion,

              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.secondaryContainer,
              ),

              child: Text(
                'Önceki Soru', 
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold
                ),
              ),
            ) else SizedBox(),

            ElevatedButton(
              onPressed: q.selectedAnswer != null 
                ? _goToNextQuestion 
                : null,

              style: ElevatedButton.styleFrom(
                backgroundColor: _currentQuestionIndex == _questions.length - 1 
                  ? colorScheme.tertiaryContainer 
                  : colorScheme.secondaryContainer,
              ),

              child: Text(
                _currentQuestionIndex == _questions.length - 1 
                  ? 'Testi Tamamla' 
                  : 'Sonraki Soru',

                style: TextStyle(
                  color: _currentQuestionIndex == _questions.length - 1 
                    ? colorScheme.tertiary 
                    : colorScheme.primary, 
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,

      children: [
        Icon(
          Icons.check_circle_outline_rounded, 
          color: Colors.green, 
          size: 80,
        ),

        SizedBox(height: 24),
        
        Text(
          'Test Tamamlandı!', 
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ), 
          textAlign: TextAlign.center
        ),

        SizedBox(height: 16),

        Text(
          'Tüm soruları yanıtladınız. Test sonuçları kaydedildi.',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ), 
          textAlign: TextAlign.center
        ),

        SizedBox(height: 32),

        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(), 

          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primaryContainer,
          ),

          child: Text(
            'Ana Ekrana Dön',
            style: textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          )
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.test.title,
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ), 
        centerTitle: true
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: _testCompleted ? _buildCompletedView() : _buildQuestionView(),
      ),
    );
  }
}