-- MySQL dump 10.13  Distrib 5.5.50, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: chinaroad_imis
-- ------------------------------------------------------
-- Server version	5.5.50-0ubuntu0.14.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `t_vital_parameter`
--

DROP TABLE IF EXISTS `t_vital_parameter`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `t_vital_parameter` (
  `id` varchar(50) NOT NULL,
  `param_name` varchar(50) DEFAULT NULL COMMENT '参数名',
  `cn_name` varchar(50) DEFAULT NULL COMMENT '参数中文名',
  `param_value` varchar(1000) DEFAULT NULL COMMENT '参数值',
  `innate` bit(1) DEFAULT b'0' COMMENT '是否内置参数',
  `default_value` varchar(100) DEFAULT NULL COMMENT '默认值',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `create_user` varchar(50) DEFAULT NULL,
  `update_time` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `update_user` varchar(50) DEFAULT NULL,
  `description` varchar(500) DEFAULT NULL COMMENT '描述/备注',
  `sort` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_vital_parameter`
--

LOCK TABLES `t_vital_parameter` WRITE;
/*!40000 ALTER TABLE `t_vital_parameter` DISABLE KEYS */;
INSERT INTO `t_vital_parameter` VALUES ('16','theme','主题','[{\"default\":\"默认主题\",\"cerulean\":\"天蓝主题\",\"readable\":\"橙色主题\",\"united\":\"红色主题\",\"flat\":\"Flat主题\"}]','\0','天蓝主题','2016-09-03 06:01:55','1','2016-09-03 06:01:54','1',NULL,0),('24','sys_office_type','机构类型','[{\"1\":\"单位\",\"2\":\"部门\",\"3\":\"工作组\",\"4\":\"其它\"}]','\0','单位','2016-09-03 06:02:13','1','2016-09-03 06:01:54','1',NULL,0),('27','sys_office_common','其他','[{\"1\":\"综合部\",\"2\":\"开发部\",\"3\":\"人力部\"}]','\0','综合部','2016-09-03 06:02:15','1','2016-09-03 06:01:54','1',NULL,0),('4','show_hide','是否隐藏','[{\"1\":\"显示\",\"0\":\"隐藏\"}]','\0','显示','2016-09-03 06:02:19','1','2016-09-03 06:01:54','1',NULL,0),('41','sys_user_type','用户类型','[{\"1\":\"系统管理\",\"2\":\"部门经理\",\"3\":\"普通用户\"}]','\0','系统管理','2016-09-03 06:02:21','1','2016-09-03 06:01:54','1',NULL,0),('6','yes_no','是否','[{\"1\":\"是\",\"0\":\"否\"}]','\0','是','2016-09-03 06:02:23','1','2016-09-03 06:01:54','1',NULL,0),('68','sys_log_type','日志类型','[{\"1\":\"接入日志\",\"2\":\"异常日志\"}]','\0','接入日志','2016-09-03 06:02:24','1','2016-09-03 06:01:54','1',NULL,0),('9','color','颜色','[{\"yellow\":\"黄色\",\"orange\":\"橙色\",\"red\":\"红色\",\"green\":\"绿色\",\"blue\":\"蓝色\"}]','\0','蓝色','2016-09-03 06:02:26','1','2016-09-03 06:01:54','1',NULL,0),('97','sex','性别','[{\"1\":\"男\",\"2\":\"女\"}]','\0','男','2016-09-03 06:02:28','1','2016-09-03 06:01:54','1',NULL,0),('aae6f83b3d294b679a0c0eaed548b073','org_level','级次','[{\"0\":\"子级\",\"1\":\"平级\"}]','\0','子级','2016-09-03 06:02:29','1','2016-09-03 06:01:54','1',NULL,0),('dcfced4fdb1247fb8fcf7800e9434bf9','global_permission','全局权限','[{\"2\":\"系统管理员\",\"3\":\"常规\",\"1\":\"超级管理员\"}]','\0','超级管理员','2016-09-03 06:02:30','1','2016-09-03 06:01:54','1',NULL,0),('e040f16c0a354e77a85ccc65dc8c1d18','resource_type','资源类型','[{\"2\":\"菜单\",\"5\":\"权限\",\"3\":\"功能\",\"1\":\"模块\",\"4\":\"操作\"}]','\0','菜单','2016-09-03 06:02:32','1','2016-09-03 06:01:54','1',NULL,0),('f1f5de5fe0b54e0d810d14d6ab6630e6','org_location','位置','[{\"1\":\"行后\",\"0\":\"行前\"}]','\0','行后','2016-09-03 06:02:34','1','2016-09-03 06:01:54','1',NULL,0);
/*!40000 ALTER TABLE `t_vital_parameter` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2016-09-03 17:56:33
