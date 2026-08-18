class ProgramModel {
  const ProgramModel({
    required this.id,
    required this.stationId,
    required this.title,
    required this.description,
    required this.schedule,
    required this.imageUrl,
    this.host,
  });

  final String id;
  final String stationId;
  final String title;
  final String description;
  final String schedule;
  final String imageUrl;
  final String? host;
}