import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('도움말'),
        backgroundColor: Colors.teal[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpSectionWithIcon(
              Icons.add_circle_outline,
              Colors.blue,
              '약물 등록하기',
              '새로운 약물을 등록하여 복용 관리를 시작하세요.',
              [
                '1. 홈 화면에서 "약물 등록" 버튼 클릭',
                '2. 약물명, 복용량, 복용 횟수 입력',
                '3. 필요시 약물 사진 촬영',
                '4. 저장 버튼으로 등록 완료',
              ],
            ),
            
            _buildHelpSectionWithIcon(
              Icons.check_circle_outline,
              Colors.green,
              '복용 완료 기록하기',
              '약물을 복용했을 때 기록을 남겨 통계를 관리하세요.',
              [
                '1. "약물 관리" 탭에서 복용한 약물 찾기',
                '2. "복용 완료" 버튼 클릭',
                '3. 자동으로 복용 기록이 저장됨',
                '4. 통계에 실시간 반영',
              ],
            ),
            
            _buildHelpSectionWithIcon(
              Icons.analytics_outlined,
              Colors.purple,
              '통계 확인하기',
              '복용 패턴을 분석하고 개선점을 찾아보세요.',
              [
                '1. "통계" 탭에서 복용 현황 확인',
                '2. 주간/월간/연간 기간 선택',
                '3. 차트로 복용률 추이 확인',
                '4. 약물별 복용 현황 비교',
              ],
            ),
            
            _buildHelpSectionWithIcon(
              Icons.psychology_outlined,
              Colors.deepPurple,
              'AI 추천 받기',
              'AI가 분석한 맞춤형 복용 개선 방안을 확인하세요.',
              [
                '1. 홈 화면에서 "AI 추천" 버튼 클릭',
                '2. AI가 복용 패턴 자동 분석',
                '3. 개인화된 추천사항 확인',
                '4. 복용 습관 개선에 활용',
              ],
            ),
            
            _buildHelpSectionWithIcon(
              Icons.notifications_outlined,
              Colors.orange,
              '알림 설정하기',
              '복용 시간을 놓치지 않도록 알림을 설정하세요.',
              [
                '1. "복용 일정" 탭에서 시간대 확인',
                '2. 각 시간대별 알림 ON/OFF 설정',
                '3. 복용 예정 약물 확인',
                '4. "복용" 버튼으로 즉시 기록',
              ],
            ),
            
            const SizedBox(height: 24),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.teal[600]),
                      const SizedBox(width: 8),
                      Text(
                        '💡 사용 팁',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('• 매일 같은 시간에 복용하면 습관이 됩니다'),
                  const Text('• 복용 완료 버튼을 눌러야 통계에 반영됩니다'),
                  const Text('• AI 추천은 일주일 이상 사용 후 더 정확해집니다'),
                  const Text('• 약물 사진을 등록하면 구분하기 쉽습니다'),
                  const Text('• AI 추천은 일정 금액에 비용이 개발자에게 청구 됩니다.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHelpSectionWithIcon(IconData icon, Color color, String title, String description, List<String> steps) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...steps.map((step) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 6),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step,
                    style: const TextStyle(fontSize: 14, height: 1.4),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}