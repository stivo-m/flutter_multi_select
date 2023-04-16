import 'package:flutter/material.dart';

class MultiSelectBody extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      height: options.isEmpty ? 50 : null,
      constraints: const BoxConstraints(
        maxHeight: 400,
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
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey.shade300,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 10,
                spreadRadius: 5,
              )
            ],
          ),
          child: Builder(builder: (context) {
            if (options.isEmpty) {
              return const Center(
                child: Text('No options found'),
              );
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  options.length,
                  (index) {
                    final String option = options[index];

                    return CheckboxListTile(
                      key: Key(option),
                      activeColor: Colors.green.shade700,
                      dense: true,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(option),
                      value: selectedOptions[option],
                      onChanged: (bool? value) {
                        onSelection(<String, bool>{option: value ?? false});
                      },
                    );
                  },
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
