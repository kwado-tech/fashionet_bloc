import 'package:fashionet_bloc/widgets/shared/shared.dart';
import 'package:flutter/material.dart';

class ExploreTab extends StatefulWidget {
  @override
  _ExploreTabState createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  Widget _buildFlexibleSpaceBarTitle() {
    return Text('Explore',
        style: Theme.of(context).textTheme.display1.copyWith(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold));
  }

  Widget _buildFlexibleSpaceBar() {
    return FlexibleSpaceBar(
      title: _buildFlexibleSpaceBarTitle(),
      titlePadding: EdgeInsets.only(left: 20.0, bottom: 10.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double _deviceWidth = MediaQuery.of(context).size.width;
    final double _contentMaxWidth =
        _deviceWidth > 500.0 ? 500.0 : _deviceWidth * .90;

    final double _contentPadding = (_deviceWidth - _contentMaxWidth) / 2;
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          expandedHeight: 150.0,
          backgroundColor: Colors.white,
          flexibleSpace: _buildFlexibleSpaceBar(),
          actions: <Widget>[
            IconButton(
                onPressed: () {},
                color: Theme.of(context).primaryColor,
                iconSize: 30.0,
                icon: Icon(Icons.settings))
          ],
        ),
        SliverToBoxAdapter(child: PageIndicator()),
        SliverToBoxAdapter(child: PostCardDefault()),
        SliverList(
          delegate: SliverChildListDelegate([
            SizedBox(
              height: 150.0,
              width: 200.0,
              child: Card(),
            ),
            SizedBox(
              height: 150.0,
              width: 200.0,
              child: Card(),
            ),
            SizedBox(
              height: 150.0,
              width: 200.0,
              child: Card(),
            ),
            SizedBox(
              height: 150.0,
              width: 200.0,
              child: Card(),
            ),
            SizedBox(
              height: 150.0,
              width: 200.0,
              child: Card(),
            ),
            SizedBox(
              height: 150.0,
              width: 200.0,
              child: Card(),
            ),
            SizedBox(
              height: 150.0,
              width: 200.0,
              child: Card(),
            ),
          ]),
        )
      ],
    );
  }
}
