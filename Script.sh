#!/bin/sh

#  Script.sh
#  zhuishushenqi
#
#  Created by yung on 2017/8/10.
#  Copyright © 2017年 QS. All rights reserved.

# Localizable.strings文件路径
localizableFile="en.lproj/Localizable.strings"
# 生成的swift文件路径（根据个人习惯修改）
localizedFile="zhuishushenqi/Extension/LocalizedUtils.swift"
# 将localizable.strings中的文本转为swift格式的常量，存入一个临时文件
cat ${localizableFile}
sed "s/^\"/  static var localized_/g" "${localizableFile}" | sed "s/\" = \"/: String { return \"/g" | sed "s/;$/.localized }/g" > "${localizedFile}.tmp"
# 先将localized作为计算属性输出到目标文件
echo -e "import Foundation\n\nextension String {\n  var localized: String { return NSLocalizedString(self, comment: self) }" > "${localizedFile}"
# 再将临时文件中的常量增量输出到目标文件
cat "${localizedFile}.tmp" >> "${localizedFile}"
# 最后增量输出一个"}"到目标文件，完成输出
echo -e "\n}" >> "${localizedFile}"
# 删除临时文件
rm "${localizedFile}.tmp"
