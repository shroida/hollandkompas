// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReviewStats {

 int get total; int get dueToday; int get weakWords; int get mastered;
/// Create a copy of ReviewStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewStatsCopyWith<ReviewStats> get copyWith => _$ReviewStatsCopyWithImpl<ReviewStats>(this as ReviewStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewStats&&(identical(other.total, total) || other.total == total)&&(identical(other.dueToday, dueToday) || other.dueToday == dueToday)&&(identical(other.weakWords, weakWords) || other.weakWords == weakWords)&&(identical(other.mastered, mastered) || other.mastered == mastered));
}


@override
int get hashCode => Object.hash(runtimeType,total,dueToday,weakWords,mastered);

@override
String toString() {
  return 'ReviewStats(total: $total, dueToday: $dueToday, weakWords: $weakWords, mastered: $mastered)';
}


}

/// @nodoc
abstract mixin class $ReviewStatsCopyWith<$Res>  {
  factory $ReviewStatsCopyWith(ReviewStats value, $Res Function(ReviewStats) _then) = _$ReviewStatsCopyWithImpl;
@useResult
$Res call({
 int total, int dueToday, int weakWords, int mastered
});




}
/// @nodoc
class _$ReviewStatsCopyWithImpl<$Res>
    implements $ReviewStatsCopyWith<$Res> {
  _$ReviewStatsCopyWithImpl(this._self, this._then);

  final ReviewStats _self;
  final $Res Function(ReviewStats) _then;

/// Create a copy of ReviewStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? total = null,Object? dueToday = null,Object? weakWords = null,Object? mastered = null,}) {
  return _then(_self.copyWith(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,dueToday: null == dueToday ? _self.dueToday : dueToday // ignore: cast_nullable_to_non_nullable
as int,weakWords: null == weakWords ? _self.weakWords : weakWords // ignore: cast_nullable_to_non_nullable
as int,mastered: null == mastered ? _self.mastered : mastered // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewStats].
extension ReviewStatsPatterns on ReviewStats {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewStats() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewStats value)  $default,){
final _that = this;
switch (_that) {
case _ReviewStats():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewStats value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewStats() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int total,  int dueToday,  int weakWords,  int mastered)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewStats() when $default != null:
return $default(_that.total,_that.dueToday,_that.weakWords,_that.mastered);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int total,  int dueToday,  int weakWords,  int mastered)  $default,) {final _that = this;
switch (_that) {
case _ReviewStats():
return $default(_that.total,_that.dueToday,_that.weakWords,_that.mastered);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int total,  int dueToday,  int weakWords,  int mastered)?  $default,) {final _that = this;
switch (_that) {
case _ReviewStats() when $default != null:
return $default(_that.total,_that.dueToday,_that.weakWords,_that.mastered);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewStats implements ReviewStats {
  const _ReviewStats({required this.total, required this.dueToday, required this.weakWords, required this.mastered});
  

@override final  int total;
@override final  int dueToday;
@override final  int weakWords;
@override final  int mastered;

/// Create a copy of ReviewStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewStatsCopyWith<_ReviewStats> get copyWith => __$ReviewStatsCopyWithImpl<_ReviewStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewStats&&(identical(other.total, total) || other.total == total)&&(identical(other.dueToday, dueToday) || other.dueToday == dueToday)&&(identical(other.weakWords, weakWords) || other.weakWords == weakWords)&&(identical(other.mastered, mastered) || other.mastered == mastered));
}


@override
int get hashCode => Object.hash(runtimeType,total,dueToday,weakWords,mastered);

@override
String toString() {
  return 'ReviewStats(total: $total, dueToday: $dueToday, weakWords: $weakWords, mastered: $mastered)';
}


}

/// @nodoc
abstract mixin class _$ReviewStatsCopyWith<$Res> implements $ReviewStatsCopyWith<$Res> {
  factory _$ReviewStatsCopyWith(_ReviewStats value, $Res Function(_ReviewStats) _then) = __$ReviewStatsCopyWithImpl;
@override @useResult
$Res call({
 int total, int dueToday, int weakWords, int mastered
});




}
/// @nodoc
class __$ReviewStatsCopyWithImpl<$Res>
    implements _$ReviewStatsCopyWith<$Res> {
  __$ReviewStatsCopyWithImpl(this._self, this._then);

  final _ReviewStats _self;
  final $Res Function(_ReviewStats) _then;

/// Create a copy of ReviewStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? total = null,Object? dueToday = null,Object? weakWords = null,Object? mastered = null,}) {
  return _then(_ReviewStats(
total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as int,dueToday: null == dueToday ? _self.dueToday : dueToday // ignore: cast_nullable_to_non_nullable
as int,weakWords: null == weakWords ? _self.weakWords : weakWords // ignore: cast_nullable_to_non_nullable
as int,mastered: null == mastered ? _self.mastered : mastered // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
