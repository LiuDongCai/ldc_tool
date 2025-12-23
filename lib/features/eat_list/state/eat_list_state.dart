import 'package:ldc_tool/features/eat_list/state/eat_list_state_filter.dart';
import 'package:ldc_tool/features/eat_list/state/eat_list_state_list.dart';

class EatListState extends EatListCommonState
    with EatListStateFilter, EatListStateList {}

class EatListCommonState {}
