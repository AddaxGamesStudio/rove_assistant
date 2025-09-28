class Codex {
  final int number;
  final int? page;
  final String title;
  final String body;
  final String? subtitle;
  final String? artwork;
  Codex(
      {required this.number,
      this.page,
      required this.title,
      required this.body,
      this.subtitle,
      this.artwork});

  factory Codex.fromString(String data, int number) {
    Iterable<String> lines = data.split('\n');
    String? subtitle;
    int? page;
    String? artwork;
    while (lines.isNotEmpty && lines.first.startsWith('[')) {
      final line = lines.first;
      final metadata = line.substring(1, line.length - 1);
      if (metadata.toLowerCase().startsWith('subtitle')) {
        subtitle = metadata.split('=')[1];
      } else if (metadata.toLowerCase().startsWith('page')) {
        final pageString = metadata.split('=')[1];
        page = int.tryParse(pageString);
      } else if (metadata.toLowerCase().startsWith('artwork')) {
        artwork = metadata.split('=')[1];
      }
      lines = lines.skip(1);
    }
    final String title = lines.first;
    final String body =
        lines.skip(1).join('\n\n').replaceAll('\n\n\n\n', '\n\n\n');
    return Codex(
        number: number,
        page: page,
        title: title,
        body: body,
        subtitle: subtitle,
        artwork: artwork);
  }
}
