import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:workout_tracker_prototype/project/classes/exercises_list_view.dart';
import 'package:workout_tracker_prototype/project/classes/exercises_add.dart';

class Exercises extends StatefulWidget {
  const Exercises({Key? key}) : super(key: key);

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  final List<String> _exercises = [];
  late _MySearchDelegate _delegate;

  @override
  void initState() {
    super.initState();
    _delegate = _MySearchDelegate(_exercises);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue[400],
          title: Text("Exercises", style: TextStyle(fontSize: 21.sp)),
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
            const ExercisesAdd(),
          ],
        ),
        body: const ExerciseList(),
    );
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
