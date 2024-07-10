int? numberInString(String? words) {
  if (words == null) return null;
  RegExp regex = RegExp(r'\d+');
  var matches = regex.allMatches(words);
  if (matches.isEmpty) return null;
  return int.parse(matches.first.group(0)!);
}

Map<String, dynamic> mergePercentages(Map<String, dynamic> percentListMap,
    Map<String, dynamic> chapterScrollPercentages) {
  Map<String, dynamic> mergedPercentages = chapterScrollPercentages;

  // Add values from percentListMap to mergedPercentages
  for (var entry in percentListMap.entries) {
    String id = entry.key;
    num percentage = entry.value ?? 0; // Assign 0 if the percentage is null

    // Check if the ID exists in chapterScrollPercentages
    if (chapterScrollPercentages.containsKey(id)) {
      // If the ID exists in both, prioritize value from chapterScrollPercentages
      mergedPercentages[id] = chapterScrollPercentages[id];
    } else {
      // If the ID doesn't exist in chapterScrollPercentages, add it to mergedPercentages
      mergedPercentages[id] = percentage;
    }
  }
  return mergedPercentages;
}

num percentAllChapters(
    Map<String, dynamic> chapterScrollPercentages, var totalChapters) {
  double totalPercentage = chapterScrollPercentages.values
      .fold(0, (sum, percentage) => sum + percentage);

  num overallPercentage =
      (totalChapters != 0) ? (totalPercentage / totalChapters) * 100 : 0;
  return overallPercentage;
}

String formatTime(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  final hour = twoDigits(duration.inHours);
  final minutes = twoDigits(duration.inMinutes.remainder(60));
  final seconds = twoDigits(duration.inSeconds.remainder(60));
  return [if (duration.inHours > 0) hour, minutes, seconds].join(':');
}

void sortChapterListMap(List<Map<String, dynamic>>? chapterListMap) {
  return chapterListMap?.sort((a, b) {
    // Trích xuất số từ chuỗi chương (ví dụ: 'Chương 1' -> 1)
    int aNumber = int.parse(a['id'].replaceAll(RegExp(r'[^0-9]'), ''));
    int bNumber = int.parse(b['id'].replaceAll(RegExp(r'[^0-9]'), ''));
    return aNumber.compareTo(bNumber);
  });
}

bool compareChapterId(String oldChapter, String newChapter) {
  int aNumber = int.parse(oldChapter.replaceAll(RegExp(r'[^0-9]'), ''));
  int bNumber = int.parse(newChapter.replaceAll(RegExp(r'[^0-9]'), ''));
  return aNumber > bNumber;
}
