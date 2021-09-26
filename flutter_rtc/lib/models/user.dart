import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// {@template user}
/// User model
///
/// [User.empty] represents an unauthenticated user.
/// {@contemplate}
class User extends Equatable {
  /// {@macro user}
  const User({
    required this.id,
    this.email,
    this.name,
    this.photo,
  });

  /// The current user's email address.
  final String? email;

  /// The current user's id.
  final String id;

  /// The current user's name (display name).
  final String? name;

  /// Url for the current user's photo.
  final String? photo;

  /// Empty user which represents an unauthenticated user.
  static const empty = User(id: '');

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == User.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != User.empty;


  factory User.fromJson(DocumentSnapshot data) {
    return User(
      email: data["email"],
      id: data["id"],
      name: data["name"],
      photo: data["photo"],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      "email": this.email,
      "id": this.id,
      "name": this.name,
      "photo": this.photo,
    };
  }

  @override
  List<Object?> get props => [email, id, name, photo];
}
