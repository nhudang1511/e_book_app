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