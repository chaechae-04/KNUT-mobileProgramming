# 스마트모바일 메인 담당 — 이영수

PDF의 게스트 홈, 로그인 사용자 홈, 전체 메뉴, 공지 목록, 공지 상세를 Flutter Material 3로 구현했습니다. 기존 mp 프로젝트와 동일한 lib / android / ios / pubspec.yaml 구조입니다.

## 실행
Flutter SDK가 설치된 컴퓨터에서 이 폴더를 열고 실행합니다.

```sh
flutter create --platforms=android,ios .
flutter pub get
flutter run
```

첫 명령은 원본 프로젝트에도 빠져 있는 Gradle 실행 파일 등 플랫폼 생성 파일을 보완합니다.

## 구현 범위
- 대표색 #A3162B, 카드형 홈, 8개 바로가기, 하단 5탭
- 게스트 → 시연 로그인 → 학생증 / 로그아웃
- 잠금 기능 접근 시 로그인 유도
- 전체 메뉴 검색, 한 분류씩 펼치기, 즐겨찾기 편집
- 공지 카테고리 전달, 검색, 날짜 정렬, 빈 결과, 상세, 이전/다음 글
- IndexedStack으로 탭 상태 유지

## 팀 프로젝트에 합치기
`lib/home` 폴더를 팀 프로젝트의 `lib` 안에 복사하세요.

```dart
import 'home/home_tab.dart';
import 'library/library_tab.dart';

// MaterialApp의 home:
HomeTab(libraryTab: const LibraryTab())
```

`attendanceTab`, `transportTab`, `mealTab`에도 각 팀원의 Widget을 전달할 수 있습니다. 미연결 탭은 연결 안내를 표시합니다.

## 데이터와 검증
학교 인증/API는 제공받지 않았으므로 로그인, 학생증, 공지, 학식, 버스는 시연 데이터입니다. 포탈 등의 외부 서비스와 첨부 다운로드는 연결 안내까지만 구현했습니다. 즐겨찾기와 로그인은 앱 실행 중에 유지되며 재시작하면 초기화됩니다.

작성 환경에 Flutter/Dart SDK가 없어 `flutter analyze`, `flutter test`, 에뮬레이터 실행을 수행하지 못했습니다. 아래 테스트는 Flutter 환경에서 실행하세요.

```sh
flutter analyze
flutter test
```
