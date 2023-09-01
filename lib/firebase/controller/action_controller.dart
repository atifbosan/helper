class ActionController {
  /* pickImage() async {
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);
    if (pick != null) {
      helper.uploadFile("images/${pick.name}", pick.path);
    }
  }

  getData() async {
    final data =
    await helper.getData(path: "tools/${Globals.userId}/${Globals.userId}");
    toolModel = [];
    data.docs.forEach((doc) {
      return toolModel.add(ToolsModel(
        id: doc.id,
        toolName: doc['toolName'],
      ));
    });
    update();
  }

  deleteData(id) async {
    print("tools/${Globals.userId}/${Globals.userId}");

    await helper.deleteDocument(
        "tools/${Globals.userId}/${Globals.userId}", id);
    getData();
  }

  addSkills() async {
    loading = true;
    update();
    print('AuthController.addSkills: ${Globals.userId}');
    final resp = await helper.postDocument(
      path: "tools/${Globals.userId}/${Globals.userId}",
      data: {"toolName": emailCtrl.text},
      isID: false,
    );
    getData();
    loading = false;
    update();
    if (resp != null) {
      Utils.showSnackBar(
          title: "Success", message: 'Data Saved Successfully', error: true);
    }
    print("Check Data saved or not: ${resp}");
  }*/
}
