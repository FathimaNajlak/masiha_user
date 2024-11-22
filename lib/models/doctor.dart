class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String hospital;
  final String imageUrl;
  bool isFavorite;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.hospital,
    required this.imageUrl,
    this.isFavorite = false,
  });
}
