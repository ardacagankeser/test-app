import 'package:flutter/material.dart';
import "package:test_app_rev/models/test_question.dart";
import "package:test_app_rev/models/medical_test.dart";

class CreateTestScreen extends StatefulWidget {
  final Function(MedicalTest) onTestCreated;
  final MedicalTest? existingTest;

  const CreateTestScreen({super.key, required this.onTestCreated, this.existingTest});

  @override
  State<CreateTestScreen> createState() => _CreateTestScreenState();
}

class _CreateTestScreenState extends State<CreateTestScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late List<TestQuestion> _questions;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.existingTest?.title ?? "",
    );

    _descriptionController = TextEditingController(
      text: widget.existingTest?.description ?? "",
    );

    _questions = widget.existingTest?.questions.map((q) => q.copy()).toList() ?? [];
  }

  void _addNewQuestion(TestQuestion question) {
    setState(() {
      _questions.add(question);
    });
  }

  void _editQuestion(int index) {
    _showQuestionDialog(editQuestionIndex: index);
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  void _saveTest() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    if (_titleController.text.isNotEmpty && _questions.isNotEmpty) {
      final newTest = MedicalTest(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : 'Açıklama yok',
        questions: _questions,
        createdAt: DateTime.now(),
      );

      widget.onTestCreated(newTest);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Lütfen soru başlığını ve soruları giriniz.',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: colorScheme.errorContainer,
        ),
      );
    }
  }

  void _showQuestionDialog({int? editQuestionIndex}) {
    final TextEditingController questionController = TextEditingController();
    List<TextEditingController> optionControllers = [];

    if (editQuestionIndex != null) {
      questionController.text = _questions[editQuestionIndex].question;
      for (String opt in _questions[editQuestionIndex].options) {
        optionControllers.add(TextEditingController(text: opt));
      }
    }

    if (optionControllers.isEmpty) {
      optionControllers.add(TextEditingController());
      optionControllers.add(TextEditingController());
    }

    showDialog(
      context: context,
      builder: (ctx) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final textTheme = theme.textTheme;
        
        return StatefulBuilder(
          builder: (ctx, setDialogState) { // Renamed setState to setDialogState for clarity
            return AlertDialog(
              title: Text(
                editQuestionIndex == null ? 'Yeni Soru Ekle' : 'Soruyu Düzenle',

                style: textTheme.headlineMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),

              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    TextField(
                      controller: questionController,
                      decoration: InputDecoration(
                        labelText: 'Soru Metni',
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 2,
                    ),

                    SizedBox(height: 16),

                    Text(
                      'Cevap Seçenekleri', 
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                      ),
                    ),

                    SizedBox(height: 8),

                    ...List.generate(optionControllers.length, (i) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,

                              backgroundColor: colorScheme.primary,

                              child: Text(
                                '${i + 1}', 
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onPrimary, 
                                  fontWeight: FontWeight.bold)
                                ),
                            ),

                            SizedBox(width: 8),

                            Expanded(
                              child: TextField(
                                controller: optionControllers[i],

                                decoration: InputDecoration(
                                  hintText: 'Seçenek ${i + 1}',
                                  border: OutlineInputBorder(),
                                  suffixIcon: i > 1
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.delete, 
                                            color: colorScheme.error,
                                            size: 20,
                                          ),

                                          onPressed: () {
                                            setDialogState(() => optionControllers.removeAt(i));
                                          },
                                        )
                                      : null,
                                ),
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    ElevatedButton.icon(
                      onPressed: () {
                        setDialogState(() => optionControllers.add(TextEditingController()));
                      },

                      icon: Icon(
                        Icons.add, 
                        color: colorScheme.primary,
                      ),

                      label: Text(
                        'Seçenek Ekle', 
                        style: textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),

                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primaryContainer,
                      ),
                    ),
                  ],
                ),
              ),

              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(), 
                  child: Text(
                    'İptal',
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.error,
                    ),
                  )
                ),


                ElevatedButton(
                  onPressed: () {
                    final opts = optionControllers.map((c) => c.text).where((t) => t.trim().isNotEmpty).toList();
                    if (questionController.text.isNotEmpty && opts.length >= 2) {
                      final newQ = TestQuestion(question: questionController.text, options: opts);
                      
                      if (editQuestionIndex == null) {
                        _addNewQuestion(newQ);
                      } else {
                        setState(() { // Ana widget'ın setState'ini kullanıyoruz
                          _questions[editQuestionIndex] = newQ;
                        });
                      }
                      Navigator.of(ctx).pop();
                    } else {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Lütfen soru metni ve en az 2 seçenek giriniz.',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.error,
                            ),
                          ), 
                          backgroundColor: colorScheme.errorContainer,
                        ),
                      );
                    }
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primaryContainer.withValues(alpha: 0.7),
                  ),

                  child: Text(
                    editQuestionIndex == null ? 'Ekle' : 'Güncelle',

                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
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
          widget.existingTest == null ? "Test oluştur" : "Testi düzenle",

          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true
      ),

      body: Padding(
        padding: EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Test Başlığı',
                border: OutlineInputBorder()
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),

            SizedBox(height: 16),

            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Test Açıklaması', 
                border: OutlineInputBorder()
              ),
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
              maxLines: 2,
            ),

            SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Sorular', 
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),

                SizedBox(width: 8),

                ElevatedButton.icon(
                  onPressed: () => _showQuestionDialog(),

                  icon: Icon(
                    Icons.add, 
                    color: colorScheme.primary,
                  ),

                  label: Text(
                    'Soru Ekle', 
                    style: textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primaryContainer,
                  ),
                ),
              ],
            ),

            SizedBox(height: 8),

            Expanded(
              child: _questions.isEmpty
                ? Center(
                  child: Text(
                    'Soru yok. Soru eklemek için yukarıdaki butona tıklayın.',
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.primary,
                    ),
                  )
                )

                : ListView.builder(
                  itemCount: _questions.length,
                  itemBuilder: (_, i) {
                    final q = _questions[i];

                    return Card(
                      margin: EdgeInsets.only(bottom: 12),
                      color: colorScheme.primaryContainer.withValues(alpha: .5),

                      child: ListTile(
                        title: Text(
                          'Soru ${i + 1}: ${q.question}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold
                          ),
                        ),

                        subtitle: Text(
                          '${q.options.length} seçenek',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.primary.withValues(alpha: 0.7),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min, 
                          mainAxisAlignment: MainAxisAlignment.end,
                          
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: colorScheme.primary,
                              ), 
                              
                              onPressed: () => _editQuestion(i,)
                            ),

                            IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: colorScheme.error
                              ), 
                              
                              onPressed: () => _deleteQuestion(i)
                            ),
                          ]
                        ),
                      ),
                    );
                  },
                ),
            ),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveTest,

                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.onPrimaryContainer.withValues(alpha: 0.8)
                ),
                
                child: Text(
                  widget.existingTest == null ? "Testi kaydet" : "Testi güncelle",
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onPrimary
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}