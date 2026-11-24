import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/todo_api.dart';
import '../../models/todo.dart';
import 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(const TodoState());

  Future<void> load() async {
    emit(state.copyWith(loading: true));
    emit(TodoState(todos: await fetchTodos()));
  }

  void add(String title) {
    final nextId = state.todos.isEmpty
        ? 1
        : state.todos.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
    emit(state.copyWith(
      todos: [
        ...state.todos,
        Todo(userId: 1, id: nextId, title: title, completed: false),
      ],
    ));
  }

  void toggle(int id) => emit(
        state.copyWith(
          todos: [
            for (final t in state.todos)
              if (t.id == id) t.copyWith(completed: !t.completed) else t,
          ],
        ),
      );

  void remove(int id) => emit(
        state.copyWith(
          todos: state.todos.where((t) => t.id != id).toList(),
        ),
      );
}