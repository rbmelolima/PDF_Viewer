import 'package:flutter/material.dart';

class ListFilesPage extends StatelessWidget {
  const ListFilesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Olá, bom te ver!',
            style: Theme.of(context).textTheme.headline2,
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(48),
            child: Align(
              alignment: Alignment.centerLeft,
              child: TabBar(
                isScrollable: true,
                indicatorColor: Colors.black87,
                tabs: [
                  Tab(text: 'Recentes'),
                  Tab(text: 'Favoritos'),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            Center(child: Text('Recentes')),
            Center(child: Text('Todos')),
          ],
        ),
      ),
    );
  }
}
