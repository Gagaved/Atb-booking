import '../models/role.dart';
import '../models/user.dart';
import 'users_provider.dart';

class UsersRepository {
  UsersRepository._internal() {}

  static final UsersRepository _singleton = UsersRepository._internal();

  factory UsersRepository() {
    return _singleton;
  }

  Future<List<User>> getAllUsers(int page, int size, String sort) =>
      UsersProvider().fetchAllUsers(page, size, sort);

  Future<User> getUserById(int id) => UsersProvider().fetchUserById(id);

  Future<List<Role>> getUsersRole() => UsersProvider().fetchUsersRoles();
  Future<List<User>> getUserFavorites(int id) =>
      UsersProvider().fetchUserFavorites(id);

  Future<void> addUserFavorites(int userId, int favoriteId) =>
      UsersProvider().addFavorite(favoriteId);
}
