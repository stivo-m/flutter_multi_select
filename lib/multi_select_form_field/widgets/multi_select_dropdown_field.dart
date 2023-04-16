import 'package:flutter/material.dart';
import 'package:flutter_multi_select/multi_select_form_field/widgets/selected_option_chip.dart';

class MultiSelectDropdownField extends StatelessWidget {
  const MultiSelectDropdownField({
    super.key,
    this.hintText = 'Select options',
    this.isEnabled = true,
    this.borderColor,
    required this.selectedOptions,
    required this.onRemove,
    required this.onDropdownTapped,
  });

  final List<String> selectedOptions;
  final Function(String) onRemove;
  final VoidCallback onDropdownTapped;
  final String hintText;
  final Color? borderColor;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 50,
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: borderColor ?? Colors.grey.shade400,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Default Hint text whenever there are no options selected
          Visibility(
            visible: selectedOptions.isEmpty,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(hintText),
              ),
            ),
          ),
          // List of all the options
          Visibility(
            visible: selectedOptions.isNotEmpty,
            child: Expanded(
              child: Wrap(
                children: List.generate(selectedOptions.length, (index) {
                  return SelectedOptionChip(
                    value: selectedOptions[index],
                    onRemove: isEnabled ? onRemove : (String? value) {},
                  );
                }),
              ),
            ),
          ),
          // Dropdown arrow
          GestureDetector(
            onTap: isEnabled ? onDropdownTapped : null,
            child: SizedBox(
              width: 30,
              child: Center(
                child: Image.asset('assets/Arrow_Down.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
