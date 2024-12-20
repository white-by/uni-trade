/*
 Navicat Premium Data Transfer

 Source Server         : MyDatabase
 Source Server Type    : MySQL
 Source Server Version : 80039
 Source Host           : localhost:3306
 Source Schema         : trade_db

 Target Server Type    : MySQL
 Target Server Version : 80039
 File Encoding         : 65001

 Date: 20/12/2024 09:48:40
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for address
-- ----------------------------
DROP TABLE IF EXISTS `address`;
CREATE TABLE `address`  (
  `addrID` int NOT NULL AUTO_INCREMENT,
  `userID` int NOT NULL,
  `province` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `city` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `districts` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `address` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `tel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `receiver` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `isDefault` tinyint NOT NULL DEFAULT 1,
  PRIMARY KEY (`addrID`) USING BTREE,
  INDEX `userID`(`userID` ASC) USING BTREE,
  CONSTRAINT `address_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 20 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (1, 1, '广东省', '珠海市', '香洲区', '中山大学', '19999999999', '塔夫', 1);
INSERT INTO `address` VALUES (3, 1, '湖南省', '湘潭市', '岳塘区', '测试修改地址', '15436273843', '塔夫', 0);
INSERT INTO `address` VALUES (8, 1, '吉林省', '长春市', '二道区', '测试', '9999999999', '小明', 0);
INSERT INTO `address` VALUES (14, 2, '安徽省', '芜湖市', '镜湖区', '动物园', '09876543211', '影心', 1);
INSERT INTO `address` VALUES (15, 2, '新疆维吾尔自治区', '克孜勒苏柯尔克孜自治州', '阿克陶县', '营地', '1234567890', '挠挠', 0);
INSERT INTO `address` VALUES (16, 3, '浙江省', '杭州市', '钱塘区', '西泠印社', '12345678970', '阿尔菲拉', 1);
INSERT INTO `address` VALUES (17, 6, '广东省', '珠海市', '香洲区', '中山大学珠海校区蝾螈食堂三楼', '1234567800', '1', 1);
INSERT INTO `address` VALUES (18, 3, '北京市', '市辖区', '东城区', '幽暗地域', '12345678903', '塔夫', 0);
INSERT INTO `address` VALUES (19, 6, '广东省', '广州市', '海珠区', '新港西路中山大学南校园松涛园三楼啫啫鸡', '12345678900', '啫啫鸡', 0);

-- ----------------------------
-- Table structure for admins
-- ----------------------------
DROP TABLE IF EXISTS `admins`;
CREATE TABLE `admins`  (
  `adminID` int NOT NULL AUTO_INCREMENT,
  `passwords` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `adminName` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `tel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `mail` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `gender` tinyint NULL DEFAULT NULL,
  `age` int NULL DEFAULT NULL,
  PRIMARY KEY (`adminID`) USING BTREE,
  UNIQUE INDEX `adminName`(`adminName` ASC) USING BTREE,
  CONSTRAINT `admins_chk_1` CHECK (`age` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admins
-- ----------------------------
INSERT INTO `admins` VALUES (1, '1jdzWuniG6UMtoa3T6uNLA==', '管理员', '12212121221', '1@qq.com', 0, 20);
INSERT INTO `admins` VALUES (3, '1jdzWuniG6UMtoa3T6uNLA==', '邪念', '13609723842', 'darkurge@qq.com', 0, 289);
INSERT INTO `admins` VALUES (4, '1jdzWuniG6UMtoa3T6uNLA==', '莎尔', '18867574564', 'shawdowheart@mail2.sysu.edu.cn', 0, 1000);

-- ----------------------------
-- Table structure for announcement
-- ----------------------------
DROP TABLE IF EXISTS `announcement`;
CREATE TABLE `announcement`  (
  `announcementID` int NOT NULL AUTO_INCREMENT,
  `anTitle` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `anContent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `anTime` datetime NOT NULL,
  PRIMARY KEY (`announcementID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of announcement
-- ----------------------------
INSERT INTO `announcement` VALUES (1, '公告测试', '公告内容测', '2024-12-14 08:07:28');
INSERT INTO `announcement` VALUES (2, '公告测试2', '12313123', '2024-12-16 09:15:53');
INSERT INTO `announcement` VALUES (3, '公告测试3', '5432', '2024-12-16 09:17:30');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `categoryID` int NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `descriptions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`categoryID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '日常用品', '日常生活中使用的物品，如衣物、文具等');
INSERT INTO `category` VALUES (2, '数码产品', '如手机、平板、电脑\n');
INSERT INTO `category` VALUES (3, '二手教材', '旧教材');
INSERT INTO `category` VALUES (4, '闲置衣物', '旧衣服');
INSERT INTO `category` VALUES (5, '通勤工具', '如自行车、电动车、二轮车、平衡车');
INSERT INTO `category` VALUES (6, '同人周边', '谷子等');
INSERT INTO `category` VALUES (7, '虚拟物品', '充值卡，软件会员等');

-- ----------------------------
-- Table structure for chat_records
-- ----------------------------
DROP TABLE IF EXISTS `chat_records`;
CREATE TABLE `chat_records`  (
  `chatID` int NOT NULL AUTO_INCREMENT,
  `senderID` int NOT NULL,
  `receiverID` int NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `sendTime` datetime NULL DEFAULT NULL,
  PRIMARY KEY (`chatID`) USING BTREE,
  INDEX `senderID`(`senderID` ASC) USING BTREE,
  INDEX `receiverID`(`receiverID` ASC) USING BTREE,
  CONSTRAINT `chat_records_ibfk_1` FOREIGN KEY (`senderID`) REFERENCES `users` (`userID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `chat_records_ibfk_2` FOREIGN KEY (`receiverID`) REFERENCES `users` (`userID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chat_records
-- ----------------------------

-- ----------------------------
-- Table structure for collection
-- ----------------------------
DROP TABLE IF EXISTS `collection`;
CREATE TABLE `collection`  (
  `goodsID` int NOT NULL,
  `userID` int NOT NULL,
  `createdTime` datetime NOT NULL,
  PRIMARY KEY (`goodsID`, `userID`) USING BTREE,
  INDEX `userID`(`userID` ASC) USING BTREE,
  CONSTRAINT `collection_ibfk_1` FOREIGN KEY (`goodsID`) REFERENCES `goods` (`goodsID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `collection_ibfk_2` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of collection
-- ----------------------------
INSERT INTO `collection` VALUES (3, 1, '2024-12-19 07:53:13');
INSERT INTO `collection` VALUES (6, 1, '2024-12-13 05:52:41');
INSERT INTO `collection` VALUES (7, 2, '2024-12-18 14:01:36');
INSERT INTO `collection` VALUES (8, 1, '2024-12-13 05:52:46');
INSERT INTO `collection` VALUES (8, 3, '2024-12-12 10:59:06');
INSERT INTO `collection` VALUES (9, 1, '2024-12-13 05:52:48');

-- ----------------------------
-- Table structure for comment
-- ----------------------------
DROP TABLE IF EXISTS `comment`;
CREATE TABLE `comment`  (
  `commentID` int NOT NULL AUTO_INCREMENT,
  `goodsID` int NOT NULL,
  `commentatorID` int NOT NULL,
  `commentContent` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `commentTime` datetime NOT NULL,
  PRIMARY KEY (`commentID`) USING BTREE,
  INDEX `goodsID`(`goodsID` ASC) USING BTREE,
  INDEX `commentatorID`(`commentatorID` ASC) USING BTREE,
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`goodsID`) REFERENCES `goods` (`goodsID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`commentatorID`) REFERENCES `users` (`userID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (1, 3, 1, '评论测试', '2024-10-13 00:00:00');
INSERT INTO `comment` VALUES (2, 1, 2, '评论测试2', '2024-12-07 15:33:25');
INSERT INTO `comment` VALUES (3, 5, 1, '测试评价内容', '2024-12-08 13:55:48');
INSERT INTO `comment` VALUES (4, 16, 2, '非常优质的解答', '2024-12-18 13:48:53');

-- ----------------------------
-- Table structure for goods
-- ----------------------------
DROP TABLE IF EXISTS `goods`;
CREATE TABLE `goods`  (
  `goodsID` int NOT NULL AUTO_INCREMENT,
  `goodsName` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `userID` int NOT NULL,
  `price` decimal(10, 2) NOT NULL,
  `categoryID` int NOT NULL,
  `details` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `isSold` tinyint NOT NULL DEFAULT 0,
  `goodsImages` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `createdTime` datetime NOT NULL,
  `deliveryMethod` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `shippingCost` decimal(10, 0) NULL DEFAULT NULL,
  `addrID` int NULL DEFAULT NULL,
  `view` int NULL DEFAULT 0,
  PRIMARY KEY (`goodsID`) USING BTREE,
  INDEX `userID`(`userID` ASC) USING BTREE,
  INDEX `categoryID`(`categoryID` ASC) USING BTREE,
  INDEX `addrID`(`addrID` ASC) USING BTREE,
  CONSTRAINT `goods_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `goods_ibfk_2` FOREIGN KEY (`categoryID`) REFERENCES `category` (`categoryID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `goods_ibfk_3` FOREIGN KEY (`addrID`) REFERENCES `address` (`addrID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `goods_chk_1` CHECK (`price` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, '小狗玩偶', 1, 190.00, 1, 'jellycat小狗玩偶', 0, 'https://cbu01.alicdn.com/img/ibank/O1CN01DS6DcJ1TfMxwYtIoM_!!2206564752409-0-cib.jpg,https://cbu01.alicdn.com/img/ibank/O1CN01OM3LFu23opMDQ0lF8_!!2216752467303-0-cib.310x310.jpg', '2024-12-07 23:45:42', '0', 0, 1, 15);
INSERT INTO `goods` VALUES (2, '拍立得mini99', 1, 1300.00, 1, '凑字数凑字数', 1, 'https://tse1-mm.cn.bing.net/th/id/OIP-C.Go6VmQ13-kKnm04jNqMIHQD6D6?rs=1&pid=ImgDetMain', '2024-12-08 15:32:55', '1', 8, 1, 3);
INSERT INTO `goods` VALUES (3, '蛋白粉', 2, 99.00, 1, '凑字数', 0, 'https://imgservice.suning.cn/uimg1/b2c/image/gFZyU4ciCobR3PX2VAjTjQ.jpg', '2024-12-06 15:41:57', '1', 8, 1, 37);
INSERT INTO `goods` VALUES (4, 'pingu摸鱼鹅', 1, 65.00, 1, '未拆袋', 1, 'https://cbu01.alicdn.com/img/ibank/O1CN011aNtFI1EXqJIFR22Q_!!2216426590362-0-cib.310x310.jpg', '2024-12-08 20:29:17', '2', 8, 1, 8);
INSERT INTO `goods` VALUES (5, '充电宝', 2, 60.00, 2, '2w毫安。使用1年', 1, 'https://cbu01.alicdn.com/img/ibank/2019/194/723/10889327491_1286304817.jpg', '2024-12-08 20:30:16', '0', 8, 1, 6);
INSERT INTO `goods` VALUES (6, '联想小新电脑', 2, 4000.00, 2, '使用两年', 0, 'https://pic1.zhimg.com/v2-32d8111e1d00fba6d12d7095e4f4d561_r.jpg?source=1940ef5c', '2024-10-09 15:54:20', '1', 8, 1, 19);
INSERT INTO `goods` VALUES (7, '博德之门3黑胶', 1, 400.00, 6, '全新', 0, 'https://tse1-mm.cn.bing.net/th/id/OIP-C.6oHTxnMBGqA46oG1668s3wHaEK?rs=1&pid=ImgDetMain', '2024-09-09 15:55:07', '2', 8, 1, 17);
INSERT INTO `goods` VALUES (8, '星界棱镜', 2, 99.00, 5, '打不开，故卖出', 0, 'https://s2.loli.net/2024/12/11/7j2avqJPWRMkHUC.jpg\n', '2024-12-11 03:32:53', '1', 0, 15, 0);
INSERT INTO `goods` VALUES (9, 'delias厚底小皮鞋女秋冬加绒真皮黑色玛丽珍增高马丁乐福鞋', 3, 100.00, 4, '哑黑色，39码，加绒款，增高5cm，走路不打脚，仅穿过一次，尺码买小了所以出。 鞋垫材质超纤皮，鞋垫材质超纤皮，鞋头圆头，重量非常轻 已自刀，不可小刀，爽快包邮', 0, 'https://s2.loli.net/2024/12/12/8ynONh71MYjkPcp.jpg,https://s2.loli.net/2024/12/12/VNHQgLnB6Uhb3cp.jpg,https://s2.loli.net/2024/12/12/bDSoBAIjr4ZUFMt.jpg', '2024-12-12 11:42:16', '1', 0, 16, 1);
INSERT INTO `goods` VALUES (10, '树林猫猫狗狗手机壳', 3, 15.80, 1, '适用iPhone15，全包软壳，全新未使用，买多了出', 0, 'https://s2.loli.net/2024/12/14/b1LAO3eBsHVGRNC.png,https://s2.loli.net/2024/12/14/1yJHGl4k8ueB92o.png', '2024-12-14 08:12:19', '2', 4, 16, 3);
INSERT INTO `goods` VALUES (11, '麦当劳早餐券', 3, 9.90, 7, '猪柳麦满分+小杯豆浆\n拍前先咨询', 1, 'https://s2.loli.net/2024/12/14/7GpLczrDd54tJ6N.png', '2024-12-14 08:15:05', '0', 0, NULL, 4);
INSERT INTO `goods` VALUES (12, '麦香鱼代下单', 5, 19.99, 7, '【两件套】麦香鱼+五块麦乐鸡\n一旦下单，不支持退款！请考虑清除后再购买', 0, 'https://s2.loli.net/2024/12/14/vuBgtML35iRGXnU.png,https://s2.loli.net/2024/12/14/yBt6fnLVHlbZsoU.png,https://s2.loli.net/2024/12/14/swDGBJvnNh78exT.png', '2024-12-14 08:21:32', '0', 0, NULL, 3);
INSERT INTO `goods` VALUES (13, '麦旋风买一送一', 5, 15.00, 7, '仅限到店使用', 0, 'https://s2.loli.net/2024/12/14/Cj7tpsy2GENTg8d.png,https://s2.loli.net/2024/12/14/Xjd3kprhIm5EnVu.png', '2024-12-14 08:24:22', '0', 0, NULL, 3);
INSERT INTO `goods` VALUES (14, '测试', 5, 4.00, 6, '测试', 0, 'https://s2.loli.net/2024/12/14/DqVs7mEAe8h3bvc.png', '2024-12-14 08:25:08', '0', 0, NULL, 1);
INSERT INTO `goods` VALUES (16, '数据库作业答案', 6, 11.00, 3, '纸质版，测试', 1, 'https://s2.loli.net/2024/12/16/3jrl9wHGxcBIShf.png,https://s2.loli.net/2024/12/16/HZ7JdCtlYxzosKy.png,https://s2.loli.net/2024/12/16/9mrTulbjhf8NzDi.png,https://s2.loli.net/2024/12/16/mvsVxWgiBIy8nlq.png,https://s2.loli.net/2024/12/16/LvJH5GdNygm8O4V.png', '2024-12-16 09:42:21', '2', 6, 17, 5);
INSERT INTO `goods` VALUES (17, '数据库与系统第一章答案', 6, 10.00, 3, '纸质版面交或邮寄', 0, 'https://s2.loli.net/2024/12/18/QkaXbeJCR1WscpF.png,https://s2.loli.net/2024/12/18/aVBLWDktKYfqOmo.png', '2024-12-18 14:03:36', '2', 8, 17, 4);
INSERT INTO `goods` VALUES (18, '数据库与系统第二章答案', 6, 10.00, 3, '纸质版面交或邮寄', 0, 'https://s2.loli.net/2024/12/18/7Q1CIBbHlgsAW3z.png,https://s2.loli.net/2024/12/18/tE2SQqn7WKslAyg.png', '2024-12-18 14:04:59', '1', 0, 19, 0);
INSERT INTO `goods` VALUES (19, '数据库与系统第三章答案', 6, 10.00, 3, '纸质版面交或邮寄', 1, 'https://s2.loli.net/2024/12/18/iG91FVmOMbvRpxo.png,https://s2.loli.net/2024/12/18/EinCce8p9PK3MvV.png', '2024-12-18 14:05:30', '2', 4, 19, 1);
INSERT INTO `goods` VALUES (20, '数据库与系统第四章答案', 6, 12.00, 3, '纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面', 0, 'https://s2.loli.net/2024/12/18/Txc3s7JmXOizKLa.png,https://s2.loli.net/2024/12/18/d9Yj6fvKCg8PLEa.png', '2024-12-18 14:06:20', '1', 0, 17, 0);
INSERT INTO `goods` VALUES (21, '数据库与系统第六章答案', 6, 10.00, 3, '纸质版面交或邮寄纸质版面交或邮寄', 0, 'https://s2.loli.net/2024/12/18/sfylupiq6IUaTD1.png,https://s2.loli.net/2024/12/18/rp71xWS5q3EslBD.png', '2024-12-18 14:07:12', '1', 0, 17, 0);
INSERT INTO `goods` VALUES (22, '软件测试第三周练习答案', 6, 9.00, 3, '电子版，发邮箱，不会可讲解', 0, 'https://s2.loli.net/2024/12/18/ASnXRfaUJrzKVHW.png,https://s2.loli.net/2024/12/18/IKHdb7W6DjJpqCV.png', '2024-12-18 14:08:09', '0', 0, NULL, 0);
INSERT INTO `goods` VALUES (23, '软件测试复习资料', 6, 5.00, 3, '虽然不用考试，但最好还是复习一下', 1, 'https://s2.loli.net/2024/12/18/Zo3TzHuURr8gFDA.png', '2024-12-18 14:08:48', '0', 0, NULL, 1);
INSERT INTO `goods` VALUES (24, 'Unity射箭游戏源文件', 6, 99.00, 7, '可运行', 0, 'https://s2.loli.net/2024/12/18/2VFsv9GfAPcOmKp.png,https://s2.loli.net/2024/12/18/7KTVLwvJQD6sPqE.png', '2024-12-18 14:10:56', '0', 0, NULL, 1);
INSERT INTO `goods` VALUES (25, '明萨拉', 6, 999999.00, 1, '不卖，没走丢，长太漂亮了给你们看一下', 0, 'https://s2.loli.net/2024/12/18/xIrKwNzhRgy1T8M.png,https://s2.loli.net/2024/12/18/MpH9JWq6ofYg87L.png', '2024-12-18 14:12:14', '2', 99999, 19, 3);
INSERT INTO `goods` VALUES (26, '用C#编写数据库实验', 6, 20.00, 7, '内含源码', 0, 'https://s2.loli.net/2024/12/18/CJcwL4tWIzKMRs1.png', '2024-12-18 14:14:11', '0', 0, NULL, 1);
INSERT INTO `goods` VALUES (27, 'steam平台雨世界cdk', 3, 21.00, 7, '发货后不可退款', 0, 'https://s2.loli.net/2024/12/18/PMvQB9TSLJ4Kemf.png', '2024-12-18 14:18:44', '0', 0, NULL, 1);
INSERT INTO `goods` VALUES (28, 'steam平台空洞骑士cdk', 3, 23.00, 7, '发货后不可退款', 1, 'https://s2.loli.net/2024/12/18/sQG3JDucieqUIYo.png', '2024-12-18 14:19:20', '0', 0, NULL, 4);
INSERT INTO `goods` VALUES (29, '博德之门3cdk', 3, 218.00, 7, '发货后不可退款', 0, 'https://s2.loli.net/2024/12/18/gFKbIajHrBJ3cix.png', '2024-12-18 14:20:02', '1', 0, 16, 1);
INSERT INTO `goods` VALUES (30, '星际拓荒cdk', 3, 50.00, 7, '发货后不可退款，不含dlc', 0, 'https://s2.loli.net/2024/12/18/GrzcfNyQmUwn4q7.png', '2024-12-18 14:20:53', '1', 0, 18, 2);
INSERT INTO `goods` VALUES (31, '山羊', 3, 1.00, 7, 'Unity山羊模型，含声音、动画', 0, 'https://s2.loli.net/2024/12/18/q4QAMgY1LPa6CVW.png', '2024-12-18 14:21:29', '0', 0, NULL, 1);

-- ----------------------------
-- Table structure for refund_complaint
-- ----------------------------
DROP TABLE IF EXISTS `refund_complaint`;
CREATE TABLE `refund_complaint`  (
  `complaintID` int NOT NULL AUTO_INCREMENT,
  `tradeID` int NOT NULL,
  `sellerReason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `cTime` datetime NOT NULL,
  `cStatus` tinyint NOT NULL DEFAULT 0,
  `buyerReason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`complaintID`) USING BTREE,
  INDEX `tradeID`(`tradeID` ASC) USING BTREE,
  CONSTRAINT `refund_complaint_ibfk_1` FOREIGN KEY (`tradeID`) REFERENCES `trade_records` (`tradeID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of refund_complaint
-- ----------------------------
INSERT INTO `refund_complaint` VALUES (4, 31, NULL, '2024-12-19 07:27:22', 0, '不用考试');
INSERT INTO `refund_complaint` VALUES (5, 30, NULL, '2024-12-20 01:40:28', 0, '不想要了');
INSERT INTO `refund_complaint` VALUES (6, 1, '二手数码商品，不支持退款', '2024-12-20 01:44:30', 0, '看到了更便宜的');

-- ----------------------------
-- Table structure for refund_records
-- ----------------------------
DROP TABLE IF EXISTS `refund_records`;
CREATE TABLE `refund_records`  (
  `refundID` int NOT NULL AUTO_INCREMENT,
  `tradeID` int NOT NULL,
  `payMethod` tinyint NOT NULL,
  `refundAgreedTime` datetime NOT NULL,
  `refundShippedTime` datetime NULL DEFAULT NULL,
  `refundArrivalTime` datetime NULL DEFAULT NULL,
  `trackingNumber` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`refundID`) USING BTREE,
  INDEX `tradeID`(`tradeID` ASC) USING BTREE,
  CONSTRAINT `refund_records_ibfk_1` FOREIGN KEY (`tradeID`) REFERENCES `trade_records` (`tradeID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of refund_records
-- ----------------------------

-- ----------------------------
-- Table structure for report
-- ----------------------------
DROP TABLE IF EXISTS `report`;
CREATE TABLE `report`  (
  `reportID` int NOT NULL AUTO_INCREMENT,
  `userID` int NOT NULL,
  `goodsID` int NOT NULL,
  `reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `createdTime` datetime NOT NULL,
  PRIMARY KEY (`reportID`) USING BTREE,
  INDEX `userID`(`userID` ASC) USING BTREE,
  INDEX `goodsID`(`goodsID` ASC) USING BTREE,
  CONSTRAINT `report_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `report_ibfk_2` FOREIGN KEY (`goodsID`) REFERENCES `goods` (`goodsID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of report
-- ----------------------------

-- ----------------------------
-- Table structure for school
-- ----------------------------
DROP TABLE IF EXISTS `school`;
CREATE TABLE `school`  (
  `schoolID` int NOT NULL AUTO_INCREMENT,
  `schoolName` varchar(80) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `mailSuffix` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`schoolID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of school
-- ----------------------------
INSERT INTO `school` VALUES (1, '中山大学', 'mail2.sysu.edu.cn');
INSERT INTO `school` VALUES (2, '华南理工大学', 'mail2.scut.edu.cn');

-- ----------------------------
-- Table structure for trade_records
-- ----------------------------
DROP TABLE IF EXISTS `trade_records`;
CREATE TABLE `trade_records`  (
  `tradeID` int NOT NULL AUTO_INCREMENT,
  `sellerID` int NOT NULL,
  `buyerID` int NOT NULL,
  `goodsID` int NOT NULL,
  `turnoverAmount` decimal(10, 2) NOT NULL,
  `shippingAddrID` int NULL DEFAULT NULL,
  `deliveryAddrID` int NULL DEFAULT NULL,
  `orderTime` datetime NOT NULL,
  `payTime` datetime NULL DEFAULT NULL,
  `shippingTime` datetime NULL DEFAULT NULL,
  `shippingCost` decimal(10, 2) NOT NULL DEFAULT 0.00,
  `turnoverTime` datetime NULL DEFAULT NULL,
  `payMethod` tinyint NOT NULL DEFAULT 0,
  `trackingNumber` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `isReturn` tinyint NOT NULL DEFAULT 0,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`tradeID`) USING BTREE,
  INDEX `sellerID`(`sellerID` ASC) USING BTREE,
  INDEX `buyerID`(`buyerID` ASC) USING BTREE,
  INDEX `goodsID`(`goodsID` ASC) USING BTREE,
  INDEX `shippingAddrID`(`shippingAddrID` ASC) USING BTREE,
  INDEX `deliveryAddrID`(`deliveryAddrID` ASC) USING BTREE,
  CONSTRAINT `trade_records_ibfk_1` FOREIGN KEY (`sellerID`) REFERENCES `users` (`userID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `trade_records_ibfk_2` FOREIGN KEY (`buyerID`) REFERENCES `users` (`userID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `trade_records_ibfk_3` FOREIGN KEY (`goodsID`) REFERENCES `goods` (`goodsID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `trade_records_ibfk_4` FOREIGN KEY (`shippingAddrID`) REFERENCES `address` (`addrID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `trade_records_ibfk_5` FOREIGN KEY (`deliveryAddrID`) REFERENCES `address` (`addrID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `trade_records_chk_1` CHECK (`turnoverAmount` >= 0),
  CONSTRAINT `trade_records_chk_2` CHECK (`shippingCost` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 33 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of trade_records
-- ----------------------------
INSERT INTO `trade_records` VALUES (1, 1, 2, 2, 20.00, 1, 1, '2024-12-08 09:45:38', '2024-12-08 15:45:44', '2024-12-18 13:26:00', 0.00, NULL, 1, NULL, 0, '处理中');
INSERT INTO `trade_records` VALUES (2, 1, 2, 4, 65.00, 1, 1, '2024-12-08 20:32:38', '2024-12-08 20:32:41', NULL, 6.00, NULL, 2, NULL, 0, '未发货');
INSERT INTO `trade_records` VALUES (3, 2, 1, 5, 60.00, 1, 1, '2024-12-08 20:52:58', '2024-12-08 20:53:00', '2024-12-08 20:53:01', 0.00, '2024-12-08 13:55:30', 2, NULL, 0, '已评价');
INSERT INTO `trade_records` VALUES (23, 2, 3, 8, 99.00, 15, 18, '2024-12-17 14:11:47', NULL, NULL, 0.00, '2024-12-17 14:16:47', 1, '', 0, '已取消');
INSERT INTO `trade_records` VALUES (24, 2, 3, 8, 99.00, 15, 18, '2024-12-18 00:30:51', NULL, NULL, 0.00, '2024-12-18 00:35:51', 1, '', 0, '已取消');
INSERT INTO `trade_records` VALUES (26, 5, 2, 14, 4.00, NULL, NULL, '2024-12-18 00:44:27', '2024-12-18 00:46:07', NULL, 0.00, '2024-12-18 13:17:57', 0, '', 0, '已退款');
INSERT INTO `trade_records` VALUES (27, 6, 1, 16, 11.00, 17, 1, '2024-12-18 13:21:24', NULL, NULL, 6.00, '2024-12-18 13:26:24', 2, '', 0, '已取消');
INSERT INTO `trade_records` VALUES (28, 6, 2, 16, 11.00, 17, 14, '2024-12-18 13:40:17', '2024-12-18 21:40:52', '2024-12-18 13:44:29', 6.00, '2024-12-18 13:47:02', 2, '', 0, '已评价');
INSERT INTO `trade_records` VALUES (29, 3, 2, 11, 9.90, NULL, NULL, '2024-12-18 13:43:07', '2024-12-18 21:43:25', NULL, 0.00, '2024-12-18 13:56:11', 0, '', 0, '已取消');
INSERT INTO `trade_records` VALUES (30, 3, 1, 28, 23.00, NULL, NULL, '2024-12-19 04:49:59', '2024-12-19 04:50:57', NULL, 0.00, NULL, 0, '', 0, '未发货');
INSERT INTO `trade_records` VALUES (31, 6, 1, 23, 5.00, NULL, NULL, '2024-12-19 05:23:29', '2024-12-19 05:24:48', '2024-12-19 07:20:24', 0.00, '2024-12-20 01:06:24', 0, '', 0, '交易完成');
INSERT INTO `trade_records` VALUES (32, 6, 1, 19, 10.00, 19, 8, '2024-12-19 07:12:15', '2024-12-19 07:13:19', NULL, 4.00, '2024-12-19 07:20:34', 2, '', 0, '已取消');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `userID` int NOT NULL AUTO_INCREMENT,
  `userName` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `passwords` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `schoolID` int NOT NULL,
  `picture` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `tel` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `mail` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `gender` tinyint NULL DEFAULT NULL,
  `userStatus` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`userID`) USING BTREE,
  UNIQUE INDEX `userName`(`userName` ASC) USING BTREE,
  UNIQUE INDEX `mail`(`mail` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, '北风', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://cdn2.thecatapi.com/images/MjA4MTM0OA.jpg', '18620715714', 'bf1@mail2.sysu.edu.cn', 0, 0);
INSERT INTO `users` VALUES (2, 'whiteby', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://images.dog.ceo/breeds/papillon/n02086910_5023.jpg', '17777777777', 'whi@mail2.sysu.edu.cn', 0, 0);
INSERT INTO `users` VALUES (3, '塔夫', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://images.dog.ceo/breeds/spitz-indian/Indian_Spitz.jpg', '11111111111', 'tav@mail2.sysu.edu.cn', 0, 0);
INSERT INTO `users` VALUES (4, 'boreascup', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://s2.loli.net/2024/12/09/1kM2XWOR8uDHqsL.jpg', '18620715784', 'zengrx6@mail2.sysu.edu.cn', 0, 0);
INSERT INTO `users` VALUES (5, '麦麦', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://s2.loli.net/2024/12/14/zEB5r6GwXCWxaeM.png', '12345678900', 'mcd@mail2.sysu.edu.cn', 1, 0);
INSERT INTO `users` VALUES (6, '小猿搜题', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://s2.loli.net/2024/12/18/F9ICLVRUz5NPGoc.png', '12345678900', 'test@mail2.sysu.edu.cn', 0, 0);

SET FOREIGN_KEY_CHECKS = 1;
