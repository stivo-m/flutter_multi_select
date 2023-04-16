import 'package:flutter/material.dart';
import 'package:flutter_multi_select/data.dart';
import 'package:flutter_multi_select/multi_select_form_field/multi_select_form_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MultiSelectPage(),
    );
  }
}

class MultiSelectPage extends StatefulWidget {
  const MultiSelectPage({super.key});

  @override
  State<MultiSelectPage> createState() => _MultiSelectPageState();
}

class _MultiSelectPageState extends State<MultiSelectPage> {
  List<Map<String, dynamic>> data = <Map<String, dynamic>>[];
  Map<String, dynamic> zonesByState = <String, dynamic>{};
  List<String> allStates = <String>[];
  List<String> availableZones = <String>[];
  // TODO: ADD THIS LINE HERE
  List<String> selectedZones = <String>[];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // TODO: Add this to handle focusing
  late final FocusNode statesFocusNode;
  late final FocusNode zonesFocusNode;

  @override
  void initState() {
    data = jsonData['Data'] as List<Map<String, dynamic>>;
    allStates = getStates();

    // TODO: Add this to handle focusing
    statesFocusNode = FocusNode();
    zonesFocusNode = FocusNode();

    super.initState();
  }

  void groupZonesByState(List<String> states) {
    // ignore: no_leading_underscores_for_local_identifiers
    Map<String, dynamic> _zonesByState = <String, dynamic>{};
    if (states.isNotEmpty) {
      for (var i = 0; i < states.length; i++) {
        List<String> zones = getZones(states[i]);
        _zonesByState.addAll({states[i]: zones});
      }
      setState(() {
        zonesByState = _zonesByState;

  // todo: update this line as follows
        availableZones = getAvailableZones(states);
      });
    } else {
      setState(() {
        zonesByState = _zonesByState;
        availableZones = <String>[];
      });
    }
  }

  List<String> getStates() {
    List<String> states = [];
    for (var i = 0; i < data.length; i++) {
      states.add(data[i]['dmolcnlcnstate']);
    }
    return states;
  }

  List<String> getZones(String state) {
    List<String> zones = [];

    for (var i = 0; i < data.length; i++) {
      if (data[i]['dmolcnlcnstate'] == state) {
        zones.add(data[i]['dmolcnlcncity']);
      }
    }

    return zones;
  }

// todo: update this function as follows
  List<String> getAvailableZones(List<String> states) {
    List<String> zones = [];

    for (String state in states) {
      List<String> z = zonesByState.entries
          .where((MapEntry<String, dynamic> entry) => entry.key == state)
          .map((MapEntry<String, dynamic> e) => e.value)
          .fold<List<String>>(
        <String>[],
        (List<String> previousValue, dynamic zones) =>
            <String>[...previousValue, ...zones],
      ).toList();

      zones.addAll(z);
    }

    return zones;
  }

  // TODO: Add this to handle focusing
  void handleDropdownFocus() {
    statesFocusNode.unfocus();
    zonesFocusNode.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          // TODO: Add this to handle focusing
          child: GestureDetector(
            onTap: () {
              handleDropdownFocus();
            },
            child: Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 50),
                  // Stats selector
                  MultiSelectFormField(
                    focusNode: statesFocusNode,
                    isEnabled: true,
                    key: const Key('States'),
                    label: 'State(s)*',
                    options: allStates,
                    validator: (List<String>? values) {
                      if (values == null || values.isEmpty) {
                        return 'States are required';
                      }

                      return null;
                    },
                    onChange: (List<String> selectedOptions) {
                      groupZonesByState(selectedOptions);
                    },
                    onReset: () {
                      groupZonesByState(<String>[]);
                    },
                  ),

                  // Zones selector
                  MultiSelectFormField(
                    focusNode: zonesFocusNode,
                    key: const Key('Zones'),
                    label: 'Zones(s)*',
                    options: availableZones,
                    onChange: (List<String> selectedOptions) {},
                    onReset: () {},
                    validator: (List<String>? values) {
                      if (values == null || values.isEmpty) {
                        return 'Zones are required';
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.maxFinite,
                    height: 55,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                        Colors.green.shade700,
                      )),
                      onPressed: () {
                        formKey.currentState!.validate();
                      },
                      child: const Text('Submit'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
