import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GridSearchScreen extends StatefulWidget {
  @override
  _GridSearchScreenState createState() => _GridSearchScreenState();
}

class _GridSearchScreenState extends State<GridSearchScreen> {
  TextEditingController searchController = TextEditingController();
  TextEditingController gridController = TextEditingController();
  final snackBar = const SnackBar(
    content: Text('Ooops!!! This Word Is Unavailable...'),
  );
  int rows = 0;
  int columns = 0;
  List<List<String>> grid = [];
  List<List<bool>> highlightMatrix = [];
  int wordCount = 0;

  void generateGrid() {
    if (gridController.text.isNotEmpty) {
      final count = int.tryParse(gridController.text);
      if (count != null && count > 0) {
        setState(() {
          rows = count;
          columns = count;
          grid = List.generate(
              rows, (row) => List<String>.filled(columns, "", growable: false));
          highlightMatrix = List.generate(rows,
              (row) => List<bool>.filled(columns, false, growable: false));
        });
      }
    }
  }

  void updateHighlightMatrix(String word) {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        highlightMatrix[i][j] = false;

        if (grid[i][j].startsWith('*') && grid[i][j].endsWith('*')) {
          grid[i][j] = grid[i][j].substring(1, grid[i][j].length - 1);
        }
      }
    }

    wordCount = 0;

    if (word.isNotEmpty) {
      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < columns; j++) {
          if (j + word.length <= columns &&
              grid[i].sublist(j, j + word.length).join().toUpperCase() ==
                  word.toUpperCase()) {
            for (int k = 0; k < word.length; k++) {
              highlightMatrix[i][j + k] = true;
              grid[i][j + k] = '*${grid[i][j + k]}*';
            }
            wordCount++;
          }

          if (i + word.length <= rows) {
            bool found = true;
            for (int k = 0; k < word.length; k++) {
              if (grid[i + k][j].toUpperCase() != word[k].toUpperCase()) {
                found = false;
                break;
              }
            }
            if (found) {
              for (int k = 0; k < word.length; k++) {
                highlightMatrix[i + k][j] = true;
                grid[i + k][j] = '*${grid[i + k][j]}*';
              }
              wordCount++;
            }
          }

          if (i - word.length + 1 >= 0) {
            bool found = true;
            for (int k = 0; k < word.length; k++) {
              if (grid[i - k][j].toUpperCase() != word[k].toUpperCase()) {
                found = false;
                break;
              }
            }
            if (found) {
              for (int k = 0; k < word.length; k++) {
                highlightMatrix[i - k][j] = true;
                grid[i - k][j] = '*${grid[i - k][j]}*';
              }
              wordCount++;
            }
          }
        }
      }
    }
  }

  Widget buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
      ),
      itemCount: rows * columns,
      itemBuilder: (context, index) {
        final rowIndex = index ~/ columns;
        final colIndex = index % columns;
        return TextField(
          onChanged: (value) {
            if (value.isNotEmpty && RegExp(r'^[a-zA-Z]$').hasMatch(value)) {
              setState(() {
                grid[rowIndex][colIndex] = value.toUpperCase();
              });
            }
          },
          maxLength: 1,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: highlightMatrix[rowIndex][colIndex]
                ? FontWeight.bold
                : FontWeight.normal,
          ),
          decoration: InputDecoration(
            filled: highlightMatrix.isEmpty ? false : true,
            fillColor: highlightMatrix[rowIndex][colIndex]
                ? Colors.yellow
                : Colors.transparent,
            counterText: '',
            border: const OutlineInputBorder(),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
          ],
        );
      },
    );
  }

  void restartApp() {
    setState(() {
      rows = 0;
      columns = 0;
      grid = [];
      highlightMatrix = [];
      wordCount = 0;
      searchController.clear();
      gridController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade100,
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Mobigic Assignment'),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: gridController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    suffixIcon: Icon(
                      Icons.grid_view_sharp,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    labelText: 'Enter number of rows and columns'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: generateGrid,
                child: const Text('Generate Grid'),
              ),
              const SizedBox(height: 16),
              if (columns > 0) buildGrid(),
              const SizedBox(height: 16),
              TextField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    updateHighlightMatrix(value);
                  });
                },
                decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    labelText: 'Enter word to search'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  if (wordCount >= 1) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Word Count'),
                          content: Text.rich(
                            TextSpan(
                              children: [
                                const TextSpan(text: 'Word '),
                                TextSpan(
                                  text:
                                      '${searchController.text.toUpperCase()} ',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                const TextSpan(text: ' occured '),
                                TextSpan(
                                  text: '$wordCount',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                                wordCount <= 1
                                    ? const TextSpan(text: ' time in the grid.')
                                    : const TextSpan(text: ' times in the grid')
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                gridController.clear();
                                Navigator.of(context).pop();
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text('Search Word'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: restartApp,
                child: const Text('Restart App'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
