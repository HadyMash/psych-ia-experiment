class Note {
  final String id;
  final String? author;
  final List<String>? notes;
  final String? kickReason;
  final bool? kick;

  const Note(
      {required this.id, this.author, this.notes, this.kickReason, this.kick});
}
