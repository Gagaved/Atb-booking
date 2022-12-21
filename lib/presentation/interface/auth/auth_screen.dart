import 'package:atb_booking/logic/auth_bloc/auth_bloc.dart';
import 'package:atb_booking/logic/user_role/booking/booking_list_bloc/booking_list_bloc.dart';
import 'package:atb_booking/logic/user_role/profile_bloc/profile_bloc.dart';
import 'package:atb_booking/presentation/interface/admin_role/adminHome.dart';
import 'package:atb_booking/presentation/interface/user_role/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/styles.dart';
import '../../widgets/elevated_button.dart';

class Auth extends StatelessWidget {
  const Auth({super.key});

  static final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthBloc>(
      create: (context) => AuthBloc(),
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              height: 650,
              padding: const EdgeInsets.only(top: 30, right: 50, left: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 1, child: _AuthTitle()),
                  Expanded(
                    flex: 2,
                    child: _FormWidget(
                      scrollController: _scrollController,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthTitle extends StatelessWidget {
  const _AuthTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Column(
        children: [
          Center(child: Image.asset("assets/atb_logo.png")),
          Text(
            "Авторизация",
            style: Theme.of(context)
                .textTheme
                .displayMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _FormWidget extends StatefulWidget {
  final ScrollController scrollController;

  const _FormWidget({required this.scrollController});

  @override
  State<_FormWidget> createState() => __FormWidgetState();
}

class __FormWidgetState extends State<_FormWidget> {
  bool? _isChecked = false;
  final String _errorTextLogin = "Не верный логин или пароль";
  final String _errorTextInput = "Введите корректное значение";
  final _loginTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (_, state) {
        if (state is AuthUserSuccessState) {
          BookingListBloc().add(BookingListLoadEvent());
          ProfileBloc().add(ProfileLoadEvent());

          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => const Home()));
        } else if (state is AuthAdminSuccessState) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AdminHome()));
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (state is AuthLoadingState) ...[
                  const Center(child: CircularProgressIndicator()),
                ] else ...[
                  TextField(
                    controller: _loginTextController,
                    obscureText: false,
                    decoration: const InputDecoration(
                      hintText: "Логин",
                      filled: true,
                      fillColor: Color.fromARGB(255, 238, 238, 238),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 40),
                  TextField(
                    obscureText: true,
                    controller: _passwordTextController,
                    decoration: const InputDecoration(
                      hintText: "пароль",
                      filled: true,
                      fillColor: Color.fromARGB(255, 238, 238, 238),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Состояние ошибки
                  //
                  // Если неправильный ЛОГИН
                  if (state is AuthErrorState &&
                      state.message == "not correct login") ...[
                    Text(
                      _errorTextLogin,
                      style: TextStyle(
                          color: appThemeData.colorScheme.error, fontSize: 17),
                    ),
                    const SizedBox(height: 5)
                  ]
                  // Если не прошел ВАЛИДАЦИЮ
                  else if (state is AuthErrorState &&
                      state.message == "not correct input") ...[
                    Text(
                      _errorTextInput,
                      style: TextStyle(
                          color: appThemeData.colorScheme.error, fontSize: 17),
                    ),
                    const SizedBox(height: 5)
                  ]
                  // Остальные ошибки
                  else if (state is AuthErrorState) ...[
                    Text(
                      state.message,
                      style: TextStyle(
                          color: appThemeData.colorScheme.error, fontSize: 17),
                    ),
                    const SizedBox(height: 5)
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: ((newBool) {
                          setState(() {
                            _isChecked = newBool;
                          });
                        }),
                      ),
                      const Expanded(
                        child:  Text(
                          "Запомнить логин и пароль?",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 19),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0),
                    child: AtbElevatedButton(
                        onPressed: () {
                          BlocProvider.of<AuthBloc>(context).add(AuthLoginEvent(
                              login: _loginTextController.text,
                              password: _passwordTextController.text,
                              isChecked: _isChecked ?? false));
                        },
                        text: "Войти"),
                  )
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
