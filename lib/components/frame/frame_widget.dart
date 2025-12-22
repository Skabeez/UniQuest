import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'frame_model.dart';
export 'frame_model.dart';

class FrameWidget extends StatefulWidget {
  const FrameWidget({
    super.key,
    this.id,
    required this.url,
  });

  final String? id;
  final String? url;

  @override
  State<FrameWidget> createState() => _FrameWidgetState();
}

class _FrameWidgetState extends State<FrameWidget> {
  late FrameModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FrameModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        var confirmDialogResponse = await showDialog<bool>(
              context: context,
              builder: (alertDialogContext) {
                return AlertDialog(
                  title: Text('Do you want to equip this?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext, false),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(alertDialogContext, true),
                      child: Text('Confirm'),
                    ),
                  ],
                );
              },
            ) ??
            false;
        if (confirmDialogResponse) {
          await ProfilesTable().update(
            data: {
              'equipped_border': widget!.url,
            },
            matchingRows: (rows) => rows.eqOrNull(
              'id',
              currentUserUid,
            ),
          );
          await showDialog(
            context: context,
            builder: (alertDialogContext) {
              return AlertDialog(
                title: Text('Equipped'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(alertDialogContext),
                    child: Text('Ok'),
                  ),
                ],
              );
            },
          );
        }
      },
      child: Container(
        width: 120.0,
        height: 120.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primaryText,
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Container(
                width: 100.0,
                height: 100.0,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Image.network(
                  widget!.url!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
