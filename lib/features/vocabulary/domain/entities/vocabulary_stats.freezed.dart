// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VocabularyStats {

 int get totalWords; int get masteredWords; int get learningWords; int get newWords;
/// Create a copy of VocabularyStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularyStatsCopyWith<VocabularyStats> get copyWith => _$VocabularyStatsCopyWithImpl<VocabularyStats>(this as VocabularyStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabularyStats&&(identical(other.totalWords, totalWords) || other.totalWords == totalWords)&&(identical(other.masteredWords, masteredWords) || other.masteredWords == masteredWords)&&(identical(other.learningWords, learningWords) || other.learningWords == learningWords)&&(identical(other.newWords, newWords) || other.newWords == newWords));
}


@override
int get hashCode => Object.hash(runtimeType,totalWords,masteredWords,learningWords,newWords);

@override
String toString() {
  return 'VocabularyStats(totalWords: $totalWords, masteredWords: $masteredWords, learningWords: $learningWords, newWords: $newWords)';
}


}

/// @nodoc
abstract mixin class $VocabularyStatsCopyWith<$Res>  {
  factory $VocabularyStatsCopyWith(VocabularyStats value, $Res Function(VocabularyStats) _then) = _$VocabularyStatsCopyWithImpl;
@useResult
$Res call({
 int totalWords, int masteredWords, int learningWords, int newWords
});




}
/// @nodoc
class _$VocabularyStatsCopyWithImpl<$Res>
    implements $VocabularyStatsCopyWith<$Res> {
  _$VocabularyStatsCopyWithImpl(this._self, this._then);

  final VocabularyStats _self;
  final $Res Function(VocabularyStats) _then;

/// Create a copy of VocabularyStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalWords = null,Object? masteredWords = null,Object? learningWords = null,Object? newWords = null,}) {
  return _then(_self.copyWith(
totalWords: null == totalWords ? _self.totalWords : totalWords // ignore: cast_nullable_to_non_nullable
as int,masteredWords: null == masteredWords ? _self.masteredWords : masteredWords // ignore: cast_nullable_to_non_nullable
as int,learningWords: null == learningWords ? _self.learningWords : learningWords // ignore: cast_nullable_to_non_nullable
as int,newWords: null == newWords ? _self.newWords : newWords // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [VocabularyStats].
extension VocabularyStatsPatterns on VocabularyStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VocabularyStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VocabularyStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VocabularyStats value)  $default,){
final _that = this;
switch (_that) {
case _VocabularyStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VocabularyStats value)?  $default,){
final _that = this;
switch (_that) {
case _VocabularyStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalWords,  int masteredWords,  int learningWords,  int newWords)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabularyStats() when $default != null:
return $default(_that.totalWords,_that.masteredWords,_that.learningWords,_that.newWords);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalWords,  int masteredWords,  int learningWords,  int newWords)  $default,) {final _that = this;
switch (_that) {
case _VocabularyStats():
return $default(_that.totalWords,_that.masteredWords,_that.learningWords,_that.newWords);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalWords,  int masteredWords,  int learningWords,  int newWords)?  $default,) {final _that = this;
switch (_that) {
case _VocabularyStats() when $default != null:
return $default(_that.totalWords,_that.masteredWords,_that.learningWords,_that.newWords);case _:
  return null;

}
}

}

/// @nodoc


class _VocabularyStats extends VocabularyStats {
  const _VocabularyStats({required this.totalWords, required this.masteredWords, required this.learningWords, required this.newWords}): super._();
  

@override final  int totalWords;
@override final  int masteredWords;
@override final  int learningWords;
@override final  int newWords;

/// Create a copy of VocabularyStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabularyStatsCopyWith<_VocabularyStats> get copyWith => __$VocabularyStatsCopyWithImpl<_VocabularyStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabularyStats&&(identical(other.totalWords, totalWords) || other.totalWords == totalWords)&&(identical(other.masteredWords, masteredWords) || other.masteredWords == masteredWords)&&(identical(other.learningWords, learningWords) || other.learningWords == learningWords)&&(identical(other.newWords, newWords) || other.newWords == newWords));
}


@override
int get hashCode => Object.hash(runtimeType,totalWords,masteredWords,learningWords,newWords);

@override
String toString() {
  return 'VocabularyStats(totalWords: $totalWords, masteredWords: $masteredWords, learningWords: $learningWords, newWords: $newWords)';
}


}

/// @nodoc
abstract mixin class _$VocabularyStatsCopyWith<$Res> implements $VocabularyStatsCopyWith<$Res> {
  factory _$VocabularyStatsCopyWith(_VocabularyStats value, $Res Function(_VocabularyStats) _then) = __$VocabularyStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalWords, int masteredWords, int learningWords, int newWords
});




}
/// @nodoc
class __$VocabularyStatsCopyWithImpl<$Res>
    implements _$VocabularyStatsCopyWith<$Res> {
  __$VocabularyStatsCopyWithImpl(this._self, this._then);

  final _VocabularyStats _self;
  final $Res Function(_VocabularyStats) _then;

/// Create a copy of VocabularyStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalWords = null,Object? masteredWords = null,Object? learningWords = null,Object? newWords = null,}) {
  return _then(_VocabularyStats(
totalWords: null == totalWords ? _self.totalWords : totalWords // ignore: cast_nullable_to_non_nullable
as int,masteredWords: null == masteredWords ? _self.masteredWords : masteredWords // ignore: cast_nullable_to_non_nullable
as int,learningWords: null == learningWords ? _self.learningWords : learningWords // ignore: cast_nullable_to_non_nullable
as int,newWords: null == newWords ? _self.newWords : newWords // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
