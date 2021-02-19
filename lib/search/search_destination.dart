import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_app/models/geocoding_response.dart';
import 'package:maps_app/models/search_result.dart';
import 'package:maps_app/providers/traffic_service.dart';

class SearchDestination extends SearchDelegate<SearchResult> {
  @override
  final String searchFieldLabel;
  final TrafficService _trafficService = TrafficService();
  final LatLng proximity;

  SearchDestination(this.proximity) : this.searchFieldLabel = 'Buscar destino';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () => this.query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    final searchResult = SearchResult(cancelled: true);
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () async {
        hideKeyboard(context);
        await Future.delayed(Duration(milliseconds: 300));
        this.close(context, searchResult);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (this.query.isEmpty) {
      return Container();
    }
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResult = SearchResult(cancelled: false, manual: true);
    return ListView(
      children: [
        ListTile(
          leading: Icon(Icons.location_on),
          title: Text("Colocar ubicación manualmente"),
          onTap: () async {
            hideKeyboard(context);
            await Future.delayed(Duration(milliseconds: 300));
            this.close(context, searchResult);
          },
        )
      ],
    );
  }

  void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus.unfocus();
    }
  }

  Widget _buildSearchResults() {
    return FutureBuilder(
      future:
          this._trafficService.getResultsByQuery(this.query, this.proximity),
      builder:
          (BuildContext context, AsyncSnapshot<GeocodingResponse> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final places = snapshot.data.features;
        return ListView.separated(
          itemCount: places.length,
          separatorBuilder: (context, index) => Divider(),
          itemBuilder: (_, int index) {
            final place = places.elementAt(index);
            return ListTile(
              leading: Icon(Icons.place),
              title: Text(place.text),
              subtitle: Text(place.placeName),
              onTap: () async {
                hideKeyboard(context);
                await Future.delayed(Duration(milliseconds: 300));
                this.close(
                  context,
                  SearchResult(
                      cancelled: false,
                      manual: false,
                      location: LatLng(place.center[1], place.center[0]),
                      name: place.text,
                      description: place.placeName),
                );
              },
            );
          },
        );
      },
    );
  }
}
