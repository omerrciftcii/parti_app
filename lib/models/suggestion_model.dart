class SuggestionModel {
  final String placeId;
  final String description;

  SuggestionModel(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}