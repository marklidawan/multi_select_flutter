import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:line_icons/line_icons.dart';
import '../util/multi_select_actions.dart';
import '../util/multi_select_item.dart';
import '../util/multi_select_list_type.dart';

/// A dialog containing either a classic checkbox style list, or a chip style list.
class MultiSelectDialog<T> extends StatefulWidget with MultiSelectActions<T> {
  /// List of items to select from.
  final List<MultiSelectItem<T>> items;

  /// The list of selected values before interaction.
  final List<T> initialValue;

  /// The text at the top of the dialog.
  final Widget? title;

  /// Fires when the an item is selected / unselected.
  final void Function(List<T>)? onSelectionChanged;

  /// Fires when confirm is tapped.
  final void Function(List<T>)? onConfirm;

  /// Toggles search functionality. Default is false.
  final bool searchable;

  /// Text on the confirm button.
  final Text? confirmText;

  /// Text on the cancel button.
  final Text? cancelText;

  /// An enum that determines which type of list to render.
  final MultiSelectListType? listType;

  /// Sets the color of the checkbox or chip when it's selected.
  final Color? selectedColor;

  /// Sets a fixed height on the dialog.
  final double? height;

  /// Sets a fixed width on the dialog.
  final double? width;

  /// Set the placeholder text of the search field.
  final String? searchHint;

  /// A function that sets the color of selected items based on their value.
  /// It will either set the chip color, or the checkbox color depending on the list type.
  final Color? Function(T)? colorator;

  /// The background color of the dialog.
  final Color? backgroundColor;

  /// The color of the chip body or checkbox border while not selected.
  final Color? unselectedColor;

  /// Icon button that shows the search field.
  final Icon? searchIcon;

  /// Icon button that hides the search field
  final Icon? closeSearchIcon;

  /// Style the text on the chips or list tiles.
  final TextStyle? itemsTextStyle;

  /// Style the text on the selected chips or list tiles.
  final TextStyle? selectedItemsTextStyle;

  /// Style the search text.
  final TextStyle? searchTextStyle;

  /// Style the search hint.
  final TextStyle? searchHintStyle;

  /// Moves the selected items to the top of the list.
  final bool separateSelectedItems;

  /// Set the color of the check in the checkbox
  final Color? checkColor;

  final Function()? checkConflict;

  // final Icon? trailingIcon;


  MultiSelectDialog({
    required this.items,
    required this.initialValue,
    this.title,
    this.onSelectionChanged,
    this.onConfirm,
    this.listType,
    this.searchable = false,
    this.confirmText,
    this.cancelText,
    this.selectedColor,
    this.searchHint,
    this.height,
    this.width,
    this.colorator,
    this.backgroundColor,
    this.unselectedColor,
    this.searchIcon,
    this.closeSearchIcon,
    this.itemsTextStyle,
    this.searchHintStyle,
    this.searchTextStyle,
    this.selectedItemsTextStyle,
    this.separateSelectedItems = false,
    this.checkColor,
    this.checkConflict,
    // this.trailingIcon,
  });

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<T>(items);
}

class _MultiSelectDialogState<T> extends State<MultiSelectDialog<T>> {
  List<T> _selectedValues = [];
  bool _showSearch = false;
  List<MultiSelectItem<T>> _items;

  _MultiSelectDialogState(this._items);

  @override
  void initState() {
    super.initState();
    _selectedValues.addAll(widget.initialValue);

    for (int i = 0; i < _items.length; i++) {
      _items[i].selected = false;
      if (_selectedValues.contains(_items[i].value)) {
        _items[i].selected = true;
      }
    }

    if (widget.separateSelectedItems) {
      _items = widget.separateSelected(_items);
    }
  }

  /// Returns a CheckboxListTile
  Widget _buildListItem(MultiSelectItem<T> item) {
    return Theme(
      data: ThemeData(
        unselectedWidgetColor: widget.unselectedColor ?? Colors.black54,
      ),
      child: CheckboxListTile(
        secondary: Text(
          '${item.noOfRegistered} / ${item.limit}'
        ),
        checkColor: widget.checkColor,
        value: item.selected,
        activeColor: widget.colorator != null
            ? widget.colorator!(item.value) ?? widget.selectedColor
            : widget.selectedColor,
        title: GestureDetector(
          // child: Text(
          //   item.label,
          //   style: item.selected
          //       ? widget.selectedItemsTextStyle
          //       : widget.itemsTextStyle,
          // ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      item.lock == 1 
                      ? Row(
                        children: [
                          Icon(
                            Icons.lock_person_rounded,
                            size: 14.0,
                            color: Colors.black54,
                          ),
                          Text(
                            ' Locked',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.red,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      )
                      : Container(),
                      Text(
                        item.title,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w800,
                          color: Colors.black
                        ),
                        softWrap: false,  
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10 / 6,),
                      Text(
                        item.faculty,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14.0,
                          // fontWeight: FontWeight.w500,
                          color: Colors.black
                        ),
                        softWrap: false,  
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10 / 6,),
                      Text(
                        item.label,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: Colors.black
                        ),
                        softWrap: false,  
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 10 / 6,),
                      Text(
                        '${item.acadUnits} academic units',
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 12.0,
                          fontWeight: FontWeight.w300,
                          color: Colors.black
                        ),
                        softWrap: false,  
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        onChanged: item.lock == 1 
        ? null 
        : (checked) {
          setState(() {
            _selectedValues = widget.onItemCheckedChange(
                _selectedValues, item.value, checked!);

            if (checked) {
              item.selected = true;
            } else {
              item.selected = false;
            }
            if (widget.separateSelectedItems) {
              _items = widget.separateSelected(_items);
            }
          });
          if (widget.onSelectionChanged != null) {
            widget.onSelectionChanged!(_selectedValues);
          }
        },
      ),
    );
  }

  /// Returns a ChoiceChip
  Widget _buildChipItem(MultiSelectItem<T> item) {
    return Container(
      padding: const EdgeInsets.all(2.0),
      child: ChoiceChip(
        backgroundColor: widget.unselectedColor,
        selectedColor: widget.colorator?.call(item.value) ??
            widget.selectedColor ??
            Theme.of(context).primaryColor.withOpacity(0.35),
        label: Text(
          item.title,
          style: item.selected
              ? TextStyle(
                  color: widget.selectedItemsTextStyle?.color ??
                      widget.colorator?.call(item.value) ??
                      widget.selectedColor?.withOpacity(1) ??
                      Theme.of(context).primaryColor,
                  fontSize: widget.selectedItemsTextStyle?.fontSize,
                )
              : widget.itemsTextStyle,
        ),
        selected: item.selected,
        onSelected: (checked) {
          if (checked) {
            item.selected = true;
          } else {
            item.selected = false;
          }
          setState(() {
            _selectedValues = widget.onItemCheckedChange(
                _selectedValues, item.value, checked);
          });
          if (widget.onSelectionChanged != null) {
            widget.onSelectionChanged!(_selectedValues);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: widget.backgroundColor,
      title: widget.searchable == false
          ? widget.title ?? const Text("Select")
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _showSearch
                    ? Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          child: TextField(
                            style: widget.searchTextStyle,
                            decoration: InputDecoration(
                              hintStyle: widget.searchHintStyle,
                              hintText: widget.searchHint ?? "Search",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: widget.selectedColor ??
                                      Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                            onChanged: (val) {
                              List<MultiSelectItem<T>> filteredList = [];
                              filteredList =
                                  widget.updateSearchQuery(val, widget.items);
                              setState(() {
                                if (widget.separateSelectedItems) {
                                  _items =
                                      widget.separateSelected(filteredList);
                                } else {
                                  _items = filteredList;
                                }
                              });
                            },
                          ),
                        ),
                      )
                    : widget.title ?? Text("Select"),
                IconButton(
                  icon: _showSearch
                      ? widget.closeSearchIcon ?? Icon(Icons.close)
                      : widget.searchIcon ?? Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _showSearch = !_showSearch;
                      if (!_showSearch) {
                        if (widget.separateSelectedItems) {
                          _items = widget.separateSelected(widget.items);
                        } else {
                          _items = widget.items;
                        }
                      }
                    });
                  },
                ),
              ],
            ),
      contentPadding:
          widget.listType == null || widget.listType == MultiSelectListType.LIST
              ? EdgeInsets.only(top: 12.0)
              : EdgeInsets.all(20),
      content: widget.items.isEmpty 
      ? Container(
        height: widget.height,
        width: widget.width ?? MediaQuery.of(context).size.width * 0.73,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nothing to show',
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: HexColor('#313131'),
                fontSize: 16
              ),
              softWrap: false,  
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
            Text(
              'Please select section',
              style: TextStyle(
                overflow: TextOverflow.ellipsis,
                color: HexColor('#95a1ac'),
                fontSize: 14
              ),
              softWrap: false,  
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
            ),
          ]
        ),
      )
      : Container(
        height: widget.height,
        width: widget.width ?? MediaQuery.of(context).size.width * 0.73,
        child: widget.listType == null ||
                widget.listType == MultiSelectListType.LIST
            ? ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return _buildListItem(_items[index]);
                },
              )
            : SingleChildScrollView(
                child: Wrap(
                  children: _items.map(_buildChipItem).toList(),
                ),
              ),
      ),
      actions: <Widget>[
        TextButton(
          child: widget.cancelText ??
              Text(
                "CANCEL",
                style: TextStyle(
                  color: (widget.selectedColor != null &&
                          widget.selectedColor != Colors.transparent)
                      ? widget.selectedColor!.withOpacity(1)
                      : Theme.of(context).primaryColor,
                ),
              ),
          onPressed: () {
            widget.onCancelTap(context, widget.initialValue);
          },
        ),
        TextButton(
          child: widget.confirmText ??
              Text(
                'OK',
                style: TextStyle(
                  color: (widget.selectedColor != null &&
                          widget.selectedColor != Colors.transparent)
                      ? widget.selectedColor!.withOpacity(1)
                      : Theme.of(context).primaryColor,
                ),
              ),
          onPressed: () {
            widget.onConfirmTap(context, _selectedValues, widget.onConfirm);
          },
        )
      ],
    );
  }
}
