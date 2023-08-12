String snakeCaseToNormalText(String snakeCase) {
  List<String> parts = snakeCase.split('_');
  String normalText = parts.map((part) => part[0].toUpperCase() + part.substring(1)).join(' ');
  return normalText;
}