import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class AddDebtDialog extends StatefulWidget {
  const AddDebtDialog({Key? key}) : super(key: key);

  @override
  _AddDebtDialogState createState() => _AddDebtDialogState();
}

class _AddDebtDialogState extends State<AddDebtDialog> {
  _DebtType? _selected = _DebtType.theyOwe;
  bool _amountValidationError = false;

  late final TextEditingController descController;
  late final TextEditingController amountController;

  /// Returns true if there is no validation error
  bool checkAndAddDebt() {
    if (_amountValidationError || amountController.text.isEmpty) return false;

    return true;
  }

  @override
  void initState() {
    super.initState();
    descController = TextEditingController();
    amountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    TextField descTextField = TextField(
      autofocus: true,
      controller: descController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Описание',
      ),
    );

    RegExp regexp = RegExp(r'^([0-9]+|\.[0-9]{1,2}|[0-9]+\.[0-9]{0,2})$');
    TextField amountTextField = TextField(
      controller: amountController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Сумма',
        errorText: _amountValidationError ? 'Сумма набрана неверно' : null,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: (text) {
        if (!regexp.hasMatch(text) && text.isNotEmpty) {
          if (!_amountValidationError) {
            setState(() {
              _amountValidationError = true;
            });
          }
        } else {
          if (_amountValidationError) {
            setState(() {
              _amountValidationError = false;
            });
          }
        }
      },
      onSubmitted: (text) {
        bool success = checkAndAddDebt();
        if (success) Navigator.pop(context);
      },
    );

    return AlertDialog(
      title: Text('Добавить'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            descTextField,
            RadioListTile<_DebtType>(
              title: const Text('Мне должны'),
              value: _DebtType.theyOwe,
              groupValue: _selected,
              onChanged: (_DebtType? value) {
                setState(() {
                  _selected = value;
                });
              },
            ),
            RadioListTile<_DebtType>(
              title: const Text('Я должен'),
              value: _DebtType.iOwe,
              groupValue: _selected,
              onChanged: (_DebtType? value) {
                setState(() {
                  _selected = value;
                });
              },
            ),
            amountTextField,
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('ОТМЕНА'),
        ),
        TextButton(
          onPressed: () {
            bool success = checkAndAddDebt();
            if (success) Navigator.pop(context);
          },
          child: Text('ДОБАВИТЬ'),
        ),
      ],
    );
  }
}

enum _DebtType { theyOwe, iOwe }

class PayPartOfSumDialog extends StatefulWidget {
  final double debtSum;
  final void Function(double part) payPartOfSum;

  const PayPartOfSumDialog(this.debtSum, this.payPartOfSum, {Key? key})
      : super(key: key);

  @override
  _PayPartOfSumDialogState createState() => _PayPartOfSumDialogState();
}

class _PayPartOfSumDialogState extends State<PayPartOfSumDialog> {
  bool _amountValidationError = false;
  bool _amountExceedsSum = false;

  late final TextEditingController amountController;

  bool checkAndPay() {
    if (_amountValidationError ||
        _amountExceedsSum ||
        amountController.text.isEmpty) return false;

    widget.payPartOfSum.call(
        double.parse(amountController.text) * (widget.debtSum < 0 ? -1 : 1));
    return true;
  }

  @override
  void initState() {
    super.initState();
    amountController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    RegExp regexp = RegExp(r'^([0-9]+|\.[0-9]{1,2}|[0-9]+\.[0-9]{0,2})$');
    final amountField = TextField(
      controller: amountController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Сумма',
        errorText: _amountValidationError
            ? 'Сумма набрана неверно'
            : (_amountExceedsSum ? 'Заданная часть превышает сумму' : null),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      onChanged: (text) {
        if (!regexp.hasMatch(text) && text.isNotEmpty) {
          if (!_amountValidationError) {
            setState(() {
              _amountValidationError = true;
            });
          }
        } else {
          if (_amountValidationError) {
            setState(() {
              _amountValidationError = false;
            });
          }
          if (text.isNotEmpty && double.parse(text) > widget.debtSum.abs()) {
            if (!_amountExceedsSum) {
              setState(() {
                _amountExceedsSum = true;
              });
            }
          } else {
            if (_amountExceedsSum) {
              setState(() {
                _amountExceedsSum = false;
              });
            }
          }
        }
      },
      onSubmitted: (text) {
        bool success = checkAndPay();
        if (success) Navigator.pop(context);
      },
    );

    return AlertDialog(
      title: Text('Оплатить часть'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            amountField,
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.info_outline,
                      color: Colors.grey,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Вы можете отметить оплаченной сразу всю сумму, удерживая строчку в списке.',
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('ОТМЕНА'),
        ),
        TextButton(
          onPressed: () {
            bool success = checkAndPay();
            if (success) Navigator.pop(context);
          },
          child: Text('ОПЛАТИТЬ'),
        ),
      ],
    );
  }
}

class AddProfileDialog extends StatefulWidget {
  const AddProfileDialog({Key? key}) : super(key: key);

  @override
  State<AddProfileDialog> createState() => _AddProfileDialogState();
}

class _AddProfileDialogState extends State<AddProfileDialog> {
  final userNameController = TextEditingController();
  final userAgeController = TextEditingController();
  final userSalaryController = TextEditingController();
  final myUserId = FirebaseAuth.instance.currentUser!.uid;

  late DatabaseReference dbRef;
  late DatabaseReference reference;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Students').child(myUserId);
  }

  @override
  Widget build(BuildContext context) {
    var container = Center(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: userNameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Имя',
                ),
                onSubmitted: (text) {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: userAgeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Возраст',
                ),
                onSubmitted: (text) {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: userSalaryController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Сумма',
                ),
                onSubmitted: (text) {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );

    return Container(
      height: 300,
      child: AlertDialog(
        title: Text("Добавить"),
        content: container,
        actions: [
          TextButton(
            onPressed: () {
              Map<String, String> students = {
                'name': userNameController.text,
                'age': userAgeController.text,
                'salary': userSalaryController.text,
              };

              dbRef.push().set(students);
              Navigator.pop(context);
            },
            child: Text('ДОБАВИТЬ'),
          ),
        ],
      ),
    );
  }
}

class EditProfileDialog extends StatelessWidget {
  final String oldName;

  const EditProfileDialog(this.oldName, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    controller.text = oldName;

    TextField textField = TextField(
      controller: controller,
      keyboardType: TextInputType.text,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        labelText: 'Name',
        hintText: 'Enter Your Name',
      ),
    );

    return AlertDialog(
      title: Text("Изменить"),
      content: textField,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('ОТМЕНА'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('ИЗМЕНИТЬ'),
        ),
      ],
    );
  }
}

class MergeDebtsDialog extends StatefulWidget {
  late final DatabaseReference dbRef;

  @override
  _MergeDebtsDialogState createState() => _MergeDebtsDialogState();
}

class _MergeDebtsDialogState extends State<MergeDebtsDialog> {
  late final DatabaseReference dbRef;
  late final TextEditingController _controller;
  final myUserId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Students').child(myUserId);
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Объединить'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return DebtWithCheckboxListTile(
                    dbRef: widget.dbRef,
                    onChanged: (bool newValue) {
                      if (newValue) {
                        setState(() {});
                      } else {
                        setState(() {});
                      }
                    },
                    myUserId: myUserId,
                    value: true,
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Новое описание',
              ),
              onSubmitted: (text) {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('ОТМЕНА'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('ОБЪЕДИНИТЬ'),
        ),
      ],
    );
  }
}

class DebtWithCheckboxListTile extends StatelessWidget {
  final DatabaseReference dbRef;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String myUserId;

  const DebtWithCheckboxListTile(
      {Key? key,
      required this.dbRef,
      required this.value,
      required this.onChanged,
      required this.myUserId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          children: [
            Checkbox(
              value: value,
              onChanged: (bool? newValue) {
                onChanged(newValue!);
              },
            ),
            Expanded(
                child: Text(
                    dbRef.ref.child('Students').child(myUserId).toString())),
            Text(dbRef.ref.child('Students').child(myUserId).toString()),
          ],
        ),
      ),
    );
  }
}
