class MenuItemModel {
  String name;
  String caption;
  String type;
  String visible;
  String img;
  String parent;
  String levelno;
  String pagetype;
  String intview;
  String icon;
  String url;
  String parent_tree = "";
  List<MenuItemModel> childList = [];

  MenuItemModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        caption = json['caption'],
        type = json['type'],
        visible = json['visible'],
        img = json['img'] ?? "",
        parent = json['parent'] ?? "",
        levelno = json['levelno'].toString(),
        pagetype = json['pagetype'] ?? "",
        intview = json['intview'] ?? "",
        icon = json['icon'] ?? "",
        url = json['url'] ?? "",
        parent_tree = json['parent_tree'] ?? "",
        childList = json['childList'] ?? [];

  Map<String, dynamic> toJson() => {
        'name': name,
        'caption': caption,
        'type': type,
        'visible': visible,
        'img': img,
        'parent': parent,
        'levelno': levelno,
        'pagetype': pagetype,
        'intview': intview,
        'icon': icon,
        'url': url,
      };

  @override
  String toString() {
    return "name:$name, caption:$caption, type:$type, visible:$visible, img:$img, parent:$parent, levelno:$levelno, pagetype:$pagetype, intview:$intview, icon:$icon, url:$url,  parent_tree:$parent_tree, childList:$childList ";
  }
}
