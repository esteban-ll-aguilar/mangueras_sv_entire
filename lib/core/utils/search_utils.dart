/// Escapes PostgreSQL/PostgREST LIKE wildcards so user input is literal.
String escapeLikePattern(String value) {
  return value
      .replaceAll(r'\', r'\\')
      .replaceAll('%', r'\%')
      .replaceAll('_', r'\_');
}
