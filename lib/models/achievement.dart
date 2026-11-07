class Achievement {
  final String id, title, titleEn, description, descriptionEn, iconName;
  bool isUnlocked;
  Achievement({required this.id, required this.title, required this.titleEn, required this.description, required this.descriptionEn, required this.iconName, this.isUnlocked = false});
}