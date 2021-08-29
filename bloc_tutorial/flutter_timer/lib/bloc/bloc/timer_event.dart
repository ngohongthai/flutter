part of 'timer_bloc.dart';

@immutable
abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object?> get props => [];
}

// TimerStarted - informs the TimerBloc that the timer should be started.
class TimerStarted extends TimerEvent {
  const TimerStarted({required this.duration});
  final int duration;
}

// TimerPaused — informs the TimerBloc that the timer should be paused.
class TimerPaused extends TimerEvent {
  const TimerPaused();
}

// TimerResumed — informs the TimerBloc that the timer should be resumed.
class TimerResumed extends TimerEvent {
  const TimerResumed();
}

// TimerReset — informs the TimerBloc that the timer should be reset to the original state.
class TimerReset extends TimerEvent {
  const TimerReset();
}

// TimerTicked — informs the TimerBloc that a tick has occurred and that it needs to update its state accordingly.
class TimerTicked extends TimerEvent {
  const TimerTicked({required this.duration});
  final int duration;

  @override
  List<Object> get props => [duration];
}
