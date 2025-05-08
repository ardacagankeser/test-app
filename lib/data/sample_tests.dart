import "package:test_app_rev/models/test_question.dart";
import "package:test_app_rev/models/medical_test.dart";

List<MedicalTest> sampleTests = [
  MedicalTest(
    id: '1',
    title: 'Klinik Değerlendirme Ölçeği',
    description: 'Hastaların klinik durumunu değerlendirmek için test',
    createdAt: DateTime.now(),
    questions: [
      TestQuestion(
        question: 'Bu hasta grubu ile olan klinik deneyimlerinize dayanarak, sizce bu kişi ne kadar hasta?',
        options: [
          'Normal, hasta değil',
          'Hastalık sınırında',
          'Hafif düzeyde hasta',
          'Orta düzeyde hasta',
          'Belirgin düzeyde hasta',
          'Ağır hasta',
          'Çok ağır hasta',
        ],
      ),
      TestQuestion(
        question: 'Hastanın günlük yaşam aktivitelerini gerçekleştirme düzeyi nasıldır?',
        options: [
          'Tamamen bağımsız',
          'Minimal yardıma ihtiyaç duyuyor',
          'Orta düzeyde yardıma ihtiyaç duyuyor',
          'Büyük ölçüde yardıma ihtiyaç duyuyor',
          'Tamamen bağımlı',
        ],
      ),
    ],
  ),
  
  MedicalTest(
    id: '2',
    title: 'Anksiyete Değerlendirme Testi',
    description: 'Hastalarda anksiyete seviyesini ölçmek için test',
    createdAt: DateTime.now(),
    questions: [
      TestQuestion(
        question: 'Son bir hafta içinde ne sıklıkla endişeli hissettiniz?',
        options: [
          'Hiç',
          'Nadiren',
          'Bazen',
          'Sık sık',
          'Her zaman',
        ],
      ),
      TestQuestion(
        question: 'Endişeleriniz günlük yaşamınızı ne kadar etkiliyor?',
        options: [
          'Hiç etkilemiyor',
          'Biraz etkiliyor',
          'Orta düzeyde etkiliyor',
          'Oldukça etkiliyor',
          'Aşırı derecede etkiliyor',
        ],
      ),
    ],
  ),
];
