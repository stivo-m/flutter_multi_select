import 'package:flutter/material.dart';

class MultiSelectBody extends StatefulWidget {
  const MultiSelectBody({
    super.key,
    required this.options,
    required this.selectedOptions,
    required this.onSelection,
  });

  final List<String> options;
  final Map<String, bool> selectedOptions;
  final Function(Map<String, bool>) onSelection;

  @override
  State<MultiSelectBody> createState() => _MultiSelectBodyState();
}

class _MultiSelectBodyState extends State<MultiSelectBody> {
  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: 0,
      ),
      height: widget.options.isEmpty ? 50 : null,
      constraints: const BoxConstraints(
        maxHeight: 250,
        minHeight: 50,
      ),
      duration: kThemeAnimationDuration,
      child: Material(
        color: Colors.transparent,
        child: AnimatedContainer(
          constraints: const BoxConstraints(
            maxHeight: 400,
            minHeight: 60,
          ),
          duration: kThemeAnimationDuration,
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.shade700.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 5,
              )
            ],
          ),
          child: Builder(builder: (context) {
            if (widget.options.isEmpty) {
              return const Center(
                child: Text('No options found'),
              );
            }
            return MediaQuery.removePadding(
              context: context,
              child: Scrollbar(
                interactive: true,
                thumbVisibility: true,
                controller: scrollController,
                thickness: 6,
                radius: const Radius.circular(6),
                child: ListView(
                  controller: scrollController,
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(top: 0),
                  children: List.generate(
                    widget.options.length,
                    (index) {
                      final String option = widget.options[index];

                      return CheckboxListTile(
                        key: Key(option),
                        activeColor: Colors.green.shade700,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(option),
                        value: widget.selectedOptions[option] ?? false,
                        onChanged: (bool? value) {
                          widget.onSelection(
                              <String, bool>{option: value ?? false});
                        },
                      );
                    },
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
