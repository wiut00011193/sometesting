import 'package:mars_it_app/mars_space/features/data/model/request/delete_child_request_model.dart';

class DeleteChildRequestEntity {
  int? id;

  DeleteChildRequestEntity({required this.id});

  Future<DeleteChildRequestModel> toModel() async {
    return DeleteChildRequestModel(id: id);
  }
}