import 'package:flutter/material.dart';
import "package:test_app_rev/models/test_question.dart";
import "package:test_app_rev/models/medical_test.dart";

class CreateTestScreen extends StatefulWidget {
  final Function(MedicalTest) onTestCreated;

  const CreateTestScreen({super.key, required this.onTestCreated});

  @override
  State<CreateTestScreen> createState() => _CreateTestScreenState();
}

class _CreateTestScreenState extends State<CreateTestScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<TestQuestion> _questions = [];

  void _addNewQuestion(TestQuestion question) {
    setState(() {
      _questions.add(question);
    });
  }

  void _editQuestion(int index) {
    _showQuestionDialog(editIndex: index);
  }

  void _deleteQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  void _saveTest() {
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
    }
  }

  void _showQuestionDialog({int? editIndex}) {
    final TextEditingController questionController = TextEditingController();
    List<TextEditingController> optionControllers = [];

    if (editIndex != null) {
      questionController.text = _questions[editIndex].question;
      for (String opt in _questions[editIndex].options) {
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
        return StatefulBuilder(
          builder: (ctx, setDialogState) { // Renamed setState to setDialogState for clarity
            return AlertDialog(
              title: Text(editIndex == null ? 'Yeni Soru Ekle' : 'Soruyu Düzenle'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    TextField(
                      controller: questionController,
                      decoration: const InputDecoration(
                        labelText: 'Soru Metni',
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 16),

                    const Text('Cevap Seçenekleri', style: TextStyle(fontWeight: FontWeight.bold)),

                    const SizedBox(height: 8),

                    ...List.generate(optionControllers.length, (i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: Color.fromRGBO(80,100,130,1),
                              child: Text(
                                '${i + 1}', 
                                style: const TextStyle(
                                  color: Colors.white, 
                                  fontSize: 12, 
                                  fontWeight: FontWeight.bold)
                                ),
                            ),

                            const SizedBox(width: 8),

                            Expanded(
                              child: TextField(
                                controller: optionControllers[i],
                                decoration: InputDecoration(
                                  hintText: 'Seçenek ${i + 1}',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: i > 1
                                      ? IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            setDialogState(() => optionControllers.removeAt(i));
                                          },
                                        )
                                      : null,
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
                      icon: const Icon(Icons.add_circle_outline, color: Colors.white,),
                      label: const Text('Seçenek Ekle', style: TextStyle(color: Colors.white),),
                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(80,100,130,1)),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('İptal')),
                ElevatedButton(
                  onPressed: () {
                    final opts = optionControllers.map((c) => c.text).where((t) => t.trim().isNotEmpty).toList();
                    if (questionController.text.isNotEmpty && opts.length >= 2) {
                      final newQ = TestQuestion(question: questionController.text, options: opts);
                      
                      if (editIndex == null) {
                        _addNewQuestion(newQ);
                      } else {
                        setState(() { // Ana widget'ın setState'ini kullanıyoruz
                          _questions[editIndex] = newQ;
                        });
                      }
                      Navigator.of(ctx).pop();
                    } else {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                        const SnackBar(content: Text('Lütfen soru metni ve en az 2 seçenek giriniz.'), backgroundColor: Colors.red),
                      );
                    }
                  },
                  child: Text(editIndex == null ? 'Ekle' : 'Güncelle'),
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
    return Scaffold(
      appBar: AppBar(title: const Text('Yeni Test Oluştur'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Test Başlığı',
                border: OutlineInputBorder()
              )
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Test Açıklaması', 
                border: OutlineInputBorder()
              ),
              maxLines: 2,
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Sorular', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

                const SizedBox(width: 8),

                ElevatedButton.icon(
                  onPressed: () => _showQuestionDialog(),
                  icon: const Icon(Icons.add, color: Colors.white,), 
                  label: const Text('Soru Ekle', style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(80,100,130,1)),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Expanded(
              child: _questions.isEmpty
                  ? const Center(child: Text('Henüz soru eklenmedi. Soru eklemek için yukarıdaki butona tıklayın.'))
                  : ListView.builder(
                      itemCount: _questions.length,
                      itemBuilder: (_, i) {
                        final q = _questions[i];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),

                          child: ListTile(
                            title: Text(
                              'Soru ${i + 1}: ${q.question}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(80,100,130,1),
                              ),
                            ),

                            subtitle: Text('${q.options.length} seçenek'),

                            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue
                                ), onPressed: () => _editQuestion(i,)
                              ),

                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red
                                ), onPressed: () => _deleteQuestion(i)
                              ),
                            ]),
                          ),
                        );
                      },
                    ),
            ),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(onPressed: _saveTest, child: const Text('Testi Kaydet', style: TextStyle(fontSize: 16))),
            ),
          ],
        ),
      ),
    );
  }
}