import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../config/api_keys.dart';

class AIRecommendationService {
  static const String _apiKey = ApiKeys.openaiApiKey;
  static const String _apiUrl = ApiKeys.openaiAPiUrl;

  static Future<String> testApiKey() async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'user',
              'content': 'Hello, this is a test message. Please respond with "API test successful!"'
            }
          ],
          'max_tokens': 20,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices']?[0]?['message']?['content'];
        return '✅ API 테스트 성공!\n응답: $content';
      } else {
        return '❌ API 테스트 실패\n상태 코드: ${response.statusCode}\n오류: ${response.body}';
      }
    } catch (e) {
      return '❌ API 테스트 실패\n오류: $e';
    }
  }

  static Future<String> getRecommendation() async {
    try {
      final analysisData = await _analyzeUserData();
      print('Sending request to OpenAI API...');
      print('Analysis data: $analysisData');
      
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'system',
              'content': '당신은 열정적이고 직설적인 약물 코치 입니다. 사용자의 약물 복용 패턴을 날카롭게 지적하고, 강력하고 인상적인 개선 방안을 제시하세요. 이모티콘과 느낌표를 사용해 생동감 있게 말하세요. 예: "😱 이거 진짜 심각한데요?" 같은 식으로.'
            },
            {
              'role': 'user',
              'content': '다음 약물 복용 데이터를 분석해서 개선 방안을 무조건 2문단 이네로 아주 짧고 강력하게 제안해주세요:\n$analysisData'
            }
          ],
          'max_tokens': 200,
          'temperature': 0.7,
        }),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices']?[0]?['message']?['content'];
        if (content != null) {
          return content;
        } else {
          print('No content in API response');
          return await _getFallbackRecommendation();
        }
      } else if (response.statusCode == 401) {
        print('API Key authentication failed');
        return 'API 키 인증에 실패했습니다. 개발자에게 문의하세요.';
      } else if (response.statusCode == 429) {
        print('API rate limit exceeded');
        return 'API 사용량 한도를 초과했습니다. 잠시 후 다시 시도해주세요.';
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return await _getFallbackRecommendation();
      }
    } catch (e) {
      print('Exception in API call: $e');
      return await _getFallbackRecommendation();
    }
  }

  static Future<String> _analyzeUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return '로그인이 필요합니다.';
    
    final now = DateTime.now();
    final weekAgo = now.subtract(Duration(days: 7));
    
    final records = await FirebaseFirestore.instance
        .collection('medicine_records')
        .where('userId', isEqualTo: user.uid)
        .get();
    
    final medicines = await FirebaseFirestore.instance
        .collection('medicines')
        .where('userId', isEqualTo: user.uid)
        .get();

    Map<String, int> dailyRecords = {};
    final weekAgoStr = DateFormat('yyyy-MM-dd').format(weekAgo);
    
    for (var record in records.docs) {
      final data = record.data();
      final date = data['date'] as String?;
      if (date != null && date.compareTo(weekAgoStr) > 0) {
        dailyRecords[date] = (dailyRecords[date] ?? 0) + 1;
      }
    }



    final recentRecordsCount = dailyRecords.values.fold<int>(0, (sum, count) => sum + count);
    
    return '''
등록된 약물 수: ${medicines.docs.length}개
최근 7일 복용 기록: ${recentRecordsCount}회
일별 복용 현황: ${dailyRecords.toString()}
''';
  }

  static Future<String> _getFallbackRecommendation() async {
    final analysisData = await _analyzeUserData();
    if (analysisData.contains('0개') || analysisData.contains('0회')) {
      return '''🚀 약물 관리를 시작해보세요!

💊 먼저 복용 중인 약물을 등록해주세요
⏰ 복용 시간을 정해서 규칙적으로 드세요
📱 복용 완료 버튼을 눌러 기록을 남기세요''';
    }
    
    if (analysisData.contains('점심') && analysisData.contains('누락')) {
      return '''😱 점심 시간 복용을 자주 빼먹고 계시네요!

⏰ 점심 알림을 30분 일찍 설정해보세요
🍽️ 식사 시간에 맞춰 약을 미리 준비해두세요
📱 스마트폰 알림을 적극 활용하세요''';
    }
    
    if (analysisData.contains('아침') && analysisData.contains('누락')) {
      return '''🌅 아침 약물 복용을 놓치는 경우가 많네요!

🛏️ 침대 옆에 약을 미리 준비해두세요
⏰ 기상 알람과 함께 약물 알림을 설정하세요
💧 충분한 물과 함께 복용하는 습관을 만드세요''';
    }
    
    return '''👏 꾸준히 약물을 잘 복용하고 계시네요!

✅ 이 패턴을 계속 유지해주세요
📊 통계를 정기적으로 확인해보세요
⚡ 복용하기 어려운 시간대가 있다면 알림 시간을 조정해보세요''';
  }
}