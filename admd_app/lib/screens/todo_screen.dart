import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../api/todo_api.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoState();
}

class _TodoState extends State<TodoScreen> {
  List<Todo> _items = [];
  final _input = TextEditingController();
  bool _isLoading = true;
  String _retryLog = '';

  @override
  void initState() {
    super.initState();
    const a = Todo(userId: 1, id: 1, title: 'todo', completed: false);
    const b = Todo(userId: 1, id: 1, title: 'todo', completed: false);
    print('Equality test a == b: ${a == b}');
    _loadApiTodos();
  }

  Future<void> _loadApiTodos() async {
    try {
      final fetchedTodos = await fetchTodos();
      setState(() {
        _items = fetchedTodos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _retryLog = 'Failed after retries: $e';
      });
    }
  }

  void _add() {
    setState(() {
      _items.add(Todo(
        userId: 1,
        id: _items.length + 1,
        title: _input.text,
        completed: false,
      ));
    });
    _input.clear();
  }

  void _toggle(int index) {
    setState(() {
      final current = _items[index];
      _items[index] = Todo(
        userId: current.userId,
        id: current.id,
        title: current.title,
        completed: !current.completed,
      );
    });
  }

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
      body: Column(
        children: [
          if (_retryLog.isNotEmpty)
            Container(
              color: Colors.red.shade100,
              padding: const EdgeInsets.all(8.0),
              width: double.infinity,
              child: Text(
                _retryLog,
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final todo = _items[index];
                      return Dismissible(
                        key: ValueKey(todo.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => setState(() {
                          _items.removeAt(index);
                        }),
                        background: Container(color: Colors.red),
                        child: Card(
                          margin: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Text(todo.title),
                            trailing: Checkbox(
                              value: todo.completed,
                              onChanged: (_) => _toggle(index),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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