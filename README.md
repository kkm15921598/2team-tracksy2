# TRACKSY

오늘의 러닝을, 나만의 이야기로.

러닝 기록을 한 곳에 모으고 예쁜 러닝카드로 꾸며 저장/공유할 수 있는 모바일 앱입니다.

원래 HTML/CSS/JS 프로토타입이었지만, **Flutter**로 전체를 새로 구현했습니다.

## 실행

Flutter 3.24+ 와 Dart 3.5+ 가 필요합니다.

```bash
flutter pub get
flutter run                     # 실제 디바이스 / 에뮬레이터
flutter run -d chrome           # 웹 브라우저로 빠르게 확인
flutter build web               # 정적 웹 빌드
```

## 화면 구성

### 메인 (바텀 네비)
- **홈** — 인사말, 가로 캐러셀(사진/CTA/통계), 주간 그리드, 월/90일 통계
- **스튜디오** — 러닝카드 캔버스, 편집/텍스트/스티커/디자인 4탭, 내보내기
- **기록(FAB)** — 직접 입력 진입
- **커뮤니티** — 검색, Hot/New, 컬렉션 그리드, masonry 피드
- **보관함** — 내 기록(달력/리스트) · 갤러리(연/월 필터) · 스타일(저장/내가 만든)

### 보조 화면
- 스플래시 / 로그인 / 회원가입
- 프로필 / 프로필 수정 / 설정
- 파트너 앱 목록·상세 (Nike, Garmin, Coros, Adidas, Health Connect, Google, Apple)
- 이용 문의 · 나의 문의내역(목록/상세) · 개선사항
- 보관함 직접 입력 / 타사앱 연동 / 캡쳐 스캔
- AI 오늘의 러닝일지 (인트로 → 챗 → 로딩 → 결과 → 저장/스킵)
- 스튜디오 내보내기 / 배경 변경

## 디렉토리 구조

```
lib/
├── main.dart                # MaterialApp + MultiProvider
├── theme/                   # 색상 팔레트 + ThemeData
├── state/                   # ChangeNotifier 스토어들
├── data/                    # 샘플 데이터(러닝/갤러리/스타일/커뮤니티/파트너)
├── models/                  # 도메인 모델
├── shell/                   # AppShell, 상태바, 바텀 네비
├── widgets/                 # 공용 컴포넌트(마스코트, 토스트, 러닝카드 등)
└── screens/                 # 화면별 위젯
assets/
└── mascot.svg               # 브랜드 마스코트
```

## 의존성

- `provider` — 상태 관리
- `google_fonts` — Noto Sans KR
- `flutter_svg` — 마스코트 SVG
- `intl` — 날짜 포맷
