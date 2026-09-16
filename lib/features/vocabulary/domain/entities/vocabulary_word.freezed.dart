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

 String get id; String get dutchWord; String get arabicMeaning; VocabularyLevel get level; VocabularyCategory get category; String? get germanMeaning; String? get pronunciation; String? get exampleSentenceDutch; String? get exampleSentenceArabic; List<String> get synonyms; List<String> get antonyms; bool get isFavorite; VocabularyProgressStatus get progressStatus;
/// Create a copy of VocabularyWord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularyWordCopyWith<VocabularyWord> get copyWith => _$VocabularyWordCopyWithImpl<VocabularyWord>(this as VocabularyWord, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabularyWord&&(identical(other.id, id) || other.id == id)&&(identical(other.dutchWord, dutchWord) || other.dutchWord == dutchWord)&&(identical(other.arabicMeaning, arabicMeaning) || other.arabicMeaning == arabicMeaning)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.germanMeaning, germanMeaning) || other.germanMeaning == germanMeaning)&&(identical(other.pronunciation, pronunciation) || other.pronunciation == pronunciation)&&(identical(other.exampleSentenceDutch, exampleSentenceDutch) || other.exampleSentenceDutch == exampleSentenceDutch)&&(identical(other.exampleSentenceArabic, exampleSentenceArabic) || other.exampleSentenceArabic == exampleSentenceArabic)&&const DeepCollectionEquality().equals(other.synonyms, synonyms)&&const DeepCollectionEquality().equals(other.antonyms, antonyms)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.progressStatus, progressStatus) || other.progressStatus == progressStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,dutchWord,arabicMeaning,level,category,germanMeaning,pronunciation,exampleSentenceDutch,exampleSentenceArabic,const DeepCollectionEquality().hash(synonyms),const DeepCollectionEquality().hash(antonyms),isFavorite,progressStatus);

@override
String toString() {
  return 'VocabularyWord(id: $id, dutchWord: $dutchWord, arabicMeaning: $arabicMeaning, level: $level, category: $category, germanMeaning: $germanMeaning, pronunciation: $pronunciation, exampleSentenceDutch: $exampleSentenceDutch, exampleSentenceArabic: $exampleSentenceArabic, synonyms: $synonyms, antonyms: $antonyms, isFavorite: $isFavorite, progressStatus: $progressStatus)';
}


}

/// @nodoc
abstract mixin class $VocabularyWordCopyWith<$Res>  {
  factory $VocabularyWordCopyWith(VocabularyWord value, $Res Function(VocabularyWord) _then) = _$VocabularyWordCopyWithImpl;
@useResult
$Res call({
 String id, String dutchWord, String arabicMeaning, VocabularyLevel level, VocabularyCategory category, String? germanMeaning, String? pronunciation, String? exampleSentenceDutch, String? exampleSentenceArabic, List<String> synonyms, List<String> antonyms, bool isFavorite, VocabularyProgressStatus progressStatus
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dutchWord = null,Object? arabicMeaning = null,Object? level = null,Object? category = null,Object? germanMeaning = freezed,Object? pronunciation = freezed,Object? exampleSentenceDutch = freezed,Object? exampleSentenceArabic = freezed,Object? synonyms = null,Object? antonyms = null,Object? isFavorite = null,Object? progressStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dutchWord: null == dutchWord ? _self.dutchWord : dutchWord // ignore: cast_nullable_to_non_nullable
as String,arabicMeaning: null == arabicMeaning ? _self.arabicMeaning : arabicMeaning // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as VocabularyLevel,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as VocabularyCategory,germanMeaning: freezed == germanMeaning ? _self.germanMeaning : germanMeaning // ignore: cast_nullable_to_non_nullable
as String?,pronunciation: freezed == pronunciation ? _self.pronunciation : pronunciation // ignore: cast_nullable_to_non_nullable
as String?,exampleSentenceDutch: freezed == exampleSentenceDutch ? _self.exampleSentenceDutch : exampleSentenceDutch // ignore: cast_nullable_to_non_nullable
as String?,exampleSentenceArabic: freezed == exampleSentenceArabic ? _self.exampleSentenceArabic : exampleSentenceArabic // ignore: cast_nullable_to_non_nullable
as String?,synonyms: null == synonyms ? _self.synonyms : synonyms // ignore: cast_nullable_to_non_nullable
as List<String>,antonyms: null == antonyms ? _self.antonyms : antonyms // ignore: cast_nullable_to_non_nullable
as List<String>,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String dutchWord,  String arabicMeaning,  VocabularyLevel level,  VocabularyCategory category,  String? germanMeaning,  String? pronunciation,  String? exampleSentenceDutch,  String? exampleSentenceArabic,  List<String> synonyms,  List<String> antonyms,  bool isFavorite,  VocabularyProgressStatus progressStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabularyWord() when $default != null:
return $default(_that.id,_that.dutchWord,_that.arabicMeaning,_that.level,_that.category,_that.germanMeaning,_that.pronunciation,_that.exampleSentenceDutch,_that.exampleSentenceArabic,_that.synonyms,_that.antonyms,_that.isFavorite,_that.progressStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String dutchWord,  String arabicMeaning,  VocabularyLevel level,  VocabularyCategory category,  String? germanMeaning,  String? pronunciation,  String? exampleSentenceDutch,  String? exampleSentenceArabic,  List<String> synonyms,  List<String> antonyms,  bool isFavorite,  VocabularyProgressStatus progressStatus)  $default,) {final _that = this;
switch (_that) {
case _VocabularyWord():
return $default(_that.id,_that.dutchWord,_that.arabicMeaning,_that.level,_that.category,_that.germanMeaning,_that.pronunciation,_that.exampleSentenceDutch,_that.exampleSentenceArabic,_that.synonyms,_that.antonyms,_that.isFavorite,_that.progressStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String dutchWord,  String arabicMeaning,  VocabularyLevel level,  VocabularyCategory category,  String? germanMeaning,  String? pronunciation,  String? exampleSentenceDutch,  String? exampleSentenceArabic,  List<String> synonyms,  List<String> antonyms,  bool isFavorite,  VocabularyProgressStatus progressStatus)?  $default,) {final _that = this;
switch (_that) {
case _VocabularyWord() when $default != null:
return $default(_that.id,_that.dutchWord,_that.arabicMeaning,_that.level,_that.category,_that.germanMeaning,_that.pronunciation,_that.exampleSentenceDutch,_that.exampleSentenceArabic,_that.synonyms,_that.antonyms,_that.isFavorite,_that.progressStatus);case _:
  return null;

}
}

}

/// @nodoc


class _VocabularyWord implements VocabularyWord {
  const _VocabularyWord({required this.id, required this.dutchWord, required this.arabicMeaning, required this.level, required this.category, this.germanMeaning, this.pronunciation, this.exampleSentenceDutch, this.exampleSentenceArabic, final  List<String> synonyms = const <String>[], final  List<String> antonyms = const <String>[], this.isFavorite = false, this.progressStatus = VocabularyProgressStatus.newWord}): _synonyms = synonyms,_antonyms = antonyms;
  

@override final  String id;
@override final  String dutchWord;
@override final  String arabicMeaning;
@override final  VocabularyLevel level;
@override final  VocabularyCategory category;
@override final  String? germanMeaning;
@override final  String? pronunciation;
@override final  String? exampleSentenceDutch;
@override final  String? exampleSentenceArabic;
 final  List<String> _synonyms;
@override@JsonKey() List<String> get synonyms {
  if (_synonyms is EqualUnmodifiableListView) return _synonyms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_synonyms);
}

 final  List<String> _antonyms;
@override@JsonKey() List<String> get antonyms {
  if (_antonyms is EqualUnmodifiableListView) return _antonyms;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_antonyms);
}

@override@JsonKey() final  bool isFavorite;
@override@JsonKey() final  VocabularyProgressStatus progressStatus;

/// Create a copy of VocabularyWord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabularyWordCopyWith<_VocabularyWord> get copyWith => __$VocabularyWordCopyWithImpl<_VocabularyWord>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabularyWord&&(identical(other.id, id) || other.id == id)&&(identical(other.dutchWord, dutchWord) || other.dutchWord == dutchWord)&&(identical(other.arabicMeaning, arabicMeaning) || other.arabicMeaning == arabicMeaning)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.germanMeaning, germanMeaning) || other.germanMeaning == germanMeaning)&&(identical(other.pronunciation, pronunciation) || other.pronunciation == pronunciation)&&(identical(other.exampleSentenceDutch, exampleSentenceDutch) || other.exampleSentenceDutch == exampleSentenceDutch)&&(identical(other.exampleSentenceArabic, exampleSentenceArabic) || other.exampleSentenceArabic == exampleSentenceArabic)&&const DeepCollectionEquality().equals(other._synonyms, _synonyms)&&const DeepCollectionEquality().equals(other._antonyms, _antonyms)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.progressStatus, progressStatus) || other.progressStatus == progressStatus));
}


@override
int get hashCode => Object.hash(runtimeType,id,dutchWord,arabicMeaning,level,category,germanMeaning,pronunciation,exampleSentenceDutch,exampleSentenceArabic,const DeepCollectionEquality().hash(_synonyms),const DeepCollectionEquality().hash(_antonyms),isFavorite,progressStatus);

@override
String toString() {
  return 'VocabularyWord(id: $id, dutchWord: $dutchWord, arabicMeaning: $arabicMeaning, level: $level, category: $category, germanMeaning: $germanMeaning, pronunciation: $pronunciation, exampleSentenceDutch: $exampleSentenceDutch, exampleSentenceArabic: $exampleSentenceArabic, synonyms: $synonyms, antonyms: $antonyms, isFavorite: $isFavorite, progressStatus: $progressStatus)';
}


}

/// @nodoc
abstract mixin class _$VocabularyWordCopyWith<$Res> implements $VocabularyWordCopyWith<$Res> {
  factory _$VocabularyWordCopyWith(_VocabularyWord value, $Res Function(_VocabularyWord) _then) = __$VocabularyWordCopyWithImpl;
@override @useResult
$Res call({
 String id, String dutchWord, String arabicMeaning, VocabularyLevel level, VocabularyCategory category, String? germanMeaning, String? pronunciation, String? exampleSentenceDutch, String? exampleSentenceArabic, List<String> synonyms, List<String> antonyms, bool isFavorite, VocabularyProgressStatus progressStatus
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dutchWord = null,Object? arabicMeaning = null,Object? level = null,Object? category = null,Object? germanMeaning = freezed,Object? pronunciation = freezed,Object? exampleSentenceDutch = freezed,Object? exampleSentenceArabic = freezed,Object? synonyms = null,Object? antonyms = null,Object? isFavorite = null,Object? progressStatus = null,}) {
  return _then(_VocabularyWord(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dutchWord: null == dutchWord ? _self.dutchWord : dutchWord // ignore: cast_nullable_to_non_nullable
as String,arabicMeaning: null == arabicMeaning ? _self.arabicMeaning : arabicMeaning // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as VocabularyLevel,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as VocabularyCategory,germanMeaning: freezed == germanMeaning ? _self.germanMeaning : germanMeaning // ignore: cast_nullable_to_non_nullable
as String?,pronunciation: freezed == pronunciation ? _self.pronunciation : pronunciation // ignore: cast_nullable_to_non_nullable
as String?,exampleSentenceDutch: freezed == exampleSentenceDutch ? _self.exampleSentenceDutch : exampleSentenceDutch // ignore: cast_nullable_to_non_nullable
as String?,exampleSentenceArabic: freezed == exampleSentenceArabic ? _self.exampleSentenceArabic : exampleSentenceArabic // ignore: cast_nullable_to_non_nullable
as String?,synonyms: null == synonyms ? _self._synonyms : synonyms // ignore: cast_nullable_to_non_nullable
as List<String>,antonyms: null == antonyms ? _self._antonyms : antonyms // ignore: cast_nullable_to_non_nullable
as List<String>,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,progressStatus: null == progressStatus ? _self.progressStatus : progressStatus // ignore: cast_nullable_to_non_nullable
as VocabularyProgressStatus,
  ));
}


}

// dart format on
