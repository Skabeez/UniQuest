import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'onboarding_img_model.dart';
export 'onboarding_img_model.dart';

class OnboardingImgWidget extends StatefulWidget {
  const OnboardingImgWidget({
    super.key,
    required this.img,
  });

  final String? img;

  @override
  State<OnboardingImgWidget> createState() => _OnboardingImgWidgetState();
}

class _OnboardingImgWidgetState extends State<OnboardingImgWidget> {
  late OnboardingImgModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnboardingImgModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.network(
          widget.img!,
          width: 200.0,
          height: 200.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
