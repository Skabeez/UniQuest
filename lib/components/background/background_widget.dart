import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'background_model.dart';
export 'background_model.dart';

class BackgroundWidget extends StatefulWidget {
  const BackgroundWidget({
    super.key,
    required this.id,
    required this.url,
  });

  final String? id;
  final String? url;

  @override
  State<BackgroundWidget> createState() => _BackgroundWidgetState();
}

class _BackgroundWidgetState extends State<BackgroundWidget> {
  late BackgroundModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BackgroundModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 5.0, 0.0),
      child: InkWell(
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
                        onPressed: () =>
                            Navigator.pop(alertDialogContext, false),
                        child: Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(alertDialogContext, true),
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
                'equipped_namecard': widget!.url,
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
          width: 180.0,
          height: 130.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget!.url!,
              width: 200.0,
              height: 200.0,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
