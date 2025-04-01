import '../model/sample_model.dart';

class HomeController {
  List<SampleModel> getSampleData() {
    return [
      SampleModel(title: "Item 1", description: "Description 1"),
      SampleModel(title: "Item 2", description: "Description 2"),
      SampleModel(title: "Item 3", description: "Description 3"),
    ];
  }
}
