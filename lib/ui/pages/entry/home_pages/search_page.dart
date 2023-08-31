import 'package:flutter/material.dart';
import 'package:food_delivery_app/core/model/resturant_model.dart';

class RestaurantSearchDelegate extends SearchDelegate<FoodItem> {
  final List<FoodItem> restaurants; // List of restaurants to search

  RestaurantSearchDelegate(this.restaurants);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = ''; // Clear the search query
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, [] as FoodItem); // Close the search and return null
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Filter the restaurants based on the query
    final filteredRestaurants = restaurants.where((restaurant) {
      return restaurant.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredRestaurants.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredRestaurants[index].name),
          onTap: () {
            close(context,
                filteredRestaurants[index]); // Return selected restaurant
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // You can provide suggestions here, if needed
    return Container();
  }
}
