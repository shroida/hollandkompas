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

 String get id;@JsonKey(name: 'word') String get dutchWord;@JsonKey(name: 'translation_ar') String get arabicMeaning;@JsonKey(name: 'translation_en') String? get englishMeaning; String get level; String get category;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(includeFromJson: false, includeToJson: false) bool get isFavorite;@JsonKey(includeFromJson: false, includeToJson: false) String get progressStatus;
/// Create a copy of VocabularyWordModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabularyWordModelCopyWith<VocabularyWordModel> get copyWith => _$VocabularyWordModelCopyWithImpl<VocabularyWordModel>(this as VocabularyWordModel, _$identity);

  /// Serializes this VocabularyWordModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabularyWordModel&&(identical(other.id, id) || other.id == id)&&(identical(other.dutchWord, dutchWord) || other.dutchWord == dutchWord)&&(identical(other.arabicMeaning, arabicMeaning) || other.arabicMeaning == arabicMeaning)&&(identical(other.englishMeaning, englishMeaning) || other.englishMeaning == englishMeaning)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.progressStatus, progressStatus) || other.progressStatus == progressStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dutchWord,arabicMeaning,englishMeaning,level,category,createdAt,isFavorite,progressStatus);

@override
String toString() {
  return 'VocabularyWordModel(id: $id, dutchWord: $dutchWord, arabicMeaning: $arabicMeaning, englishMeaning: $englishMeaning, level: $level, category: $category, createdAt: $createdAt, isFavorite: $isFavorite, progressStatus: $progressStatus)';
}


}

/// @nodoc
abstract mixin class $VocabularyWordModelCopyWith<$Res>  {
  factory $VocabularyWordModelCopyWith(VocabularyWordModel value, $Res Function(VocabularyWordModel) _then) = _$VocabularyWordModelCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'word') String dutchWord,@JsonKey(name: 'translation_ar') String arabicMeaning,@JsonKey(name: 'translation_en') String? englishMeaning, String level, String category,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(includeFromJson: false, includeToJson: false) bool isFavorite,@JsonKey(includeFromJson: false, includeToJson: false) String progressStatus
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'word')  String dutchWord, @JsonKey(name: 'translation_ar')  String arabicMeaning, @JsonKey(name: 'translation_en')  String? englishMeaning,  String level,  String category, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(includeFromJson: false, includeToJson: false)  bool isFavorite, @JsonKey(includeFromJson: false, includeToJson: false)  String progressStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabularyWordModel() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'word')  String dutchWord, @JsonKey(name: 'translation_ar')  String arabicMeaning, @JsonKey(name: 'translation_en')  String? englishMeaning,  String level,  String category, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(includeFromJson: false, includeToJson: false)  bool isFavorite, @JsonKey(includeFromJson: false, includeToJson: false)  String progressStatus)  $default,) {final _that = this;
switch (_that) {
case _VocabularyWordModel():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'word')  String dutchWord, @JsonKey(name: 'translation_ar')  String arabicMeaning, @JsonKey(name: 'translation_en')  String? englishMeaning,  String level,  String category, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(includeFromJson: false, includeToJson: false)  bool isFavorite, @JsonKey(includeFromJson: false, includeToJson: false)  String progressStatus)?  $default,) {final _that = this;
switch (_that) {
case _VocabularyWordModel() when $default != null:
return $default(_that.id,_that.dutchWord,_that.arabicMeaning,_that.englishMeaning,_that.level,_that.category,_that.createdAt,_that.isFavorite,_that.progressStatus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VocabularyWordModel extends VocabularyWordModel {
  const _VocabularyWordModel({required this.id, @JsonKey(name: 'word') required this.dutchWord, @JsonKey(name: 'translation_ar') required this.arabicMeaning, @JsonKey(name: 'translation_en') this.englishMeaning, required this.level, required this.category, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(includeFromJson: false, includeToJson: false) this.isFavorite = false, @JsonKey(includeFromJson: false, includeToJson: false) this.progressStatus = 'new'}): super._();
  factory _VocabularyWordModel.fromJson(Map<String, dynamic> json) => _$VocabularyWordModelFromJson(json);

@override final  String id;
@override@JsonKey(name: 'word') final  String dutchWord;
@override@JsonKey(name: 'translation_ar') final  String arabicMeaning;
@override@JsonKey(name: 'translation_en') final  String? englishMeaning;
@override final  String level;
@override final  String category;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabularyWordModel&&(identical(other.id, id) || other.id == id)&&(identical(other.dutchWord, dutchWord) || other.dutchWord == dutchWord)&&(identical(other.arabicMeaning, arabicMeaning) || other.arabicMeaning == arabicMeaning)&&(identical(other.englishMeaning, englishMeaning) || other.englishMeaning == englishMeaning)&&(identical(other.level, level) || other.level == level)&&(identical(other.category, category) || other.category == category)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isFavorite, isFavorite) || other.isFavorite == isFavorite)&&(identical(other.progressStatus, progressStatus) || other.progressStatus == progressStatus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,dutchWord,arabicMeaning,englishMeaning,level,category,createdAt,isFavorite,progressStatus);

@override
String toString() {
  return 'VocabularyWordModel(id: $id, dutchWord: $dutchWord, arabicMeaning: $arabicMeaning, englishMeaning: $englishMeaning, level: $level, category: $category, createdAt: $createdAt, isFavorite: $isFavorite, progressStatus: $progressStatus)';
}


}

/// @nodoc
abstract mixin class _$VocabularyWordModelCopyWith<$Res> implements $VocabularyWordModelCopyWith<$Res> {
  factory _$VocabularyWordModelCopyWith(_VocabularyWordModel value, $Res Function(_VocabularyWordModel) _then) = __$VocabularyWordModelCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'word') String dutchWord,@JsonKey(name: 'translation_ar') String arabicMeaning,@JsonKey(name: 'translation_en') String? englishMeaning, String level, String category,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(includeFromJson: false, includeToJson: false) bool isFavorite,@JsonKey(includeFromJson: false, includeToJson: false) String progressStatus
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? dutchWord = null,Object? arabicMeaning = null,Object? englishMeaning = freezed,Object? level = null,Object? category = null,Object? createdAt = freezed,Object? isFavorite = null,Object? progressStatus = null,}) {
  return _then(_VocabularyWordModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,dutchWord: null == dutchWord ? _self.dutchWord : dutchWord // ignore: cast_nullable_to_non_nullable
as String,arabicMeaning: null == arabicMeaning ? _self.arabicMeaning : arabicMeaning // ignore: cast_nullable_to_non_nullable
as String,englishMeaning: freezed == englishMeaning ? _self.englishMeaning : englishMeaning // ignore: cast_nullable_to_non_nullable
as String?,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isFavorite: null == isFavorite ? _self.isFavorite : isFavorite // ignore: cast_nullable_to_non_nullable
as bool,progressStatus: null == progressStatus ? _self.progressStatus : progressStatus // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
