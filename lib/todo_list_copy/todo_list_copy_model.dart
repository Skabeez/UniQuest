import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/add_new_task/add_new_task_widget.dart';
import '/components/menu_task/menu_task_widget.dart';
import '/components/task_div/task_div_widget.dart';
import '/flutter_flow/flutter_flow_button_tabbar.dart';
import '/flutter_flow/flutter_flow_calendar.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/walkthroughs/todolist_view.dart';
import 'dart:ui';
import '/index.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'
    show TutorialCoachMark;
import 'todo_list_copy_widget.dart' show TodoListCopyWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TodoListCopyModel extends FlutterFlowModel<TodoListCopyWidget> {
  ///  Local state fields for this page.

  List<TasksRow> tasksName = [];
  void addToTasksName(TasksRow item) => tasksName.add(item);
  void removeFromTasksName(TasksRow item) => tasksName.remove(item);
  void removeAtIndexFromTasksName(int index) => tasksName.removeAt(index);
  void insertAtIndexInTasksName(int index, TasksRow item) =>
      tasksName.insert(index, item);
  void updateTasksNameAtIndex(int index, Function(TasksRow) updateFn) =>
      tasksName[index] = updateFn(tasksName[index]);

  List<TasksRow> searchedTasks = [];
  void addToSearchedTasks(TasksRow item) => searchedTasks.add(item);
  void removeFromSearchedTasks(TasksRow item) => searchedTasks.remove(item);
  void removeAtIndexFromSearchedTasks(int index) =>
      searchedTasks.removeAt(index);
  void insertAtIndexInSearchedTasks(int index, TasksRow item) =>
      searchedTasks.insert(index, item);
  void updateSearchedTasksAtIndex(int index, Function(TasksRow) updateFn) =>
      searchedTasks[index] = updateFn(searchedTasks[index]);

  ///  State fields for stateful widgets in this page.

  TutorialCoachMark? todolistViewController;
  // State field(s) for Calendar widget.
  DateTimeRange? calendarSelectedDay;
  // State field(s) for TabBar widget.
  TabController? tabBarController;
  int get tabBarCurrentIndex =>
      tabBarController != null ? tabBarController!.index : 0;
  int get tabBarPreviousIndex =>
      tabBarController != null ? tabBarController!.previousIndex : 0;

  Stream<List<TasksRow>>? listViewSupabaseStream1;
  // Models for taskDiv dynamic component.
  late FlutterFlowDynamicModels<TaskDivModel> taskDivModels1;
  Stream<List<TasksRow>>? listViewSupabaseStream2;
  // Models for taskDiv dynamic component.
  late FlutterFlowDynamicModels<TaskDivModel> taskDivModels2;
  Stream<List<TasksRow>>? listViewSupabaseStream3;
  // Models for taskDiv dynamic component.
  late FlutterFlowDynamicModels<TaskDivModel> taskDivModels3;
  Stream<List<TasksRow>>? listViewSupabaseStream4;
  // Models for taskDiv dynamic component.
  late FlutterFlowDynamicModels<TaskDivModel> taskDivModels4;

  @override
  void initState(BuildContext context) {
    calendarSelectedDay = DateTimeRange(
      start: DateTime.now().startOfDay,
      end: DateTime.now().endOfDay,
    );
    taskDivModels1 = FlutterFlowDynamicModels(() => TaskDivModel());
    taskDivModels2 = FlutterFlowDynamicModels(() => TaskDivModel());
    taskDivModels3 = FlutterFlowDynamicModels(() => TaskDivModel());
    taskDivModels4 = FlutterFlowDynamicModels(() => TaskDivModel());
  }

  @override
  void dispose() {
    todolistViewController?.finish();
    tabBarController?.dispose();
    taskDivModels1.dispose();
    taskDivModels2.dispose();
    taskDivModels3.dispose();
    taskDivModels4.dispose();
  }
}
