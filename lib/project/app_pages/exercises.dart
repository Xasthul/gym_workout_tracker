import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Exercises extends StatefulWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  late TextEditingController _controller;
  final List<String> _exercises = [];
  late _MySearchDelegate _delegate;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _delegate = _MySearchDelegate(_exercises);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: const Text("Exercises", style: TextStyle(fontSize: 21)),
          actions: [
            IconButton(
              tooltip: "Search",
              onPressed: () async {
                final String? selectedExercise = await showSearch<String?>(
                    context: context, delegate: _delegate);
                if (selectedExercise != null &&
                    _exercises.contains(selectedExercise)) {
                  if (!mounted) return;
                  Navigator.pop(context, selectedExercise);
                }
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              tooltip: "Add new exercise",
              onPressed: () async {
                final newExerciseName = await openDialog();
                if (newExerciseName == null || newExerciseName.isEmpty) return;
                setState(() {
                  _exercises.add(newExerciseName);
                });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: SlidableAutoCloseBehavior(
          closeWhenOpened: true,
          child: ListView.builder(
              itemCount: _exercises.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context, _exercises[index]),
                  child: Card(
                      elevation: 1,
                      color: Colors.amber[200],
                      child: Slidable(
                        endActionPane: ActionPane(
                          motion: const DrawerMotion(),
                          children: [
                            SlidableAction(
                              onPressed: doNothing,
                              backgroundColor: const Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.edit,
                              label: 'Rename',
                            ),
                            SlidableAction(
                              onPressed: doNothing,
                              backgroundColor: const Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete',
                            ),
                          ],
                        ),
                        child: ListTile(title: Text(_exercises[index])),
                      )),
                );
              }),
        ));
  }

  void doNothing(BuildContext context) {}

  // Dialog to add exercise
  Future<String?> openDialog() => showDialog<String>(
      context: context,
      builder: (context) => Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("New exercise", style: TextStyle(fontSize: 18)),
                    const SizedBox(height: 25),
                    TextField(
                      autofocus: true,
                      controller: _controller,
                      decoration: const InputDecoration(
                          hintText: "Name of exercise",
                          contentPadding: EdgeInsets.all(10),
                          isDense: true,
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)))),
                      onSubmitted: (_) => submitDialog(),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                        width: 320.0,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.amber[300]),
                          onPressed: submitDialog,
                          child: const Text("Add",
                              style: TextStyle(color: Colors.black)),
                        ))
                  ],
                ),
              ),
            ),
          ));

  void submitDialog() {
    Navigator.of(context).pop(_controller.text);
    _controller.clear();
  }
}

// For searching
class _MySearchDelegate extends SearchDelegate<String?> {
  final List<String> _exercises;

  _MySearchDelegate(List<String> exercises)
      : _exercises = exercises,
        super();

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final Iterable<String> suggestions =
        _exercises.where((word) => word.startsWith(query));

    return _SuggestionList(
      query: query,
      suggestions: suggestions.toList(),
      onSelected: (String suggestion) {
        query = suggestion;
        showResults(context);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () {
            query = '';
            // showSuggestions(context);
          },
          icon: const Icon(Icons.clear)),
    ];
  }

  @override
  void showResults(BuildContext context) {
    close(context, query);
  }
}

class _SuggestionList extends StatelessWidget {
  const _SuggestionList(
      {required this.suggestions,
      required this.query,
      required this.onSelected});

  final List<String> suggestions;
  final String query;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme.subtitle1;
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (BuildContext context, int i) {
        final String suggestion = suggestions[i];
        return ListTile(
          // Highlight the substring that matched the query.
          title: RichText(
            text: TextSpan(
              text: suggestion.substring(0, query.length),
              style: textTheme?.copyWith(fontWeight: FontWeight.bold),
              children: <TextSpan>[
                TextSpan(
                  text: suggestion.substring(query.length),
                  style: textTheme,
                ),
              ],
            ),
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
