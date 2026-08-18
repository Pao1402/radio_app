class StationModel {
  const StationModel({
    required this.id,
    required this.name,
    required this.acronym,
    required this.streamUrl,
    required this.imageUrl,
    required this.slogan,
    this.websiteUrl,
    this.facebookUrl,
    this.instagramUrl,
    this.youtubeUrl,
  });

  final String id;
  final String name;
  final String acronym;
  final String streamUrl;
  final String imageUrl;
  final String slogan;

  final String? websiteUrl;
  final String? facebookUrl;
  final String? instagramUrl;
  final String? youtubeUrl;
}