import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:main_app/main.dart';
import 'package:main_app/home/notices.dart';

void main() {
  testWidgets('게스트가 로그인 후 학생증을 열고 로그아웃한다', (tester) async {
    await tester.pumpWidget(const MainApp());
    await tester.tap(find.text('로그인'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('시연 로그인'));
    await tester.pumpAndSettle();
    expect(find.text('이영수 님'), findsOneWidget);
    await tester.tap(find.text('학생증'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('로그아웃'));
    await tester.pumpAndSettle();
    expect(find.text('로그인하고 시작하세요'), findsOneWidget);
  });
  testWidgets('공지 분류가 전달되고 검색 결과가 없으면 안내한다', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: NoticeListScreen(initialCategory: '장학')));
    expect(find.text('총 1건'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '없는공지검색');
    await tester.pump();
    expect(find.text('검색 결과가 없습니다.'), findsOneWidget);
  });
}
