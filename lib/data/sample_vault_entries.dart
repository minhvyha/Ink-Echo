class SampleVaultEntry {
  final String title;
  final String author;
  final String echo;
  final String? mood;
  final String? transcription;
  final String imageSearchTerm;

  const SampleVaultEntry({
    required this.title,
    required this.author,
    required this.echo,
    this.mood,
    this.transcription,
    required this.imageSearchTerm,
  });
}

const sampleVaultEntries = [
  SampleVaultEntry(
    title: 'Piranesi',
    author: 'Susanna Clarke',
    mood: 'Deeply Moving',
    echo:
        'The Beauty of the House is immeasurable; its Kindness infinite. '
        'I keep returning to the marble halls and the tides in the lower halls.',
    imageSearchTerm: 'Piranesi Susanna Clarke book cover',
  ),
  SampleVaultEntry(
    title: 'Dune',
    author: 'Frank Herbert',
    mood: 'Challenging',
    echo:
        'Fear is the mind-killer. I will face my fear on the desert of Arrakis. '
        'The spice and the stillness stayed with me long after the last page.',
    imageSearchTerm: 'Dune Frank Herbert book cover',
  ),
  SampleVaultEntry(
    title: 'The Ocean at the End of the Lane',
    author: 'Neil Gaiman',
    mood: 'Nostalgic',
    echo:
        'Childhood is a grass-green ZEPHYR over the lane. The ocean at the end '
        'felt both impossible and completely true.',
    imageSearchTerm: 'Ocean at the End of the Lane book cover',
  ),
  SampleVaultEntry(
    title: 'Klara and the Sun',
    author: 'Kazuo Ishiguro',
    mood: 'Inspiring',
    echo:
        'Klara watches the light move across the storefront. Hope is not naive; '
        'it is a discipline practiced in small, daily observations.',
    transcription:
        'The sun looked kinder in the afternoon, as if it were leaning closer to listen.',
    imageSearchTerm: 'Klara and the Sun book cover',
  ),
  SampleVaultEntry(
    title: 'Project Hail Mary',
    author: 'Andy Weir',
    mood: 'Challenging',
    echo:
        'Science friendship and an impossible problem. The word EMBER kept '
        'appearing in my notes — a covenant made in orbit, not on Earth.',
    transcription:
        'Tap to dictate: Rocky is the best co-pilot the human race never planned for.',
    imageSearchTerm: 'Project Hail Mary Andy Weir book cover',
  ),
];
