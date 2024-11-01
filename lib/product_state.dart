import 'package:equatable/equatable.dart';
import 'package:flutter_store/home.dart';
import 'package:flutter_store/models/productModels.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final List<CourseModel> products;

  ProductLoadedState(this.products);

  @override
  List<Object?> get props => [products];
}

class ProductErrorState extends ProductState {
  final String message;

  ProductErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
