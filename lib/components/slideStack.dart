import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/scheduler.dart';
import 'package:async/async.dart';

enum SlideDirection {
  left,
  right,
}
typedef SlideChanged<double, SlideDirection> = void Function(
    double value, SlideDirection value2);

class SlideStack extends StatefulWidget {
  final Widget upper;
  final Widget under;

  final double slideDistance;
  final double rotateRate;
  final double scaleRate;

  final Duration scaleDuration;
  final double minAutoSlideDragVelocity;
  final VoidCallback onSlideStarted;
  final VoidCallback onSlideCompleted;
  final VoidCallback onSlideCanceled;
  final VoidCallback refreshBelow;

  final SlideChanged<double, SlideDirection> onSlide;

  const SlideStack({
    Key key,
    @required this.upper,
    @required this.under,
    @required this.slideDistance,
    this.rotateRate = 0.25,
    this.scaleRate = 1.08,
    this.scaleDuration = const Duration(milliseconds: 250),
    this.minAutoSlideDragVelocity = 600.0,
    this.onSlideStarted,
    this.onSlideCompleted,
    this.onSlideCanceled,
    this.refreshBelow,
    this.onSlide,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<SlideStack> with TickerProviderStateMixin {
  double elevation = 0.0;

  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = new AnimationController(
      vsync: this,
      duration: widget.scaleDuration,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller
              .animateTo(0.0, duration: widget.scaleDuration)
              .whenCompleteOrCancel(() {
            elevation = 0.0;
            if (widget.refreshBelow != null) widget.refreshBelow();
            setState(() {});
          });
        }
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void onSlide(value, direction) {
    if (widget.onSlide != null) widget.onSlide(value, direction);
    controller.value = value;
    setState(() {});
  }

  void onSlideStarted() {
    if (widget.onSlideStarted != null) widget.onSlideStarted();
    elevation = 1.0;
    setState(() {});
  }

  void onSlideCanceled() {
    if (widget.onSlideCanceled != null) widget.onSlideCanceled();
    elevation = 0.0;
    setState(() {});
  }

  double get _underScale => 1 + controller.value * (widget.scaleRate - 1.0);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: Transform.scale(
            scale: _underScale,
            child: Card(
              elevation: elevation,
              child: widget.under,
            ),
          ),
        ),
        Positioned.fill(
          child: SlideContainer(
            child: widget.upper,
            slideDistance: widget.slideDistance,
            rotateRate: widget.rotateRate,
            minAutoSlideDragVelocity: widget.minAutoSlideDragVelocity,
            reShowDuration: widget.scaleDuration,
            onSlideStarted: onSlideStarted,
            onSlideCompleted: widget.onSlideCompleted,
            onSlideCanceled: onSlideCanceled,
            onSlide: onSlide,
          ),
        ),
      ],
    );
  }
}

class SlideContainer extends StatefulWidget {
  final Widget child;
  final double slideDistance;
  final double rotateRate;
  final Duration reShowDuration;
  final double minAutoSlideDragVelocity;
  final VoidCallback onSlideStarted;
  final VoidCallback onSlideCompleted;
  final VoidCallback onSlideCanceled;
  final SlideChanged<double, SlideDirection> onSlide;

  SlideContainer({
    Key key,
    @required this.child,
    @required this.slideDistance,
    this.rotateRate = 0.25,
    this.minAutoSlideDragVelocity = 600.0,
    this.reShowDuration,
    this.onSlideStarted,
    this.onSlideCompleted,
    this.onSlideCanceled,
    this.onSlide,
  })  : assert(child != null),
        assert(rotateRate != null),
        assert(minAutoSlideDragVelocity != null),
        assert(reShowDuration != null),
        super(key: key);

  @override
  _ContainerState createState() => _ContainerState();
}

class _ContainerState extends State<SlideContainer>
    with TickerProviderStateMixin {
  final Map<Type, GestureRecognizerFactory> gestures =
      <Type, GestureRecognizerFactory>{};

  RestartableTimer timer;

  // User's finger move value.
  double dragValue = 0.0;

  // How long should the container move.
  double dragTarget = 0.0;
  bool isFirstDragFrame;
  AnimationController animationController;
  Ticker fingerTicker;

  double get maxDragDistance => widget.slideDistance;

  double get minAutoSlideDistance => maxDragDistance * 0.5;

  // The translation offset of the container.(decides the position of the container)
  double get containerOffset =>
      animationController.value *
      maxDragDistance *
      (1.0 + widget.rotateRate) *
      dragTarget.sign;

  set containerOffset(double value) {
    containerOffset = value;
  }

  @override
  void initState() {
    animationController =
        AnimationController(vsync: this, duration: widget.reShowDuration)
          ..addListener(() {
            if (widget.onSlide != null)
              widget.onSlide(animationController.value, slideDirection);
            setState(() {});
          });

    fingerTicker = createTicker((_) {
      if ((dragValue - dragTarget).abs() <= 1.0) {
        dragTarget = dragValue;
      } else {
        dragTarget += (dragValue - dragTarget);
      }
      animationController.value = dragTarget.abs() / maxDragDistance;
    });

    _registerGestureRecognizer();

    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    fingerTicker?.dispose();
    timer?.cancel();
    super.dispose();
  }

  GestureRecognizerFactoryWithHandlers<T>
      createGestureRecognizer<T extends DragGestureRecognizer>(
              GestureRecognizerFactoryConstructor<T> constructor) =>
          GestureRecognizerFactoryWithHandlers<T>(
            constructor,
            (T instance) {
              instance
                ..onStart = handleDragStart
                ..onUpdate = handleDragUpdate
                ..onEnd = handleDragEnd;
            },
          );

  void _registerGestureRecognizer() {
    gestures[HorizontalDragGestureRecognizer] =
        createGestureRecognizer<HorizontalDragGestureRecognizer>(
            () => HorizontalDragGestureRecognizer());
  }

  double getVelocity(DragEndDetails details) =>
      details.velocity.pixelsPerSecond.dx;

  double getDelta(DragUpdateDetails details) => details.delta.dx;

  void reShow() {
    setState(() {
      animationController.value = 0.0;
    });
  }

  void _startTimer() {
    if (timer == null) {
      timer = RestartableTimer(widget.reShowDuration, reShow);
    } else {
      timer.reset();
    }
  }

  void _completeSlide() => animationController.forward().then((_) {
        if (widget.onSlideCompleted != null) widget.onSlideCompleted();
        _startTimer();
      });

  void _cancelSlide() => animationController.reverse().then((_) {
        if (widget.onSlideCanceled != null) widget.onSlideCanceled();
      });

  void handleDragStart(DragStartDetails details) {
    isFirstDragFrame = true;
    dragValue = animationController.value * maxDragDistance * dragTarget.sign;
    dragTarget = dragValue;
    fingerTicker.start();
    if (widget.onSlideStarted != null) widget.onSlideStarted();
  }

  void handleDragUpdate(DragUpdateDetails details) {
    if (isFirstDragFrame) {
      isFirstDragFrame = false;
      return;
    }
    dragValue = (dragValue + getDelta(details))
        .clamp(-maxDragDistance, maxDragDistance);

    if (slideDirection == SlideDirection.left) {
      dragValue = dragValue.clamp(-maxDragDistance, 0.0);
    } else if (slideDirection == SlideDirection.right) {
      dragValue = dragValue.clamp(0.0, maxDragDistance);
    }
  }

  void handleDragEnd(DragEndDetails details) {
    if (getVelocity(details) * dragTarget.sign >
        widget.minAutoSlideDragVelocity) {
      _completeSlide();
    } else if (getVelocity(details) * dragTarget.sign <
        -widget.minAutoSlideDragVelocity) {
      _cancelSlide();
    } else {
      dragTarget.abs() > minAutoSlideDistance
          ? _completeSlide()
          : _cancelSlide();
    }
    fingerTicker.stop();
  }

  SlideDirection get slideDirection =>
      dragValue.isNegative ? SlideDirection.left : SlideDirection.right;

  double get rotation => animationController.value * widget.rotateRate;

  Matrix4 get transformMatrix => slideDirection == SlideDirection.left
      ? (Matrix4.rotationZ(rotation)..invertRotation())
      : (Matrix4.rotationZ(rotation));

  Widget _getContainer() {
    return Transform(
      child: Card(
        child: widget.child,
      ),
      transform: transformMatrix,
      alignment: FractionalOffset.center,
    );
  }

  @override
  Widget build(BuildContext context) => RawGestureDetector(
        gestures: gestures,
        child: Transform.translate(
          offset: Offset(
            containerOffset,
            0.0,
          ),
          child: _getContainer(),
        ),
      );
}
