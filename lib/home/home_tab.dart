import 'package:flutter/material.dart';
import 'notices.dart';

const brand = Color(0xFFA3162B);
const pale = Color(0xFFFBECEF);

/// 팀 통합 시 다른 담당자의 화면을 주입할 수 있습니다.
class HomeTab extends StatefulWidget {
  final Widget? attendanceTab, libraryTab, transportTab, mealTab;
  const HomeTab({super.key, this.attendanceTab, this.libraryTab, this.transportTab, this.mealTab});
  @override
  State<HomeTab> createState() => _HomeTabState();
}
class _HomeTabState extends State<HomeTab> {
  bool loggedIn = false;
  int tab = 0;
  String category = '학사';
  final favorites = <String>{'학생시간표조회', '금학기성적조회', '등록금 고지서', '외박신청'};
  Future<bool> login() async {
    if (loggedIn) return true;
    final result = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
      title: const Text('로그인이 필요한 서비스'),
      content: const Text('학교 계정 연결 전 시연 모드입니다.\n시연 로그인으로 개인화 화면을 확인하세요.'),
      actions: [TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('취소')), FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('시연 로그인'))],
    ));
    if (result == true && mounted) setState(() => loggedIn = true);
    return result == true;
  }
  void push(Widget page) => Navigator.push(context, MaterialPageRoute<void>(builder: (_) => page));
  Future<void> selectTab(int value) async {
    if (value == 1 && !await login()) return;
    if (mounted) setState(() => tab = value);
  }
  void menu() => push(MenuScreen(favorites: favorites, onOpen: openFeature));
  Future<void> openFeature(String name) async {
    if (['포탈', '이캠퍼스', '전자출결', '학생시간표조회', '금학기성적조회', '강의평가', '졸업자가진단', '등록금 고지서', '외박신청', '휴학신청', '복학신청', '장학금 신청'].contains(name) && !await login()) return;
    if (!mounted) return;
    if (name == '전체 메뉴') { menu(); return; }
    final index = {'전자출결': 1, '도서관': 2, '교통': 3, '학식': 4}[name];
    if (index != null) { setState(() => tab = index); return; }
    push(Scaffold(appBar: AppBar(title: Text(name)), body: Center(child: Padding(padding: const EdgeInsets.all(24), child: Text('$name\n\n메인 화면 연결 지점입니다.\n팀 통합 시 해당 담당 화면 또는 학교 서비스 URL을 연결합니다.', textAlign: TextAlign.center)))));
  }
  Widget card(Widget child, {Color color = Colors.white}) => Container(margin: const EdgeInsets.only(bottom: 14), padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(18)), child: child);
  Widget summary(IconData icon, String label, String value, String caption, int index) => Expanded(child: InkWell(borderRadius: BorderRadius.circular(18), onTap: () => selectTab(index), child: card(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(icon, color: brand), const SizedBox(width: 6), Flexible(child: Text(label))]), const SizedBox(height: 12), Text(value, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(caption, style: const TextStyle(color: Colors.blueGrey, fontSize: 12))]))));
  Widget home() => ListView(key: const PageStorageKey('home-scroll'), padding: const EdgeInsets.all(16), children: [
    card(Row(children: [CircleAvatar(backgroundColor: Colors.white24, child: Icon(loggedIn ? Icons.person : Icons.lock_outline, color: Colors.white)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(loggedIn ? '이영수 님' : '로그인하고 시작하세요', style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold)), const SizedBox(height: 5), Text(loggedIn ? '스마트모바일 · 시연 로그인' : '개인 서비스를 편리하게 이용하세요', style: const TextStyle(color: Colors.white, fontSize: 12))])), const SizedBox(width: 6), FilledButton(style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: brand), onPressed: () { if (!loggedIn) { login(); } else { showModalBottomSheet<void>(context: context, builder: (_) => SafeArea(child: Padding(padding: const EdgeInsets.all(28), child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('모바일 학생증 · 시연용', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(height: 20), const Icon(Icons.badge_outlined, size: 90, color: brand), const Text('이영수 · 2425051\n국립한국교통대학교', textAlign: TextAlign.center), const SizedBox(height: 16), const Text('실제 출입·인증에 사용할 수 없습니다.'), TextButton(onPressed: () { setState(() { loggedIn = false; tab = 0; }); Navigator.pop(context); }, child: const Text('로그아웃'))])))); } }, child: Text(loggedIn ? '학생증' : '로그인'))]), color: brand),
    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [summary(Icons.restaurant, '오늘 학식', '치즈돈까스 외 7개', '학생식당 · 2,000~5,000원', 4), const SizedBox(width: 12), summary(Icons.directions_bus, '다음 버스', '999  ·  15분 후', '14:47 교통대 → 터미널', 3)]),
    const Padding(padding: EdgeInsets.only(bottom: 12), child: Text('학식·교통·공지는 시연 데이터입니다.', style: TextStyle(fontSize: 11, color: Colors.blueGrey))),
    card(LayoutBuilder(builder: (context, constraints) {
      const labels = ['포탈', '이캠퍼스', '전자출결', '도서관', '학식', '교통', '길찾기', '전체 메뉴'];
      const icons = [Icons.computer, Icons.school_outlined, Icons.how_to_reg_outlined, Icons.menu_book, Icons.restaurant, Icons.directions_bus, Icons.location_on_outlined, Icons.apps];
      return Wrap(spacing: 8, runSpacing: 20, children: [for (int i = 0; i < labels.length; i++) SizedBox(width: (constraints.maxWidth - 24) / 4, child: InkWell(onTap: () => openFeature(labels[i]), child: Column(children: [Stack(clipBehavior: Clip.none, children: [Container(padding: const EdgeInsets.all(13), decoration: BoxDecoration(color: pale, borderRadius: BorderRadius.circular(16)), child: Icon(icons[i], color: brand, size: 28)), if (i < 3 && !loggedIn) const Positioned(right: -3, bottom: -3, child: CircleAvatar(radius: 11, backgroundColor: Color(0xFFF5F7FA), child: Icon(Icons.lock, size: 14, color: Colors.blueGrey)))]), const SizedBox(height: 8), Text(labels[i], textAlign: TextAlign.center, style: const TextStyle(fontSize: 12))])))]);
    })),
    Row(children: [const Expanded(child: Text('공지사항', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold))), TextButton(onPressed: () => push(NoticeListScreen(initialCategory: category)), child: const Text('더보기  ›'))]),
    categoryChips(category, (v) => setState(() => category = v)), const SizedBox(height: 12),
    card(Column(children: [for (final n in notices.where((n) => category == '전체' || n.category == category).take(3)) ListTile(contentPadding: EdgeInsets.zero, leading: const Icon(Icons.circle, color: brand, size: 8), title: Text(n.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14)), trailing: Text(n.date.substring(5), style: const TextStyle(color: Colors.blueGrey, fontSize: 12)), onTap: () => openNotice(context, n))])),
  ]);
  Widget pending(String name) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.extension_outlined, size: 48, color: brand), const SizedBox(height: 18), Text('$name 담당 화면 연결 영역', style: const TextStyle(fontSize: 20)), const SizedBox(height: 12), const Text('메인 담당 범위 외 화면입니다.\nHomeTab 생성자에 팀원의 Widget을 연결하세요.', textAlign: TextAlign.center), TextButton(onPressed: () => selectTab(0), child: const Text('홈으로'))])));
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Row(children: [Icon(Icons.school, color: brand), SizedBox(width: 8), Flexible(child: Text('국립한국교통대학교', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)))]), actions: [IconButton(tooltip: '메뉴 검색', onPressed: menu, icon: const Icon(Icons.search)), IconButton(tooltip: '공지사항', onPressed: () => push(const NoticeListScreen()), icon: const Icon(Icons.notifications_none))]),
    body: IndexedStack(index: tab, children: [home(), loggedIn ? (widget.attendanceTab ?? pending('출결')) : pending('로그인 후 출결'), widget.libraryTab ?? pending('도서관'), widget.transportTab ?? pending('교통'), widget.mealTab ?? pending('학식')]),
    bottomNavigationBar: NavigationBar(selectedIndex: tab, onDestinationSelected: selectTab, indicatorColor: pale, destinations: const [NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home, color: brand), label: '홈'), NavigationDestination(icon: Icon(Icons.how_to_reg_outlined), label: '출결'), NavigationDestination(icon: Icon(Icons.menu_book), label: '도서관'), NavigationDestination(icon: Icon(Icons.directions_bus_outlined), label: '교통'), NavigationDestination(icon: Icon(Icons.restaurant), label: '학식')]),
  );
}

class MenuScreen extends StatefulWidget {
  final Set<String> favorites;
  final Future<void> Function(String) onOpen;
  const MenuScreen({super.key, required this.favorites, required this.onOpen});
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}
class _MenuScreenState extends State<MenuScreen> {
  String query = '';
  String? expanded = '수업·성적';
  bool editing = false;
  static const groups = <String, List<String>>{'수업·성적': ['학생시간표조회', '금학기성적조회', '강의평가', '졸업자가진단'], '학적': ['휴학신청', '복학신청'], '장학·등록': ['장학금 신청', '등록금 고지서'], '생활관': ['외박신청', '생활관 안내'], '학생지원': ['도서관', '학식', '교통', '길찾기']};
  void open(String name) { Navigator.pop(context); widget.onOpen(name); }
  void toggle(String name) => setState(() { if (!widget.favorites.add(name)) widget.favorites.remove(name); });
  Widget row(String name) => ListTile(title: Text(name), trailing: editing ? IconButton(tooltip: '즐겨찾기 변경', icon: Icon(widget.favorites.contains(name) ? Icons.star : Icons.star_border, color: brand), onPressed: () => toggle(name)) : const Icon(Icons.chevron_right), onTap: () => editing ? toggle(name) : open(name));
  @override
  Widget build(BuildContext context) {
    final results = groups.values.expand((v) => v).where((n) => n.contains(query)).toList();
    return Scaffold(appBar: AppBar(title: const Text('전체 메뉴')), body: ListView(padding: const EdgeInsets.all(16), children: [
      TextField(decoration: const InputDecoration(hintText: '메뉴 검색 (예: 성적, 외박)', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()), onChanged: (v) => setState(() => query = v.trim())),
      const SizedBox(height: 20), Row(children: [const Expanded(child: Text('자주 쓰는 메뉴', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold))), TextButton(onPressed: () => setState(() => editing = !editing), child: Text(editing ? '완료' : '편집'))]),
      Wrap(spacing: 8, children: [for (final name in widget.favorites) ActionChip(avatar: Icon(editing ? Icons.remove_circle_outline : Icons.star_border, size: 18, color: brand), label: Text(name), onPressed: () => editing ? toggle(name) : open(name))]),
      if (editing) const Padding(padding: EdgeInsets.all(8), child: Text('아래 메뉴의 별을 눌러 즐겨찾기를 변경하세요.')),
      const SizedBox(height: 16),
      if (query.isNotEmpty) ...[Text('검색 결과 ${results.length}개'), if (results.isEmpty) const Padding(padding: EdgeInsets.all(24), child: Text('검색 결과가 없습니다.')), ...results.map(row)]
      else for (final entry in groups.entries) Card(margin: const EdgeInsets.only(bottom: 12), child: Column(children: [ListTile(leading: const Icon(Icons.folder_outlined, color: brand), title: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text('${entry.value.length}개 메뉴'), trailing: Icon(expanded == entry.key ? Icons.expand_less : Icons.expand_more), onTap: () => setState(() => expanded = expanded == entry.key ? null : entry.key)), if (expanded == entry.key) ...entry.value.map(row)])),
    ]));
  }
}
