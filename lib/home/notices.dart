import 'package:flutter/material.dart';

const noticeCategories = ['전체', '학사', '일반', '장학', '행사', '취업'];
class Notice {
  final String category, title, date, department, body;
  const Notice(this.category, this.title, this.date, this.department, this.body);
}
const notices = <Notice>[
  Notice('학사', '2026학년도 2학기 중간고사 성적 입력 기간 안내', '2026-10-06', '학사관리과', '2026학년도 2학기 중간고사 성적 입력 및 확인 일정을 안내합니다.\n\n학생 여러분께서는 통합정보시스템에서 수강 교과목의 성적을 확인하시기 바랍니다. 성적에 대한 문의는 해당 교과목 담당 교수님께 문의해 주세요.\n\n※ 이 공지는 화면 구현을 위한 시연용 데이터입니다.'),
  Notice('학사', '2학기 수강 정정 신청 안내', '2026-10-02', '학사관리과', '수강 정정 신청은 통합정보시스템에서 진행합니다. 신청 후 처리 결과를 반드시 확인해 주세요.\n\n※ 시연용 공지입니다.'),
  Notice('학사', '2027학년도 전과(부) 신청 안내', '2026-09-29', '학사관리과', '전과 신청 전 소속 학과와 희망 학과의 모집 요건을 확인해 주세요.\n\n※ 시연용 공지입니다.'),
  Notice('일반', '스마트모바일 서비스 이용 안내', '2026-10-07', '정보전산원', '홈에서 학식, 교통, 도서관 정보를 편리하게 확인할 수 있습니다.\n\n※ 시연용 공지입니다.'),
  Notice('장학', '2026학년도 2학기 교내 장학금 신청 안내', '2026-10-05', '학생과', '장학금 신청 자격과 제출 서류를 확인하고 신청해 주세요.\n\n※ 시연용 공지입니다.'),
  Notice('행사', '가을 캠퍼스 문화 행사 안내', '2026-10-04', '학생과', '교내 문화 행사에 학생 여러분의 많은 참여 바랍니다.\n\n※ 시연용 공지입니다.'),
  Notice('취업', '취업 상담 및 자기소개서 특강', '2026-10-03', '취업지원실', '진로 상담과 자기소개서 특강 참여자를 모집합니다.\n\n※ 시연용 공지입니다.'),
];

Widget categoryChips(String selected, ValueChanged<String> onChanged) => SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(children: [for (final c in noticeCategories) Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(label: Text(c), selected: c == selected, onSelected: (_) => onChanged(c)),
  )]),
);

void openNotice(BuildContext context, Notice notice) => Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => NoticeDetailScreen(notice: notice)));

class NoticeListScreen extends StatefulWidget {
  final String initialCategory;
  const NoticeListScreen({super.key, this.initialCategory = '전체'});
  @override
  State<NoticeListScreen> createState() => _NoticeListScreenState();
}
class _NoticeListScreenState extends State<NoticeListScreen> {
  late String category;
  String query = '';
  bool newest = true;
  @override
  void initState() { super.initState(); category = widget.initialCategory; }
  @override
  Widget build(BuildContext context) {
    final rows = notices.where((n) => (category == '전체' || n.category == category) && n.title.contains(query)).toList()
      ..sort((a,b) => newest ? b.date.compareTo(a.date) : a.date.compareTo(b.date));
    return Scaffold(appBar: AppBar(title: const Text('공지사항')), body: ListView(padding: const EdgeInsets.all(16), children: [
      TextField(decoration: const InputDecoration(hintText: '공지 제목 검색', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()), onChanged: (v) => setState(() => query = v.trim())),
      const SizedBox(height: 16), categoryChips(category, (v) => setState(() => category = v)),
      Row(children: [Expanded(child: Text('총 ${rows.length}건')), TextButton.icon(onPressed: () => setState(() => newest = !newest), icon: const Icon(Icons.sort), label: Text(newest ? '최신순' : '오래된순'))]),
      if (rows.isEmpty) const Padding(padding: EdgeInsets.all(40), child: Center(child: Text('검색 결과가 없습니다.'))),
      for (final n in rows) Card(child: ListTile(contentPadding: const EdgeInsets.all(16), title: Text(n.title), subtitle: Text('${n.category} · ${n.date}'), trailing: const Icon(Icons.chevron_right), onTap: () => openNotice(context, n))),
    ]));
  }
}
class NoticeDetailScreen extends StatelessWidget {
  final Notice notice;
  const NoticeDetailScreen({super.key, required this.notice});
  @override
  Widget build(BuildContext context) {
    final index = notices.indexOf(notice);
    return Scaffold(appBar: AppBar(title: const Text('공지사항 상세')), body: ListView(padding: const EdgeInsets.all(20), children: [
      Align(alignment: Alignment.centerLeft, child: Chip(label: Text(notice.category))),
      Text(notice.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12), Text('${notice.department} · ${notice.date} · 조회 128 (시연)'),
      const Divider(height: 32), Text(notice.body, style: const TextStyle(fontSize: 16, height: 1.8)),
      const SizedBox(height: 24), Container(padding: const EdgeInsets.all(18), decoration: BoxDecoration(color: const Color(0xFFFBECEF), borderRadius: BorderRadius.circular(16)), child: const Text('주요 안내 · 시연 데이터\n\n입력 기간  2026.10.12 ~ 10.23\n확인 방법  통합정보시스템 → 성적조회\n문의처  공지 작성 부서', style: TextStyle(height: 1.7))),
      const SizedBox(height: 20), const Text('첨부파일', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      Card(child: ListTile(leading: const Icon(Icons.attach_file), title: const Text('안내문.pdf'), subtitle: const Text('시연용 · 실제 파일 미연결'), trailing: const Icon(Icons.download_outlined), onTap: () => showDialog<void>(context: context, builder: (_) => AlertDialog(title: const Text('첨부파일 안내'), content: const Text('실제 공지 API의 첨부파일 URL을 연결하면 다운로드할 수 있습니다.'), actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('확인'))])))),
      const Divider(height: 32),
      if (index > 0) ListTile(title: Text('이전 글 · ${notices[index - 1].title}'), onTap: () => Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (_) => NoticeDetailScreen(notice: notices[index - 1])))),
      if (index < notices.length - 1) ListTile(title: Text('다음 글 · ${notices[index + 1].title}'), onTap: () => Navigator.pushReplacement(context, MaterialPageRoute<void>(builder: (_) => NoticeDetailScreen(notice: notices[index + 1])))),
    ]));
  }
}
