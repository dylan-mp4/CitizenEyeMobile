import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'settings_data.dart';

/// A page that displays the results of a search or analysis.
class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key});

  @override
  ResultsPageState createState() => ResultsPageState();
}

/// The state of the [ResultsPage] widget.
class ResultsPageState extends State<ResultsPage> {
  String dropdownValue = 'License Plate A-Z';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        actions: <Widget>[
          // Dropdown button to select sorting option
          DropdownButton<String>(
            value: dropdownValue,
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
            items: <String>[
              'License Plate A-Z',
              'License Plate Z-A',
              'Score',
              'Date Added',
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          // Button to clear all data
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm'),
                    content:
                        const Text('Are you sure you want to clear all data?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          // Call your function to clear all results here
                          Provider.of<SettingsData>(context, listen: false)
                              .clearResults();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<SettingsData>(
        builder: (context, settingsData, child) {
          List<Map<String, dynamic>> sortedResults =
              List.from(settingsData.results);
          if (dropdownValue == 'License Plate A-Z') {
            sortedResults.sort(
                (a, b) => a['License Plate'].compareTo(b['License Plate']));
          } else if (dropdownValue == 'License Plate Z-A') {
            sortedResults.sort(
                (a, b) => b['License Plate'].compareTo(a['License Plate']));
          } else if (dropdownValue == 'Score') {
            sortedResults.sort((a, b) => b['Score'].compareTo(a['Score']));
          } else if (dropdownValue == 'Date Added') {
            sortedResults = sortedResults.reversed.toList();
          }
          return DataTable(
            columns: const [
              DataColumn(label: Text('License Plate')),
              DataColumn(label: Text('Score(%)')),
              DataColumn(label: Text('')), // Column for 'View' button
            ],
            rows: sortedResults.map((result) {
              return DataRow(cells: [
                DataCell(Text(result['License Plate'].toString())),
                DataCell(Text(result['Score'].toString())),
                DataCell(
                  MaterialButton(
                    child: const Text('View'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ResultDetailsPage(result: result),
                        ),
                      );
                    },
                  ),
                ),
              ]);
            }).toList(),
          );
        },
      ),
    );
  }
}

/// A page that displays the details of a specific result.
class ResultDetailsPage extends StatefulWidget {
  final Map<String, dynamic> result;

  const ResultDetailsPage({Key? key, required this.result}) : super(key: key);

  @override
  _ResultDetailsPageState createState() => _ResultDetailsPageState();
}

/// The state of the [ResultDetailsPage] widget.
class _ResultDetailsPageState extends State<ResultDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Result Details'),
        actions: [
          // Button to remove the result
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: () {
              Provider.of<SettingsData>(context, listen: false)
                  .removeResult(widget.result['index']);
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        children: widget.result.entries.map((entry) {
          return ListTile(
            title: Text('${entry.key}: ${entry.value}'),
          );
        }).toList(),
      ),
    );
  }
}
