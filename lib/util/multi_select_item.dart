/// A model class used to represent a selectable item.
class MultiSelectItem<T> {
  final T value;
  final String title;
  final String label;
  final String acadUnits;
  bool selected = false;

  MultiSelectItem(this.value, this.title, this.label, this.acadUnits);
}
