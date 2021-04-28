enum PositionItemType {
  permission,
  position,
}

class PositionItem {
  PositionItem(this.type, this.displayValue);

  final PositionItemType type;
  final String displayValue;
}
