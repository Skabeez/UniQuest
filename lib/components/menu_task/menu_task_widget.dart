import '/backend/supabase/supabase.dart';
import '/auth/supabase_auth/auth_util.dart';
import '/components/lottie_burst_overlay/lottie_burst_overlay_widget.dart';
import '/components/modern_alert_dialog.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/services/audio_manager.dart';
import '/services/sound_effects.dart';
import 'package:flutter/material.dart';
import 'menu_task_model.dart';
export 'menu_task_model.dart';

class MenuTaskWidget extends StatefulWidget {
  const MenuTaskWidget({
    super.key,
    this.tasks,
    required this.tasksid,
  });

  final TasksRow? tasks;
  final String? tasksid;

  @override
  State<MenuTaskWidget> createState() => _MenuTaskWidgetState();
}

class _MenuTaskWidgetState extends State<MenuTaskWidget> {
  late MenuTaskModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MenuTaskModel());

    // Play popup sound
    AudioManager().playSfx(SoundEffects.popUp);
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400.0,
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E1E),
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Color(0x3B1D2429),
            offset: Offset(
              0.0,
              -3.0,
            ),
          )
        ],
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
                  var confirmDialogResponse = await showDialog<bool>(
                        context: context,
                        barrierColor: Colors.black87,
                        builder: (alertDialogContext) {
                          return ModernAlertDialog(
                            title: 'Delete Task?',
                            description:
                                'This task will be permanently deleted. This action cannot be undone.',
                            secondaryButtonText: 'DELETE',
                            primaryButtonText: 'Cancel',
                            onSecondaryPressed: () =>
                                Navigator.pop(alertDialogContext, true),
                            onPrimaryPressed: () =>
                                Navigator.pop(alertDialogContext, false),
                          );
                        },
                      ) ??
                      false;
                  if (confirmDialogResponse) {
                    await TasksTable().delete(
                      matchingRows: (rows) => rows.eqOrNull(
                        'task_id',
                        widget.tasksid,
                      ),
                    );
                    await showDialog(
                      context: context,
                      barrierColor: Colors.black87,
                      builder: (alertDialogContext) {
                        return const ModernAlertDialog(
                          title: 'Deleted!',
                          description:
                              'The task has been deleted successfully.',
                          primaryButtonText: 'Done',
                        );
                      },
                    );
                    Navigator.pop(context);
                  } else {
                    await showDialog(
                      context: context,
                      barrierColor: Colors.black87,
                      builder: (alertDialogContext) {
                        return const ModernAlertDialog(
                          title: 'Cancelled',
                          description: 'The delete action has been cancelled.',
                          primaryButtonText: 'OK',
                        );
                      },
                    );
                  }
                },
                text: 'Delete Task',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 60.0,
                  padding: const EdgeInsets.all(14.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).error,
                  textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Feather',
                        color: const Color(0xFF14181B),
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                  elevation: 2.0,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
                  await TasksTable().update(
                    data: {
                      'status': 'Ongoing',
                    },
                    matchingRows: (rows) => rows.eqOrNull(
                      'task_id',
                      widget.tasks?.taskId,
                    ),
                  );
                  await showDialog(
                    context: context,
                    barrierColor: Colors.black87,
                    builder: (alertDialogContext) {
                      return const ModernAlertDialog(
                        title: 'Updated!',
                        description: 'Task marked as ongoing.',
                        primaryButtonText: 'Done',
                      );
                    },
                  );
                },
                text: 'Mark as Ongoing',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 60.0,
                  padding: const EdgeInsets.all(14.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).accent1,
                  textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Feather',
                        color: const Color(0xFF14181B),
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                  elevation: 2.0,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
                  var confirmDialogResponse = await showDialog<bool>(
                        context: context,
                        barrierColor: Colors.black87,
                        builder: (alertDialogContext) {
                          return ModernAlertDialog(
                            title: 'Complete Task?',
                            description:
                                'Mark this task as complete? This action cannot be undone.',
                            secondaryButtonText: 'Cancel',
                            primaryButtonText: 'Complete',
                            onSecondaryPressed: () =>
                                Navigator.pop(alertDialogContext, false),
                            onPrimaryPressed: () =>
                                Navigator.pop(alertDialogContext, true),
                          );
                        },
                      ) ??
                      false;
                  if (confirmDialogResponse) {
                    // Get task details to check XP reward
                    final taskRows = await TasksTable().queryRows(
                      queryFn: (q) => q.eqOrNull('task_id', widget.tasksid),
                    );

                    if (taskRows.isEmpty) {
                      await showDialog(
                        context: context,
                        barrierColor: Colors.black87,
                        builder: (alertDialogContext) {
                          return const ModernAlertDialog(
                            title: 'Error',
                            description: 'Unable to load task details.',
                            primaryButtonText: 'OK',
                          );
                        },
                      );
                      return;
                    }

                    final taskXp = taskRows.first.xpReward ?? 0;

                    // Get current user profile to check daily limit
                    final userRows = await ProfilesTable().queryRows(
                      queryFn: (q) => q.eqOrNull('id', currentUserUid),
                    );

                    if (userRows.isEmpty) {
                      await showDialog(
                        context: context,
                        barrierColor: Colors.black87,
                        builder: (alertDialogContext) {
                          return const ModernAlertDialog(
                            title: 'Error',
                            description: 'Unable to load user profile.',
                            primaryButtonText: 'OK',
                          );
                        },
                      );
                      return;
                    }

                    final userProfile = userRows.first;

                    final now = DateTime.now();
                    final today = DateTime(now.year, now.month, now.day);
                    
                    // Calculate XP reduction for late tasks
                    int baseTaskXp = taskXp;
                    int xpReduction = 0;
                    String lateMessage = '';
                    
                    if (taskRows.first.dueDate != null) {
                      final dueDate = DateTime(
                        taskRows.first.dueDate!.year,
                        taskRows.first.dueDate!.month,
                        taskRows.first.dueDate!.day,
                      );
                      
                      if (today.isAfter(dueDate)) {
                        // Task is late - calculate days late
                        final daysLate = today.difference(dueDate).inDays;
                        
                        // 10% XP reduction per day late, max 50% reduction
                        // (5 days late = 50% reduction, 6+ days = 50% max)
                        final reductionPercent = (daysLate * 10).clamp(0, 50);
                        xpReduction = ((baseTaskXp * reductionPercent) / 100).round();
                        
                        if (xpReduction > 0) {
                          lateMessage = ' (-$reductionPercent% for $daysLate day${daysLate == 1 ? '' : 's'} late)';
                        }
                      }
                    }
                    
                    final adjustedTaskXp = baseTaskXp - xpReduction;
                    
                    final resetDate = userProfile.taskXpResetDate != null
                        ? DateTime(
                            userProfile.taskXpResetDate!.year,
                            userProfile.taskXpResetDate!.month,
                            userProfile.taskXpResetDate!.day,
                          )
                        : null;

                    int xpEarnedToday = userProfile.taskXpEarnedToday;
                    final dailyLimit = userProfile.dailyTaskXpLimit;

                    // Reset counter if it's a new day
                    if (resetDate == null || resetDate.isBefore(today)) {
                      xpEarnedToday = 0;
                    }

                    // Check if adding this task's XP would exceed daily limit
                    final remainingXp = dailyLimit - xpEarnedToday;
                    final xpToAward = adjustedTaskXp > remainingXp ? remainingXp : adjustedTaskXp;
                    final limitReached = xpToAward < adjustedTaskXp;

                    // Perform DB updates in a guarded block so we can show errors
                    try {
                      // Mark task as done
                      await TasksTable().update(
                        data: {
                          'status': 'Completed',
                          'isdone': true,
                        },
                        matchingRows: (rows) => rows.eqOrNull(
                          'task_id',
                          widget.tasksid,
                        ),
                      );

                      // Award XP if any is available
                      if (currentUserUid.isEmpty) {
                        if (context.mounted) {
                          await showDialog(
                            context: context,
                            barrierColor: Colors.black87,
                            builder: (alertDialogContext) {
                              return const ModernAlertDialog(
                                title: 'Not signed in',
                                description:
                                    'Please sign in to complete this task.',
                                primaryButtonText: 'OK',
                              );
                            },
                          );
                        }
                        return;
                      }

                      if (xpToAward > 0) {
                        await ProfilesTable().update(
                          data: {
                            'xp': userProfile.xp + xpToAward,
                            'task_xp_earned_today': xpEarnedToday + xpToAward,
                            'task_xp_reset_date': today.toIso8601String(),
                          },
                          matchingRows: (rows) => rows.eq('id', currentUserUid),
                        );
                      } else {
                        // Just update the reset date even if no XP awarded
                        await ProfilesTable().update(
                          data: {
                            'task_xp_reset_date': today.toIso8601String(),
                          },
                          matchingRows: (rows) => rows.eq('id', currentUserUid),
                        );
                      }
                    } catch (e, st) {
                      // Log and show a dialog with the error to help debugging
                      print('Error during task completion: $e');
                      print(st);
                      if (context.mounted) {
                        await showDialog(
                          context: context,
                          barrierColor: Colors.black87,
                          builder: (alertDialogContext) {
                            return ModernAlertDialog(
                              title: 'Error',
                              description: e.toString(),
                              primaryButtonText: 'OK',
                            );
                          },
                        );
                      }
                      return;
                    }

                    // 🎉 Trigger confetti burst!
                    if (context.mounted) {
                      LottieBurstOverlay.showCentered(
                        context: context,
                        lottieAsset: 'assets/jsons/Confetti.json',
                        size: 400.0,
                      );
                    }

                    // Show appropriate completion message
                    String completionMessage;
                    if (xpReduction > 0) {
                      // Task was late - show penalty info
                      if (limitReached) {
                        completionMessage =
                            'Task completed!$lateMessage\n\nBase XP: $baseTaskXp → Adjusted: +$xpToAward XP\nDaily task XP: ${xpEarnedToday + xpToAward}/$dailyLimit';
                      } else if (xpToAward > 0) {
                        completionMessage =
                            'Task completed!$lateMessage\n\nBase XP: $baseTaskXp → Adjusted: +$xpToAward XP (-${((xpReduction * 100) / baseTaskXp).round()}% penalty)\nDaily task XP: ${xpEarnedToday + xpToAward}/$dailyLimit';
                      } else {
                        completionMessage =
                            'Task completed!$lateMessage\n\nBase XP: $baseTaskXp but daily limit reached.';
                      }
                    } else if (limitReached) {
                      completionMessage =
                          'Task completed! You\'ve reached your daily XP limit from tasks ($dailyLimit XP/day).\n\nXP awarded: +$xpToAward XP';
                    } else if (xpToAward > 0) {
                      completionMessage =
                          'Task completed! You earned +$xpToAward XP!\n\nDaily task XP: ${xpEarnedToday + xpToAward}/$dailyLimit';
                    } else {
                      completionMessage =
                          'Task completed!\n\nYou\'ve reached your daily XP limit from tasks ($dailyLimit XP/day).';
                    }

                    await showDialog(
                      context: context,
                      barrierColor: Colors.black87,
                      builder: (alertDialogContext) {
                        String dialogTitle;
                        if (xpReduction > 0) {
                          dialogTitle = 'Task Late! ⏰';
                        } else if (limitReached) {
                          dialogTitle = 'Daily Limit Reached! ⏰';
                        } else {
                          dialogTitle = 'Completed! 🎉';
                        }
                        
                        return ModernAlertDialog(
                          title: dialogTitle,
                          description: completionMessage,
                          primaryButtonText: 'Awesome',
                        );
                      },
                    );
                    Navigator.pop(context);
                  } else {
                    await showDialog(
                      context: context,
                      barrierColor: Colors.black87,
                      builder: (alertDialogContext) {
                        return const ModernAlertDialog(
                          title: 'Cancelled',
                          description: 'Task completion cancelled.',
                          primaryButtonText: 'OK',
                        );
                      },
                    );
                  }
                },
                text: 'Mark as Done',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 60.0,
                  padding: const EdgeInsets.all(14.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).accent1,
                  textStyle: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Feather',
                        color: const Color(0xFF14181B),
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                  elevation: 2.0,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsetsDirectional.fromSTEB(0.0, 16.0, 0.0, 0.0),
              child: FFButtonWidget(
                onPressed: () async {
                  context.pop();
                },
                text: 'Cancel',
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 60.0,
                  padding: const EdgeInsets.all(14.0),
                  iconPadding:
                      const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).secondaryText,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Feather',
                        color: FlutterFlowTheme.of(context).primaryText,
                        fontSize: 16.0,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.bold,
                      ),
                  elevation: 0.0,
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 0.0,
                  ),
                  borderRadius: BorderRadius.circular(14.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
