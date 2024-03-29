import 'package:flutter/material.dart';
import 'package:workout_tracker_prototype/main.dart';

class ExercisesSearch extends StatefulWidget {
  const ExercisesSearch({Key? key}) : super(key: key);

  @override
  State<ExercisesSearch> createState() => _ExercisesSearchState();
}

class _ExercisesSearchState extends State<ExercisesSearch> {
  late List<String> _exercises;
  late _MySearchDelegate _delegate;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Search",
      onPressed: () async {
        setState(() {
          _exercises = objectbox.exerciseBox
              .getAll()
              .map((exercise) => exercise.name)
              .toList();
          _delegate = _MySearchDelegate(_exercises);
        });
        final String? selectedExercise =
            await showSearch<String?>(context: context, delegate: _delegate);
        if (selectedExercise != null && _exercises.contains(selectedExercise)) {
          if (!mounted) return;
          Navigator.pop(context, selectedExercise);
        }
      },
      icon: const Icon(Icons.search),
    );
  }
}

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
    final Iterable<String> suggestions = _exercises.where(
        (exercise) => exercise.toUpperCase().contains(query.toUpperCase()));

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
          title: Text(
            suggestion,
            style: textTheme,
          ),
          onTap: () {
            onSelected(suggestion);
          },
        );
      },
    );
  }
}
