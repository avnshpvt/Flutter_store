import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_store/home.dart';
import 'package:flutter_store/models/productModels.dart';
import 'package:flutter_store/product_event.dart';
import 'package:flutter_store/product_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductLoadingState()) {
    on<FetchProductsEvent>(_onFetchProducts); // Register the event handler
  }

  // Define the handler function for FetchProductsEvent
  Future<void> _onFetchProducts(FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoadingState()); // Emit loading state while fetching data

    try {
      final response = await http.get(Uri.parse('https://dummyjson.com/products'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<CourseModel> products = List<CourseModel>.from(
          data['products'].map((product) => CourseModel.fromJson(product)),
        );
        emit(ProductLoadedState(products)); // Emit loaded state with data
      } else {
        emit(ProductErrorState('Failed to load products'));
      }
    } catch (e) {
      emit(ProductErrorState('An error occurred while fetching products'));
    }
  }
}
