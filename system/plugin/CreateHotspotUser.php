<?php
/// Allow requests from any origin
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    exit;
}
function Alloworigins()
{
    if (isset($_GET['type'])) {
        $type = $_GET['type'];

        if ($type == "verify") {
            VerifyHotspot();
        } elseif ($type == "grant") {
            CreateHostspotUser();
        }
    }
}

function VerifyHotspot()
{
    $phone = $_POST['phone_number'];

    $user = ORM::for_table('tbl_payment_gateway')
        ->where('username', $phone)
        ->order_by_desc('id')
        ->find_one();

    if ($user) {
        $status = $user->status;
        $mpesacode = $user->gateway_trx_id;
        $res = $user->pg_paid_response;

        if ($status == 2 && !empty($mpesacode)) {
            $data = [
                "Resultcode" => "3",
                "phone" => $phone,
                "tyhK" => "1234",
                "Message" => "We have received your transaction under the Mpesa Transaction $mpesacode, Please don't leave this page as we are redirecting you",
                "Status" => "success"
            ];
        } elseif ($res == "Not enough balance") {
            $data = [
                "Resultcode" => "2",
                "Message1" => "Insufficient Balance for the transaction",
                "Status" => "danger",
                "Redirect" => "Insufficient balance"
            ];
        } elseif ($res == "Wrong Mpesa pin") {
            $data = [
                "Resultcode" => "2",
                "Message" => "You entered Wrong Mpesa pin, please resubmit",
                "Status" => "danger",
                "Redirect" => "Wrong Mpesa pin"
            ];
        } elseif ($status == 4) {
            $data = [
                "Resultcode" => "2",
                "Message" => "You cancelled the transaction, you can enter phone number again to activate",
                "Status" => "info",
                "Redirect" => "Transaction Cancelled"
            ];
        } elseif (empty($mpesacode)) {
            $data = [
                "Resultcode" => "1",
                "Message" => "A payment pop up has been sent to $phone, Please enter pin to continue (Please do not leave or reload the page until redirected)",
                "Status" => "primary"
            ];
        } else {
            $data = ["status" => "error", "message" => "Unknown error occurred"];
        }
    } else {
        $data = ["status" => "error", "message" => "User not found"];
    }
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode($data);
    exit();
}

function CreateHostspotUser()
{
    $result = ORM::for_table('tbl_appconfig')->find_many();
    foreach ($result as $value) {
        $config[$value['setting']] = $value['value'];
    }
    // Check if the request method is POST
    if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Invalid request method"]);
        exit();
    }
    if ($config['maintenance_mode']) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(['status' => 'error', 'message' => 'Scheduled maintenance is currently in progress. Please check back soon. We apologize for any inconvenience']);
        exit();
    }
    try {
        // Parse JSON input
        $input = json_decode(file_get_contents('php://input'), true);

        // Extract data from JSON input
        $phone = isset($input['phone_number']) ? $input['phone_number'] : '';
        $planId = isset($input['plan_id']) ? $input['plan_id'] : '';
        $routerId = isset($input['router_id']) ? $input['router_id'] : '';
        $mac_address = isset($input['mac_address']) ? $input['mac_address'] : '';

        if (empty($phone) || empty($planId) || empty($routerId)) {
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode(["status" => "error", "message" => "Missing required parameters"]);
            exit();
        }

        $macs = ["22:12:59:0C:45:58"];

        if (in_array($mac_address, $macs)) {
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode(['status' => 'error', 'message' => 'This device has been blocked from accessing this service, please contact service provider']);
            exit();
        }

        $phone = (substr($phone, 0, 1) == '+') ? str_replace('+', '', $phone) : $phone;
        $phone = (substr($phone, 0, 1) == '0') ? preg_replace('/^0/', '254', $phone) : $phone;
        $phone = (substr($phone, 0, 1) == '7') ? preg_replace('/^7/', '2547', $phone) : $phone; //cater for phone number prefix 2547XXXX
        $phone = (substr($phone, 0, 1) == '1') ? preg_replace('/^1/', '2541', $phone) : $phone; //cater for phone number prefix 2541XXXX
        $phone = (substr($phone, 0, 1) == '0') ? preg_replace('/^01/', '2541', $phone) : $phone;
        $phone = (substr($phone, 0, 1) == '0') ? preg_replace('/^07/', '2547', $phone) : $phone;

        $PlanExist = ORM::for_table('tbl_plans')->where('id', $planId)->count() > 0;
        $RouterExist = ORM::for_table('tbl_routers')->where('id', $routerId)->count() > 0;

        if (!$PlanExist || !$RouterExist) {
            header('Content-Type: application/json; charset=utf-8');
            echo json_encode(["status" => "error", "message" => "Unable to process your request, please refresh the page"]);
            exit();
        }

        $Userexist = ORM::for_table('tbl_customers')->where('username', $phone)->find_one();

        if ($Userexist) {
            $Userexist->router_id = $routerId;
            $Userexist->password = '1234';
            $Userexist->save();
            InitiateStkpush($phone, $planId, $routerId, $mac_address);
        } else {
            $defpass = '1234';
            $defaddr = 'Hotspot Address';
            $defmail = $phone . '@gmail.com';

            $createUser = ORM::for_table('tbl_customers')->create();
            $createUser->username = $phone;
            $createUser->password = $defpass;
            $createUser->fullname = $phone;
            $createUser->router_id = $routerId;
            $createUser->phonenumber = $phone;
            $createUser->pppoe_password = $defpass;
            $createUser->address = $defaddr;
            $createUser->email = $defmail;
            $createUser->service_type = 'Hotspot';

            if ($createUser->save()) {
                InitiateStkpush($phone, $planId, $routerId, $mac_address);
            } else {
                header('Content-Type: application/json; charset=utf-8');
                echo json_encode(["status" => "error", "message" => "There was a system error when registering user, please contact support"]);
                exit();
            }
        }
    } catch (Exception $e) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
        exit();
    }
}

function InitiateStkpush($phone, $planId, $routerId, $mac_address)
{
    try {
        $file_path = 'system/removeuser.php';
        //  include_once $file_path;

        $gateway = ORM::for_table('tbl_appconfig')
            ->where('setting', 'payment_gateway')
            ->find_one();
        $gateway = ($gateway) ? $gateway->value : null;

        if ($gateway == "MpesatillStk") {
            $url = (U . "plugin/initiatetillstk");
        } elseif ($gateway == "BankStkPush") {
            $url = (U . "plugin/initiatebankstk");
        } elseif ($gateway == "MpesaPaybill") {
            $url = (U . "plugin/initiatePaybillStk");
        }

        $Planname = ORM::for_table('tbl_plans')
            ->where('id', $planId)
            ->order_by_desc('id')
            ->find_one();
        $Findrouter = ORM::for_table('tbl_routers')
            ->where('id', $routerId)
            ->order_by_desc('id')
            ->find_one();

        $rname = $Findrouter->name;
        $price = $Planname->price;
        $Planname = $Planname->name_plan;

        $Checkorders = ORM::for_table('tbl_payment_gateway')
            ->where('username', $phone)
            ->where('status', 1)
            ->order_by_desc('id')
            ->find_many();

        if ($Checkorders) {
            foreach ($Checkorders as $Dorder) {
                $Dorder->delete();
            }
        }

        $d = ORM::for_table('tbl_payment_gateway')->create();
        $d->username = $phone;
        $d->gateway = $gateway;
        $d->mac_address = $mac_address;
        $d->plan_id = $planId;
        $d->plan_name = $Planname;
        $d->routers_id = $routerId;
        $d->routers = $rname;
        $d->price = $price;
        $d->payment_method = $gateway;
        $d->payment_channel = $gateway;
        $d->created_date = date('Y-m-d H:i:s');
        $d->paid_date = date('Y-m-d H:i:s');
        $d->expired_date = date('Y-m-d H:i:s');
        $d->pg_url_payment = $url;
        $d->status = 1;
        $d->save();
        SendSTKcred($phone, $url);
        exit;
    } catch (Exception $e) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => $e->getMessage()]);
        exit();
    }
}

function SendSTKcred($phone, $url)
{
    $link = $url;
    $fields = [
        'username' => $phone,
        'phone' => $phone,
        'channel' => 'Yes',
    ];

    $postvars = http_build_query($fields);
    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $link);
    curl_setopt($ch, CURLOPT_POST, count($fields));
    curl_setopt($ch, CURLOPT_POSTFIELDS, $postvars);

    $result = curl_exec($ch);
    if ($result === false) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => curl_error($ch)]);
        exit();
    }

    curl_close($ch);
}

Alloworigins();
