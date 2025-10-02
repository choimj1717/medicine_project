# 💊 Medicine Management App

> AI 기반 스마트 약물 관리 앱

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" />
  <img src="https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black" />
  <img src="https://img.shields.io/badge/OpenAI-412991?style=for-the-badge&logo=openai&logoColor=white" />
</div>

## 📱 프로젝트 소개

**Medicine Management App**은 사용자의 약물 복용을 체계적으로 관리하고, AI 기반 개인 맞춤형 복용 가이드를 제공하는 스마트 헬스케어 애플리케이션입니다.

### ✨ 주요 기능

- 🔐 **Firebase 인증** - 안전한 사용자 계정 관리
- 💊 **약물 등록 및 관리** - 복용 중인 약물 정보 저장
- ⏰ **복용 스케줄링** - 시간별 복용 알림 설정
- 📊 **복용 통계** - 시각적 차트로 복용 패턴 분석
- 🤖 **AI 추천 시스템** - OpenAI GPT 기반 개인 맞춤 복용 가이드
- 📱 **크로스 플랫폼** - iOS, Android, Web 지원

## 🏗️ 기술 스택

### Frontend
- **Flutter** - 크로스 플랫폼 UI 프레임워크
- **Dart** - 프로그래밍 언어
- **Material Design 3** - 모던 UI/UX

### Backend & Services
- **Firebase Authentication** - 사용자 인증
- **Cloud Firestore** - NoSQL 데이터베이스
- **Firebase Storage** - 파일 저장소
- **OpenAI GPT-3.5** - AI 추천 엔진

### 주요 패키지
```yaml
dependencies:
  firebase_core: ^3.6.0
  firebase_auth: ^5.3.1
  cloud_firestore: ^5.4.3
  flutter_local_notifications: ^17.2.2
  fl_chart: ^0.69.0
  http: ^1.1.0
  intl: ^0.19.0
```

## 📸 스크린샷

<div align="center">
  <table>
    <tr>
      <td align="center">
        <img src="screenshots/login.png" width="200" alt="로그인 화면"/>
        <br/><b>로그인 화면</b>
      </td>
      <td align="center">
        <img src="screenshots/dashboard.png" width="200" alt="대시보드"/>
        <br/><b>메인 대시보드</b>
      </td>
      <td align="center">
        <img src="screenshots/medicine_list.png" width="200" alt="약물 목록"/>
        <br/><b>약물 관리</b>
      </td>
    </tr>
    <tr>
      <td align="center">
        <img src="screenshots/schedule.png" width="200" alt="복용 스케줄"/>
        <br/><b>복용 스케줄</b>
      </td>
      <td align="center">
        <img src="screenshots/statistics.png" width="200" alt="통계"/>
        <br/><b>복용 통계</b>
      </td>
      <td align="center">
        <img src="screenshots/ai_recommendation.png" width="200" alt="AI 추천"/>
        <br/><b>AI 추천</b>
      </td>
    </tr>
  </table>
</div>

## 🚀 시작하기

### 필수 요구사항
- Flutter SDK (3.9.2+)
- Dart SDK
- Firebase 프로젝트
- OpenAI API 키 (중요)

### 설치 및 실행

1. **저장소 클론**
```bash
git clone https://github.com/your-username/medicine_project.git
cd medicine_project
```

2. **의존성 설치**
```bash
flutter pub get
```

3. **Firebase 설정**
```bash
# Firebase CLI 설치 후
flutter packages pub run build_runner build
```

4. **API 키 설정**
`lib/config/api_keys.dart` 파일에 OpenAI API 키 추가:
```dart
class ApiKeys {
  static const String openaiApiKey = 'your-openai-api-key';
  static const String openaiAPiUrl = 'https://api.openai.com/v1/chat/completions';
}
```

5. **앱 실행**
```bash
flutter run
```

## 📁 프로젝트 구조

```
lib/
├── config/
│   └── api_keys.dart              # API 키 설정
├── main.dart                      # 앱 진입점
├── login_screen.dart              # 로그인 화면
├── main_dashboard.dart            # 메인 대시보드
├── medicine_list_screen.dart      # 약물 목록 관리
├── medicine_register_screen.dart  # 약물 등록
├── medicine_schedule_screen.dart  # 복용 스케줄
├── medicine_statistics_screen.dart # 복용 통계
├── ai_recommendation_screen.dart   # AI 추천 화면
├── ai_recommendation_service.dart  # AI 서비스 로직
└── help_screen.dart              # 도움말
```

## 🔧 주요 기능 상세

### 1. 약물 관리 시스템
- 약물 정보 등록 (이름, 용량, 복용법)
- 약물 목록 조회 및 수정
- 약물별 복용 기록 관리

### 2. 스마트 알림 시스템
- 시간별 복용 알림
- 로컬 푸시 알림
- 복용 완료 체크

### 3. AI 기반 추천 엔진
- 사용자 복용 패턴 분석
- GPT-3.5 기반 개인 맞춤 가이드
- 복용 개선 방안 제시

### 4. 데이터 시각화
- 일별/주별/월별 복용 통계
- 차트 기반 복용 패턴 분석
- 복용률 트렌드 분석

## 🤝 기여하기

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 라이선스

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 문의

프로젝트에 대한 문의사항이나 버그 리포트는 [Issues](https://github.com/your-username/medicine_project/issues)를 통해 남겨주세요.

---

<div align="center">
  Made with ❤️ by Your Name
</div>
