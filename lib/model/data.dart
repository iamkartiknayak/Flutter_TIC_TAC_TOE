import 'package:flutter/material.dart';
import 'package:tictactoe/widgets/result_dialog.dart';

class DataModel with ChangeNotifier {
  final List<String> _boardValues = ['', '', '', '', '', '', '', '', ''];

  List<String> get boardValues => _boardValues;

  String _activeValue = 'o';
  String get activeValue => _activeValue;

  int _playerOnePoints = 0;
  int get playerOnePoints => _playerOnePoints;

  int _playerTwoPoints = 0;
  int get playerTwoPoints => _playerTwoPoints;

  int _drawCount = 0;
  int get drawCount => _drawCount;

  var _isReadOnly = false;

  void resetBoard() {
    for (int i = 0; i < _boardValues.length; i++) {
      _boardValues[i] = '';
    }
  }

  void displayResult(BuildContext context, String playerNumber, String result) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return ResultDialog(
          playerNumber: playerNumber,
          result: result,
        );
      },
    );
  }

  void setValue(int index, BuildContext context) {
    if (_boardValues[index].isEmpty && !_isReadOnly) {
      _activeValue = _activeValue == 'x' ? 'o' : 'x';
      _boardValues[index] = _activeValue;

      final playerNumber = _activeValue == 'x' ? '1' : '2';

      if (isGameWon(_activeValue)) {
        displayResult(context, playerNumber, 'win');
        _isReadOnly = true;
        playerNumber == '1' ? _playerOnePoints += 1 : _playerTwoPoints += 1;
      } else if (isGameOver()) {
        _drawCount += 1;
        displayResult(context, playerNumber, 'draw');
      }
    }

    notifyListeners();
  }

  bool isGameOver() {
    var count = 0;

    for (final item in _boardValues) {
      if (item.isEmpty) {
        count += 1;
        break;
      }
    }

    return count == 0;
  }

  bool isGameWon(String value) {
    const List<List<int>> combinationList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (final list in combinationList) {
      int count = 0;
      for (final index in list) {
        if (_boardValues[index] == value) {
          count += 1;
        }
        if (count == 3) return true;
      }
    }

    return false;
  }

  void restartGame(BuildContext context) {
    _activeValue = 'o';
    _isReadOnly = false;
    resetBoard();
    notifyListeners();
  }
}
