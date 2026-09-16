// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocabulary_word_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$VocabularyWordModel {

 String get id;@JsonKey(name: 'dutch_word') String get dutchWord;@JsonKey(name: 'arabic_meaning') String get arabicMeaning;// Raw DB text ('a1'..'b2' / snake_case category) — converted to the
// domain enums in [toEntity], not here.
 String get level; String get category;@JsonKey(name: 'german_meaning') String? get germanMeaning; String? get pronunciation;@JsonKey(name: 'example_sentence_nl') String? get exampleSentenceDutch;@JsonKey(name: 'example_sentence_ar') String? get exampleSentenceArabic; List<String> get synonyms; List<String> get antonyms;// Not columns on `vocabularies` — filled in by the repository after
// joining with the user's favorites/progress rows. Never sent to
// or read from Supabase directly on this table.
@JsonKey(includeFromJson: false, includeToJson: false) bool get isFavorite;@JsonKey(includeFromJson: false, includeToJson: false) String get progressStatus;
/// Create a copy of VocabularyWordModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularyWordModelCopyWith<VocabularyWordModel> get copyWith => _$VocabularyWordModelCopyWithImpl<VocabularyWordModel>(this as VocabularyWordModel, _$identity);

  /// Serializes this VocabularyWordModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabularyWordModel&&(identical(other.id, id) || other.id == id)&&(identical(other.dutchWord, dutchWord) || other.dutchWord == dutchWord)&&(identical(other.arabicMeaning, arabicMeaning) || other.arabicMeaning == arabicMeaning)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.germanMeaning, germanMeaning) || other.germanMeaning == germanMeaning)&&(identical(other.pronunciation, pronunciation) || other.pronunciation == pronunciation)&&(identical(other.exampleSentenceDutch, exampleSentenceDutch) || other.exampleSentenceDutch == exampleSentenceDutch)&&(identical(other.exampleSentenceArabic, exampleSentenceArabic) || other.exampleSentenceArabic == exampleSentenceArabic)&&const DeepCollectionEquality().equals(other.synonyms, synonyms)&&const DeepCollectionEquality().equals(other.antonyms, antonyms)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.progressStatus, progressStatus) || other.progressStatus == progressStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dutchWord,arabicMeaning,level,category,germanMeaning,pronunciation,exampleSentenceDutch,exampleSentenceArabic,const DeepCollectionEquality().hash(synonyms),const DeepCollectionEquality().hash(antonyms),isFavorite,progressStatus);

@override
String toString() {
  return 'VocabularyWordModel(id: $id, dutchWord: $dutchWord, arabicMeaning: $arabicMeaning, level: $level, category: $category, germanMeaning: $germanMeaning, pronunciation: $pronunciation, exampleSentenceDutch: $exampleSentenceDutch, exampleSentenceArabic: $exampleSentenceArabic, synonyms: $synonyms, antonyms: $antonyms, isFavorite: $isFavorite, progressStatus: $progressStatus)';
}


}

/// @nodoc
abstract mixin class $VocabularyWordModelCopyWith<$Res>  {
  factory $VocabularyWordModelCopyWith(VocabularyWordModel value, $Res Function(VocabularyWordModel) _then) = _$VocabularyWordModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'dutch_word') String dutchWord,@JsonKey(name: 'arabic_meaning') String arabicMeaning, String level, String category,@JsonKey(name: 'german_meaning') String? germanMeaning, String? pronunciation,@JsonKey(name: 'example_sentence_nl') String? exampleSentenceDutch,@JsonKey(name: 'example_sentence_ar') String? exampleSentenceArabic, List<String> synonyms, List<String> antonyms,@JsonKey(includeFromJson: false, includeToJson: false) bool isFavorite,@JsonKey(includeFromJson: false, includeToJson: false) String progressStatus
});




}
/// @nodoc
class _$VocabularyWordModelCopyWithImpl<$Res>
    implements $VocabularyWordModelCopyWith<$Res> {
  _$VocabularyWordModelCopyWithImpl(this._self, this._then);

  final VocabularyWordModel _self;
  final $Res Function(VocabularyWordModel) _then;

/// Create a copy of VocabularyWordModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? dutchWord = null,Object? arabicMeaning = null,Object? level = null,Object? category = null,Object? germanMeaning = freezed,Object? pronunciation = freezed,Object? exampleSentenceDutch = freezed,Object? exampleSentenceArabic = freezed,Object? synonyms = null,Object? antonyms = null,Object? isFavorite = null,Object? progressStatus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dutchWord: null == dutchWord ? _self.dutchWord : dutchWord // ignore: cast_nullable_to_non_nullable
as String,arabicMeaning: null == arabicMeaning ? _self.arabicMeaning : arabicMeaning // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,germanMeaning: freezed == germanMeaning ? _self.germanMeaning : germanMeaning // ignore: cast_nullable_to_non_nullable
as String?,pronunciation: freezed == pronunciation ? _self.pronunciation : pronunciation // ignore: cast_nullable_to_non_nullable
as String?,exampleSentenceDutch: freezed == exampleSentenceDutch ? _self.exampleSentenceDutch : exampleSentenceDutch // ignore: cast_nullable_to_non_nullable
as String?,exampleSentenceArabic: freezed == exampleSentenceArabic ? _self.exampleSentenceArabic : exampleSentenceArabic // ignore: cast_nullable_to_non_nullable
as String?,synonyms: null == synonyms ? _self.synonyms : synonyms // ignore: cast_nullable_to_non_nullable
as List<String>,antonyms: null == antonyms ? _self.antonyms : antonyms // ignore: cast_nullable_to_non_nullable
as List<String>,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,progressStatus: null == progressStatus ? _self.progressStatus : progressStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [VocabularyWordModel].
extension VocabularyWordModelPatterns on VocabularyWordModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VocabularyWordModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VocabularyWordModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VocabularyWordModel value)  $default,){
final _that = this;
switch (_that) {
case _VocabularyWordModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VocabularyWordModel value)?  $default,){
final _that = this;
switch (_that) {
case _VocabularyWordModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'dutch_word')  String dutchWord, @JsonKey(name: 'arabic_meaning')  String arabicMeaning,  String level,  String category, @JsonKey(name: 'german_meaning')  String? germanMeaning,  String? pronunciation, @JsonKey(name: 'example_sentence_nl')  String? exampleSentenceDutch, @JsonKey(name: 'example_sentence_ar')  String? exampleSentenceArabic,  List<String> synonyms,  List<String> antonyms, @JsonKey(includeFromJson: false, includeToJson: false)  bool isFavorite, @JsonKey(includeFromJson: false, includeToJson: false)  String progressStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabularyWordModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'dutch_word')  String dutchWord, @JsonKey(name: 'arabic_meaning')  String arabicMeaning,  String level,  String category, @JsonKey(name: 'german_meaning')  String? germanMeaning,  String? pronunciation, @JsonKey(name: 'example_sentence_nl')  String? exampleSentenceDutch, @JsonKey(name: 'example_sentence_ar')  String? exampleSentenceArabic,  List<String> synonyms,  List<String> antonyms, @JsonKey(includeFromJson: false, includeToJson: false)  bool isFavorite, @JsonKey(includeFromJson: false, includeToJson: false)  String progressStatus)  $default,) {final _that = this;
switch (_that) {
case _VocabularyWordModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'dutch_word')  String dutchWord, @JsonKey(name: 'arabic_meaning')  String arabicMeaning,  String level,  String category, @JsonKey(name: 'german_meaning')  String? germanMeaning,  String? pronunciation, @JsonKey(name: 'example_sentence_nl')  String? exampleSentenceDutch, @JsonKey(name: 'example_sentence_ar')  String? exampleSentenceArabic,  List<String> synonyms,  List<String> antonyms, @JsonKey(includeFromJson: false, includeToJson: false)  bool isFavorite, @JsonKey(includeFromJson: false, includeToJson: false)  String progressStatus)?  $default,) {final _that = this;
switch (_that) {
case _VocabularyWordModel() when $default != null:
return $default(_that.id,_that.dutchWord,_that.arabicMeaning,_that.level,_that.category,_that.germanMeaning,_that.pronunciation,_that.exampleSentenceDutch,_that.exampleSentenceArabic,_that.synonyms,_that.antonyms,_that.isFavorite,_that.progressStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VocabularyWordModel extends VocabularyWordModel {
  const _VocabularyWordModel({required this.id, @JsonKey(name: 'dutch_word') required this.dutchWord, @JsonKey(name: 'arabic_meaning') required this.arabicMeaning, required this.level, required this.category, @JsonKey(name: 'german_meaning') this.germanMeaning, this.pronunciation, @JsonKey(name: 'example_sentence_nl') this.exampleSentenceDutch, @JsonKey(name: 'example_sentence_ar') this.exampleSentenceArabic, final  List<String> synonyms = const <String>[], final  List<String> antonyms = const <String>[], @JsonKey(includeFromJson: false, includeToJson: false) this.isFavorite = false, @JsonKey(includeFromJson: false, includeToJson: false) this.progressStatus = 'new'}): _synonyms = synonyms,_antonyms = antonyms,super._();
  factory _VocabularyWordModel.fromJson(Map<String, dynamic> json) => _$VocabularyWordModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'dutch_word') final  String dutchWord;
@override@JsonKey(name: 'arabic_meaning') final  String arabicMeaning;
// Raw DB text ('a1'..'b2' / snake_case category) — converted to the
// domain enums in [toEntity], not here.
@override final  String level;
@override final  String category;
@override@JsonKey(name: 'german_meaning') final  String? germanMeaning;
@override final  String? pronunciation;
@override@JsonKey(name: 'example_sentence_nl') final  String? exampleSentenceDutch;
@override@JsonKey(name: 'example_sentence_ar') final  String? exampleSentenceArabic;
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

// Not columns on `vocabularies` — filled in by the repository after
// joining with the user's favorites/progress rows. Never sent to
// or read from Supabase directly on this table.
@override@JsonKey(includeFromJson: false, includeToJson: false) final  bool isFavorite;
@override@JsonKey(includeFromJson: false, includeToJson: false) final  String progressStatus;

/// Create a copy of VocabularyWordModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabularyWordModelCopyWith<_VocabularyWordModel> get copyWith => __$VocabularyWordModelCopyWithImpl<_VocabularyWordModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VocabularyWordModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabularyWordModel&&(identical(other.id, id) || other.id == id)&&(identical(other.dutchWord, dutchWord) || other.dutchWord == dutchWord)&&(identical(other.arabicMeaning, arabicMeaning) || other.arabicMeaning == arabicMeaning)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.germanMeaning, germanMeaning) || other.germanMeaning == germanMeaning)&&(identical(other.pronunciation, pronunciation) || other.pronunciation == pronunciation)&&(identical(other.exampleSentenceDutch, exampleSentenceDutch) || other.exampleSentenceDutch == exampleSentenceDutch)&&(identical(other.exampleSentenceArabic, exampleSentenceArabic) || other.exampleSentenceArabic == exampleSentenceArabic)&&const DeepCollectionEquality().equals(other._synonyms, _synonyms)&&const DeepCollectionEquality().equals(other._antonyms, _antonyms)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.progressStatus, progressStatus) || other.progressStatus == progressStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dutchWord,arabicMeaning,level,category,germanMeaning,pronunciation,exampleSentenceDutch,exampleSentenceArabic,const DeepCollectionEquality().hash(_synonyms),const DeepCollectionEquality().hash(_antonyms),isFavorite,progressStatus);

@override
String toString() {
  return 'VocabularyWordModel(id: $id, dutchWord: $dutchWord, arabicMeaning: $arabicMeaning, level: $level, category: $category, germanMeaning: $germanMeaning, pronunciation: $pronunciation, exampleSentenceDutch: $exampleSentenceDutch, exampleSentenceArabic: $exampleSentenceArabic, synonyms: $synonyms, antonyms: $antonyms, isFavorite: $isFavorite, progressStatus: $progressStatus)';
}


}

/// @nodoc
abstract mixin class _$VocabularyWordModelCopyWith<$Res> implements $VocabularyWordModelCopyWith<$Res> {
  factory _$VocabularyWordModelCopyWith(_VocabularyWordModel value, $Res Function(_VocabularyWordModel) _then) = __$VocabularyWordModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'dutch_word') String dutchWord,@JsonKey(name: 'arabic_meaning') String arabicMeaning, String level, String category,@JsonKey(name: 'german_meaning') String? germanMeaning, String? pronunciation,@JsonKey(name: 'example_sentence_nl') String? exampleSentenceDutch,@JsonKey(name: 'example_sentence_ar') String? exampleSentenceArabic, List<String> synonyms, List<String> antonyms,@JsonKey(includeFromJson: false, includeToJson: false) bool isFavorite,@JsonKey(includeFromJson: false, includeToJson: false) String progressStatus
});




}
/// @nodoc
class __$VocabularyWordModelCopyWithImpl<$Res>
    implements _$VocabularyWordModelCopyWith<$Res> {
  __$VocabularyWordModelCopyWithImpl(this._self, this._then);

  final _VocabularyWordModel _self;
  final $Res Function(_VocabularyWordModel) _then;

/// Create a copy of VocabularyWordModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dutchWord = null,Object? arabicMeaning = null,Object? level = null,Object? category = null,Object? germanMeaning = freezed,Object? pronunciation = freezed,Object? exampleSentenceDutch = freezed,Object? exampleSentenceArabic = freezed,Object? synonyms = null,Object? antonyms = null,Object? isFavorite = null,Object? progressStatus = null,}) {
  return _then(_VocabularyWordModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dutchWord: null == dutchWord ? _self.dutchWord : dutchWord // ignore: cast_nullable_to_non_nullable
as String,arabicMeaning: null == arabicMeaning ? _self.arabicMeaning : arabicMeaning // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,germanMeaning: freezed == germanMeaning ? _self.germanMeaning : germanMeaning // ignore: cast_nullable_to_non_nullable
as String?,pronunciation: freezed == pronunciation ? _self.pronunciation : pronunciation // ignore: cast_nullable_to_non_nullable
as String?,exampleSentenceDutch: freezed == exampleSentenceDutch ? _self.exampleSentenceDutch : exampleSentenceDutch // ignore: cast_nullable_to_non_nullable
as String?,exampleSentenceArabic: freezed == exampleSentenceArabic ? _self.exampleSentenceArabic : exampleSentenceArabic // ignore: cast_nullable_to_non_nullable
as String?,synonyms: null == synonyms ? _self._synonyms : synonyms // ignore: cast_nullable_to_non_nullable
as List<String>,antonyms: null == antonyms ? _self._antonyms : antonyms // ignore: cast_nullable_to_non_nullable
as List<String>,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,progressStatus: null == progressStatus ? _self.progressStatus : progressStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
