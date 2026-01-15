import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '/components/walkthrough_bubble/walkthrough_bubble_widget.dart';

// Focus widget keys for this walkthrough
final columnZz4db3v5 = GlobalKey();
final icon5vj7w71e = GlobalKey();
final image9a5hoiqt = GlobalKey();
final columnFawd2z5q = GlobalKey();
final textFieldDurp415i = GlobalKey();
final textField9ioipjz3 = GlobalKey();
final dropDownNy0nvxce = GlobalKey();
final textFieldJxiohxvi = GlobalKey();
final button1ipklr67 = GlobalKey();
final buttonY0izahv0 = GlobalKey();
final buttonUx6svqrw = GlobalKey();

///Onboarding home - Learn to create and manage tasks
///
///
List<TargetFocus> createWalkthroughTargets(BuildContext context) => [
      /// Step 1 - Welcome
      TargetFocus(
        keyTarget: columnZz4db3v5,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        radius: 16.0,
        paddingFocus: 10.0,
        color: const Color(0xCC000000),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.all(16.0),
            builder: (context, __) => const WalkthroughBubbleWidget(
              text:
                  'Welcome! This guide will show you how to create and manage your tasks. Tap anywhere to continue.',
            ),
          ),
        ],
      ),

      /// Step 2 - Create task button
      TargetFocus(
        keyTarget: icon5vj7w71e,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.Circle,
        radius: 12.0,
        paddingFocus: 20.0,
        color: const Color(0xCC000000),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.all(16.0),
            builder: (context, __) => const WalkthroughBubbleWidget(
              text:
                  'Tap this + button to create a new task. A simple form will appear to enter your task details.',
            ),
          ),
        ],
      ),

      /// Step 3 - Task preview
      TargetFocus(
        keyTarget: image9a5hoiqt,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        radius: 16.0,
        paddingFocus: 15.0,
        color: const Color(0xCC000000),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.all(16.0),
            builder: (context, __) => const WalkthroughBubbleWidget(
              text: 'Your created tasks will appear here as cards. Tap on any task to view or edit it.',
            ),
          ),
        ],
      ),

      /// Step 4 - Task form
      TargetFocus(
        keyTarget: textFieldDurp415i,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        radius: 12.0,
        paddingFocus: 10.0,
        color: const Color(0xCC000000),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.all(16.0),
            builder: (context, __) => const WalkthroughBubbleWidget(
              text: 'Give your task a clear, descriptive name.',
            ),
          ),
        ],
      ),

      /// Step 5 - Priority
      TargetFocus(
        keyTarget: dropDownNy0nvxce,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        radius: 12.0,
        paddingFocus: 10.0,
        color: const Color(0xCC000000),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.all(16.0),
            builder: (context, __) => const WalkthroughBubbleWidget(
              text: 'Set the priority level (Low, Medium, High) based on urgency.',
            ),
          ),
        ],
      ),

      /// Step 6 - Save
      TargetFocus(
        keyTarget: button1ipklr67,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        radius: 12.0,
        paddingFocus: 10.0,
        color: const Color(0xCC000000),
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            padding: const EdgeInsets.all(16.0),
            builder: (context, __) => const WalkthroughBubbleWidget(
              text: 'Tap Save to create your task, or Cancel to discard it.',
            ),
          ),
        ],
      ),

      /// Step 7 - Get started
      TargetFocus(
        keyTarget: buttonUx6svqrw,
        enableOverlayTab: true,
        alignSkip: Alignment.bottomRight,
        shape: ShapeLightFocus.RRect,
        radius: 12.0,
        paddingFocus: 10.0,
        color: const Color(0xCC000000),
        contents: [
          TargetContent(
            align: ContentAlign.top,
            padding: const EdgeInsets.all(16.0),
            builder: (context, __) => const WalkthroughBubbleWidget(
              text:
                  'You\'re ready! Tap Get Started to begin creating your first task and start questing!',
            ),
          ),
        ],
      ),
    ];
