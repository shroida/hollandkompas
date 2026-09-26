// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'flashcard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Flashcard {

 String get id; String get dutchWord; String get arabicMeaning; String? get englishMeaning; String get level; String get category; DateTime? get createdAt; bool get isFavorite; String get status; int get reviewCount; int get intervalDays; DateTime? get nextReviewAt; DateTime? get lastReviewedAt; int get forgetCount;
/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlashcardCopyWith<Flashcard> get copyWith => _$FlashcardCopyWithImpl<Flashcard>(this as Flashcard, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Flashcard&&(identical(other.id, id) || other.id == id)&&(identical(other.dutchWord, dutchWord) || other.dutchWord == dutchWord)&&(identical(other.arabicMeaning, arabicMeaning) || other.arabicMeaning == arabicMeaning)&&(identical(other.englishMeaning, englishMeaning) || other.englishMeaning == englishMeaning)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.status, status) || other.status == status)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.intervalDays, intervalDays) || other.intervalDays == intervalDays)&&(identical(other.nextReviewAt, nextReviewAt) || other.nextReviewAt == nextReviewAt)&&(identical(other.lastReviewedAt, lastReviewedAt) || other.lastReviewedAt == lastReviewedAt)&&(identical(other.forgetCount, forgetCount) || other.forgetCount == forgetCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,dutchWord,arabicMeaning,englishMeaning,level,category,createdAt,isFavorite,status,reviewCount,intervalDays,nextReviewAt,lastReviewedAt,forgetCount);

@override
String toString() {
  return 'Flashcard(id: $id, dutchWord: $dutchWord, arabicMeaning: $arabicMeaning, englishMeaning: $englishMeaning, level: $level, category: $category, createdAt: $createdAt, isFavorite: $isFavorite, status: $status, reviewCount: $reviewCount, intervalDays: $intervalDays, nextReviewAt: $nextReviewAt, lastReviewedAt: $lastReviewedAt, forgetCount: $forgetCount)';
}


}

/// @nodoc
abstract mixin class $FlashcardCopyWith<$Res>  {
  factory $FlashcardCopyWith(Flashcard value, $Res Function(Flashcard) _then) = _$FlashcardCopyWithImpl;
@useResult
$Res call({
 String id, String dutchWord, String arabicMeaning, String? englishMeaning, String level, String category, DateTime? createdAt, bool isFavorite, String status, int reviewCount, int intervalDays, DateTime? nextReviewAt, DateTime? lastReviewedAt, int forgetCount
});




}
/// @nodoc
class _$FlashcardCopyWithImpl<$Res>
    implements $FlashcardCopyWith<$Res> {
  _$FlashcardCopyWithImpl(this._self, this._then);

  final Flashcard _self;
  final $Res Function(Flashcard) _then;

/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dutchWord = null,Object? arabicMeaning = null,Object? englishMeaning = freezed,Object? level = null,Object? category = null,Object? createdAt = freezed,Object? isFavorite = null,Object? status = null,Object? reviewCount = null,Object? intervalDays = null,Object? nextReviewAt = freezed,Object? lastReviewedAt = freezed,Object? forgetCount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dutchWord: null == dutchWord ? _self.dutchWord : dutchWord // ignore: cast_nullable_to_non_nullable
as String,arabicMeaning: null == arabicMeaning ? _self.arabicMeaning : arabicMeaning // ignore: cast_nullable_to_non_nullable
as String,englishMeaning: freezed == englishMeaning ? _self.englishMeaning : englishMeaning // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,intervalDays: null == intervalDays ? _self.intervalDays : intervalDays // ignore: cast_nullable_to_non_nullable
as int,nextReviewAt: freezed == nextReviewAt ? _self.nextReviewAt : nextReviewAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastReviewedAt: freezed == lastReviewedAt ? _self.lastReviewedAt : lastReviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,forgetCount: null == forgetCount ? _self.forgetCount : forgetCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Flashcard].
extension FlashcardPatterns on Flashcard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Flashcard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Flashcard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Flashcard value)  $default,){
final _that = this;
switch (_that) {
case _Flashcard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Flashcard value)?  $default,){
final _that = this;
switch (_that) {
case _Flashcard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String dutchWord,  String arabicMeaning,  String? englishMeaning,  String level,  String category,  DateTime? createdAt,  bool isFavorite,  String status,  int reviewCount,  int intervalDays,  DateTime? nextReviewAt,  DateTime? lastReviewedAt,  int forgetCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Flashcard() when $default != null:
return $default(_that.id,_that.dutchWord,_that.arabicMeaning,_that.englishMeaning,_that.level,_that.category,_that.createdAt,_that.isFavorite,_that.status,_that.reviewCount,_that.intervalDays,_that.nextReviewAt,_that.lastReviewedAt,_that.forgetCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String dutchWord,  String arabicMeaning,  String? englishMeaning,  String level,  String category,  DateTime? createdAt,  bool isFavorite,  String status,  int reviewCount,  int intervalDays,  DateTime? nextReviewAt,  DateTime? lastReviewedAt,  int forgetCount)  $default,) {final _that = this;
switch (_that) {
case _Flashcard():
return $default(_that.id,_that.dutchWord,_that.arabicMeaning,_that.englishMeaning,_that.level,_that.category,_that.createdAt,_that.isFavorite,_that.status,_that.reviewCount,_that.intervalDays,_that.nextReviewAt,_that.lastReviewedAt,_that.forgetCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String dutchWord,  String arabicMeaning,  String? englishMeaning,  String level,  String category,  DateTime? createdAt,  bool isFavorite,  String status,  int reviewCount,  int intervalDays,  DateTime? nextReviewAt,  DateTime? lastReviewedAt,  int forgetCount)?  $default,) {final _that = this;
switch (_that) {
case _Flashcard() when $default != null:
return $default(_that.id,_that.dutchWord,_that.arabicMeaning,_that.englishMeaning,_that.level,_that.category,_that.createdAt,_that.isFavorite,_that.status,_that.reviewCount,_that.intervalDays,_that.nextReviewAt,_that.lastReviewedAt,_that.forgetCount);case _:
  return null;

}
}

}

/// @nodoc


class _Flashcard implements Flashcard {
  const _Flashcard({required this.id, required this.dutchWord, required this.arabicMeaning, this.englishMeaning, required this.level, required this.category, this.createdAt, this.isFavorite = false, this.status = 'new', this.reviewCount = 0, this.intervalDays = 0, this.nextReviewAt, this.lastReviewedAt, this.forgetCount = 0});
  

@override final  String id;
@override final  String dutchWord;
@override final  String arabicMeaning;
@override final  String? englishMeaning;
@override final  String level;
@override final  String category;
@override final  DateTime? createdAt;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  String status;
@override@JsonKey() final  int reviewCount;
@override@JsonKey() final  int intervalDays;
@override final  DateTime? nextReviewAt;
@override final  DateTime? lastReviewedAt;
@override@JsonKey() final  int forgetCount;

/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlashcardCopyWith<_Flashcard> get copyWith => __$FlashcardCopyWithImpl<_Flashcard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Flashcard&&(identical(other.id, id) || other.id == id)&&(identical(other.dutchWord, dutchWord) || other.dutchWord == dutchWord)&&(identical(other.arabicMeaning, arabicMeaning) || other.arabicMeaning == arabicMeaning)&&(identical(other.englishMeaning, englishMeaning) || other.englishMeaning == englishMeaning)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.status, status) || other.status == status)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.intervalDays, intervalDays) || other.intervalDays == intervalDays)&&(identical(other.nextReviewAt, nextReviewAt) || other.nextReviewAt == nextReviewAt)&&(identical(other.lastReviewedAt, lastReviewedAt) || other.lastReviewedAt == lastReviewedAt)&&(identical(other.forgetCount, forgetCount) || other.forgetCount == forgetCount));
}


@override
int get hashCode => Object.hash(runtimeType,id,dutchWord,arabicMeaning,englishMeaning,level,category,createdAt,isFavorite,status,reviewCount,intervalDays,nextReviewAt,lastReviewedAt,forgetCount);

@override
String toString() {
  return 'Flashcard(id: $id, dutchWord: $dutchWord, arabicMeaning: $arabicMeaning, englishMeaning: $englishMeaning, level: $level, category: $category, createdAt: $createdAt, isFavorite: $isFavorite, status: $status, reviewCount: $reviewCount, intervalDays: $intervalDays, nextReviewAt: $nextReviewAt, lastReviewedAt: $lastReviewedAt, forgetCount: $forgetCount)';
}


}

/// @nodoc
abstract mixin class _$FlashcardCopyWith<$Res> implements $FlashcardCopyWith<$Res> {
  factory _$FlashcardCopyWith(_Flashcard value, $Res Function(_Flashcard) _then) = __$FlashcardCopyWithImpl;
@override @useResult
$Res call({
 String id, String dutchWord, String arabicMeaning, String? englishMeaning, String level, String category, DateTime? createdAt, bool isFavorite, String status, int reviewCount, int intervalDays, DateTime? nextReviewAt, DateTime? lastReviewedAt, int forgetCount
});




}
/// @nodoc
class __$FlashcardCopyWithImpl<$Res>
    implements _$FlashcardCopyWith<$Res> {
  __$FlashcardCopyWithImpl(this._self, this._then);

  final _Flashcard _self;
  final $Res Function(_Flashcard) _then;

/// Create a copy of Flashcard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dutchWord = null,Object? arabicMeaning = null,Object? englishMeaning = freezed,Object? level = null,Object? category = null,Object? createdAt = freezed,Object? isFavorite = null,Object? status = null,Object? reviewCount = null,Object? intervalDays = null,Object? nextReviewAt = freezed,Object? lastReviewedAt = freezed,Object? forgetCount = null,}) {
  return _then(_Flashcard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dutchWord: null == dutchWord ? _self.dutchWord : dutchWord // ignore: cast_nullable_to_non_nullable
as String,arabicMeaning: null == arabicMeaning ? _self.arabicMeaning : arabicMeaning // ignore: cast_nullable_to_non_nullable
as String,englishMeaning: freezed == englishMeaning ? _self.englishMeaning : englishMeaning // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,intervalDays: null == intervalDays ? _self.intervalDays : intervalDays // ignore: cast_nullable_to_non_nullable
as int,nextReviewAt: freezed == nextReviewAt ? _self.nextReviewAt : nextReviewAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastReviewedAt: freezed == lastReviewedAt ? _self.lastReviewedAt : lastReviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,forgetCount: null == forgetCount ? _self.forgetCount : forgetCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
