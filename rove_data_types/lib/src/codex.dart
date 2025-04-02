class Codex {
  final int number;
  final int? page;
  final String title;
  final String body;
  final bool isConclusion;

  Codex(
      {required this.number,
      this.page,
      required this.title,
      required this.body,
      required this.isConclusion});

  factory Codex.fromString(String data, int number) {
    Iterable<String> lines = data.split('\n');
    bool isConclusion = false;
    int? page;
    while (lines.isNotEmpty && lines.first.startsWith('[')) {
      final line = lines.first.toLowerCase();
      final metadata = line.substring(1, line.length - 1);
      if (metadata.startsWith('conclusion')) {
        isConclusion = true;
      } else if (metadata.startsWith('page')) {
        final pageString = metadata.split('=')[1];
        page = int.tryParse(pageString);
      }
      lines = lines.skip(1);
    }
    final String title = lines.first;
    final String body = lines.skip(1).join('\n\n');
    return Codex(
        number: number,
        page: page,
        title: title,
        body: body,
        isConclusion: isConclusion);
  }
}
