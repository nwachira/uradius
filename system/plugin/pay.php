<?php
/// Allow requests from any origin
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit;
}

// Check if the tbl_payments_page table exists
$db = ORM::getDb();
$tableExists = false;
$tables = $db->query("SHOW TABLES")->fetchAll(PDO::FETCH_COLUMN);
if (in_array('tbl_payments_page', $tables)) {
    $tableExists = true;
}


if (!$tableExists) {
    // Create the tbl_payments_page table if it doesn't exist
    if (!in_array('tbl_payments_page', $tables)) {
        try {
            $db->exec("
                CREATE TABLE `tbl_payments_page` (
                    `id` INT(11) AUTO_INCREMENT PRIMARY KEY,
                    `username` VARCHAR(255) NOT NULL,
                    `transaction_id` VARCHAR(1000) NULL,
                    `transaction_ref` VARCHAR(1000) NOT NULL,
                    `router_name` VARCHAR(1000) NOT NULL,
                    `plan_id` INT(11) NOT NULL,
                    `plan_name` VARCHAR(1000) NOT NULL,
                    `amount` INT(11) NOT NULL,
                    `phone_number` VARCHAR(255) NOT NULL,
                    `transaction_status` VARCHAR(255) NOT NULL,
                    `gateway_response` TEXT,
                    `payment_gateway` VARCHAR(255),
                    `payment_method` VARCHAR(255),
                    `created_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
                    `payment_date` DATETIME DEFAULT NULL,
                    `expired_date` DATETIME DEFAULT NULL
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
            ");
        } catch (PDOException $e) {
            // Handle the exception or log the error message
            echo "Error creating tbl_payments_page table: " . $e->getMessage();
        }
    }
}

register_menu(" Payment Page", true, "pay_overview", 'AFTER_NETWORKS', 'fa fa-paypal', '', "");


function pay_overview()
{
    global $ui;
    _admin();
    $ui->assign('_title', Lang::T("Alternative Payment Page"));
    $ui->assign('_system_menu', '');
    $admin = Admin::_info();
    $ui->assign('_admin', $admin);

    // Check user type for access
    if (!in_array($admin['user_type'], ['SuperAdmin', 'Admin', 'Sales'])) {
        _alert(Lang::T('You do not have permission to access this page'), 'danger', "dashboard");
        exit;
    }

    $query = ORM::for_table('tbl_payments_page')->order_by_desc('created_date');
    $payments = $query->find_many();

    // Get successful payments
    $successfulPayments = ORM::for_table('tbl_payments_page')
        ->where('transaction_status', 'paid')
        ->count();

    // Get failed payments
    $failedPayments = ORM::for_table('tbl_payments_page')
        ->where('transaction_status', 'failed')
        ->count();

    // Get pending payments
    $pendingPayments = ORM::for_table('tbl_payments_page')
        ->where('transaction_status', 'pending')
        ->count();

    // Get cancelled payments
    $cancelledPayments = ORM::for_table('tbl_payments_page')
        ->where('transaction_status', 'cancelled')
        ->count();

    $ui->assign('totalPayments', count($payments));
    $ui->assign('successfulPayments', $successfulPayments);
    $ui->assign('failedPayments', $failedPayments);
    $ui->assign('pendingPayments', $pendingPayments);
    $ui->assign('cancelledPayments', $cancelledPayments);
    $ui->assign('payments', $payments);

    $paymentGateway = pay_getAvailablePaymentGateways();
    if (!$paymentGateway) {
        $ui->assign('message', '<em>' . Lang::T("Payment Gateway is missing, you can purchase payment gateway plugin from ") . ' <a href="https://shop.focuslinkstech.com.ng"> shop.focuslinkstech.com.ng </a>' . ' ' . ' ' . Lang::T(" or Contact ") . ' ' . '<a href="https://t.me/focuslinkstech"> @focuslinkstech </a>' . ' ' . Lang::T(" for more informations") . '</em>');
    }
    $ui->display('pay_overview.tpl');
}

function pay_generate_verification_code()
{
    return rand(100000, 999999);
}

function pay_check()
{
    global $config, $ui;

    if ($config['maintenance_mode']) {
        displayMaintenanceMessage();
        die();
    }
    $payment_gateways = pay_getAvailablePaymentGateways();
    if (empty($payment_gateways)) {
        pay_throwError(Lang::T("Payment gateway not found, Please Go back and try again, or Report this issue to ") . ' <a href="tel:' . $config['phone'] . '">' . $config['phone'] . '</a><br><br>' . Lang::T("Thanks."));
    }
    session_start();
    $ui->assign('_title', Lang::T("Check Your Account Status"));

    $attemptLimit = 5;
    $timeFrame = 10 * 60; // 10 minutes
    $verificationCodeExpiry = 5 * 60; // 5 minutes

    // Initialize or clean up old attempts
    if (!isset($_SESSION['attempts'])) {
        $_SESSION['attempts'] = [];
    } else {
        $_SESSION['attempts'] = array_filter($_SESSION['attempts'], function ($timestamp) use ($timeFrame) {
            return $timestamp >= time() - $timeFrame;
        });
    }

    if (isset($_POST['check']) || isset($_POST['resend_code'])) {
        if (count($_SESSION['attempts']) >= $attemptLimit) {
            $ui->assign('notify', Lang::T("Too many attempts. Please try again later."));
            $ui->assign('notify_t', 'e');
        } else {
            $account = $_POST['account'];
            // Use ORM's first() method to fetch the first matching record
            $customerDetails = ORM::for_table('tbl_customers')
                ->where_any_is([
                    ['username' => $account],
                    ['phonenumber' => $account],
                    ['email' => $account],
                    ['id' => $account]
                ])
                ->find_one();

            $_SESSION['attempts'][] = time();

            if ($customerDetails) {
                // Generate and send verification code
                $verificationCode = pay_generate_verification_code();
                $message = "Hello, \n\n Your verification code is: $verificationCode \n\n" . $config['CompanyName'];
                $phone = $customerDetails->phonenumber;
                $sendMethods = ['sendSMS', 'sendWhatsapp'];

                foreach ($sendMethods as $method) {
                    try {
                        Message::$method($phone, $message);
                        _log('Verification Code Sent to: ' . $phone . ' ' . 'Via: ' . $method . ' ' . 'Message: ' . $message);
                    } catch (Exception $e) {
                        // Log the error and display an error message to the user
                        _log('Failed to send verification code to: ' . $phone . ' ' . 'Via: ' . $method . ' ' . 'Message: ' . $message . ' ' . 'Error: ' . $e->getMessage());
                        $ui->assign('notify', Lang::T("Failed to send verification code via $method. Please try again later."));
                        $ui->assign('notify_t', 'e');
                    }
                }

                // Store verification code, timestamp, and customer ID in session
                $_SESSION['verification_code'] = $verificationCode;
                $_SESSION['verification_code_timestamp'] = time();
                $_SESSION['customer_id'] = $customerDetails->id;

                $ui->assign('method', 'verify');
                $ui->assign('notify', Lang::T("Verification code sent to your phone number."));
                $ui->assign('notify_t', 's');
                $ui->assign('id', $customerDetails->id);
                $ui->assign('customerDetails', $customerDetails);
            } else {
                $ui->assign('notify', Lang::T("No customer found with the provided information."));
                $ui->assign('notify_t', 'e');
            }
        }
    } elseif (isset($_POST['verify_code'])) {
        $inputCode = $_POST['verification_code'];

        if (isset($_SESSION['verification_code'], $_SESSION['verification_code_timestamp'])) {
            $storedCode = $_SESSION['verification_code'];
            $codeTimestamp = $_SESSION['verification_code_timestamp'];

            if (time() - $codeTimestamp <= $verificationCodeExpiry) {
                if ($inputCode == $storedCode && isset($_SESSION['customer_id'])) {
                    $customerDetails = ORM::for_table('tbl_customers')
                        ->find_one($_SESSION['customer_id']);

                    if ($customerDetails) {
                        $ui->assign('method', '');
                        $ui->assign('notify', Lang::T("Account verified successfully."));
                        $ui->assign('notify_t', 's');
                        $bills = User::_billing($_SESSION['customer_id']);
                        foreach ($bills as $bill) {
                        }
                        $plan = pay_getPlan($bill->plan_id);
                        $amount = $plan->price;
                        $currency = $config['currency_code'];
                        $ui->assign('currency', $currency);
                        $ui->assign('amount', $amount);
                        $ui->assign('_bills', $bills);
                        $ui->assign('customerDetails', $customerDetails);
                        $ui->assign('payment_gateways', $payment_gateways);

                        // Clear verification code after successful verification
                        unset($_SESSION['verification_code'], $_SESSION['verification_code_timestamp'], $_SESSION['customer_id']);
                    } else {
                        $ui->assign('notify', Lang::T("Customer details not found."));
                        $ui->assign('notify_t', 'e');
                    }
                } else {
                    $ui->assign('method', 'verify');
                    $ui->assign('customerDetails', 'verify');
                    $ui->assign('id', $_SESSION['customer_id']);
                    $ui->assign('notify', Lang::T("Invalid verification code."));
                    $ui->assign('notify_t', 'e');
                }
            } else {
                $ui->assign('notify', Lang::T("Verification code expired."));
                $ui->assign('notify_t', 'e');
            }
        } else {
            $ui->assign('notify', Lang::T("Verification code not found."));
            $ui->assign('notify_t', 'e');
        }
    }

    $ui->display('pay_check.tpl');
}

function pay_suspended()
{
    global $ui;
    $ui->assign('_title', Lang::T("Internet Suspended"));

    $ui->display('pay_suspended.tpl');
}

function pay_now()
{
    global $config;

    if ($config['maintenance_mode']) {
        displayMaintenanceMessage();
        die();
    }
    if (isset($_POST['pay'])) {
        $payment_data = pay_validateAndPreparePaymentData($_POST);
        $gateway = $payment_data['payment_gateway'];
        if (empty($gateway)) {
            pay_throwError(Lang::T("Please select a payment gateway."));
        }
        $function_name = 'pay_processPayment_' . $gateway;
        if (function_exists($function_name)) {
            echo $function_name($payment_data);
        } else {
            pay_throwError(Lang::T("Payment processing function not found, Please Go back and try again, or Report this issue to ") . ' <a href="tel:' . $config['phone'] . '">' . $config['phone'] . '</a><br><br>' . Lang::T("Thanks."));
        }
    }
}


function pay_getAvailablePaymentGateways()
{
    $payment_gateway_files = glob('system/plugin/pay_pg-*.php');
    $payment_gateways = [];

    foreach ($payment_gateway_files as $file) {
        $parts = explode('-', basename($file, '.php'));
        $gateway_identifier = isset($parts[1]) ? $parts[1] : 'unknown';
        $payment_gateways[] = [
            'filename' => basename($file),
            'value' => $gateway_identifier,
            'name' => str_replace('_', ' ', ucfirst($gateway_identifier))
        ];
    }
    return $payment_gateways;
}

function pay_validateAndPreparePaymentData($post_data)
{
    $phone = trim($post_data['phone']);
    $phone = pay_formatPhoneNumber($phone);
    if (strlen($phone) < 12) {
        pay_throwError(Lang::T("Phone number is invalid, please check and try again."));
        exit();
    }
    $plan = pay_getPlan($post_data['planid']);
    $amount = $plan->price;
    $username = $post_data['username'];
    if (isset($post_data['email']) == '') {
        $email = pay_getEmailAddress($phone);
    } else {
        $email = trim($post_data['email']);
    }
    $plan_name = $post_data['plan_name'];
    return [
        'username' => $username,
        'routername' => $post_data['routername'],
        'planid' => $post_data['planid'],
        'plan_name' => $plan_name,
        'payment_gateway' => $post_data['payment_gateway'],
        'phone' => $phone,
        'email' => $email,
        'amount' => $amount,
        'txref' => uniqid('trx'),
        'status' => 'pending'
    ];
}

function pay_getEmailAddress($phone)
{
    $serverHost = $_SERVER['HTTP_HOST'];

    if ($serverHost === 'localhost') {
        $email = $phone . '@' . $serverHost . '.com';
    } else {
        $email = $phone . '@' . $serverHost;
    }
    return $email;
}

function pay_getPlan($planid)
{
    return ORM::for_table('tbl_plans')
        ->where('id', $planid)
        ->find_one();
}
function pay_formatPhoneNumber($phone)
{
    global $config;
    $countryCode = $config['country_code_phone'];
    if (substr($phone, 0, 1) == '+') {
        $phone = str_replace('+', '', $phone);
    }
    if (substr($phone, 0, 1) == '9') {
        $phone = preg_replace('/^9/', $countryCode . '9', $phone);
    }

    if (substr($phone, 0, 1) == '8') {
        $phone = preg_replace('/^8/', $countryCode . '8', $phone);
    }

    if (substr($phone, 0, 1) == '0') {
        $phone = preg_replace('/^0/', $countryCode, $phone);
    }
    if (substr($phone, 0, 1) == '7') {
        $phone = preg_replace('/^7/', $countryCode . '7', $phone);
    }

    if (substr($phone, 0, 1) == '1') {
        $phone = preg_replace('/^1/', $countryCode . '1', $phone);
    }

    return $phone;
}

function pay_savePayment(
    $username,
    $transaction_id,
    $transaction_ref,
    $amount,
    $phone,
    $planid,
    $plan_name,
    $routername,
    $status,
    $paymentGateway,
    $failedMessage,
    $location
) {

    if (
        empty($transaction_id) || empty($transaction_ref) || empty($amount) || empty($phone) ||
        empty($planid) || empty($plan_name) || empty($routername) ||
        empty($status) || empty($paymentGateway)
    ) {
        pay_throwError(Lang::T("Invalid input provided"));
        exit();
    }

    $trx = ORM::for_table('tbl_payments_page')->create();
    $trx->username = $username;
    $trx->transaction_id = $transaction_id;
    $trx->transaction_ref = $transaction_ref;
    $trx->amount = $amount;
    $trx->phone_number = $phone;
    $trx->plan_id = $planid;
    $trx->plan_name = $plan_name;
    $trx->router_name = $routername;
    $trx->transaction_status = $status;
    $trx->payment_gateway = $paymentGateway;

    try {
        $trx->save();
        return $location;
    } catch (Exception $e) {
        _log(Lang::T("Failed to save transaction: ") . $e->getMessage());
        pay_throwError($failedMessage);
        exit;
    }
}


function pay_throwError($message)
{
    // Construct the HTML content
    $html = '<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error: Bad Request</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f1f1f1;
            text-align: center;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 600px;
            margin: 100px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h1 {
            color: #333;
            margin-top: 0;
            font-size: 24px;
        }
        p {
            color: #777;
            font-size: 16px;
        }
        .btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            font-size: 16px;
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        /* Responsive Styles */
        @media screen and (max-width: 600px) {
            .container {
                margin: 50px auto;
                padding: 10px;
            }
            h1 {
                font-size: 20px;
            }
            p {
                font-size: 14px;
            }
            .btn {
                font-size: 14px;
                padding: 8px 16px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>An Error Occured</h1>
        <p> ' . $message . '</p>
        <a href="javascript:history.back()" class="btn">Go Back</a>
    </div>
</body>
</html>';


    // Set the appropriate headers
    header('Content-Type: text/html');
    header('HTTP/1.1 400 Bad Request');

    // Output the HTML page
    echo $html;
    exit;
}


function pay_verify()
{
    global $ui, $config;
    $ui->assign('_title', Lang::T("Payment Verification"));

    $reference = isset($_GET['reference']) ? $_GET['reference'] : '';
    $message = isset($_GET['message']) ? $_GET['message'] : '';

    if ($message) {
        pay_verify_display_error($message);
    }

    if (!$reference) {
        pay_verify_display_error(Lang::T("No reference supplied."));
    }

    $check = ORM::for_table('tbl_payments_page')
        ->where('transaction_ref', $reference)
        ->find_one();

    if ($check) {
        $status = $check->transaction_status;

        switch ($status) {
            case 'paid':
                pay_verify_display_success($check);
                break;
            case 'failed':
                pay_verify_display_error(Lang::T("Transaction with this Reference ID: [$reference] has been processed and failed."));
                break;
            case 'cancelled':
                pay_verify_display_error(Lang::T("Transaction with this Reference ID: [$reference] has been processed and cancelled."));
                break;
            default:
                $ui->assign('companyName', $config['CompanyName']);
                $ui->assign('msg', $message);
                $ui->display('pay_verify.tpl');
                break;
        }
    } else {
        pay_verify_display_error(Lang::T("Transaction with this Reference ID: [$reference] not found."));
    }
}

function pay_verify_display_error($message)
{
    $html = '<!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Error: Bad Request</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f1f1f1;
                    text-align: center;
                    margin: 0;
                    padding: 0;
                }
                .container {
                    max-width: 600px;
                    margin: 100px auto;
                    padding: 20px;
                    background-color: #fff;
                    border-radius: 8px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }
                h1 {
                    color: #333;
                    margin-top: 0;
                    font-size: 24px;
                }
                p {
                    color: #777;
                    font-size: 16px;
                }
                /* Responsive Styles */
                @media screen and (max-width: 600px) {
                    .container {
                        margin: 50px auto;
                        padding: 10px;
                    }
                    h1 {
                        font-size: 20px;
                    }
                    p {
                        font-size: 14px;
                    }
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>Error: Bad Request</h1>
                <p>' . $message . '</p>
            </div>
        </body>
        </html>';

    // Set the appropriate headers
    header('Content-Type: text/html');
    header('HTTP/1.1 400 Bad Request');

    // Output the HTML page
    echo $html;
    exit();
}

function pay_verify_display_success($transaction)
{
    global $config;
    $orderSummary = [
        Lang::T("Order Number") => $transaction->id,
        Lang::T("Transaction ID") => $transaction->transaction_id,
        Lang::T("Transaction Ref") => $transaction->transaction_ref,
        Lang::T("Package") => $transaction->plan_name,
        Lang::T("Expiry") => $transaction->expired_date,
        Lang::T("Amount Paid") => $config['currency_code'] . number_format($transaction->amount, 2),
        Lang::T("Payment Method") => $transaction->payment_gateway
    ];

    $html = '<!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Successful</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f1f1f1;
                    text-align: center;
                    margin: 0;
                    padding: 0;
                }
                .container {
                    max-width: 600px;
                    margin: 100px auto;
                    padding: 20px;
                    background-color: #fff;
                    border-radius: 8px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }
                h1 {
                    color: #28a745;
                    margin-top: 0;
                    font-size: 24px;
                    animation: fadeIn 1s ease-in-out;
                }
                p {
                    color: #777;
                    font-size: 16px;
                    animation: fadeIn 1.5s ease-in-out;
                }
                .checkmark {
                    width: 80px;
                    height: 80px;
                    margin: 0 auto 20px auto;
                    border-radius: 50%;
                    background-color: #28a745;
                    animation: scaleUp 0.5s ease-in-out;
                    position: relative;
                }
                .checkmark::after {
                    content: "";
                    display: block;
                    width: 40px;
                    height: 20px;
                    border: 5px solid #fff;
                    border-width: 0 0 5px 5px;
                    transform: rotate(-45deg);
                    position: absolute;
                    top: 20px;
                    left: 20px;
                    animation: drawCheck 0.5s ease-in-out 0.5s forwards;
                }
                .btn {
                    display: inline-block;
                    margin-top: 20px;
                    padding: 10px 20px;
                    font-size: 16px;
                    color: #fff;
                    background-color: #007bff;
                    border: none;
                    border-radius: 4px;
                    text-decoration: none;
                    cursor: pointer;
                    animation: fadeIn 2s ease-in-out;
                }
                .btn:hover {
                    background-color: #0056b3;
                }
                .order-summary {
                    text-align: left;
                    margin: 20px auto;
                    padding: 20px;
                    background-color: #f9f9f9;
                    border-radius: 8px;
                    animation: fadeIn 2.5s ease-in-out;
                }
                .order-summary h2 {
                    color: #333;
                    font-size: 20px;
                    margin-bottom: 10px;
                }
                .order-summary table {
                    width: 100%;
                    border-collapse: collapse;
                }
                .order-summary table, .order-summary th, .order-summary td {
                    border: 1px solid #ddd;
                }
                .order-summary th, .order-summary td {
                    padding: 8px;
                    text-align: left;
                }
                .order-summary th {
                    background-color: #f2f2f2;
                }
                .small-btn {
                    padding: 5px 10px;
                    font-size: 14px;
                }
                /* Animations */
                @keyframes fadeIn {
                    from { opacity: 0; }
                    to { opacity: 1; }
                }
                @keyframes scaleUp {
                    from { transform: scale(0); }
                    to { transform: scale(1); }
                }
                @keyframes drawCheck {
                    from { width: 0; height: 0; }
                    to { width: 40px; height: 20px; }
                }
                /* Responsive Styles */
                @media screen and (max-width: 600px) {
                    .container {
                        margin: 50px auto;
                        padding: 10px;
                    }
                    h1 {
                        font-size: 20px;
                    }
                    p {
                        font-size: 14px;
                    }
                    .btn {
                        font-size: 14px;
                        padding: 8px 16px;
                    }
                    .order-summary {
                        padding: 10px;
                    }
                    .order-summary h2 {
                        font-size: 18px;
                    }
                    .order-summary th, .order-summary td {
                        font-size: 14px;
                        padding: 6px;
                    }
                    .small-btn {
                        padding: 3px 8px;
                        font-size: 12px;
                    }
                }
            </style>
            <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
            <script>
                function copyVoucherCode() {
                    var voucherCode = document.getElementById("voucherCode").innerText;
                    navigator.clipboard.writeText(voucherCode).then(function() {
                        Swal.fire({
                            icon: "success",
                            title: "Voucher code copied!",
                            text: "The voucher code has been copied to the clipboard.",
                            timer: 2000,
                            showConfirmButton: false
                        });
                    }, function(err) {
                        console.error("Could not copy text: ", err);
                    });
                }
            </script>
        </head>
        <body>
            <div class="container">
                <div class="checkmark"></div>
                <h1>Thank You!</h1>
                <p>Your payment has been successfully processed.</p>
                <div class="order-summary">
                    <h2>Payment Summary</h2>
                    <table>
                        <tr>
                            <th>Item</th>
                            <th>Details</th>
                        </tr>';

    foreach ($orderSummary as $item => $details) {
        $html .= '<tr>
                            <td>' . $item . '</td>
                            <td>' . $details . '</td>
                        </tr>';
    }

    $html .= '</table>
                </div>
        </body>
        </html>';

    // Set the appropriate headers
    header('Content-Type: text/html');
    header('HTTP/1.1 200 OK');

    // Output the HTML page
    echo $html;
    exit();
}
