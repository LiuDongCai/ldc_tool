class DCMenuModel {
  final String title;
  final String icon;
  final String page;
  final Map<String, dynamic>? params;

  DCMenuModel({
    required this.title,
    required this.icon,
    required this.page,
    this.params,
  });
}
