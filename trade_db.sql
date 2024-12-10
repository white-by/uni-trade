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

 Date: 10/12/2024 13:13:44
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
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of address
-- ----------------------------
INSERT INTO `address` VALUES (1, 1, '广东省', '珠海市', '香洲区', '中山大学', '19999999999', '塔夫', 1);
INSERT INTO `address` VALUES (3, 1, '湖南省', '湘潭市', '岳塘区', '测试修改地址', '15436273843', '塔夫', 0);
INSERT INTO `address` VALUES (7, 2, '山东省', '枣庄市', '山亭区', '哀伤之邸', '18273629473', '影心', 0);
INSERT INTO `address` VALUES (8, 1, '吉林省', '长春市', '二道区', '测试', '9999999999', '小明', 0);

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
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of admins
-- ----------------------------
INSERT INTO `admins` VALUES (1, '1jdzWuniG6UMtoa3T6uNLA==', '管理员', '12212121221', '1@qq.com', 0, 20);
INSERT INTO `admins` VALUES (3, '1jdzWuniG6UMtoa3T6uNLA==', '邪念', '13609723842', 'darkurge@qq.com', 0, 289);

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
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of announcement
-- ----------------------------

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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of comment
-- ----------------------------
INSERT INTO `comment` VALUES (1, 3, 1, '评论测试', '2024-10-13 00:00:00');
INSERT INTO `comment` VALUES (2, 1, 2, '评论测试2', '2024-12-07 15:33:25');
INSERT INTO `comment` VALUES (3, 5, 1, '测试评价内容', '2024-12-08 13:55:48');

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
  `view` int NULL DEFAULT NULL,
  PRIMARY KEY (`goodsID`) USING BTREE,
  INDEX `userID`(`userID` ASC) USING BTREE,
  INDEX `categoryID`(`categoryID` ASC) USING BTREE,
  INDEX `addrID`(`addrID` ASC) USING BTREE,
  CONSTRAINT `goods_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `users` (`userID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `goods_ibfk_2` FOREIGN KEY (`categoryID`) REFERENCES `category` (`categoryID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `goods_ibfk_3` FOREIGN KEY (`addrID`) REFERENCES `address` (`addrID`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `goods_chk_1` CHECK (`price` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of goods
-- ----------------------------
INSERT INTO `goods` VALUES (1, '小狗玩偶', 1, 19.00, 1, '测试细节', 0, 'https://cbu01.alicdn.com/img/ibank/O1CN01DS6DcJ1TfMxwYtIoM_!!2206564752409-0-cib.jpg,https://cbu01.alicdn.com/img/ibank/O1CN01OM3LFu23opMDQ0lF8_!!2216752467303-0-cib.310x310.jpg', '2024-12-07 23:45:42', '1', 8, 1, 4);
INSERT INTO `goods` VALUES (2, '拍立得mini99', 1, 1300.00, 1, '凑字数凑字数', 1, 'https://tse1-mm.cn.bing.net/th/id/OIP-C.Go6VmQ13-kKnm04jNqMIHQD6D6?rs=1&pid=ImgDetMain', '2024-12-08 15:32:55', '1', 8, 1, 3);
INSERT INTO `goods` VALUES (3, '蛋白粉', 2, 99.00, 1, '凑字数', 0, 'https://imgservice.suning.cn/uimg1/b2c/image/gFZyU4ciCobR3PX2VAjTjQ.jpg', '2024-12-06 15:41:57', '1', 8, 1, 5);
INSERT INTO `goods` VALUES (4, 'pingu摸鱼鹅', 1, 65.00, 1, '未拆袋', 1, 'https://cbu01.alicdn.com/img/ibank/O1CN011aNtFI1EXqJIFR22Q_!!2216426590362-0-cib.310x310.jpg', '2024-12-08 20:29:17', '2', 8, 1, 6);
INSERT INTO `goods` VALUES (5, '充电宝', 2, 60.00, 2, '2w毫安。使用1年', 1, 'https://cbu01.alicdn.com/img/ibank/2019/194/723/10889327491_1286304817.jpg', '2024-12-08 20:30:16', '0', 8, 1, 3);
INSERT INTO `goods` VALUES (6, '联想小新电脑', 2, 4000.00, 2, '使用两年', 0, 'https://pic1.zhimg.com/v2-32d8111e1d00fba6d12d7095e4f4d561_r.jpg?source=1940ef5c', '2024-10-09 15:54:20', '1', 8, 1, 4);
INSERT INTO `goods` VALUES (7, '博德之门3黑胶', 1, 400.00, 6, '全新', 0, 'https://tse1-mm.cn.bing.net/th/id/OIP-C.6oHTxnMBGqA46oG1668s3wHaEK?rs=1&pid=ImgDetMain', '2024-09-09 15:55:07', '2', 8, 1, 6);

-- ----------------------------
-- Table structure for refund_complaint
-- ----------------------------
DROP TABLE IF EXISTS `refund_complaint`;
CREATE TABLE `refund_complaint`  (
  `complaintID` int NOT NULL AUTO_INCREMENT,
  `tradeID` int NOT NULL,
  `cReason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `cTime` datetime NOT NULL,
  `cStatus` tinyint NOT NULL DEFAULT 0,
  PRIMARY KEY (`complaintID`) USING BTREE,
  INDEX `tradeID`(`tradeID` ASC) USING BTREE,
  CONSTRAINT `refund_complaint_ibfk_1` FOREIGN KEY (`tradeID`) REFERENCES `trade_records` (`tradeID`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of refund_complaint
-- ----------------------------

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
  `shippingAddrID` int NOT NULL,
  `deliveryAddrID` int NOT NULL,
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
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of trade_records
-- ----------------------------
INSERT INTO `trade_records` VALUES (1, 1, 2, 2, 20.00, 1, 1, '2024-12-08 09:45:38', '2024-12-08 15:45:44', NULL, 0.00, NULL, 1, NULL, 0, '未发货');
INSERT INTO `trade_records` VALUES (2, 1, 2, 4, 65.00, 1, 1, '2024-12-08 20:32:38', '2024-12-08 20:32:41', '2024-12-08 20:32:45', 6.00, NULL, 2, NULL, 0, '已发货');
INSERT INTO `trade_records` VALUES (3, 2, 1, 5, 60.00, 1, 1, '2024-12-08 20:52:58', '2024-12-08 20:53:00', '2024-12-08 20:53:01', 0.00, '2024-12-08 13:55:30', 2, NULL, 0, '已评价');

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
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES (1, '北风', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://cdn2.thecatapi.com/images/MjA4MTM0OA.jpg', '18620715714', 'bf1@mail2.sysu.edu.cn', 0, 0);
INSERT INTO `users` VALUES (2, 'whiteby', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://images.dog.ceo/breeds/papillon/n02086910_5023.jpg', '17777777777', 'whi@mail2.sysu.edu.cn', 0, 0);
INSERT INTO `users` VALUES (3, '塔夫', '1jdzWuniG6UMtoa3T6uNLA==', 1, 'https://images.dog.ceo/breeds/spitz-indian/Indian_Spitz.jpg', '11111111111', 'tav@mail2.sysu.edu.cn', 0, 0);
INSERT INTO `users` VALUES (4, 'boreascup', 'cDWk421NrDGLovEnqAXCLw==', 1, 'https://s2.loli.net/2024/12/09/1kM2XWOR8uDHqsL.jpg', '18620715784', 'zengrx6@mail2.sysu.edu.cn', 0, 0);

SET FOREIGN_KEY_CHECKS = 1;
