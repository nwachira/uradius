<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{$_title}</title>
    <link rel="shortcut icon" href="ui/ui/images/logo.png" type="image/x-icon" />
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');
        
        body {
            font-family: 'Roboto', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background: linear-gradient(135deg, #71b7e6, #9b59b6);
        }
        .container {
            background-color: #fff;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            text-align: center;
            max-width: 500px;
            width: 90%;
        }
        .illustration {
            width: 100%;
            max-width: 300px;
            margin: 0 auto 20px;
            border-radius: 10px;
        }
        h1 {
            color: #333;
            font-size: 28px;
            margin-bottom: 20px;
        }
        p {
            color: #666;
            font-size: 18px;
            margin-bottom: 30px;
        }
        .pay-button {
            background-color: #e74c3c;
            color: #fff;
            padding: 15px 30px;
            border: none;
            border-radius: 30px;
            font-size: 18px;
            text-decoration: none;
            display: inline-block;
            transition: background-color 0.3s ease;
        }
        .pay-button:hover {
            background-color: #c0392b;
        }
    </style>
</head>
<body>
    <div class="container">
        <img src="system/plugin/ui/disconnected.png" alt="disconnected" class="disconnected">
        <h1>{Lang::T('Internet Service Suspended')}</h1>
        <p>{Lang::T('Your internet service has been suspended due to late payment or non payment.')}</p>
        <p>{Lang::T('Please click the button below to make a payment and restore your service.')}</p>
        <a href="{$_url}plugin/pay_check" class="pay-button">{Lang::T('Pay Now')}</a>
    </div>
</body>
</html>
