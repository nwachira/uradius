-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 29, 2024 at 05:20 PM
-- Server version: 8.0.40-0ubuntu0.22.04.1
-- PHP Version: 8.3.15

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `unganishanuxbill`
--

-- --------------------------------------------------------

--
-- Table structure for table `nas`
--

CREATE TABLE `nas` (
  `id` int NOT NULL,
  `nasname` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `shortname` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'other',
  `ports` int DEFAULT NULL,
  `secret` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'secret',
  `server` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `community` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'RADIUS Client',
  `routers` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `nasreload`
--

CREATE TABLE `nasreload` (
  `nasipaddress` varchar(15) NOT NULL,
  `reloadtime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radacct`
--

CREATE TABLE `radacct` (
  `radacctid` bigint NOT NULL,
  `acctsessionid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `acctuniqueid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `realm` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '',
  `nasipaddress` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `nasportid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nasporttype` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `acctstarttime` datetime DEFAULT NULL,
  `acctupdatetime` datetime DEFAULT NULL,
  `acctstoptime` datetime DEFAULT NULL,
  `acctinterval` int DEFAULT NULL,
  `acctsessiontime` int UNSIGNED DEFAULT NULL,
  `acctauthentic` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `connectinfo_start` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `connectinfo_stop` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `acctinputoctets` bigint DEFAULT NULL,
  `acctoutputoctets` bigint DEFAULT NULL,
  `calledstationid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `callingstationid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `acctterminatecause` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `servicetype` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `framedprotocol` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `framedipaddress` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `framedipv6address` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `framedipv6prefix` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `framedinterfaceid` varchar(44) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `delegatedipv6prefix` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `class` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radcheck`
--

CREATE TABLE `radcheck` (
  `id` int UNSIGNED NOT NULL,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `attribute` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `op` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '==',
  `value` varchar(253) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radgroupcheck`
--

CREATE TABLE `radgroupcheck` (
  `id` int UNSIGNED NOT NULL,
  `groupname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `attribute` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `op` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '==',
  `value` varchar(253) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radgroupreply`
--

CREATE TABLE `radgroupreply` (
  `id` int UNSIGNED NOT NULL,
  `groupname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `attribute` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `op` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '=',
  `value` varchar(253) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `plan_id` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radpostauth`
--

CREATE TABLE `radpostauth` (
  `id` int NOT NULL,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `pass` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `reply` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `authdate` timestamp(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  `class` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radreply`
--

CREATE TABLE `radreply` (
  `id` int UNSIGNED NOT NULL,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `attribute` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `op` char(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '=',
  `value` varchar(253) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `radusergroup`
--

CREATE TABLE `radusergroup` (
  `id` int UNSIGNED NOT NULL,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `groupname` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `priority` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `rad_acct`
--

CREATE TABLE `rad_acct` (
  `id` bigint NOT NULL,
  `acctsessionid` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `realm` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `nasid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `nasipaddress` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `nasportid` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `nasporttype` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `framedipaddress` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `acctinputoctets` bigint NOT NULL DEFAULT '0',
  `acctoutputoctets` bigint NOT NULL DEFAULT '0',
  `acctstatustype` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `macaddr` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dateAdded` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_appconfig`
--

CREATE TABLE `tbl_appconfig` (
  `id` int NOT NULL,
  `setting` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_appconfig`
--

INSERT INTO `tbl_appconfig` (`id`, `setting`, `value`) VALUES
(1, 'CompanyName', 'Unganisha Networks'),
(2, 'currency_code', 'Ksh.'),
(3, 'language', 'english'),
(4, 'show-logo', '1'),
(5, 'nstyle', 'blue'),
(6, 'timezone', 'Africa/Nairobi'),
(7, 'dec_point', ','),
(8, 'thousands_sep', '.'),
(9, 'rtl', '0'),
(10, 'address', '525\r\npatrose'),
(11, 'phone', '0111723138'),
(12, 'date_format', 'd M Y'),
(13, 'note', 'Thank you...'),
(14, 'country_code_phone', '254'),
(15, 'radius_plan', 'Radius Plan'),
(16, 'hotspot_plan', 'Hotspot Plan'),
(17, 'pppoe_plan', 'PPPOE Plan'),
(18, 'vpn_plan', 'VPN Plan'),
(19, 'mpesa_till_consumer_key', 'GBU6XdzvvyliQ3d2AM3qJ7XRTGZTadTp'),
(20, 'mpesa_till_consumer_secret', '0zRnCH6AvmLP3Ia7'),
(21, 'mpesa_till_shortcode_code', '6428468'),
(22, 'mpesa_till_partyb', '5827795'),
(23, 'mpesa_till_pass_key', '59cb7e45598c71f6c37d49806a5caa1edf9fb920bf948bebb6854a2bf3cf68f2'),
(24, 'mpesa_till_env', 'live'),
(25, 'mpesa_till_transaction', 'CustomerBuyGoodsOnline'),
(26, 'payment_gateway', 'MpesatillStk'),
(27, 'api_key', '74685a43d36c30035b7e983a45ff3386613f9a30'),
(28, 'CompanyFooter', 'Unganisha Networks'),
(29, 'printer_cols', '37'),
(30, 'theme', 'default'),
(31, 'payment_usings', 'Mpesa'),
(32, 'reset_day', '1'),
(33, 'disable_voucher', 'no'),
(34, 'voucher_format', 'up'),
(35, 'disable_registration', 'no'),
(36, 'voucher_redirect', ''),
(37, 'radius_enable', '0'),
(38, 'extend_expired', '0'),
(39, 'extend_days', ''),
(40, 'extend_confirmation', ''),
(41, 'enable_balance', 'no'),
(42, 'allow_balance_transfer', 'no'),
(43, 'minimum_transfer', ''),
(44, 'telegram_bot', ''),
(45, 'telegram_target_id', ''),
(46, 'sms_url', ''),
(47, 'wa_url', ''),
(48, 'smtp_host', ''),
(49, 'smtp_port', ''),
(50, 'smtp_user', ''),
(51, 'smtp_pass', ''),
(52, 'smtp_ssltls', ''),
(53, 'mail_from', ''),
(54, 'mail_reply_to', ''),
(55, 'user_notification_expired', 'none'),
(56, 'user_notification_payment', 'none'),
(57, 'user_notification_reminder', 'none'),
(58, 'tawkto', ''),
(59, 'http_proxy', ''),
(60, 'http_proxyauth', ''),
(61, 'session_timeout_duration', ''),
(62, 'new_version_notify', 'enable'),
(63, 'router_check', '0'),
(64, 'allow_phone_otp', 'no'),
(65, 'phone_otp_type', 'sms'),
(66, 'allow_email_otp', 'no'),
(67, 'extend_expiry', 'yes'),
(68, 'hs_auth_method', 'api'),
(69, 'enable_tax', 'no'),
(70, 'tax_rate', '0.5'),
(71, 'custom_tax_rate', ''),
(72, 'github_username', ''),
(73, 'github_token', ''),
(74, 'enable_session_timeout', '0'),
(75, 'hide_mrc', 'no'),
(76, 'hide_tms', 'no'),
(77, 'hide_aui', 'no'),
(78, 'hide_al', 'no'),
(79, 'hide_uet', 'no'),
(80, 'hide_vs', 'no'),
(81, 'hide_pg', 'no'),
(82, 'hotspot_title', 'Unganisha'),
(83, 'hotspot_description', 'Connecting The Unconnected'),
(84, 'hotspot_router_id', '1'),
(85, 'hotspot_router_name', 'Router1'),
(86, 'hotspot_faq_head1', 'test'),
(87, 'hotspot_faq_head2', 'test'),
(88, 'hotspot_faq_head3', 'test'),
(89, 'hotspot_faq_answer1', 'test'),
(90, 'hotspot_faq_answer2', 'test'),
(91, 'hotspot_faq_answer3', 'test'),
(92, 'docs_clicked', 'yes'),
(93, 'csrf_token', 'a3baa9e0c075ca09052811f832ebb660'),
(94, 'show_bandwidth_plan', 'no'),
(95, 'check_customer_online', 'yes'),
(96, 'allow_balance_custom', 'no'),
(97, 'save', 'save');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_bandwidth`
--

CREATE TABLE `tbl_bandwidth` (
  `id` int UNSIGNED NOT NULL,
  `name_bw` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `rate_down` int UNSIGNED NOT NULL,
  `rate_down_unit` enum('Kbps','Mbps') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `rate_up` int UNSIGNED NOT NULL,
  `rate_up_unit` enum('Kbps','Mbps') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `burst` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_bandwidth`
--

INSERT INTO `tbl_bandwidth` (`id`, `name_bw`, `rate_down`, `rate_down_unit`, `rate_up`, `rate_up_unit`, `burst`) VALUES
(1, '10M', 10, 'Mbps', 10, 'Mbps', '');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_customers`
--

CREATE TABLE `tbl_customers` (
  `id` int NOT NULL,
  `username` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `photo` varchar(128) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '/user.default.jpg',
  `pppoe_username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'For PPPOE Login',
  `pppoe_password` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'For PPPOE Login',
  `pppoe_ip` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'For PPPOE Login',
  `fullname` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `address` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `district` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `state` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `zip` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phonenumber` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT '0',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '1',
  `coordinates` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'Latitude and Longitude coordinates',
  `account_type` enum('Business','Personal') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Personal' COMMENT 'For selecting account type',
  `balance` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT 'For Money Deposit',
  `service_type` enum('Hotspot','PPPoE','VPN','Others') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Others' COMMENT 'For selecting user type',
  `auto_renewal` tinyint(1) NOT NULL DEFAULT '1' COMMENT 'Auto renewall using balance',
  `router_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `status` enum('Active','Banned','Disabled','Inactive','Limited','Suspended') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Active',
  `created_by` int NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `last_login` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_customers`
--

INSERT INTO `tbl_customers` (`id`, `username`, `password`, `photo`, `pppoe_username`, `pppoe_password`, `pppoe_ip`, `fullname`, `address`, `city`, `district`, `state`, `zip`, `phonenumber`, `email`, `coordinates`, `account_type`, `balance`, `service_type`, `auto_renewal`, `router_id`, `status`, `created_by`, `created_at`, `last_login`) VALUES
(10, '254111723138', '1234', '/user.default.jpg', '', '1234', '', '254111723138', 'Unganisha', NULL, NULL, NULL, NULL, '254111723138', '254111723138@gmail.com', '', 'Personal', '3.00', 'Hotspot', 1, '1', 'Active', 0, '2024-12-29 08:01:49', NULL),
(14, '254111208991', '1234', '/user.default.jpg', '', '1234', '', '254111208991', 'Unganisha', NULL, NULL, NULL, NULL, '254111208991', '254111208991@gmail.com', '', 'Personal', '0.00', 'Hotspot', 1, '1', 'Active', 0, '2024-12-29 09:43:28', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_customers_fields`
--

CREATE TABLE `tbl_customers_fields` (
  `id` int NOT NULL,
  `customer_id` int NOT NULL,
  `field_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `field_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_customers_inbox`
--

CREATE TABLE `tbl_customers_inbox` (
  `id` int UNSIGNED NOT NULL,
  `customer_id` int NOT NULL,
  `date_created` datetime NOT NULL,
  `date_read` datetime DEFAULT NULL,
  `subject` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `body` text COLLATE utf8mb4_general_ci,
  `from` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'System' COMMENT 'System or Admin or Else',
  `admin_id` int NOT NULL DEFAULT '0' COMMENT 'other than admin is 0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_logs`
--

CREATE TABLE `tbl_logs` (
  `id` int NOT NULL,
  `date` datetime DEFAULT NULL,
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `userid` int NOT NULL,
  `ip` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_logs`
--

INSERT INTO `tbl_logs` (`id`, `date`, `type`, `description`, `userid`, `ip`) VALUES
(1, '2024-12-28 19:57:59', 'SuperAdmin', 'admin Login Successful', 1, '129.222.147.119'),
(2, '2024-12-28 19:59:39', 'SuperAdmin', 'admin Login Successful', 1, '129.222.147.119'),
(3, '2024-12-28 20:37:51', 'SuperAdmin', '[admin]: Settings Saved Successfully', 1, '129.222.147.119'),
(4, '2024-12-28 16:40:17', 'Admin', '[admin]: M-Pesa TillSettings Saved Successfullynull', 1, '129.222.147.119'),
(5, '2024-12-28 16:40:23', 'Admin', '[admin]: M-Pesa TillSettings Saved Successfullynull', 1, '129.222.147.119'),
(6, '2024-12-28 17:14:39', 'SuperAdmin', '[admin]: Settings Saved Successfully', 1, '129.222.147.119'),
(7, '2024-12-28 17:17:47', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '129.222.147.119'),
(8, '2024-12-28 17:18:05', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '129.222.147.119'),
(9, '2024-12-28 17:40:55', 'SuperAdmin', 'admin Login Successful', 1, '209.126.13.153'),
(10, '2024-12-28 17:43:39', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '209.126.13.153'),
(11, '2024-12-28 17:48:14', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '129.222.147.119'),
(12, '2024-12-28 17:57:20', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '129.222.147.119'),
(13, '2024-12-28 18:01:37', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '209.126.13.153'),
(14, '2024-12-28 18:22:33', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '129.222.147.119'),
(15, '2024-12-28 19:17:08', 'Admin', '[admin]: M-Pesa TillSettings Saved Successfullynull', 1, '102.0.11.252'),
(16, '2024-12-28 19:22:51', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '102.0.11.252'),
(17, '2024-12-28 19:33:14', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '129.222.147.119'),
(18, '2024-12-28 19:33:26', '', 'Transaction Record Not Found for this transaction [ ws_CO_28122024193304572111208991 ]', 0, '10.184.20.33'),
(19, '2024-12-28 19:38:43', '', 'Transaction Record Not Found for this transaction [ ws_CO_28122024193828622111723138 ]', 0, '196.201.214.207'),
(20, '2024-12-28 19:40:06', '', 'Unable to connect to 192.168.42.10 on port 8728 using fsockopen: Connection timed out (110)', 0, 'CLI'),
(21, '2024-12-28 19:45:06', '', 'Unable to connect to 192.168.42.10 on port 8728 using fsockopen: Connection timed out (110)', 0, 'CLI'),
(22, '2024-12-28 19:49:35', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '209.126.13.153'),
(23, '2024-12-28 19:50:06', '', 'Unable to connect to 192.168.42.10 on port 8728 using fsockopen: Connection timed out (110)', 0, 'CLI'),
(24, '2024-12-28 19:50:36', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '209.126.13.153'),
(25, '2024-12-28 19:52:32', '', 'Transaction Record Not Found for this transaction [ ws_CO_28122024195156883111208991 ]', 0, '10.184.20.33'),
(26, '2024-12-28 19:52:38', '', 'Transaction Record Not Found for this transaction [ ws_CO_28122024195226851111723138 ]', 0, '196.201.213.44'),
(27, '2024-12-28 19:54:46', 'Admin', '[admin]: M-Pesa TillSettings Saved Successfullynull', 1, '102.0.11.252'),
(28, '2024-12-28 19:55:06', '', 'Unable to connect to 192.168.42.10 on port 8728 using fsockopen: Connection timed out (110)', 0, 'CLI'),
(29, '2024-12-28 19:55:39', '', 'Transaction Record Not Found for this transaction [ ws_CO_28122024195505554111208991 ]', 0, '10.184.20.33'),
(30, '2024-12-28 20:00:01', '', 'Transaction Record Not Found for this transaction [ ws_CO_28122024195951737111208991 ]', 0, '10.184.20.33'),
(31, '2024-12-28 20:00:06', '', 'Unable to connect to 192.168.42.10 on port 8728 using fsockopen: Connection timed out (110)', 0, 'CLI'),
(32, '2024-12-28 20:05:06', '', 'Unable to connect to 192.168.42.10 on port 8728 using fsockopen: Connection timed out (110)', 0, 'CLI'),
(33, '2024-12-28 20:10:06', '', 'Unable to connect to 192.168.42.10 on port 8728 using fsockopen: Connection timed out (110)', 0, 'CLI'),
(34, '2024-12-28 20:15:06', '', 'Unable to connect to 192.168.42.10 on port 8728 using fsockopen: Connection timed out (110)', 0, 'CLI'),
(35, '2024-12-28 20:15:21', 'SuperAdmin', 'admin Login Successful', 1, '129.222.147.119'),
(36, '2024-12-28 20:20:06', '', 'Unable to connect to 192.168.42.10 on port 8728 using fsockopen: Connection timed out (110)', 0, 'CLI'),
(37, '2024-12-28 20:25:06', '', 'Unable to connect to 192.168.42.10 on port 8728 using fsockopen: Connection timed out (110)', 0, 'CLI'),
(38, '2024-12-28 20:25:38', 'SuperAdmin', '[Administrator]:  Cleared the system cache ', 0, '102.0.11.252'),
(39, '2024-12-28 20:27:12', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '102.0.11.252'),
(40, '2024-12-28 20:30:06', '', 'Unable to connect to 192.168.42.10 on port 8728 using fsockopen: Connection timed out (110)', 0, 'CLI'),
(41, '2024-12-28 21:15:00', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '129.222.147.119'),
(42, '2024-12-29 03:17:01', 'SuperAdmin', '[Administrator]:  Cleared the system cache ', 0, '209.126.13.153'),
(43, '2024-12-29 03:21:54', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '209.126.13.153'),
(44, '2024-12-29 14:46:34', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '209.126.13.153'),
(45, '2024-12-29 14:47:18', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '209.126.13.153'),
(46, '2024-12-29 14:48:12', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '209.126.13.153'),
(47, '2024-12-29 14:51:14', 'SuperAdmin', 'admin Login Successful', 1, '209.126.13.153'),
(48, '2024-12-29 14:56:18', 'SuperAdmin', 'admin Login Successful', 1, '209.126.13.153'),
(49, '2024-12-29 15:05:29', 'SuperAdmin', '[admin]: Settings Saved Successfully', 0, '129.222.147.119'),
(50, '2024-12-29 17:05:57', 'Admin', '[admin]: M-Pesa TillSettings Saved Successfullynull', 1, '129.222.147.119');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_meta`
--

CREATE TABLE `tbl_meta` (
  `id` int UNSIGNED NOT NULL,
  `tbl` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Table name',
  `tbl_id` int NOT NULL COMMENT 'table value id',
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `value` mediumtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='This Table to add additional data for any table';

-- --------------------------------------------------------

--
-- Table structure for table `tbl_payments_page`
--

CREATE TABLE `tbl_payments_page` (
  `id` int NOT NULL,
  `username` varchar(255) NOT NULL,
  `transaction_id` varchar(1000) DEFAULT NULL,
  `transaction_ref` varchar(1000) NOT NULL,
  `router_name` varchar(1000) NOT NULL,
  `plan_id` int NOT NULL,
  `plan_name` varchar(1000) NOT NULL,
  `amount` int NOT NULL,
  `phone_number` varchar(255) NOT NULL,
  `transaction_status` varchar(255) NOT NULL,
  `gateway_response` text,
  `payment_gateway` varchar(255) DEFAULT NULL,
  `payment_method` varchar(255) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_date` datetime DEFAULT NULL,
  `expired_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_payment_gateway`
--

CREATE TABLE `tbl_payment_gateway` (
  `id` int NOT NULL,
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` int DEFAULT NULL,
  `gateway` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'xendit | midtrans',
  `gateway_trx_id` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `plan_id` int NOT NULL,
  `plan_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `routers_id` int NOT NULL,
  `mac_address` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `routers` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `price` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `pg_url_payment` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `payment_method` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `payment_channel` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `pg_request` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `pg_paid_response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
  `expired_date` datetime DEFAULT NULL,
  `created_date` datetime NOT NULL,
  `paid_date` datetime DEFAULT NULL,
  `trx_invoice` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'from tbl_transactions',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 unpaid 2 paid 3 failed 4 canceled'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_payment_gateway`
--

INSERT INTO `tbl_payment_gateway` (`id`, `username`, `user_id`, `gateway`, `gateway_trx_id`, `plan_id`, `plan_name`, `routers_id`, `mac_address`, `routers`, `price`, `pg_url_payment`, `payment_method`, `payment_channel`, `pg_request`, `pg_paid_response`, `expired_date`, `created_date`, `paid_date`, `trx_invoice`, `status`) VALUES
(7, '254111208991', NULL, 'MpesatillStk', '', 1, '1 hour', 1, '', 'Router1', '1', 'http://51.161.35.86/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_28122024200213785111208991', 'Success. Request accepted for processing', '2024-12-28 17:02:11', '2024-12-28 17:02:11', '2024-12-28 20:02:21', '', 4),
(9, '254111723138', NULL, 'MpesatillStk', 'SLS56OO0QZ', 1, '1 hour', 1, '', 'Router1', '1', 'http://unganishanetworks.com/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_28122024200450106111723138', 'Success. Request accepted for processing', '2024-12-28 17:04:46', '2024-12-28 17:04:46', '2024-12-28 20:05:16', '', 2),
(11, '254111208991', NULL, 'MpesatillStk', '', 1, '1 hour', 1, NULL, 'Router1', '1', 'http://51.161.35.86/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_28122024202430228111208991', 'Success. Request accepted for processing', '2024-12-28 17:24:27', '2024-12-28 17:24:27', '2024-12-28 20:25:03', '', 4),
(12, '254111208991', NULL, 'MpesatillStk', '', 1, '1 hour', 1, NULL, 'Router1', '1', 'http://51.161.35.86/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_28122024202507806111208991', 'Success. Request accepted for processing', '2024-12-28 17:25:04', '2024-12-28 17:25:04', '2024-12-28 20:25:10', '', 4),
(13, '254111723138', NULL, 'MpesatillStk', 'SLS472K4SS', 1, '1 hour', 1, NULL, 'Router1', '1', 'http://unganishanetworks.com/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_28122024212841914111723138', 'Success. Request accepted for processing', '2024-12-28 18:28:38', '2024-12-28 18:28:38', '2024-12-28 21:28:50', '', 2),
(14, '254111723138', NULL, 'MpesatillStk', 'SLS573SVIX', 1, '1 hour', 1, NULL, 'Router1', '1', 'http://unganishanetworks.com/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_28122024213806931111723138', 'Success. Request accepted for processing', '2024-12-28 18:38:03', '2024-12-28 18:38:03', '2024-12-28 21:38:21', '', 2),
(15, '254111723138', NULL, 'MpesatillStk', 'SLS6750US6', 2, '1 Day', 1, NULL, 'Router1', '1', 'http://unganishanetworks.com/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_28122024214805547111723138', 'Success. Request accepted for processing', '2024-12-28 18:48:02', '2024-12-28 18:48:02', '2024-12-28 21:48:15', '', 2),
(16, '254111723138', NULL, 'MpesatillStk', 'SLT37HCBE7', 1, '1 hour', 1, NULL, 'Router1', '1', 'http://unganishanetworks.com/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_29122024024740867111723138', 'Success. Request accepted for processing', '2024-12-28 23:47:38', '2024-12-28 23:47:38', '2024-12-29 02:47:50', '', 2),
(17, '254111723138', NULL, 'MpesatillStk', 'SLT67HEF4Y', 1, '1 hour', 1, NULL, 'Router1', '1', 'http://unganishanetworks.com/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_29122024025254414111723138', 'Success. Request accepted for processing', '2024-12-28 23:52:52', '2024-12-28 23:52:52', '2024-12-29 02:53:12', '', 2),
(18, '254111723138', NULL, 'MpesatillStk', 'SLT188ZOVP', 1, '1 hour', 1, NULL, 'Router1', '1', 'http://unganishanetworks.com/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_29122024110152580111723138', 'Success. Request accepted for processing', '2024-12-29 08:01:49', '2024-12-29 08:01:49', '2024-12-29 11:02:00', '', 2),
(20, '254111208991', NULL, 'MpesatillStk', '', 2, '1 Day', 1, NULL, 'Router1', '1', 'http://51.161.35.86/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_29122024121814064111208991', 'Success. Request accepted for processing', '2024-12-29 09:18:11', '2024-12-29 09:18:11', '2024-12-29 12:18:47', '', 4),
(21, '254111208991', NULL, 'MpesatillStk', '', 1, '1 hour', 1, NULL, 'Router1', '1', 'http://51.161.35.86/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_29122024123629856111208991', 'Success. Request accepted for processing', '2024-12-29 09:36:26', '2024-12-29 09:36:26', '2024-12-29 12:37:01', '', 4),
(22, '254111208991', NULL, 'MpesatillStk', '', 1, '1 hour', 1, NULL, 'Router1', '1', 'http://51.161.35.86/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_29122024124331542111208991', 'Success. Request accepted for processing', '2024-12-29 09:43:28', '2024-12-29 09:43:28', '2024-12-29 12:44:04', '', 4),
(23, '254111208991', NULL, 'MpesatillStk', '', 1, '1 hour', 1, '', 'Router1', '1', 'http://unganishanetworks.com/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_29122024145423796111208991', 'Success. Request accepted for processing', '2024-12-29 11:54:20', '2024-12-29 11:54:20', '2024-12-29 14:54:34', '', 4),
(24, '254111723138', NULL, 'MpesatillStk', 'SLT3940KQJ', 1, '1 hour', 1, '', 'Router1', '1', 'http://unganishanetworks.com/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_29122024150913467111723138', 'Success. Request accepted for processing', '2024-12-29 12:09:10', '2024-12-29 12:09:10', '2024-12-29 15:09:21', '', 2),
(25, '254111208991', NULL, 'MpesatillStk', '', 1, '1 hour', 1, '', 'Router1', '1', 'http://unganishanetworks.com/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_29122024170010872111208991', 'Success. Request accepted for processing', '2024-12-29 14:00:06', '2024-12-29 14:00:06', '2024-12-29 17:00:18', '', 4),
(26, '254111723138', NULL, 'MpesatillStk', 'SLT39JXXRH', 1, '1 hour', 1, '', 'Router1', '1', 'http://unganishanetworks.com/phpnuxbill/?_route=plugin/initiatetillstk', 'Mpesa Stk Push', 'Mpesa Stk Push', 'ws_CO_29122024170631937111723138', 'Success. Request accepted for processing', '2024-12-29 14:06:28', '2024-12-29 14:06:28', '2024-12-29 17:06:41', '', 2);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_plans`
--

CREATE TABLE `tbl_plans` (
  `id` int NOT NULL,
  `name_plan` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_bw` int NOT NULL,
  `price` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `price_old` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `type` enum('Hotspot','PPPOE','VPN','Balance') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `typebp` enum('Unlimited','Limited') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `limit_type` enum('Time_Limit','Data_Limit','Both_Limit') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `time_limit` int UNSIGNED DEFAULT NULL,
  `time_unit` enum('Mins','Hrs') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `data_limit` int UNSIGNED DEFAULT NULL,
  `data_unit` enum('MB','GB') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `validity` int NOT NULL,
  `validity_unit` enum('Mins','Hrs','Days','Months','Period') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `shared_users` int DEFAULT NULL,
  `routers` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `is_radius` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 is radius',
  `pool` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `plan_expired` int NOT NULL DEFAULT '0',
  `expired_date` tinyint(1) NOT NULL DEFAULT '20',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0 disabled\r\n',
  `allow_purchase` enum('yes','no') COLLATE utf8mb4_general_ci DEFAULT 'yes' COMMENT 'allow to show package in buy package page',
  `prepaid` enum('yes','no') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'yes' COMMENT 'is prepaid',
  `plan_type` enum('Business','Personal') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'Personal' COMMENT 'For selecting account type',
  `device` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `on_login` text COLLATE utf8mb4_general_ci,
  `on_logout` text COLLATE utf8mb4_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_plans`
--

INSERT INTO `tbl_plans` (`id`, `name_plan`, `id_bw`, `price`, `price_old`, `type`, `typebp`, `limit_type`, `time_limit`, `time_unit`, `data_limit`, `data_unit`, `validity`, `validity_unit`, `shared_users`, `routers`, `is_radius`, `pool`, `plan_expired`, `expired_date`, `enabled`, `allow_purchase`, `prepaid`, `plan_type`, `device`, `on_login`, `on_logout`) VALUES
(1, '1 hour', 1, '1', '', 'Hotspot', 'Unlimited', 'Time_Limit', 0, 'Hrs', 0, 'MB', 1, 'Hrs', 1, 'Router1', 0, NULL, 0, 20, 1, 'yes', 'yes', 'Personal', 'MikrotikHotspot', NULL, NULL),
(2, '1 Day', 1, '1', '', 'Hotspot', 'Unlimited', 'Time_Limit', 0, 'Hrs', 0, 'MB', 1, 'Days', 1, 'Router1', 0, NULL, 0, 20, 1, 'yes', 'yes', 'Personal', 'MikrotikHotspot', NULL, NULL),
(3, 'test', 1, '1', '', 'Hotspot', 'Unlimited', 'Time_Limit', 0, 'Hrs', 0, 'MB', 10, 'Mins', 1, 'Router1', 0, NULL, 0, 20, 1, 'yes', 'yes', 'Personal', 'MikrotikHotspot', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pool`
--

CREATE TABLE `tbl_pool` (
  `id` int NOT NULL,
  `pool_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `local_ip` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `range_ip` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `routers` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_port_pool`
--

CREATE TABLE `tbl_port_pool` (
  `id` int NOT NULL,
  `public_ip` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `port_name` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `range_port` varchar(40) COLLATE utf8mb4_general_ci NOT NULL,
  `routers` varchar(40) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_recharge_cards`
--

CREATE TABLE `tbl_recharge_cards` (
  `id` int NOT NULL,
  `card_number` varchar(255) NOT NULL,
  `serial_number` varchar(255) NOT NULL,
  `value` decimal(10,2) NOT NULL,
  `status` enum('active','used') DEFAULT 'active',
  `generated_by` int NOT NULL DEFAULT '0' COMMENT 'id admin',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `used_by` int NOT NULL DEFAULT '0' COMMENT 'None',
  `used_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_recharge_lock`
--

CREATE TABLE `tbl_recharge_lock` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `failed_attempts` int DEFAULT '0',
  `last_attempt` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `locked_until` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_routers`
--

CREATE TABLE `tbl_routers` (
  `id` int NOT NULL,
  `name` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ip_address` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `description` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `coordinates` varchar(50) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `status` enum('Online','Offline') COLLATE utf8mb4_general_ci DEFAULT 'Online',
  `last_seen` datetime DEFAULT NULL,
  `coverage` varchar(8) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '0',
  `enabled` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0 disabled'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_routers`
--

INSERT INTO `tbl_routers` (`id`, `name`, `ip_address`, `username`, `password`, `description`, `coordinates`, `status`, `last_seen`, `coverage`, `enabled`) VALUES
(1, 'Router1', '10.7.0.2', 'admin', 'Kipawa@12', '', '', 'Online', '2024-12-28 22:05:02', '0', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_transactions`
--

CREATE TABLE `tbl_transactions` (
  `id` int NOT NULL,
  `invoice` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` int DEFAULT NULL,
  `plan_name` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `price` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `recharged_on` date NOT NULL,
  `recharged_time` time NOT NULL DEFAULT '00:00:00',
  `expiration` date NOT NULL,
  `time` time NOT NULL,
  `method` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `routers` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` enum('Hotspot','PPPOE','VPN','Balance') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `note` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'for note',
  `admin_id` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_transactions`
--

INSERT INTO `tbl_transactions` (`id`, `invoice`, `username`, `user_id`, `plan_name`, `price`, `recharged_on`, `recharged_time`, `expiration`, `time`, `method`, `routers`, `type`, `note`, `admin_id`) VALUES
(1, 'INV-1', '254111723138', 2, '1 hour', '1', '2024-12-28', '20:05:01', '2024-12-28', '21:05:01', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', '', 0),
(2, 'INV-2', '254111723138', 2, '1 hour', '1', '2024-12-28', '20:05:16', '2024-12-28', '21:05:16', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', '', 0),
(3, 'INV-3', '254111723138', 5, '1 hour', '1', '2024-12-28', '21:28:50', '2024-12-28', '22:28:50', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', '', 0),
(4, 'INV-4', '254111723138', 6, '1 hour', '1', '2024-12-28', '21:38:21', '2024-12-28', '22:38:21', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', '', 0),
(5, 'INV-5', '254111723138', 7, '1 Day', '1', '2024-12-28', '21:48:15', '2024-12-29', '21:48:15', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', '', 0),
(6, 'INV-6', '254111723138', 8, '1 hour', '1', '2024-12-29', '02:47:50', '2024-12-29', '03:47:50', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', '', 0),
(7, 'INV-7', '254111723138', 9, '1 hour', '1', '2024-12-29', '02:53:12', '2024-12-29', '03:53:12', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', '', 0),
(8, 'INV-8', '254111723138', 10, '1 hour', '1', '2024-12-29', '11:02:00', '2024-12-29', '12:02:00', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', '', 0),
(9, 'INV-9', '254111723138', 10, '1 hour', '1', '2024-12-29', '15:09:21', '2024-12-29', '16:09:21', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', '', 0),
(10, 'INV-10', '254111723138', 10, '1 hour', '1', '2024-12-29', '17:06:41', '2024-12-29', '18:06:41', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', '', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `id` int UNSIGNED NOT NULL,
  `root` int NOT NULL DEFAULT '0' COMMENT 'for sub account',
  `photo` varchar(128) COLLATE utf8mb4_general_ci NOT NULL DEFAULT '/admin.default.png',
  `username` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `fullname` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `email` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `city` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'kota',
  `subdistrict` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'kecamatan',
  `ward` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '' COMMENT 'kelurahan',
  `user_type` enum('SuperAdmin','Admin','Report','Agent','Sales') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` enum('Active','Inactive') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Active',
  `data` text COLLATE utf8mb4_general_ci COMMENT 'to put additional data',
  `last_login` datetime DEFAULT NULL,
  `login_token` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `creationdate` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`id`, `root`, `photo`, `username`, `fullname`, `password`, `phone`, `email`, `city`, `subdistrict`, `ward`, `user_type`, `status`, `data`, `last_login`, `login_token`, `creationdate`) VALUES
(1, 0, '/admin.default.png', 'admin', 'Administrator', 'd033e22ae348aeb5660fc2140aec35850c4da997', '', '', '', '', '', 'SuperAdmin', 'Active', NULL, '2024-12-29 14:56:18', 'f9392b63ba986521967011a4e662f6db8191bcb7', '2014-06-23 01:43:07');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_user_recharges`
--

CREATE TABLE `tbl_user_recharges` (
  `id` int NOT NULL,
  `customer_id` int NOT NULL,
  `username` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `plan_id` int NOT NULL,
  `namebp` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `recharged_on` date NOT NULL,
  `recharged_time` time NOT NULL DEFAULT '00:00:00',
  `expiration` date NOT NULL,
  `time` time NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `method` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
  `routers` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `admin_id` int NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_user_recharges`
--

INSERT INTO `tbl_user_recharges` (`id`, `customer_id`, `username`, `plan_id`, `namebp`, `recharged_on`, `recharged_time`, `expiration`, `time`, `status`, `method`, `routers`, `type`, `admin_id`) VALUES
(1, 2, '254111723138', 1, '1 hour', '2024-12-28', '20:05:01', '2024-12-28', '21:05:01', 'off', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', 0),
(2, 2, '254111723138', 1, '1 hour', '2024-12-28', '20:05:16', '2024-12-28', '21:05:16', 'off', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', 0),
(3, 5, '254111723138', 1, '1 hour', '2024-12-28', '21:28:50', '2024-12-28', '22:28:50', 'off', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', 0),
(4, 6, '254111723138', 1, '1 hour', '2024-12-28', '21:38:21', '2024-12-28', '22:38:21', 'off', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', 0),
(5, 7, '254111723138', 2, '1 Day', '2024-12-28', '21:48:15', '2024-12-29', '21:48:15', 'on', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', 0),
(6, 8, '254111723138', 1, '1 hour', '2024-12-29', '02:47:50', '2024-12-29', '03:47:50', 'off', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', 0),
(7, 9, '254111723138', 1, '1 hour', '2024-12-29', '02:53:12', '2024-12-29', '03:53:12', 'off', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', 0),
(8, 10, '254111723138', 1, '1 hour', '2024-12-29', '17:06:41', '2024-12-29', '18:06:41', 'off', 'MpesatillStk - STK-Push', 'Router1', 'Hotspot', 0);

-- --------------------------------------------------------

--
-- Table structure for table `tbl_voucher`
--

CREATE TABLE `tbl_voucher` (
  `id` int NOT NULL,
  `type` enum('Hotspot','PPPOE') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `routers` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `id_plan` int NOT NULL,
  `code` varchar(55) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `status` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `used_date` datetime DEFAULT NULL,
  `generated_by` int NOT NULL DEFAULT '0' COMMENT 'id admin'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `nas`
--
ALTER TABLE `nas`
  ADD PRIMARY KEY (`id`),
  ADD KEY `nasname` (`nasname`);

--
-- Indexes for table `nasreload`
--
ALTER TABLE `nasreload`
  ADD PRIMARY KEY (`nasipaddress`);

--
-- Indexes for table `radacct`
--
ALTER TABLE `radacct`
  ADD PRIMARY KEY (`radacctid`),
  ADD UNIQUE KEY `acctuniqueid` (`acctuniqueid`),
  ADD KEY `username` (`username`),
  ADD KEY `framedipaddress` (`framedipaddress`),
  ADD KEY `framedipv6address` (`framedipv6address`),
  ADD KEY `framedipv6prefix` (`framedipv6prefix`),
  ADD KEY `framedinterfaceid` (`framedinterfaceid`),
  ADD KEY `delegatedipv6prefix` (`delegatedipv6prefix`),
  ADD KEY `acctsessionid` (`acctsessionid`),
  ADD KEY `acctsessiontime` (`acctsessiontime`),
  ADD KEY `acctstarttime` (`acctstarttime`),
  ADD KEY `acctinterval` (`acctinterval`),
  ADD KEY `acctstoptime` (`acctstoptime`),
  ADD KEY `nasipaddress` (`nasipaddress`),
  ADD KEY `class` (`class`);

--
-- Indexes for table `radcheck`
--
ALTER TABLE `radcheck`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`(32));

--
-- Indexes for table `radgroupcheck`
--
ALTER TABLE `radgroupcheck`
  ADD PRIMARY KEY (`id`),
  ADD KEY `groupname` (`groupname`(32));

--
-- Indexes for table `radgroupreply`
--
ALTER TABLE `radgroupreply`
  ADD PRIMARY KEY (`id`),
  ADD KEY `groupname` (`groupname`(32));

--
-- Indexes for table `radpostauth`
--
ALTER TABLE `radpostauth`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`),
  ADD KEY `class` (`class`);

--
-- Indexes for table `radreply`
--
ALTER TABLE `radreply`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`(32));

--
-- Indexes for table `radusergroup`
--
ALTER TABLE `radusergroup`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`(32));

--
-- Indexes for table `rad_acct`
--
ALTER TABLE `rad_acct`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`),
  ADD KEY `framedipaddress` (`framedipaddress`),
  ADD KEY `acctsessionid` (`acctsessionid`),
  ADD KEY `nasipaddress` (`nasipaddress`);

--
-- Indexes for table `tbl_appconfig`
--
ALTER TABLE `tbl_appconfig`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_bandwidth`
--
ALTER TABLE `tbl_bandwidth`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_customers`
--
ALTER TABLE `tbl_customers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_customers_fields`
--
ALTER TABLE `tbl_customers_fields`
  ADD PRIMARY KEY (`id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `tbl_customers_inbox`
--
ALTER TABLE `tbl_customers_inbox`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_logs`
--
ALTER TABLE `tbl_logs`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_meta`
--
ALTER TABLE `tbl_meta`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_payments_page`
--
ALTER TABLE `tbl_payments_page`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_payment_gateway`
--
ALTER TABLE `tbl_payment_gateway`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_plans`
--
ALTER TABLE `tbl_plans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_pool`
--
ALTER TABLE `tbl_pool`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_port_pool`
--
ALTER TABLE `tbl_port_pool`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_recharge_cards`
--
ALTER TABLE `tbl_recharge_cards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `card_number` (`card_number`),
  ADD UNIQUE KEY `serial_number` (`serial_number`);

--
-- Indexes for table `tbl_recharge_lock`
--
ALTER TABLE `tbl_recharge_lock`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_routers`
--
ALTER TABLE `tbl_routers`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_transactions`
--
ALTER TABLE `tbl_transactions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_user_recharges`
--
ALTER TABLE `tbl_user_recharges`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `tbl_voucher`
--
ALTER TABLE `tbl_voucher`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `nas`
--
ALTER TABLE `nas`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radacct`
--
ALTER TABLE `radacct`
  MODIFY `radacctid` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radcheck`
--
ALTER TABLE `radcheck`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radgroupcheck`
--
ALTER TABLE `radgroupcheck`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radgroupreply`
--
ALTER TABLE `radgroupreply`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radpostauth`
--
ALTER TABLE `radpostauth`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radreply`
--
ALTER TABLE `radreply`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `radusergroup`
--
ALTER TABLE `radusergroup`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rad_acct`
--
ALTER TABLE `rad_acct`
  MODIFY `id` bigint NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_appconfig`
--
ALTER TABLE `tbl_appconfig`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=98;

--
-- AUTO_INCREMENT for table `tbl_bandwidth`
--
ALTER TABLE `tbl_bandwidth`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_customers`
--
ALTER TABLE `tbl_customers`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `tbl_customers_fields`
--
ALTER TABLE `tbl_customers_fields`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_customers_inbox`
--
ALTER TABLE `tbl_customers_inbox`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_logs`
--
ALTER TABLE `tbl_logs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `tbl_meta`
--
ALTER TABLE `tbl_meta`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_payments_page`
--
ALTER TABLE `tbl_payments_page`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_payment_gateway`
--
ALTER TABLE `tbl_payment_gateway`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `tbl_plans`
--
ALTER TABLE `tbl_plans`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_pool`
--
ALTER TABLE `tbl_pool`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_port_pool`
--
ALTER TABLE `tbl_port_pool`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_recharge_cards`
--
ALTER TABLE `tbl_recharge_cards`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_recharge_lock`
--
ALTER TABLE `tbl_recharge_lock`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tbl_routers`
--
ALTER TABLE `tbl_routers`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_transactions`
--
ALTER TABLE `tbl_transactions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `tbl_user_recharges`
--
ALTER TABLE `tbl_user_recharges`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `tbl_voucher`
--
ALTER TABLE `tbl_voucher`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
