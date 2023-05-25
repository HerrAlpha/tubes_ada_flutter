import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'counter_state.dart';

class CounterCubit extends Cubit<CounterInitial> {
  CounterCubit() : super(CounterInitial(counterValue : 1));

  void increment() {
    emit(CounterInitial(counterValue: state.counterValue + 1));
  }

  void decrement() {
    if(state.counterValue != 0){
      emit(CounterInitial(counterValue: state.counterValue - 1));
    }
  }
  void reset() {
    if(state.counterValue != 0){
      emit(CounterInitial(counterValue: 1));
    }
  }
}