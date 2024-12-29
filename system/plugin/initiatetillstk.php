<?php

function initiatetillstk()
{
    global $config;
    $username = $_POST['username'];
    $phone = $_POST['phone'];

    // Format phone number
    $phone = (substr($phone, 0, 1) == '+') ? str_replace('+', '', $phone) : $phone;
    $phone = (substr($phone, 0, 1) == '0') ? preg_replace('/^0/', '254', $phone) : $phone;
    $phone = (substr($phone, 0, 1) == '7') ? preg_replace('/^7/', '2547', $phone) : $phone;
    $phone = (substr($phone, 0, 1) == '1') ? preg_replace('/^1/', '2541', $phone) : $phone;
    $phone = (substr($phone, 0, 1) == '0') ? preg_replace('/^01/', '2541', $phone) : $phone;
    $phone = (substr($phone, 0, 1) == '0') ? preg_replace('/^07/', '2547', $phone) : $phone;

    $environment = $config['mpesa_till_env'];
    $consumer_key = $config['mpesa_till_consumer_key'];
    $consumer_secret = $config['mpesa_till_consumer_secret'];
    $Business_Code = $config['mpesa_till_shortcode_code'];
    $Passkey = $config['mpesa_till_pass_key'];
    $mpesa_till_partyb = $config['mpesa_till_partyb'];
    $Type_of_Transaction = $config['mpesa_till_transaction'];
    $CallBackURL = U . 'callback/MpesatillStk';
    $Time_Stamp = date("Ymdhis");
    $password = base64_encode($Business_Code . $Passkey . $Time_Stamp);
    if ($Type_of_Transaction == "CustomerPayBillOnline") {
        $partyB  =  $Business_Code;
    } elseif ($Type_of_Transaction == "CustomerBuyGoodsOnline") {
        $partyB  =  $mpesa_till_partyb;
    }

    // Fetch user and payment gateway record
    $CheckId = ORM::for_table('tbl_customers')
        ->where('username', $username)
        ->order_by_desc('id')
        ->find_one();

    $CheckUser = ORM::for_table('tbl_customers')
        ->where('phonenumber', $phone)
        ->find_many();

    if (!$CheckId) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "User not found"]);
        exit();
    }

    $UserId = $CheckId->id;

    if (!empty($CheckUser)) {
        ORM::for_table('tbl_customers')
            ->where('phonenumber', $phone)
            ->where_not_equal('id', $UserId)
            ->delete_many();
    }

    $PaymentGatewayRecord = ORM::for_table('tbl_payment_gateway')
        ->where('username', $username)
        ->where('status', 1)
        ->order_by_desc('id')
        ->find_one();

    if (!$PaymentGatewayRecord) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Unable to process payment, please reload the page"]);
        exit();
    }

    $ThisUser = ORM::for_table('tbl_customers')
        ->where('username', $username)
        ->order_by_desc('id')
        ->find_one();

    if (!$ThisUser) {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "User not found"]);
        exit();
    }

    $ThisUser->phonenumber = $phone;
    $ThisUser->username = $phone;
    $ThisUser->save();

    $amount = $PaymentGatewayRecord->price;

    if ($environment == "live") {
        $lipaOnlineUrl = 'https://api.safaricom.co.ke/mpesa/stkpush/v1/processrequest';
        $tokenUrl = 'https://api.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';
    } elseif ($environment == "sandbox") {
        $lipaOnlineUrl = 'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest';
        $tokenUrl = 'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials';
    } else {
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Invalid application status"]);
        exit();
    }

    $curl = curl_init();
    if ($curl === false) {
        return null;
    }

    curl_setopt($curl, CURLOPT_URL, $tokenUrl);
    curl_setopt($curl, CURLOPT_HTTPHEADER, ['Authorization: Basic ' . base64_encode($consumer_key . ':' . $consumer_secret)]);
    curl_setopt($curl, CURLOPT_HEADER, false);
    curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
    $response = curl_exec($curl);

    if ($response === false) {
        // Log cURL error if needed
        _log("cURL error: " . curl_error($curl));
    }

    curl_close($curl);

    $token = json_decode($response, true)['access_token'] ?? null;

    if (!$token) {
        sendTelegram("M-Pesa payment failed: " . json_encode($response));
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Failed to generate token"]);
        exit();
    }

    // Process the STK Push
    $curl2 = curl_init();
    curl_setopt($curl2, CURLOPT_URL, $lipaOnlineUrl);
    curl_setopt($curl2, CURLOPT_HTTPHEADER, ['Content-Type:application/json', 'Authorization:Bearer ' . $token]);

    $curl2_post_data = [
        'BusinessShortCode' => $Business_Code,
        'Password' => $password,
        'Timestamp' => $Time_Stamp,
        'TransactionType' => $Type_of_Transaction,
        'Amount' => $amount,
        'PartyA' => $phone,
        'PartyB' => $partyB,
        'PhoneNumber' => $phone,
        'CallBackURL' => $CallBackURL,
        'AccountReference' => 'Payment for Hotspot',
        'TransactionDesc' => 'Payment for Hotspot',
    ];

    $data2_string = json_encode($curl2_post_data);

    curl_setopt($curl2, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($curl2, CURLOPT_POST, true);
    curl_setopt($curl2, CURLOPT_POSTFIELDS, $data2_string);
    curl_setopt($curl2, CURLOPT_HEADER, false);
    curl_setopt($curl2, CURLOPT_SSL_VERIFYPEER, 0);
    curl_setopt($curl2, CURLOPT_SSL_VERIFYHOST, 0);
    $curl_response = curl_exec($curl2);

    if (!$curl_response) {
        sendTelegram("M-Pesa payment failed: " . json_encode($curl_response));
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "Failed to process STK Push"]);
        exit();
    }

    $mpesaResponse = json_decode($curl_response);
    $responseCode = $mpesaResponse->ResponseCode ?? null;
    $MerchantRequestID = $mpesaResponse->MerchantRequestID ?? null;
    $CheckoutRequestID = $mpesaResponse->CheckoutRequestID ?? null;
    $resultDesc = $mpesaResponse->CustomerMessage ?? 'No message';

    if ($responseCode == "0") {
        $PaymentGatewayRecord->pg_paid_response = $resultDesc;
        $PaymentGatewayRecord->pg_request = $CheckoutRequestID;
        $PaymentGatewayRecord->username = $phone;
        $PaymentGatewayRecord->payment_method = 'Mpesa Stk Push';
        $PaymentGatewayRecord->payment_channel = 'Mpesa Stk Push';
        $PaymentGatewayRecord->save();

        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "success", "message" => "Enter Mpesa Pin to complete"]);
    } else {
        sendTelegram("M-Pesa payment failed: " . json_encode($curl_response));
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode(["status" => "error", "message" => "There is an issue with the transaction, please try again"]);
    }
}
