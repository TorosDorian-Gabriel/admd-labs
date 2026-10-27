import 'package:flutter/material.dart';

class Todo {
  final String id;
  String title;
  bool done;

  Todo(this.title, {this.done = false, String? id})
      : id = id ?? UniqueKey().toString();
}

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoState();
}

class _TodoState 
      extends State<TodoScreen> {
  final _items = <Todo>[];
  final _input = TextEditingController();
  void _add() {
    setState(() {
      _items.add(Todo(_input.text));
    });
    _input.clear();
  }
  void _bug1() {
  int done = 0;
  for (var i = 0; i < _items.length; i++) {
    done += _items[i].done ? 1 : 0;
  }
}
void _bug3() {
  String? _filter;
  final visible = _items.where(
    (t) => t.title.contains(_filter ?? ''),);
}
void _toggle(int i) =>
  setState(() {_items[i].done = !_items[i].done;});
  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          final todo = _items[index];
          return Dismissible(
            key: ValueKey(todo.id),
            direction: DismissDirection.endToStart,
            onDismissed: (_) => setState(() {
              _items.removeWhere((t) => t.id == todo.id);
            }),
            background: Container(color: Colors.red),
            child: TodoTile(
              todo: todo,
              onChanged: (val) {
                // setState(() {
                //   todo.done = val ?? false;
                // }
                // );
                _toggle(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _bug1();
          _bug3();
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Todo'),
              content: TextField(
                controller: _input,
                decoration: const InputDecoration(hintText: 'Enter task title'),
                autofocus: true,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_input.text.isNotEmpty) {
                      _add();
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoTile extends StatelessWidget {
  const TodoTile({
    super.key,
    required this.todo,
    required this.onChanged,
  });

  final Todo todo;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(todo.title),
        trailing: Checkbox(
          value: todo.done,
          onChanged: onChanged,
        ),
      ),
    );
  }
}