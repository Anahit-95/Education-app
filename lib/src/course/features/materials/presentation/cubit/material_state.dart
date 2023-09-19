part of 'material_cubit.dart';

abstract class MaterialState extends Equatable {
  const MaterialState();

  @override
  List<Object> get props => [];
}

class MaterialInitial extends MaterialState {
  const MaterialInitial();
}

class LoadingMaterials extends MaterialState {
  const LoadingMaterials();
}

class MaterialsLoaded extends MaterialState {
  const MaterialsLoaded(this.materials);

  final List<Resource> materials;

  @override
  List<Object> get props => [materials];
}

class AddingMaterials extends MaterialState {
  const AddingMaterials();
}

class MaterialsAdded extends MaterialState {
  const MaterialsAdded();
}

class MaterialError extends MaterialState {
  const MaterialError(this.message);
  final String message;

  @override
  List<String> get props => [message];
}
