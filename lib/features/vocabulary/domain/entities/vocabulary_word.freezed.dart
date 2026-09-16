// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary_word.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$VocabularyWord {

 String get id; String get dutchWord; String get arabicMeaning; String? get englishMeaning; String get level; String get category; DateTime? get createdAt; bool get isFavorite; VocabularyProgressStatus get progressStatus;
/// Create a copy of VocabularyWord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularyWordCopyWith<VocabularyWord> get copyWith => _$VocabularyWordCopyWithImpl<VocabularyWord>(this as VocabularyWord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabularyWord&&(identical(other.id, id) || other.id == id)&&(identical(other.dutchWord, dutchWord) || other.dutchWord == dutchWord)&&(identical(other.arabicMeaning, arabicMeaning) || other.arabicMeaning == arabicMeaning)&&(identical(other.englishMeaning, englishMeaning) || other.englishMeaning == englishMeaning)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.progressStatus, progressStatus) || other.progressStatus == progressStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,dutchWord,arabicMeaning,englishMeaning,level,category,createdAt,isFavorite,progressStatus);

@override
String toString() {
  return 'VocabularyWord(id: $id, dutchWord: $dutchWord, arabicMeaning: $arabicMeaning, englishMeaning: $englishMeaning, level: $level, category: $category, createdAt: $createdAt, isFavorite: $isFavorite, progressStatus: $progressStatus)';
}


}

/// @nodoc
abstract mixin class $VocabularyWordCopyWith<$Res>  {
  factory $VocabularyWordCopyWith(VocabularyWord value, $Res Function(VocabularyWord) _then) = _$VocabularyWordCopyWithImpl;
@useResult
$Res call({
 String id, String dutchWord, String arabicMeaning, String? englishMeaning, String level, String category, DateTime? createdAt, bool isFavorite, VocabularyProgressStatus progressStatus
});




}
/// @nodoc
class _$VocabularyWordCopyWithImpl<$Res>
    implements $VocabularyWordCopyWith<$Res> {
  _$VocabularyWordCopyWithImpl(this._self, this._then);

  final VocabularyWord _self;
  final $Res Function(VocabularyWord) _then;

/// Create a copy of VocabularyWord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dutchWord = null,Object? arabicMeaning = null,Object? englishMeaning = freezed,Object? level = null,Object? category = null,Object? createdAt = freezed,Object? isFavorite = null,Object? progressStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dutchWord: null == dutchWord ? _self.dutchWord : dutchWord // ignore: cast_nullable_to_non_nullable
as String,arabicMeaning: null == arabicMeaning ? _self.arabicMeaning : arabicMeaning // ignore: cast_nullable_to_non_nullable
as String,englishMeaning: freezed == englishMeaning ? _self.englishMeaning : englishMeaning // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,progressStatus: null == progressStatus ? _self.progressStatus : progressStatus // ignore: cast_nullable_to_non_nullable
as VocabularyProgressStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [VocabularyWord].
extension VocabularyWordPatterns on VocabularyWord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VocabularyWord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VocabularyWord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VocabularyWord value)  $default,){
final _that = this;
switch (_that) {
case _VocabularyWord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VocabularyWord value)?  $default,){
final _that = this;
switch (_that) {
case _VocabularyWord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String dutchWord,  String arabicMeaning,  String? englishMeaning,  String level,  String category,  DateTime? createdAt,  bool isFavorite,  VocabularyProgressStatus progressStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabularyWord() when $default != null:
return $default(_that.id,_that.dutchWord,_that.arabicMeaning,_that.englishMeaning,_that.level,_that.category,_that.createdAt,_that.isFavorite,_that.progressStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String dutchWord,  String arabicMeaning,  String? englishMeaning,  String level,  String category,  DateTime? createdAt,  bool isFavorite,  VocabularyProgressStatus progressStatus)  $default,) {final _that = this;
switch (_that) {
case _VocabularyWord():
return $default(_that.id,_that.dutchWord,_that.arabicMeaning,_that.englishMeaning,_that.level,_that.category,_that.createdAt,_that.isFavorite,_that.progressStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String dutchWord,  String arabicMeaning,  String? englishMeaning,  String level,  String category,  DateTime? createdAt,  bool isFavorite,  VocabularyProgressStatus progressStatus)?  $default,) {final _that = this;
switch (_that) {
case _VocabularyWord() when $default != null:
return $default(_that.id,_that.dutchWord,_that.arabicMeaning,_that.englishMeaning,_that.level,_that.category,_that.createdAt,_that.isFavorite,_that.progressStatus);case _:
  return null;

}
}

}

/// @nodoc


class _VocabularyWord implements VocabularyWord {
  const _VocabularyWord({required this.id, required this.dutchWord, required this.arabicMeaning, this.englishMeaning, required this.level, required this.category, this.createdAt, this.isFavorite = false, this.progressStatus = VocabularyProgressStatus.newWord});
  

@override final  String id;
@override final  String dutchWord;
@override final  String arabicMeaning;
@override final  String? englishMeaning;
@override final  String level;
@override final  String category;
@override final  DateTime? createdAt;
@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  VocabularyProgressStatus progressStatus;

/// Create a copy of VocabularyWord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabularyWordCopyWith<_VocabularyWord> get copyWith => __$VocabularyWordCopyWithImpl<_VocabularyWord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabularyWord&&(identical(other.id, id) || other.id == id)&&(identical(other.dutchWord, dutchWord) || other.dutchWord == dutchWord)&&(identical(other.arabicMeaning, arabicMeaning) || other.arabicMeaning == arabicMeaning)&&(identical(other.englishMeaning, englishMeaning) || other.englishMeaning == englishMeaning)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.progressStatus, progressStatus) || other.progressStatus == progressStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,dutchWord,arabicMeaning,englishMeaning,level,category,createdAt,isFavorite,progressStatus);

@override
String toString() {
  return 'VocabularyWord(id: $id, dutchWord: $dutchWord, arabicMeaning: $arabicMeaning, englishMeaning: $englishMeaning, level: $level, category: $category, createdAt: $createdAt, isFavorite: $isFavorite, progressStatus: $progressStatus)';
}


}

/// @nodoc
abstract mixin class _$VocabularyWordCopyWith<$Res> implements $VocabularyWordCopyWith<$Res> {
  factory _$VocabularyWordCopyWith(_VocabularyWord value, $Res Function(_VocabularyWord) _then) = __$VocabularyWordCopyWithImpl;
@override @useResult
$Res call({
 String id, String dutchWord, String arabicMeaning, String? englishMeaning, String level, String category, DateTime? createdAt, bool isFavorite, VocabularyProgressStatus progressStatus
});




}
/// @nodoc
class __$VocabularyWordCopyWithImpl<$Res>
    implements _$VocabularyWordCopyWith<$Res> {
  __$VocabularyWordCopyWithImpl(this._self, this._then);

  final _VocabularyWord _self;
  final $Res Function(_VocabularyWord) _then;

/// Create a copy of VocabularyWord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dutchWord = null,Object? arabicMeaning = null,Object? englishMeaning = freezed,Object? level = null,Object? category = null,Object? createdAt = freezed,Object? isFavorite = null,Object? progressStatus = null,}) {
  return _then(_VocabularyWord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dutchWord: null == dutchWord ? _self.dutchWord : dutchWord // ignore: cast_nullable_to_non_nullable
as String,arabicMeaning: null == arabicMeaning ? _self.arabicMeaning : arabicMeaning // ignore: cast_nullable_to_non_nullable
as String,englishMeaning: freezed == englishMeaning ? _self.englishMeaning : englishMeaning // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,progressStatus: null == progressStatus ? _self.progressStatus : progressStatus // ignore: cast_nullable_to_non_nullable
as VocabularyProgressStatus,
  ));
}


}

// dart format on
