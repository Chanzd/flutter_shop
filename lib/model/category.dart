class CategoryBigModel {
  String mallCategoryId; 
  String mallCategoryName;
  List<BxMallSubDto> bxMallSubDto; //小类列表
  String image; //类别图片
  Null comments; // 列表描述

  CategoryBigModel({
    this.mallCategoryId,
    this.mallCategoryName,
    this.comments,
    this.image,
    this.bxMallSubDto
  });

  factory CategoryBigModel.fromJson(dynamic json) {
    List<BxMallSubDto> bxMallSubDto;
    if (json['bxMallSubDto'] != null) {
      bxMallSubDto = new List<BxMallSubDto>();
      json['bxMallSubDto'].forEach((v) {
        bxMallSubDto.add(new BxMallSubDto.fromJson(v));
      });
    }
    return CategoryBigModel(
      mallCategoryId: json['mallCategoryId'],
      mallCategoryName: json['mallCategoryName'],
      comments: json['comments'],
      image: json['image'],
      bxMallSubDto: bxMallSubDto
    );
  }
}

class CategoryBigListModel {
  List<CategoryBigModel> data;
  CategoryBigListModel(this.data);
  factory CategoryBigListModel.fromJson(List json) {
    return CategoryBigListModel(
      json.map((e) => CategoryBigModel.fromJson((e))).toList()
    );
  }
}

class BxMallSubDto {
  String mallSubId;
  String mallCategoryId;
  String mallSubName;
  String comments;

  BxMallSubDto(
      {this.mallSubId, this.mallCategoryId, this.mallSubName, this.comments});

  factory BxMallSubDto.fromJson(dynamic json) {
    return  BxMallSubDto(mallSubId:json['mallSubId'],
                        mallCategoryId: json['mallCategoryId'],
                        mallSubName: json['mallSubName'],
                        comments: json['comments']
    );
  }
}