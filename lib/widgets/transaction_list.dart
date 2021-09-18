import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function delTx;
  TransactionList(this.transactions, this.delTx);
  @override
  Widget build(BuildContext context) {
    return transactions.isEmpty
        ? LayoutBuilder(builder: (btx, constraints) {
            return Column(
              children: [
                Text(
                  'No Transactions added yet!',
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'lib/assets/images/waiting.png',
                      fit: BoxFit.cover,
                    )),
              ],
            );
          })
        : ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (ctx, index) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                elevation: 5,
                child: ListTile(
                  leading: CircleAvatar(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: FittedBox(
                        child: Text(
                          '\$${this.transactions[index].amount.toStringAsFixed(2)}',
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    radius: 30,
                  ),
                  title: Text(
                    transactions[index].title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  subtitle:
                      Text(DateFormat.yMMMd().format(transactions[index].date)),
                  trailing: MediaQuery.of(context).size.width > 360
                      ? TextButton.icon(
                          style: TextButton.styleFrom(
                              primary: Theme.of(context).errorColor),
                          onPressed: () {
                            delTx(transactions[index].id);
                          },
                          icon: Icon(Icons.delete),
                          label: Text('Delete'))
                      : IconButton(
                          icon: Icon(Icons.delete),
                          color: Theme.of(context).errorColor,
                          onPressed: () {
                            delTx(transactions[index].id);
                          },
                        ),
                ),
              );
              // return Card(
              //     child: Row(
              //   children: [
              //     Container(
              //       padding: EdgeInsets.all(10),
              //       margin: EdgeInsets.symmetric(
              //         vertical: 10,
              //         horizontal: 15,
              //       ),
              //       decoration: BoxDecoration(
              //         border: Border.all(
              //           color: Theme.of(context).primaryColor,
              //           width: 2,
              //         ),
              //       ),
              //       child: Text(
              //         '\$${this.transactions[index].amount.toStringAsFixed(2)}',
              //         style: TextStyle(
              //             fontWeight: FontWeight.bold,
              //             fontSize: 20,
              //             color: Colors.purple),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             this.transactions[index].title,
              //             style: Theme.of(context).textTheme.headline6,
              //             // style: TextStyle(
              //             //   fontFamily: 'OpenSans',
              //             //   fontSize: 18,
              //             //   fontWeight: FontWeight.bold,
              //             // ),
              //           ),
              //           Text(
              //             DateFormat.yMMMd()
              //                 .format(this.transactions[index].date),
              //             style: TextStyle(color: Colors.grey),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ));
            });
  }
}
