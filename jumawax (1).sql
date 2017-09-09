-- phpMyAdmin SQL Dump
-- version 4.7.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: 09 Sep 2017 pada 19.21
-- Versi Server: 10.1.24-MariaDB
-- PHP Version: 7.1.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jumawax`
--

DELIMITER $$
--
-- Fungsi
--
CREATE DEFINER=`priangga`@`localhost` FUNCTION `createuser` (`agent` VARCHAR(255), `username` VARCHAR(255), `password` VARCHAR(255), `role` VARCHAR(255)) RETURNS VARCHAR(255) CHARSET latin1 BEGIN
DECLARE roleid int;
SELECT u.role_id into roleid FROM role u WHERE u.role = role;
INSERT INTO user VALUES(username,password,agent,roleid);
RETURN 'User succesfully created';
END$$

CREATE DEFINER=`priangga`@`localhost` FUNCTION `doupdatejourneystore` (`pjpid` INT(11), `storecode` VARCHAR(255), `skuid` INT(11), `oos_promo` INT(11), `oos` INT(11), `collect_dtm` TIMESTAMP, `partial_oos` INT(11)) RETURNS VARCHAR(255) CHARSET latin1 BEGIN
DECLARE countsku INT(11);
  SELECT COUNT(*) INTO countsku FROM skubyplan WHERE pjp_id = pjpid AND sku_id = skuid AND store_id = storecode AND status != 'COMPLETED';
  IF countsku = 0
  THEN UPDATE journeyplanbystore SET end_dat = collect_dtm WHERE pjp_id = pjpid AND store_code = storecode;
  END IF;
	RETURN 'SUCCESS';
END$$

CREATE DEFINER=`priangga`@`localhost` FUNCTION `dovisit` (`pjpid` INT(11), `storecode` VARCHAR(255), `skuid` INT(11), `oos_promo` INT(11), `oos` INT(11), `collect_dtm` TIMESTAMP, `partial_oos` INT(11)) RETURNS VARCHAR(255) CHARSET latin1 BEGIN
DECLARE countsku INT(11);
	INSERT INTO oosstoreunit values(pjpid,storecode,sku_id,oos,collect_dtm,partial_oos);
  INSERT INTO oospromostoreunit values(pjpid,storecode,sku_id,oos_promo,collect_dtm);
  UPDATE skubyplan set status = 'COMPLETED' WHERE pjp_id = pjpid AND store_id = storecode AND sku_id = skuid;
  SELECT COUNT(*) INTO countsku FROM skubyplan WHERE pjp_id = pjpid AND sku_id = skuid AND store_id = storecode AND status != 'COMPLETED';
  /*IF countsku < 1
  THEN UPDATE journeyplanbystore SET end_dat = collect_dtm WHERE pjp_id = pjpid AND store_code = storecode;
  END IF;
  /*UPDATE journeyplanbystore SET end_dat = collect_dtm WHERE pjp_id = pjpid AND store_code = storecode;*/
	RETURN 'SUCCESS';
END$$

CREATE DEFINER=`priangga`@`localhost` FUNCTION `generatejourneyplan` (`useragent` VARCHAR(255), `pjpowner` VARCHAR(255)) RETURNS INT(11) BEGIN
	DECLARE last_id int;
  DECLARE systemdate timestamp;
   SELECT MAX(pjp_id)+1 INTO last_id from journeyplan pjp;
   SELECT NOW() INTO systemdate;
   INSERT INTO journeyplan VALUES(last_id,systemdate,useragent,pjpowner,'SUBMITTED');
	RETURN last_id;
END$$

CREATE DEFINER=`priangga`@`localhost` FUNCTION `generatejourneyplanstore` (`pjpid` INT, `storecode` VARCHAR(255)) RETURNS VARCHAR(255) CHARSET latin1 BEGIN
  INSERT INTO journeyplanbystore VALUES(pjpid,storecode,null,null);
  RETURN 'Succesfully Created';
END$$

CREATE DEFINER=`priangga`@`localhost` FUNCTION `selectuser` (`agent` VARCHAR(255)) RETURNS VARCHAR(255) CHARSET latin1 BEGIN
DECLARE userName varchar(255);
SELECT u.username into userName FROM user u WHERE u.agent_name = agent;
RETURN userName;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `account`
--

CREATE TABLE `account` (
  `account_num` varchar(255) NOT NULL,
  `account_name` varchar(255) NOT NULL,
  `pic_name` varchar(255) NOT NULL,
  `unsused_field` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `account`
--

INSERT INTO `account` (`account_num`, `account_name`, `pic_name`, `unsused_field`) VALUES
('0000121', 'Alfa Corporation', 'o0OObusO0o', 0),
('0000122', 'Indomart Corporation', 'Hadi', 0),
('0000123', 'Carefour and Friend', 'Simo', 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `address`
--

CREATE TABLE `address` (
  `address_seq` int(11) NOT NULL,
  `account_num` varchar(255) NOT NULL,
  `address_1` varchar(255) NOT NULL,
  `address_2` varchar(255) DEFAULT NULL,
  `zip_code` int(11) DEFAULT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `address`
--

INSERT INTO `address` (`address_seq`, `account_num`, `address_1`, `address_2`, `zip_code`, `latitude`, `longitude`) VALUES
(1, '0000121', 'Jalan Raya VIla Nusa Indah 1 No. 3', '', 16969, 34.052235, -118.243683),
(2, '0000121', 'Jalan Raya Tambun Tiada Ujung 984 No. 999', '', 16969, 34.052235, -118.243683),
(3, '0000121', 'Jalan Raya Cileungsi Arah Metland No. 2', '', 16969, 34.052235, -118.243683),
(4, '0000121', 'Jalan Raya Pekayon No. 12', '', 16969, 34.052235, -118.243683),
(5, '0000121', 'Jalan Jatiwarna warni No. 1', '', 16969, 34.052235, -118.243683),
(6, '0000121', 'Jalan Bebek Bulak Kapal No. 1', '', 16969, 34.052235, -118.243683),
(7, '0000121', 'Jalan Raya Kelapa Dua No. 1', '', 16969, 34.052235, -118.243683),
(1, '0000122', 'Jalan Sabang No. 1', '', 16969, 34.052235, -118.243683),
(2, '0000122', 'Jalan Perum Galaxy No. 1', '', 16969, 34.052235, -118.243683),
(3, '0000122', 'Jalan Raya Cikeas No. 1', '', 16969, 34.052235, -118.243683),
(4, '0000122', 'Jalan Rawa Lumbu No. 1', '', 16969, 34.052235, -118.243683),
(5, '0000122', 'Jalan Raya Cimuning No. 1', '', 16969, 34.052235, -118.243683),
(6, '0000122', 'Jalan Raya Saharjo Kav 2', '', 16969, 34.052235, -118.243683),
(1, '0000123', 'Jalan MT Haryono', '', 16969, 34.052235, -118.243683);

-- --------------------------------------------------------

--
-- Struktur dari tabel `contact`
--

CREATE TABLE `contact` (
  `contact_seq` int(11) NOT NULL,
  `account_num` varchar(255) NOT NULL,
  `store_name` varchar(255) NOT NULL,
  `contact_name` varchar(255) NOT NULL,
  `phone_num` char(20) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `contact`
--

INSERT INTO `contact` (`contact_seq`, `account_num`, `store_name`, `contact_name`, `phone_num`, `email`) VALUES
(1, '0000121', 'Alfamart Vila Nusa Indah', 'Baskoro', '09123123', 'baskoro@gmail.com'),
(2, '0000121', 'Alfamart Tambun Jauh', 'Baskoro1', '09123123', 'baskoro1@gmail.com'),
(3, '0000121', 'Alfamart Cileungsi Jauh', 'Baskoro2', '09123123', 'baskoro2@gmail.com'),
(4, '0000121', 'Alfa Express Pekayon', 'Baskoro3', '09123123', 'baskoro3@gmail.com'),
(4, '0000121', 'Alfa Express Pekayon', 'Baskoro3', '09123123', 'baskoro3@gmail.com'),
(5, '0000121', 'Alfa Express Jatiwarna', 'Baskoro4', '09123123', 'baskoro4@gmail.com'),
(6, '0000121', 'Alfa Midi Bulak Kapal', 'Baskoro5', '09123123', 'baskoro5@gmail.com'),
(7, '0000121', 'Lawson Kelapa Dua', 'Baskoro6', '09123123', 'baskoro6@gmail.com'),
(1, '0000122', 'Indomaret Sabang', 'Baskoro7', '09123123', 'baskoro7@gmail.com'),
(2, '0000122', 'Indomaret Galaxy', 'Baskoro8', '09123123', 'baskoro8@gmail.com'),
(3, '0000122', 'Indomaret Cikeas', 'Baskoro9', '09123123', 'baskoro9@gmail.com'),
(4, '0000122', 'Indomaret Point Rawalumbu', 'Baskoro10', '09123123', 'baskoro10@gmail.com'),
(5, '0000122', 'Indomaret Point Cimuning', 'Baskoro10', '09123123', 'baskoro10@gmail.com'),
(6, '0000122', 'Indomaret Plus Tebet', 'Baskoro11', '09123123', 'baskoro11@gmail.com'),
(1, '0000123', 'Carefour MT Haryono', 'Baskoro12', '09123123', 'baskoro12@gmail.com');

-- --------------------------------------------------------

--
-- Struktur dari tabel `gorup`
--

CREATE TABLE `gorup` (
  `group_id` int(11) NOT NULL,
  `account_num` varchar(255) NOT NULL,
  `group_name` varchar(255) NOT NULL,
  `unused_field` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `gorup`
--

INSERT INTO `gorup` (`group_id`, `account_num`, `group_name`, `unused_field`) VALUES
(1, '121', 'Alfamart', 0),
(2, '121', 'Alfa Express', 0),
(3, '121', 'Alfa Midi', 0),
(4, '121', 'Lawson', 0),
(5, '122', 'Indomart', 0),
(6, '122', 'Indomart Point', 0),
(7, '122', 'Indomart Plus', 0),
(8, '123', 'Carefour', 0),
(9, '123', 'Carefour Grosir', 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `journeyplan`
--

CREATE TABLE `journeyplan` (
  `pjp_id` int(11) NOT NULL,
  `submit_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `user_agent` varchar(25) NOT NULL,
  `pjp_owner` varchar(25) NOT NULL,
  `status` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `journeyplan`
--

INSERT INTO `journeyplan` (`pjp_id`, `submit_date`, `user_agent`, `pjp_owner`, `status`) VALUES
(125001, '2017-05-25 15:35:02', 'R.Kennedy', 'J.Bush', 'SUBMITTED'),
(125002, '2017-05-30 15:35:02', 'R.Kennedy', 'J.Bush', 'SUBMITTED'),
(125003, '2017-05-27 16:43:53', 'priangga', 'karanda', 'SUBMITTED');

-- --------------------------------------------------------

--
-- Struktur dari tabel `journeyplanbystore`
--

CREATE TABLE `journeyplanbystore` (
  `pjp_id` int(11) NOT NULL,
  `store_code` varchar(255) NOT NULL,
  `notes` varchar(255) DEFAULT NULL,
  `end_dat` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `journeyplanbystore`
--

INSERT INTO `journeyplanbystore` (`pjp_id`, `store_code`, `notes`, `end_dat`) VALUES
(125001, 'ALE14114', NULL, NULL),
(125001, 'ALE14115', NULL, NULL),
(125001, 'ALF1411', NULL, '2017-01-06 05:19:00'),
(125001, 'ALF14112', NULL, NULL),
(125001, 'CRF16111', NULL, NULL),
(125002, 'IDM15111', NULL, NULL),
(125002, 'IDM15112', NULL, NULL),
(125002, 'IDM15113', NULL, NULL),
(125002, 'IDS15116', NULL, NULL),
(125002, 'LAW14117', NULL, NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `oos`
--

CREATE TABLE `oos` (
  `store_code` varchar(255) NOT NULL,
  `pjp_id` int(11) NOT NULL,
  `oos_event_total` int(11) DEFAULT NULL,
  `collect_dtm` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `oospromo`
--

CREATE TABLE `oospromo` (
  `store_code` varchar(255) NOT NULL,
  `pjp_id` int(11) NOT NULL,
  `oos_promo_event_total` int(11) DEFAULT NULL,
  `collect_dtm` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Struktur dari tabel `oospromostoreunit`
--

CREATE TABLE `oospromostoreunit` (
  `pjp_id` int(11) DEFAULT NULL,
  `store_code` varchar(255) DEFAULT NULL,
  `sku_id` int(11) DEFAULT NULL,
  `oos_event_promo_total` int(11) DEFAULT NULL,
  `collect_dtm` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `oospromostoreunit`
--

INSERT INTO `oospromostoreunit` (`pjp_id`, `store_code`, `sku_id`, `oos_event_promo_total`, `collect_dtm`) VALUES
(125001, 'ALF1411', NULL, 1, '2017-01-30 03:30:34'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 03:31:55'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 03:55:35'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 03:57:31'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:01:12'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:02:47'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:04:58'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:05:24'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:17:41'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:18:13'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:37:32'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:38:17'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:38:58'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:40:06'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:41:40'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:42:34'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:45:26'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:46:10'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:46:49'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:47:28'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:47:57'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:49:12'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:52:13'),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:53:43'),
(125001, 'ALF1411', NULL, 1, '2017-01-06 05:19:00');

-- --------------------------------------------------------

--
-- Struktur dari tabel `oosstoreunit`
--

CREATE TABLE `oosstoreunit` (
  `pjp_id` int(11) NOT NULL,
  `store_code` varchar(255) NOT NULL,
  `sku_id` int(11) DEFAULT NULL,
  `oos_event` int(11) DEFAULT NULL,
  `collectdtm` datetime DEFAULT NULL,
  `partial_oos_event` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `oosstoreunit`
--

INSERT INTO `oosstoreunit` (`pjp_id`, `store_code`, `sku_id`, `oos_event`, `collectdtm`, `partial_oos_event`) VALUES
(125001, 'ALF1411', NULL, 1, '2017-01-30 03:30:34', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 03:31:55', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 03:55:35', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 03:57:31', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:01:12', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:02:47', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:04:58', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:05:24', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:17:41', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:18:13', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:37:32', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:38:17', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:38:58', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:40:06', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:41:40', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:42:34', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:45:26', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:46:10', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:46:49', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:47:28', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:47:57', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:49:12', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:52:13', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-30 04:53:43', 1),
(125001, 'ALF1411', NULL, 1, '2017-01-06 05:19:00', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `productcatalogue`
--

CREATE TABLE `productcatalogue` (
  `catalogue_name` varchar(50) DEFAULT NULL,
  `catalogue_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `productcatalogue`
--

INSERT INTO `productcatalogue` (`catalogue_name`, `catalogue_id`) VALUES
('UHT', 1),
('SKM', 2),
('SB', 3);

-- --------------------------------------------------------

--
-- Stand-in structure for view `pvpjpstore`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `pvpjpstore` (
`id` int(11)
,`storecode` varchar(255)
,`storename` varchar(255)
,`name` varchar(255)
,`phonenumber` char(20)
,`email` varchar(255)
,`address` varchar(255)
,`latitude` double
,`longitude` double
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `pvskustore`
-- (Lihat di bawah untuk tampilan aktual)
--
CREATE TABLE `pvskustore` (
`store_id` varchar(255)
,`sku_id` int(11)
,`catalogue_id` int(11)
,`sku_name` varchar(50)
,`pjp_id` int(11)
);

-- --------------------------------------------------------

--
-- Struktur dari tabel `region`
--

CREATE TABLE `region` (
  `region_id` int(11) NOT NULL,
  `zone_id` int(11) NOT NULL,
  `region` varchar(255) NOT NULL,
  `unused_field` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `region`
--

INSERT INTO `region` (`region_id`, `zone_id`, `region`, `unused_field`) VALUES
(1, 3, 'Jawa Barat', 0),
(2, 3, 'Jabodetabek', 0),
(3, 3, 'Jawa Tengah', 0),
(4, 3, 'Jawa Timur', 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `role`
--

CREATE TABLE `role` (
  `role_id` int(11) NOT NULL,
  `role` varchar(255) NOT NULL,
  `role_description` varchar(255) NOT NULL,
  `unused_field` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `role`
--

INSERT INTO `role` (`role_id`, `role`, `role_description`, `unused_field`) VALUES
(3, 'Agent Leader', 'Assign agents PJP', 0),
(4, 'Agent', 'Act as agent to visit store', 0);

-- --------------------------------------------------------

--
-- Struktur dari tabel `sku`
--

CREATE TABLE `sku` (
  `sku_id` int(11) DEFAULT NULL,
  `catalogue_id` int(11) DEFAULT NULL,
  `sku_name` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `sku`
--

INSERT INTO `sku` (`sku_id`, `catalogue_id`, `sku_name`) VALUES
(7777710, 1, 'Frisian Flag Disney Susu UHT Choco Tpk'),
(7777711, 1, 'Frisian Flag Disney Susu UHT'),
(7777712, 1, 'Frisian Flag Family Susu UHT Cokelat'),
(7777713, 1, 'Frisian Flag Family Susu UHT Full'),
(7777714, 1, 'Frisian Flag Family Susu UHT Low Fat Tpk'),
(7777715, 2, 'Frisian Flag Susu Kental Manis Putih 40 gram'),
(7777716, 2, 'Frisian Flag Susu Kental Manis Cokelat Kaleng'),
(7777717, 2, 'Frisian Flag Susu Kental Manis Putih Kaleng'),
(7777718, 2, 'Frisian Flag Susu Kental Manis Gold Kaleng'),
(7777719, 2, 'Frisian Flag Susu Kental Manis Gold 220 gram'),
(7777720, 3, 'Frisian Flag Mama Hamil 200 gram Box'),
(7777721, 3, 'Frisian Flag Bubuk Instant'),
(7777722, 3, 'Frisian Flag Energo Cokelat 400 gram Box'),
(7777723, 3, 'Frisian Flag Karya 456 Madu 400 gram Box'),
(7777724, 3, 'Frisian Flag Bendera Bubuk Full Cream'),
(7777725, 3, 'Frisian Flag Jelajah 123 400 gram'),
(7777725, 3, 'Frisian Flag Jelajah 123 400 gram');

-- --------------------------------------------------------

--
-- Struktur dari tabel `skubyplan`
--

CREATE TABLE `skubyplan` (
  `pjp_id` int(11) DEFAULT NULL,
  `sku_id` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `store_id` varchar(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `skubyplan`
--

INSERT INTO `skubyplan` (`pjp_id`, `sku_id`, `status`, `store_id`) VALUES
(125001, 7777712, 'COMPLETED', 'ALF1411'),
(125001, 7777713, 'COMPLETED', 'ALF1411'),
(125001, 7777714, '', 'ALF1411'),
(125001, 7777715, '', 'ALF1411'),
(125001, 7777716, '', 'ALF1411'),
(125001, 7777717, '', 'ALF1411'),
(125001, 7777720, '', 'ALF1411'),
(125001, 7777721, '', 'ALF1411'),
(125001, 7777722, '', 'ALF1411'),
(125002, 7777711, '', 'ALF1411'),
(125002, 7777710, '', 'ALF1411'),
(125002, 7777711, '', 'ALF14112'),
(125002, 7777712, '', 'ALF14112'),
(125002, 7777716, '', 'ALF14112'),
(125002, 7777717, '', 'ALF14112'),
(125002, 7777718, '', 'ALF14112'),
(125002, 7777725, '', 'ALF14112'),
(125002, 7777724, '', 'ALF14112'),
(125002, 7777723, '', 'ALF14112');

-- --------------------------------------------------------

--
-- Struktur dari tabel `skubystore`
--

CREATE TABLE `skubystore` (
  `store_id` varchar(255) DEFAULT NULL,
  `catalogue_id` int(11) DEFAULT NULL,
  `sku_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `skubystore`
--

INSERT INTO `skubystore` (`store_id`, `catalogue_id`, `sku_id`) VALUES
('ALF1411', 1, 7777710),
('ALF1411', 1, 7777711),
('ALF1411', 1, 7777712),
('ALF1411', 1, 7777713),
('ALF1411', 1, 7777714),
('ALF1411', 2, 7777715),
('ALF1411', 2, 7777716),
('ALF1411', 2, 7777717),
('ALF1411', 3, 7777720),
('ALF1411', 3, 7777721),
('ALF1411', 3, 7777722),
('ALF14112', 1, 7777710),
('ALF14112', 1, 7777711),
('ALF14112', 1, 7777712),
('ALF14112', 2, 7777716),
('ALF14112', 2, 7777717),
('ALF14112', 2, 7777718),
('ALF14112', 3, 7777725),
('ALF14112', 3, 7777724),
('ALF14112', 3, 7777723);

-- --------------------------------------------------------

--
-- Struktur dari tabel `store`
--

CREATE TABLE `store` (
  `store_code` varchar(255) NOT NULL,
  `account_num` varchar(255) NOT NULL,
  `group_id` int(11) NOT NULL,
  `contact_seq` int(11) NOT NULL,
  `address_seq` int(11) NOT NULL,
  `region_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `store`
--

INSERT INTO `store` (`store_code`, `account_num`, `group_id`, `contact_seq`, `address_seq`, `region_id`) VALUES
('ALE14114', '0000121', 2, 4, 4, 2),
('ALE14115', '0000121', 2, 5, 5, 2),
('ALF1411', '0000121', 1, 1, 1, 2),
('ALF14112', '0000121', 1, 2, 2, 2),
('ALF14113', '0000121', 1, 3, 3, 2),
('ALM14116', '0000121', 3, 6, 6, 2),
('CRF16111', '0000123', 8, 1, 1, 2),
('IDM15111', '0000122', 5, 1, 1, 2),
('IDM15112', '0000122', 5, 2, 2, 2),
('IDM15113', '0000122', 5, 3, 3, 2),
('IDS15116', '0000122', 7, 6, 6, 2),
('IDT15114', '0000122', 6, 4, 4, 2),
('IDT15115', '0000122', 6, 5, 5, 2),
('LAW14117', '0000121', 4, 7, 7, 2);

-- --------------------------------------------------------

--
-- Struktur dari tabel `teritory`
--

CREATE TABLE `teritory` (
  `id` int(11) NOT NULL,
  `teritory` varchar(20) DEFAULT NULL,
  `parent_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `teritory`
--

INSERT INTO `teritory` (`id`, `teritory`, `parent_id`) VALUES
(1, 'Jakarta', 0),
(2, 'Jakarta Utara', 1),
(3, 'Jakarta Pusat', 1),
(4, 'Jakarta Timur', 1),
(5, 'Jawa Barat', 0),
(6, 'Bekasi', 5),
(7, 'Tambun', 6),
(8, 'Jati Asih', 6),
(9, 'Narogong', 6),
(10, 'Depok', 5),
(11, 'Tanggerang', 5),
(12, 'Bulak Kapal', 7),
(13, 'Tambun Jauh', 7);

-- --------------------------------------------------------

--
-- Struktur dari tabel `user`
--

CREATE TABLE `user` (
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `agent_name` varchar(255) NOT NULL,
  `role_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `user`
--

INSERT INTO `user` (`username`, `password`, `agent_name`, `role_id`) VALUES
('R.Kennedy', '706e09929d59fcc8f52734dbd45aacff42391a06', 'Richard Kennedy', 4),
('J.Bush', 'sayaleadagent', 'Josh Bush', 3),
('JBond', 'jkluio789', 'James Bond', 4);

-- --------------------------------------------------------

--
-- Struktur dari tabel `zone`
--

CREATE TABLE `zone` (
  `zone_id` int(11) NOT NULL,
  `zone_name` varchar(255) NOT NULL,
  `unused_field` int(11) NOT NULL,
  `unused_field2` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `zone`
--

INSERT INTO `zone` (`zone_id`, `zone_name`, `unused_field`, `unused_field2`) VALUES
(1, 'Timur', 0, 0),
(2, 'Tengah', 0, 0),
(3, 'Barat', 0, 0);

-- --------------------------------------------------------

--
-- Struktur untuk view `pvpjpstore`
--
DROP TABLE IF EXISTS `pvpjpstore`;

CREATE ALGORITHM=UNDEFINED DEFINER=`priangga`@`localhost` SQL SECURITY DEFINER VIEW `pvpjpstore`  AS  select `pjps`.`pjp_id` AS `id`,`pjps`.`store_code` AS `storecode`,`c`.`store_name` AS `storename`,`c`.`contact_name` AS `name`,`c`.`phone_num` AS `phonenumber`,`c`.`email` AS `email`,`addr`.`address_1` AS `address`,`addr`.`latitude` AS `latitude`,`addr`.`longitude` AS `longitude` from (((`journeyplanbystore` `pjps` join `store` `str`) join `address` `addr`) join `contact` `c`) where ((`pjps`.`store_code` = `str`.`store_code`) and (`str`.`account_num` = `c`.`account_num`) and (`str`.`contact_seq` = `c`.`contact_seq`) and (`str`.`account_num` = `addr`.`account_num`) and (`str`.`address_seq` = `addr`.`address_seq`) and isnull(`pjps`.`end_dat`)) ;

-- --------------------------------------------------------

--
-- Struktur untuk view `pvskustore`
--
DROP TABLE IF EXISTS `pvskustore`;

CREATE ALGORITHM=UNDEFINED DEFINER=`priangga`@`localhost` SQL SECURITY DEFINER VIEW `pvskustore`  AS  select `a`.`store_id` AS `store_id`,`a`.`sku_id` AS `sku_id`,`a`.`catalogue_id` AS `catalogue_id`,`b`.`sku_name` AS `sku_name`,`d`.`pjp_id` AS `pjp_id` from (((`skubystore` `a` left join `sku` `b` on(((`a`.`sku_id` = `b`.`sku_id`) and (`a`.`catalogue_id` = `b`.`catalogue_id`)))) left join `store` `c` on((`a`.`store_id` = `c`.`store_code`))) left join `skubyplan` `d` on(((`a`.`sku_id` = `d`.`sku_id`) and (`a`.`store_id` = `d`.`store_id`) and (`d`.`status` <> 'COMPLETED')))) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account`
--
ALTER TABLE `account`
  ADD UNIQUE KEY `account_num` (`account_num`);

--
-- Indexes for table `gorup`
--
ALTER TABLE `gorup`
  ADD PRIMARY KEY (`group_id`);

--
-- Indexes for table `journeyplan`
--
ALTER TABLE `journeyplan`
  ADD PRIMARY KEY (`pjp_id`);

--
-- Indexes for table `region`
--
ALTER TABLE `region`
  ADD PRIMARY KEY (`region_id`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`role_id`);

--
-- Indexes for table `store`
--
ALTER TABLE `store`
  ADD UNIQUE KEY `store_name` (`store_code`);

--
-- Indexes for table `zone`
--
ALTER TABLE `zone`
  ADD PRIMARY KEY (`zone_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `gorup`
--
ALTER TABLE `gorup`
  MODIFY `group_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `region`
--
ALTER TABLE `region`
  MODIFY `region_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `zone`
--
ALTER TABLE `zone`
  MODIFY `zone_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
