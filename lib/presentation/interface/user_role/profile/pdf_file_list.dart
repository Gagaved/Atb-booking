import 'package:atb_booking/presentation/interface/user_role/profile/pdf_page/pdf_general_access_page.dart';
import 'package:atb_booking/presentation/interface/user_role/profile/pdf_page/pdf_mac_access.dart';
import 'package:atb_booking/presentation/interface/user_role/profile/pdf_page/pdf_new_worker.dart';
import 'package:atb_booking/presentation/interface/user_role/profile/pdf_page/pdf_windows.dart';
import 'package:flutter/material.dart';

class PDFListPage extends StatelessWidget {
  const PDFListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Список файлов"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const PDFNewWorkerPage())));
                },
                child: const _UserBubbleBtn(
                  title: "Книга нового сотрудника",
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const PDFGeneralAccessPage())));
                },
                child: const _UserBubbleBtn(
                  title: "Инструкция удаленного доступа",
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const PDFMacAccessPage())));
                },
                child: const _UserBubbleBtn(
                  title: "Удаленка MAC OS", //todo сделать page
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: ((context) => const PDFWindowsAccessPage())));
                },
                child: const _UserBubbleBtn(
                  title: "Удаленка Windows", //todo сделать page
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }
}

class _UserBubbleBtn extends StatelessWidget {
  const _UserBubbleBtn({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 3,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: 25,
      ),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 21),
            ),
          ),
          const Icon(Icons.keyboard_arrow_right_sharp)
        ],
      ),
    );
  }
}
