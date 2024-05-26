import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snippet Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SnippetGeneratorScreen(),
    );
  }
}

class SnippetGeneratorScreen extends StatefulWidget {
  const SnippetGeneratorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SnippetGeneratorScreenState createState() => _SnippetGeneratorScreenState();
}

class _SnippetGeneratorScreenState extends State<SnippetGeneratorScreen> {
  final TextEditingController _widgetController = TextEditingController();
  final TextEditingController _templateNameController = TextEditingController();
  final TextEditingController _prefixController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _snippetOutput = '';

  void _generateSnippet() {
    String widgetCode = _widgetController.text;
    String templateName = _templateNameController.text;
    String prefix = _prefixController.text;
    String description = _descriptionController.text;

    List<String> lines = widgetCode.split('\n');
    List<String> formattedLines = lines.map((line) => '  "${line.replaceAll('"', '\\"')}",').toList();

    String snippetTemplate = '''
  "$templateName": {
    "prefix": "$prefix",
    "scope": "dart",
    "description": "$description",
    "body": [
${formattedLines.join('\n')}
      ]
  }
''';

    setState(() {
      _snippetOutput = snippetTemplate;
    });
    _copyToClipboard();
  }

  void _copyToClipboard() {
    FlutterClipboard.copy(_snippetOutput).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Copied to Clipboard')));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Snippet Generator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: _widgetController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      labelText: 'Enter Unformatted Widget Code',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _templateNameController,
                    decoration: const InputDecoration(
                      labelText: 'Template Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _prefixController,
                    decoration: const InputDecoration(
                      labelText: 'Prefix',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _generateSnippet,
                    child: const Text('Generate Snippet'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  TextField(
                    controller: TextEditingController(text: _snippetOutput),
                    maxLines: 10,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Generated Snippet',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _copyToClipboard,
                    child: const Text('Copy to Clipboard'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
