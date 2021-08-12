import 'package:flutter/material.dart';
import 'package:personal_expenses_app/models/transaction.dart';
import 'package:personal_expenses_app/widgets/transaction_list.dart';

import 'new_transaction.dart';

class UserTransactions extends StatelessWidget {
  final List<Transaction> _userTransactions;
  final Function deleteTransaction;
  UserTransactions(this._userTransactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TransactionList(_userTransactions, deleteTransaction),
        ],
      ),
    );
  }
}
