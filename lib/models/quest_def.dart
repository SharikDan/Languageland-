class QuestDef {
  final String id, title, titleEn, description, descriptionEn;
  final int targetCount, reward;
  int currentCount;
  QuestDef({required this.id, required this.title, required this.titleEn, required this.description, required this.descriptionEn, required this.targetCount, required this.reward, this.currentCount = 0});
}