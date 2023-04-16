import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_multi_select/multi_select_form_field/widgets/multi_select_body.dart';
import 'package:flutter_multi_select/multi_select_form_field/widgets/multi_select_dropdown_field.dart';
import 'package:flutter_multi_select/multi_select_form_field/widgets/multi_select_header.dart';

/// [MultiSelectFormField] is a select form field that should:
/// 1. Allow for multiple selection of the passed options
/// 2. Have a button to reset the entire selection at the top
/// 3. Provide a dropdown for the selected options with a checkbox
///
/// If you would like to have the selected options, then you can call the
/// [onChanged] function which will return all the options that have already
/// been selected.
///
class MultiSelectFormField extends StatefulWidget {
  const MultiSelectFormField({
    super.key,
    required this.options,
    required this.label,
    this.initiallySelectedOptions,
    this.onChange,
    this.padding,
    this.onReset,
    this.validator,
    this.isEnabled = true,
  });

  final List<String> options;
  final List<String>? initiallySelectedOptions;
  final Function(List<String> selectedOptions)? onChange;
  final VoidCallback? onReset;
  final EdgeInsets? padding;
  final String label;
  final String? Function(List<String>?)? validator;
  final bool isEnabled;

  @override
  State<MultiSelectFormField> createState() => _MultiSelectFormFieldState();
}

class _MultiSelectFormFieldState extends State<MultiSelectFormField> {
  List<String> options = <String>[];
  late GlobalKey _key;
  late Map<String, bool> selectedOptions = <String, bool>{};
  late bool showDropDown = false;
  late OverlayEntry _overlayEntry;
  late Size buttonSize;
  late Offset buttonPosition;

  @override
  void initState() {
    options = widget.options.toSet().toList();
    resetSelections();
    setInitiallySelectedOptions();
    _key = LabeledGlobalKey('${widget.label}-${Random.secure().nextInt(2000)}');
    super.initState();
  }

  @override
  void didUpdateWidget(MultiSelectFormField oldWidget) {
    if (widget.options.isEmpty) {
      setState(() {
        for (String option in oldWidget.options) {
          selectedOptions.update(option, (value) => false);
        }
      });
    }
    if (widget.options != oldWidget.options) {
      setState(() {
        options = widget.options.toSet().toList();
        resetSelections();
        setInitiallySelectedOptions();
        generateSelectedOptions();
        _key = LabeledGlobalKey(
            '${widget.label}-${Random.secure().nextInt(2000)}');
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  findButton() {
    RenderBox renderBox = _key.currentContext!.findRenderObject()! as RenderBox;
    buttonSize = renderBox.size;
    buttonPosition = renderBox.localToGlobal(Offset.zero);
  }

  List<String> generateSelectedOptions() {
    List<String> selected = selectedOptions.entries
        .where((MapEntry<String, bool> entry) => entry.value == true)
        .map((MapEntry<String, bool> checkedEntry) => checkedEntry.key)
        .toList();
    widget.onChange?.call(selected);
    return selected;
  }

  void resetSelections() {
    for (String option in options.toSet()) {
      if (selectedOptions.containsKey(option)) {
        selectedOptions.update(option, (value) => false);
      } else {
        selectedOptions.addAll({option: false});
      }
    }
  }

  void setInitiallySelectedOptions() {
    if (widget.initiallySelectedOptions != null) {
      for (String option in widget.initiallySelectedOptions!) {
        selectedOptions.update(option, (value) => true);
      }
    }
  }

  void removeSelection(String value, FormFieldState<List<String>> fieldState) {
    setState(() {
      selectedOptions.update(value, (value) => false);
      generateSelectedOptions();
      _overlayEntry.markNeedsBuild();
      fieldState.didChange(generateSelectedOptions());
    });
  }

  void updateSelectionStatus(
      Map<String, bool> selection, FormFieldState<List<String>> fieldState) {
    setState(() {
      selectedOptions.update(
        selection.keys.first,
        (value) => selection.values.first,
      );
      generateSelectedOptions();

      _overlayEntry.markNeedsBuild();
    });
  }

  void toggleDropdown(FormFieldState<List<String>> fieldState) {
    if (showDropDown) {
      _overlayEntry.remove();
    } else {
      findButton();
      _overlayEntry = _dropdownOverlay(fieldState);
      Overlay.of(context).insert(_overlayEntry);
    }

    setState(() {
      showDropDown = !showDropDown;
      fieldState.didChange(generateSelectedOptions());
    });
  }

  OverlayEntry _dropdownOverlay(FormFieldState<List<String>> fieldState) {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: buttonPosition.dy + buttonSize.height,
          left: buttonPosition.dx,
          width: buttonSize.width,
          child: MultiSelectBody(
            options: options,
            selectedOptions: selectedOptions,
            onSelection: (Map<String, bool> selected) => updateSelectionStatus(
              selected,
              fieldState,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FormField<List<String>>(
      key: _key,
      validator: widget.validator,
      enabled: widget.isEnabled,
      builder: (FormFieldState<List<String>> fieldState) {
        return InputDecorator(
          decoration: const InputDecoration.collapsed(hintText: ''),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: widget.padding ??
                    const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                child: Column(
                  children: <Widget>[
                    MultiSelectHeader(
                      title: widget.label,
                      onReset: () {
                        setState(() {
                          resetSelections();
                          generateSelectedOptions();
                          widget.onReset?.call();
                          _overlayEntry.markNeedsBuild();
                          fieldState.didChange(generateSelectedOptions());
                        });
                      },
                    ),
                    // Select dropdown field
                    MultiSelectDropdownField(
                      isEnabled: widget.isEnabled,
                      borderColor: fieldState.hasError
                          ? Colors.red
                          : Colors.grey.shade300,
                      selectedOptions: selectedOptions.entries
                          .where((MapEntry<String, bool> entry) =>
                              entry.value == true)
                          .map((MapEntry<String, bool> checkedEntry) =>
                              checkedEntry.key)
                          .toList(),
                      onRemove: (String value) {
                        removeSelection(value, fieldState);
                      },
                      onDropdownTapped: () => toggleDropdown(fieldState),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: fieldState.hasError,
                child: Padding(
                  padding: widget.padding ??
                      const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                  child: Text(
                    fieldState.errorText ?? '',
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
