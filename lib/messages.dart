import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          // main
          'schedule': 'Schedule',
          'practiceNote': 'Practice Note',
          // card
          'card': 'Practice Card',
          'msgNoCard': 'No practice card yet. Add your card!',
          'msgAddTrack': 'Add Track',
          'trackName': 'Track Name',
          'themeColor': 'Theme Color',
          'msgSelectColor': 'Select Theme Color!',
          'maxStamp': 'Max Stamp',
          'themeStamp': 'Theme Stamp',
          'memo': 'Memo',
          'msgWriteNote': 'Write note for today practice!',
          'msgWriteMemo': 'Write memo for this stamp!',
          // analysis
          'dataAnalysis': 'Data Analysis',
          'msgNoData': 'No practice yet',
          'totalCnt': 'Total Count',
          'songLength': 'Song Length',
          'practiceTime': 'Total Practice Time',
          'unmeasurable': 'Unmeasurable',
          'totalCntN': '@N times',
          // setting
          'setting': 'Setting',
          'language': 'Language',

          //general
          'cancel': 'Cancel',
          'save': 'Save',
          'ok': 'OK',
          'delete': 'Delete',
          'Nsec': '@N sec',
          'Nmin': '@N min',
          'NhoursMmin': '@N hours @M min',
          'NhoursMminSsec': '@N:@M:@S',
        },
        'ko_KR': {
          // main
          'schedule': '스케줄',
          'practiceNote': '연습일지',
          // card
          'card': '연습카드',
          'msgNoCard': '아직 연습 카드가 없어요. 연습카드를 추가해보세요.',
          'msgAddTrack': '트랙 추가하기',
          'trackName': '트랙 이름',
          'themeColor': '테마 컬러',
          'msgSelectColor': '컬러를 선택해주세요!',
          'maxStamp': '도장 개수',
          'themeStamp': '테마 도장',
          'memo': '연습 노트',
          'msgWriteNote': '연습일지를 적어보세요!',
          'msgWriteMemo': '이 도장에 메모를 적어보세요!',
          // analysis
          'dataAnalysis': '데이터 분석',
          'msgNoData': '아직 연습 내역이 없어요.',
          'totalCnt': '총 연습 횟수',
          'songLength': '한 곡 길이',
          'practiceTime': '총 연습 시간',
          'unmeasurable': '측정불가',
          'totalCntN': '총 @N 회',
          // setting
          'setting': '설정',
          'language': '언어',
          //general
          'cancel': '취소',
          'save': '저장',
          'ok': '확인',
          'delete': '삭제하기',
          'Nsec': '@N 초',
          'Nmin': '@N 분',
          'NhoursMmin': '@N 시간 @M 분',
          'NhoursMminSsec': '@N시 @M분 @S초',
        }
      };
}
