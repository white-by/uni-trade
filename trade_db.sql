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

 Date: 22/12/2024 23:39:17
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
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (1, 1, '广东省', '珠海市', '香洲区', '中山大学', '19827645654', '北风', 1);
INSERT INTO `address` VALUES (3, 1, '湖南省', '湘潭市', '岳塘区', '湖南大学', '15436273843', '米拉', 0);
INSERT INTO `address` VALUES (8, 1, '吉林省', '长春市', '二道区', '松花路27号', '19283729483', '班瑞', 0);
INSERT INTO `address` VALUES (14, 2, '安徽省', '芜湖市', '镜湖区', '动物园', '09876543211', '影心', 1);
INSERT INTO `address` VALUES (15, 2, '新疆维吾尔自治区', '克孜勒苏柯尔克孜自治州', '阿克陶县', '营地', '1234567890', '挠挠', 0);
INSERT INTO `address` VALUES (16, 3, '浙江省', '杭州市', '钱塘区', '西泠印社', '12345678970', '阿尔菲拉', 1);
INSERT INTO `address` VALUES (17, 6, '广东省', '珠海市', '香洲区', '中山大学珠海校区蝾螈食堂三楼', '1234567800', '1', 1);
INSERT INTO `address` VALUES (18, 3, '北京市', '市辖区', '东城区', '幽暗地域', '12345678903', '塔夫', 0);
INSERT INTO `address` VALUES (19, 6, '广东省', '广州市', '海珠区', '新港西路中山大学南校园松涛园三楼啫啫鸡', '12345678900', '啫啫鸡', 0);
INSERT INTO `address` VALUES (20, 7, '广东省', '广州市', '海珠区', '中山大学', '12345678990', 'whi', 1);
INSERT INTO `address` VALUES (21, 8, '广东省', '广州市', '番禺区', '大学城', '12345678990', 'woman', 1);
INSERT INTO `address` VALUES (22, 9, '北京市', '市辖区', '东城区', 'c201', '12345678990', '4090', 1);
INSERT INTO `address` VALUES (23, 4, '广东省', '广州市', '海珠区', '中山大学南校园', '15372847263', '想冬眠', 1);
INSERT INTO `address` VALUES (24, 4, '广东省', '珠海市', '香洲区', '中山大学珠海校区蝾螈6号架空层', '3333333333', '果子狸', 0);
INSERT INTO `address` VALUES (25, 4, '广东省', '广州市', '白云区', '岭南新世界', '17284728392', '悦悦', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admins
-- ----------------------------
INSERT INTO `admins` VALUES (1, '1jdzWuniG6UMtoa3T6uNLA==', '管理员', '12212121221', '1@qq.com', 0, 20);
INSERT INTO `admins` VALUES (3, '1jdzWuniG6UMtoa3T6uNLA==', '邪念', '13609723842', 'darkurge@qq.com', 0, 289);
INSERT INTO `admins` VALUES (4, '1jdzWuniG6UMtoa3T6uNLA==', '莎尔', '18867574564', 'shawdowheart@mail2.sysu.edu.cn', 0, 1000);
INSERT INTO `admins` VALUES (5, '1jdzWuniG6UMtoa3T6uNLA==', '白烟', '12345678990', '2115182149@qq.com', 0, 19);

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of announcement
-- ----------------------------
INSERT INTO `announcement` VALUES (1, '公告测试', '公告测试', '2024-12-14 08:07:28');
INSERT INTO `announcement` VALUES (2, '公告测试2', '公告测试2', '2024-12-15 09:15:53');
INSERT INTO `announcement` VALUES (3, '公告测试3', '公告测试3', '2024-12-16 09:17:30');

-- ----------------------------
-- Table structure for category
-- ----------------------------
DROP TABLE IF EXISTS `category`;
CREATE TABLE `category`  (
  `categoryID` int NOT NULL AUTO_INCREMENT,
  `categoryName` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `descriptions` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  PRIMARY KEY (`categoryID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of category
-- ----------------------------
INSERT INTO `category` VALUES (1, '日常用品', '日常生活中使用的物品，如衣物、文具等');
INSERT INTO `category` VALUES (2, '数码产品', '如手机、平板、电脑\n');
INSERT INTO `category` VALUES (3, '纸质书籍', '旧教材、阅读书籍');
INSERT INTO `category` VALUES (4, '闲置衣物', '旧衣服');
INSERT INTO `category` VALUES (5, '通勤工具', '如自行车、电动车、二轮车、平衡车');
INSERT INTO `category` VALUES (6, '同人周边', '谷子等');
INSERT INTO `category` VALUES (7, '虚拟物品', '充值卡，软件会员等');
INSERT INTO `category` VALUES (8, '其它', '暂无');

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of collection
-- ----------------------------
INSERT INTO `collection` VALUES (3, 1, '2024-12-19 07:53:13');
INSERT INTO `collection` VALUES (6, 1, '2024-12-13 05:52:41');
INSERT INTO `collection` VALUES (7, 2, '2024-12-18 14:01:36');
INSERT INTO `collection` VALUES (8, 1, '2024-12-13 05:52:46');
INSERT INTO `collection` VALUES (8, 3, '2024-12-12 10:59:06');
INSERT INTO `collection` VALUES (9, 1, '2024-12-13 05:52:48');
INSERT INTO `collection` VALUES (25, 2, '2024-12-22 05:38:17');

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 59 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, 'jellycat海盗狗', 1, 190.00, 1, '朋友从英国带回，多买了一只，有原袋。明年一月才回国，发货时间较长，介意勿拍。', 0, 'https://static.petersofkensington.com.au/images/ProductImages/576808-03-Zoom.jpg,https://s2.loli.net/2024/12/22/1Ii7uFTzxvtoc4P.jpg', '2024-12-07 23:45:42', '2', 10, 1, 17);
INSERT INTO `goods` VALUES (2, '拍立得mini99', 1, 1300.00, 1, '凑字数凑字数', 1, 'https://tse1-mm.cn.bing.net/th/id/OIP-C.Go6VmQ13-kKnm04jNqMIHQD6D6?rs=1&pid=ImgDetMain', '2024-12-08 15:32:55', '1', 8, 1, 3);
INSERT INTO `goods` VALUES (3, '蛋白粉', 2, 20.00, 1, '买回来觉得太难吃了，便宜出', 0, 'https://imgservice.suning.cn/uimg1/b2c/image/gFZyU4ciCobR3PX2VAjTjQ.jpg', '2024-12-06 15:41:57', '1', 8, 1, 40);
INSERT INTO `goods` VALUES (4, 'pingu摸鱼鹅', 1, 65.00, 1, '未拆袋', 1, 'https://cbu01.alicdn.com/img/ibank/O1CN011aNtFI1EXqJIFR22Q_!!2216426590362-0-cib.310x310.jpg', '2024-12-08 20:29:17', '2', 8, 1, 8);
INSERT INTO `goods` VALUES (5, '充电宝', 2, 60.00, 2, '2w毫安。使用1年', 1, 'https://cbu01.alicdn.com/img/ibank/2019/194/723/10889327491_1286304817.jpg', '2024-12-08 20:30:16', '0', 8, 1, 7);
INSERT INTO `goods` VALUES (6, '联想小新电脑', 2, 4000.00, 2, '使用两年', 0, 'https://pic1.zhimg.com/v2-32d8111e1d00fba6d12d7095e4f4d561_r.jpg?source=1940ef5c', '2024-10-09 15:54:20', '1', 8, 1, 19);
INSERT INTO `goods` VALUES (7, '博德之门3黑胶', 1, 500.00, 6, '全新，没听过，实物非常好看', 0, 'https://tse1-mm.cn.bing.net/th/id/OIP-C.6oHTxnMBGqA46oG1668s3wHaEK?rs=1&pid=ImgDetMain', '2024-09-09 15:55:07', '2', 8, 1, 19);
INSERT INTO `goods` VALUES (8, '星界棱镜', 2, 99.00, 8, '打不开，故卖出', 0, 'https://s2.loli.net/2024/12/11/7j2avqJPWRMkHUC.jpg\n', '2024-12-11 03:32:53', '1', 0, 15, 2);
INSERT INTO `goods` VALUES (9, 'delias厚底小皮鞋女秋冬加绒真皮黑色玛丽珍增高马丁乐福鞋', 3, 100.00, 4, '哑黑色，39码，加绒款，增高5cm，走路不打脚，仅穿过一次，尺码买小了所以出。 鞋垫材质超纤皮，鞋垫材质超纤皮，鞋头圆头，重量非常轻 已自刀，不可小刀，爽快包邮', 0, 'https://s2.loli.net/2024/12/12/8ynONh71MYjkPcp.jpg,https://s2.loli.net/2024/12/12/VNHQgLnB6Uhb3cp.jpg,https://s2.loli.net/2024/12/12/bDSoBAIjr4ZUFMt.jpg', '2024-12-12 11:42:16', '1', 0, 16, 3);
INSERT INTO `goods` VALUES (10, '树林猫猫狗狗手机壳', 3, 15.80, 1, '适用iPhone15，全包软壳，全新未使用，买多了出', 0, 'https://s2.loli.net/2024/12/14/b1LAO3eBsHVGRNC.png,https://s2.loli.net/2024/12/14/1yJHGl4k8ueB92o.png', '2024-12-14 08:12:19', '2', 4, 16, 4);
INSERT INTO `goods` VALUES (11, '麦当劳早餐券', 3, 9.90, 7, '猪柳麦满分+小杯豆浆\n拍前先咨询', 1, 'https://s2.loli.net/2024/12/14/7GpLczrDd54tJ6N.png', '2024-12-14 08:15:05', '0', 0, NULL, 4);
INSERT INTO `goods` VALUES (12, '麦香鱼代下单', 5, 19.99, 7, '【两件套】麦香鱼+五块麦乐鸡\n一旦下单，不支持退款！请考虑清除后再购买', 0, 'https://s2.loli.net/2024/12/14/vuBgtML35iRGXnU.png,https://s2.loli.net/2024/12/14/yBt6fnLVHlbZsoU.png,https://s2.loli.net/2024/12/14/swDGBJvnNh78exT.png', '2024-12-14 08:21:32', '0', 0, NULL, 4);
INSERT INTO `goods` VALUES (13, '麦旋风买一送一', 5, 15.00, 7, '仅限到店使用', 0, 'https://s2.loli.net/2024/12/14/Cj7tpsy2GENTg8d.png,https://s2.loli.net/2024/12/14/Xjd3kprhIm5EnVu.png', '2024-12-14 08:24:22', '0', 0, NULL, 4);
INSERT INTO `goods` VALUES (14, '测试', 5, 4.00, 6, '测试', 1, 'https://s2.loli.net/2024/12/14/DqVs7mEAe8h3bvc.png', '2024-12-14 08:25:08', '0', 0, NULL, 2);
INSERT INTO `goods` VALUES (16, '数据库作业答案', 6, 11.00, 3, '纸质版，测试', 1, 'https://s2.loli.net/2024/12/16/3jrl9wHGxcBIShf.png,https://s2.loli.net/2024/12/16/HZ7JdCtlYxzosKy.png,https://s2.loli.net/2024/12/16/9mrTulbjhf8NzDi.png,https://s2.loli.net/2024/12/16/mvsVxWgiBIy8nlq.png,https://s2.loli.net/2024/12/16/LvJH5GdNygm8O4V.png', '2024-12-16 09:42:21', '2', 6, 17, 5);
INSERT INTO `goods` VALUES (17, '数据库与系统第一章答案', 6, 10.00, 3, '纸质版面交或邮寄', 0, 'https://s2.loli.net/2024/12/18/QkaXbeJCR1WscpF.png,https://s2.loli.net/2024/12/18/aVBLWDktKYfqOmo.png', '2024-12-18 14:03:36', '2', 8, 17, 4);
INSERT INTO `goods` VALUES (18, '数据库与系统第二章答案', 6, 10.00, 3, '纸质版面交或邮寄', 0, 'https://s2.loli.net/2024/12/18/7Q1CIBbHlgsAW3z.png,https://s2.loli.net/2024/12/18/tE2SQqn7WKslAyg.png', '2024-12-18 14:04:59', '1', 0, 19, 0);
INSERT INTO `goods` VALUES (19, '数据库与系统第三章答案', 6, 10.00, 3, '纸质版面交或邮寄', 1, 'https://s2.loli.net/2024/12/18/iG91FVmOMbvRpxo.png,https://s2.loli.net/2024/12/18/EinCce8p9PK3MvV.png', '2024-12-18 14:05:30', '2', 4, 19, 1);
INSERT INTO `goods` VALUES (20, '数据库与系统第四章答案', 6, 12.00, 3, '纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面交或邮寄纸质版面', 0, 'https://s2.loli.net/2024/12/18/Txc3s7JmXOizKLa.png,https://s2.loli.net/2024/12/18/d9Yj6fvKCg8PLEa.png', '2024-12-18 14:06:20', '1', 0, 17, 0);
INSERT INTO `goods` VALUES (21, '数据库与系统第六章答案', 6, 10.00, 3, '纸质版面交或邮寄纸质版面交或邮寄', 0, 'https://s2.loli.net/2024/12/18/sfylupiq6IUaTD1.png,https://s2.loli.net/2024/12/18/rp71xWS5q3EslBD.png', '2024-12-18 14:07:12', '1', 0, 17, 4);
INSERT INTO `goods` VALUES (22, '软件测试第三周练习答案', 6, 9.00, 3, '电子版，发邮箱，不会可讲解', 0, 'https://s2.loli.net/2024/12/18/ASnXRfaUJrzKVHW.png,https://s2.loli.net/2024/12/18/IKHdb7W6DjJpqCV.png', '2024-12-18 14:08:09', '0', 0, NULL, 2);
INSERT INTO `goods` VALUES (23, '软件测试复习资料', 6, 5.00, 3, '虽然不用考试，但最好还是复习一下', 1, 'https://s2.loli.net/2024/12/18/Zo3TzHuURr8gFDA.png', '2024-12-18 14:08:48', '0', 0, NULL, 1);
INSERT INTO `goods` VALUES (24, 'Unity射箭游戏源文件', 6, 99.00, 7, '可运行', 0, 'https://s2.loli.net/2024/12/18/2VFsv9GfAPcOmKp.png,https://s2.loli.net/2024/12/18/7KTVLwvJQD6sPqE.png', '2024-12-18 14:10:56', '0', 0, NULL, 1);
INSERT INTO `goods` VALUES (25, '明萨拉', 6, 999999.00, 8, '不卖，没走丢，长太漂亮了给你们看一下', 0, 'https://s2.loli.net/2024/12/18/xIrKwNzhRgy1T8M.png,https://s2.loli.net/2024/12/18/MpH9JWq6ofYg87L.png', '2024-12-18 14:12:14', '2', 99999, 19, 8);
INSERT INTO `goods` VALUES (26, '用C#编写数据库实验', 6, 20.00, 7, '内含源码', 0, 'https://s2.loli.net/2024/12/18/CJcwL4tWIzKMRs1.png', '2024-12-18 14:14:11', '0', 0, NULL, 1);
INSERT INTO `goods` VALUES (27, 'steam平台雨世界cdk', 3, 21.00, 7, '发货后不可退款', 0, 'https://s2.loli.net/2024/12/18/PMvQB9TSLJ4Kemf.png', '2024-12-18 14:18:44', '0', 0, NULL, 2);
INSERT INTO `goods` VALUES (28, 'steam平台空洞骑士cdk', 3, 23.00, 7, '发货后不可退款', 1, 'https://s2.loli.net/2024/12/18/sQG3JDucieqUIYo.png', '2024-12-18 14:19:20', '0', 0, NULL, 4);
INSERT INTO `goods` VALUES (29, '博德之门3cdk', 3, 218.00, 7, '发货后不可退款', 0, 'https://s2.loli.net/2024/12/18/gFKbIajHrBJ3cix.png', '2024-12-18 14:20:02', '1', 0, 16, 2);
INSERT INTO `goods` VALUES (30, '星际拓荒cdk', 3, 50.00, 7, '发货后不可退款，不含dlc', 0, 'https://s2.loli.net/2024/12/18/GrzcfNyQmUwn4q7.png', '2024-12-18 14:20:53', '1', 0, 18, 2);
INSERT INTO `goods` VALUES (31, '山羊', 3, 1.00, 7, 'Unity山羊模型，含声音、动画', 0, 'https://s2.loli.net/2024/12/18/q4QAMgY1LPa6CVW.png', '2024-12-18 14:21:29', '0', 0, NULL, 4);
INSERT INTO `goods` VALUES (32, 'lv围巾', 1, 999.00, 4, '本来想送妈妈的，广东热得根本没有应用场景，99新，出了。', 0, 'https://s2.loli.net/2024/12/22/LqAMpi7KVOyQ9Wu.jpg', '2024-12-22 04:53:53', '1', 0, 1, 2);
INSERT INTO `goods` VALUES (33, 'xbox手柄，荧光绿', 1, 99.00, 2, '没背键，换精英手柄了，95新\n只出手柄，不包含小骑士底座', 0, 'https://s2.loli.net/2024/12/22/4ohPqFLrYVnbcT1.jpg', '2024-12-22 04:55:15', '1', 0, 1, 2);
INSERT INTO `goods` VALUES (34, '喜德盛山地自行车黑客380', 1, 488.00, 5, '原价1k3，毕业了便宜出。\n可刀给学妹学弟，也不会给贩子割血，平时仅通勤用，骑了2年多', 0, 'https://s2.loli.net/2024/12/22/RnfZJozi3kbtWLI.jpg', '2024-12-22 04:57:22', '1', 0, 1, 3);
INSERT INTO `goods` VALUES (35, '少女歌剧大场奈奈立牌', 2, 88.00, 6, '抹布洗😭😭\n太穷了回点血。', 0, 'https://s2.loli.net/2024/12/22/Fw8ygimrB5bIHTE.jpg', '2024-12-22 05:00:19', '1', 0, 15, 7);
INSERT INTO `goods` VALUES (36, '红楼梦', 2, 25.00, 3, '人民文学出版社的。\n更喜欢看电子书，出了。', 0, 'https://s2.loli.net/2024/12/22/gWmEDYxKyd5oUSa.jpg', '2024-12-22 05:02:04', '1', 0, 14, 2);
INSERT INTO `goods` VALUES (37, '迷宫组', 2, 299.00, 6, '迷宫组99', 0, 'https://s2.loli.net/2024/12/22/JoQw8Oa569NB7LP.png,https://s2.loli.net/2024/12/22/Bh4oDEAJCQf6XLv.png', '2024-12-22 12:21:22', '1', 0, 15, 2);
INSERT INTO `goods` VALUES (38, '终将成为你台版漫画', 7, 350.00, 3, '终将成为你漫画，全新未拆封', 0, 'https://s2.loli.net/2024/12/22/cFfKzImibdnNERD.png,https://s2.loli.net/2024/12/22/Z3ovODsJIRmCNwG.png', '2024-12-22 12:24:47', '2', 10, 20, 3);
INSERT INTO `goods` VALUES (39, '迷宫饭漫画', 7, 120.00, 3, '天闻角川', 0, 'https://s2.loli.net/2024/12/22/xdTf3BMu4VXIkSq.png', '2024-12-22 12:26:12', '1', 0, 20, 1);
INSERT INTO `goods` VALUES (40, '迷宫组小立牌', 7, 90.00, 6, '迷宫组小立牌，切煤产物', 0, 'https://s2.loli.net/2024/12/22/Qxt3VArsN8lUoJk.png', '2024-12-22 12:27:56', '1', 0, 20, 3);
INSERT INTO `goods` VALUES (41, '若叶睦立牌 AveMujica MyGo ', 7, 90.00, 6, 'Ave Mujica MyGo 若叶睦 1st 立牌', 0, 'https://s2.loli.net/2024/12/22/ZJVMAWrtIQP54LF.png', '2024-12-22 12:29:09', '1', 0, 20, 5);
INSERT INTO `goods` VALUES (42, '克洛 离别战记 黄金国努努', 7, 125.00, 6, '少女歌剧克洛，离别战记黄金国努努，状态如图，离别战记有吊牌', 0, 'https://s2.loli.net/2024/12/22/iF3zW52AsJrQd8v.png', '2024-12-22 12:30:24', '2', 8, 20, 3);
INSERT INTO `goods` VALUES (43, 'dior手提包', 8, 9888.00, 4, 'dior中号 Book Tote 手袋，米白色和蓝色 Oblique 印花刺绣 ', 0, 'https://s2.loli.net/2024/12/22/sE76dNJuDtIlgKU.png,https://s2.loli.net/2024/12/22/G4nrNbwuJCKMg2i.png', '2024-12-22 13:07:01', '1', 0, 21, 1);
INSERT INTO `goods` VALUES (44, 'dior大衣', 8, 26999.00, 4, '38码，灰色，双面绵羊毛和桑蚕丝混纺面料搭配腰带', 0, 'https://s2.loli.net/2024/12/22/PYhC8SKrbFJufAX.png,https://s2.loli.net/2024/12/22/JyRNjcPlsvY7MeD.png', '2024-12-22 13:11:32', '2', 12, 21, 2);
INSERT INTO `goods` VALUES (45, '优衣库连帽外套', 8, 99.00, 4, '优衣库 春秋新款女装休闲连帽外套/时尚A字夹克耐久防水 469774', 0, 'https://s2.loli.net/2024/12/22/VhidgBu521AQ6Ds.png,https://s2.loli.net/2024/12/22/zXOoNnUWH9sGPAk.png', '2024-12-22 13:14:00', '2', 10, 21, 1);
INSERT INTO `goods` VALUES (46, '低腰牛仔阔腿裤全新', 8, 20.00, 4, '全新没穿过，全部实拍\nS码\n腰围72cm 无弹力\n前档19cm\n裤长约95cm\n是低腰，牛仔面料厚实无弹，只适合穿小码的姐妹', 0, 'https://s2.loli.net/2024/12/22/bcdO8PKTgsf3th2.png,https://s2.loli.net/2024/12/22/OmV1cqyjd4kU2Y6.png', '2024-12-22 13:17:39', '1', 0, 21, 1);
INSERT INTO `goods` VALUES (47, '开衫外套', 8, 30.00, 4, '2024单排扣纯色针织毛衣外套开衫慵懒宽松圆领上衣女\n驼色', 0, 'https://s2.loli.net/2024/12/22/VGJebZK246Eac3T.png,https://s2.loli.net/2024/12/22/ZvxTo5Ju9lNEkA1.png', '2024-12-22 13:19:41', '1', 0, 21, 1);
INSERT INTO `goods` VALUES (48, 'MLB鸭舌帽', 8, 50.00, 4, 'mlb韩版帽子ny软顶小标la帽子大标洋基队遮阳防晒', 0, 'https://s2.loli.net/2024/12/22/iwsjTMByacXUEl4.png,https://s2.loli.net/2024/12/22/q4SB7ZDYRup3Hl5.png', '2024-12-22 13:24:34', '1', 0, 21, 1);
INSERT INTO `goods` VALUES (49, '苹果earpods', 9, 30.00, 2, '个人闲置全新拆机有线扁头耳机带包装，7-14pro都可以使用11手机附带的，一次没有使用过。原装正品，习惯用无线一直没用有线不需要连蓝牙的哦线上面都有编码的要的话直接拍就好了', 0, 'https://s2.loli.net/2024/12/22/wbL9GOoSztj5N6r.png,https://s2.loli.net/2024/12/22/elQiXPc2h8AygnT.png', '2024-12-22 13:29:08', '1', 0, 22, 2);
INSERT INTO `goods` VALUES (50, '尼康D7000 尼康防抖镜头DX 18-105', 9, 950.00, 2, '2020年在深圳的时候朋友送的尼康相机和镜头组合。从深圳顺电买的（顺电是一家专业数码家电连锁品牌，实体店铺，一般开在高端商城里面）。正品。', 0, 'https://s2.loli.net/2024/12/22/TOxUqcrWDLyi8K9.png,https://s2.loli.net/2024/12/22/5ITUiDvoe7EWSM4.png', '2024-12-22 13:32:03', '1', 0, 22, 2);
INSERT INTO `goods` VALUES (51, '李宁羽毛球拍', 9, 98.00, 1, '个人闲置出李宁羽毛球拍，暑假买的实习工作了，也没空打了，就打了几分钟，保护膜都没斯，，现在便宜出掉，花230买的，拉好的24磅，算是新手拍，4U超轻80多克 包邮！\n双拍98 送球包和三个新球\n实体店买的保证正品 假货无理由退款！有付款记录', 0, 'https://s2.loli.net/2024/12/22/aXCfG1HtNowvsxe.png,https://s2.loli.net/2024/12/22/muFCXk5LYoGvZSK.png,https://s2.loli.net/2024/12/22/D1io7vpdbCYlHfT.png', '2024-12-22 13:35:19', '1', 0, 22, 2);
INSERT INTO `goods` VALUES (52, '出个小蛇', 4, 150.00, 1, 'jellycat线下店买的，无蓝色袋子，只带出去一起上过一次课，其他时间都在柜子里收着。p1实拍，p2官图。可发实物视频。', 0, 'https://s2.loli.net/2024/12/22/zLGySNEqH8cp2gu.jpg,https://s2.loli.net/2024/12/22/ocSDJB8na32PLCT.jpg', '2024-12-22 14:53:01', '2', 10, 23, 1);
INSERT INTO `goods` VALUES (53, '鱼籽小寿司JELLYCAT', 4, 138.00, 1, '个人自购，渠道是上海浦东机场的书店。想要的友友请带回家！吊牌齐全，没有把玩过', 0, 'https://s2.loli.net/2024/12/22/1eP358Q6qaLxw9d.jpg,https://s2.loli.net/2024/12/22/T3s5LHO2KdD7Ygk.jpg,https://s2.loli.net/2024/12/22/6BARNkbdXzQ75fJ.jpg', '2024-12-22 14:56:00', '2', 8, 23, 1);
INSERT INTO `goods` VALUES (54, 'classic金光圣诞树', 4, 600.00, 1, '金光闪闪圣诞树，常青树！要毕业了，带不动。\n高92cm，自提最好', 0, 'https://s2.loli.net/2024/12/22/xKnHNZrdG3hVm2b.jpg,https://s2.loli.net/2024/12/22/MeJ8uYOjXTk3bmt.jpg,https://s2.loli.net/2024/12/22/Vf6oZ8cudSU3zjq.jpg', '2024-12-22 14:58:56', '1', 0, 23, 1);
INSERT INTO `goods` VALUES (55, '海参', 4, 1.00, 8, '海参，又名海鼠、海黄瓜[2]，是一类海生的棘皮动物，通常生活在水温颇低的海底，平时以过滤沙子中的杂质为食，又有海中清道夫之称。绝大多数海参有骨片，有桌形、扣状、杆状、穿孔板、花纹样、轮形、锚形、笼状等形状；数量不一，一个丑海参约有2000万个骨片，而海地瓜有时全无骨片；骨片多的海参触感粗糙，骨片少的则光滑；骨片是一种单龋的内骨骼，是变小的骨板。 经常出现在蝾螈6号架空层。需自提。', 0, 'https://s2.loli.net/2024/12/22/OF1sau82ybQLcGX.jpg,https://s2.loli.net/2024/12/22/UdokVPJcjlwmt3X.jpg,https://s2.loli.net/2024/12/22/aKQB37TvpZhOIGX.jpg', '2024-12-22 15:07:39', '1', 0, 24, 2);
INSERT INTO `goods` VALUES (56, '外来入侵物种', 4, 1.00, 8, '睡了一觉就从草丛里长出来了，现在的外来入侵物种那么猖獗吗？天理何在！求放过', 0, 'https://s2.loli.net/2024/12/22/Bn9htcav81k6Kg5.jpg,https://s2.loli.net/2024/12/22/qQPYlnxWzSck59R.jpg', '2024-12-22 15:09:22', '1', 0, 24, 2);
INSERT INTO `goods` VALUES (57, '白色海豹', 4, 999999.00, 5, '出厂11年，比较旧', 0, 'https://s2.loli.net/2024/12/22/gobvNTRD1Hh2yZL.jpg,https://s2.loli.net/2024/12/22/IuEp3YrWtAcRj4q.jpg,https://s2.loli.net/2024/12/22/lJk7Uf9rbBHLgFA.jpg,https://s2.loli.net/2024/12/22/KePtnhHZbwUqjVB.jpg', '2024-12-22 15:15:18', '2', 99999, 23, 3);
INSERT INTO `goods` VALUES (58, '只此青绿冰箱贴', 1, 49.00, 6, '除了展孟款都可出，49r/1，可邮寄，可大湾区剧院面交。原袋被我扔了。可送物料/纪念票', 0, 'https://s2.loli.net/2024/12/22/gPlJ6sfITDn3Sv5.jpg,https://s2.loli.net/2024/12/22/jDHw2AJbPBQa5lW.jpg', '2024-12-22 15:23:45', '2', 8, 1, 2);

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
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
) ENGINE = InnoDB AUTO_INCREMENT = 36 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

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
INSERT INTO `trade_records` VALUES (33, 6, 2, 21, 10.00, 17, 14, '2024-12-22 05:06:19', NULL, NULL, 0.00, '2024-12-22 05:11:19', 1, '', 0, '已取消');
INSERT INTO `trade_records` VALUES (34, 6, 2, 21, 10.00, 17, 14, '2024-12-22 05:11:59', NULL, NULL, 0.00, '2024-12-22 05:16:59', 1, '', 0, '已取消');
INSERT INTO `trade_records` VALUES (35, 5, 2, 14, 4.00, NULL, NULL, '2024-12-22 05:12:25', '2024-12-22 05:12:54', NULL, 0.00, NULL, 0, '', 0, '未发货');

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
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, '北风', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://cdn2.thecatapi.com/images/MjA4MTM0OA.jpg', '18620715714', 'bf1@mail2.sysu.edu.cn', 0, 0);
INSERT INTO `users` VALUES (2, 'whiteby', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://images.dog.ceo/breeds/papillon/n02086910_5023.jpg', '17777777777', 'whiteby@mail2.sysu.edu.cn', 0, 0);
INSERT INTO `users` VALUES (3, '塔夫', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://images.dog.ceo/breeds/spitz-indian/Indian_Spitz.jpg', '11111111111', 'tav@mail2.sysu.edu.cn', 0, 0);
INSERT INTO `users` VALUES (4, 'boreascup', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://s2.loli.net/2024/12/09/1kM2XWOR8uDHqsL.jpg', '18620715784', 'zengrx6@mail2.sysu.edu.cn', 0, 0);
INSERT INTO `users` VALUES (5, '麦麦', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://s2.loli.net/2024/12/14/zEB5r6GwXCWxaeM.png', '12345678900', 'mcd@mail2.sysu.edu.cn', 1, 0);
INSERT INTO `users` VALUES (6, '小猿', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://s2.loli.net/2024/12/18/F9ICLVRUz5NPGoc.png', '12345678900', 'test@mail2.sysu.edu.cn', 0, 0);
INSERT INTO `users` VALUES (7, 'whi', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://s2.loli.net/2024/12/22/j79YTpSrU1ZWmeJ.jpg', '12345678990', 'whi@mail2.sysu.edu.cn', 0, 0);
INSERT INTO `users` VALUES (8, 'aaa女装批发', '1jdzWuniG6UMtoa3T6uNLA==', 2, '', '12345678990', 'woman@mail.scut.edu.cn', 0, 0);
INSERT INTO `users` VALUES (9, '4090', '1jdzWuniG6UMtoa3T6uNLA==', 2, '', '12345678990', '4090@mail.scut.edu.cn', 0, 0);

SET FOREIGN_KEY_CHECKS = 1;
