import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AnimationInfo {
  final AnimationTrigger trigger;
  final List<AnimationEffect> effects;

  AnimationInfo({required this.trigger, required this.effects});
}

class AnimationTrigger {
  final String name;
  const AnimationTrigger._(this.name);

  static const AnimationTrigger onPageLoad = AnimationTrigger._('onPageLoad');
}

/*abstract class AnimationEffect {
  Curve get curve;
  Duration get delay;
  Duration get duration;
}*/

abstract class AnimationEffect {
  final Curve curve;
  final Duration delay;
  final Duration duration;

  AnimationEffect({required this.curve, required this.delay, required this.duration});
}

// Example effect classes:
class RotateEffect extends AnimationEffect {
  final double begin;
  final double end;
  RotateEffect({required Curve curve, required Duration delay, required Duration duration, required this.begin, required this.end})
      : super(curve: curve, delay: delay, duration: duration);
}

class MoveEffect extends AnimationEffect {
  final Offset begin;
  final Offset end;

  MoveEffect({required Curve curve, required Duration delay, required Duration duration, required this.begin, required this.end})
      : super(curve: curve, delay: delay, duration: duration);
}

class FadeEffect extends AnimationEffect {
  final double begin;
  final double end;

  FadeEffect({required Curve curve, required Duration delay, required Duration duration, required this.begin, required this.end})
      : super(curve: curve, delay: delay, duration: duration);
}

extension WidgetAnimations on Widget {
  Widget animateOnPageLoad(AnimationInfo animationInfo, {required TickerProvider tickerProvider}) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      bool isDisposed = false;

      final AnimationController controller = AnimationController(
        duration: const Duration(milliseconds: 600),
        vsync: tickerProvider,
      );

      for (final effect in animationInfo.effects) {
        final delay = effect.delay;
        final duration = effect.duration;

        if (delay > Duration.zero) {
          Future.delayed(delay, () {
            if (!isDisposed) {
              controller.forward();
            }
          });
        } else {
          if (!isDisposed) {
            controller.forward();
          }
        }

        Future.delayed(delay + duration, () {
          if (!isDisposed) {
            controller.dispose();
            isDisposed = true;
          }
        });
      }
    });

    return this;
  }
}

final animationsMap = {
  'imageOnPageLoadAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      RotateEffect(
        curve: Curves.easeInOut,
        delay: 0.ms,
        duration: 900.ms,
        begin: 0,
        end: 1,
      ),
    ],
  ),
  'columnOnPageLoadAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 0.ms,
        duration: 600.ms,
        begin: 0,
        end: 1,
      ),
    ],
  ),
  'rowOnPageLoadAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 200.ms,
        duration: 600.ms,
        begin: const Offset(0, 80),
        end: const Offset(0, 0),
      ),
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 200.ms,
        duration: 600.ms,
        begin: 0,
        end: 1,
      ),
    ],
  ),
  'containerOnPageLoadAnimation1': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 200.ms,
        duration: 600.ms,
        begin: const Offset(0, 80),
        end: const Offset(0, 0),
      ),
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 200.ms,
        duration: 600.ms,
        begin: 0,
        end: 1,
      ),
    ],
  ),
  'containerOnPageLoadAnimation2': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 400.ms,
        duration: 600.ms,
        begin: const Offset(0, 80),
        end: const Offset(0, 0),
      ),
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 400.ms,
        duration: 600.ms,
        begin: 0,
        end: 1,
      ),
    ],
  ),
  'containerOnPageLoadAnimation3': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 300.ms,
        duration: 600.ms,
        begin: const Offset(0, 80),
        end: const Offset(0, 0),
      ),
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 300.ms,
        duration: 600.ms,
        begin: 0,
        end: 1,
      ),
    ],
  ),
  'containerOnPageLoadAnimation4': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 500.ms,
        duration: 600.ms,
        begin: const Offset(0, 80),
        end: const Offset(0, 0),
      ),
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 500.ms,
        duration: 600.ms,
        begin: 0,
        end: 1,
      ),
    ],
  ),
  'containerOnPageLoadAnimation5': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 900.ms,
        duration: 600.ms,
        begin: const Offset(0, 80),
        end: const Offset(0, 0),
      ),
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 900.ms,
        duration: 600.ms,
        begin: 0,
        end: 1,
      ),
    ],
  ),
  'containerOnPageLoadAnimation6': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 1200.ms,
        duration: 600.ms,
        begin: 0,
        end: 1,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 1200.ms,
        duration: 600.ms,
        begin: const Offset(0, 20),
        end: const Offset(0, 0),
      ),
    ],
  ),
  'containerOnPageLoadAnimationFitness1': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 0.ms,
        duration: 600.ms,
        begin: 0,
        end: 1,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 0.ms,
        duration: 600.ms,
        begin: const Offset(0, 5),
        end: const Offset(0, 0),
      ),
    ],
  ),
  'containerOnPageLoadAnimationFitness2': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 200.ms,
        duration: 600.ms,
        begin: 0,
        end: 1,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 200.ms,
        duration: 600.ms,
        begin: const Offset(0, 10),
        end: const Offset(0, 0),
      ),
    ],
  ),
  'containerOnPageLoadAnimationFitness3': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 400.ms,
        duration: 600.ms,
        begin: 0,
        end: 1,
      ),
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 400.ms,
        duration: 600.ms,
        begin: const Offset(0, 10),
        end: const Offset(0, 0),
      ),
    ],
  ),
};

/*final Map<String, AnimationInfo> animationsMap = {
  'imageOnPageLoadAnimation': AnimationInfo(
    trigger: AnimationTrigger.onPageLoad,
    effects: [
      MoveEffect(
        curve: Curves.easeInOut,
        delay: 0.ms,
        duration: 600.ms,
        begin: const Offset(40, 0),
        end: const Offset(0, 0),
      ),
      FadeEffect(
        curve: Curves.easeInOut,
        delay: 0.ms,
        duration: 600.ms,
        begin: 0,
        end: 1,
      ),
    ],
  ),
};*/