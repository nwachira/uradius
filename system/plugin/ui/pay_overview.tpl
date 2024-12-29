{include file="sections/header.tpl"}

<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/1.11.5/css/jquery.dataTables.css">
<style>
    @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap');
    .stats {
        display: flex;
        justify-content: space-around;
        flex-wrap: wrap;
        margin-bottom: 20px;
    }

    .stats .stat-box {
        background-color: #fff;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        text-align: center;
        flex: 1;
        margin: 10px;
        min-width: 200px;
    }

    .stat-box h3 {
        font-size: 24px;
        color: #333;
        margin-bottom: 10px;
    }

    .stat-box p {
        font-size: 18px;
        color: #666;
    }

    .table-container {
        background-color: #fff;
        padding: 20px;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        overflow-x: auto;
    }

    .table-container h2 {
        font-size: 24px;
        color: #333;
        margin-bottom: 20px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    table, th, td {
        border: 1px solid #ccc;
    }

    th, td {
        padding: 12px;
        text-align: left;
    }

    th {
        background-color: #f2f2f2;
        font-weight: bold;
    }

    .button {
        background-color: #e74c3c;
        color: #fff;
        padding: 10px 20px;
        border: none;
        border-radius: 5px;
        font-size: 16px;
        cursor: pointer;
    }

    .button:hover {
        background-color: #c0392b;
    }
    /* Styles for overall layout and responsiveness */
    body {
        background-color: #f8f9fa;
        font-family: 'Arial', sans-serif;
    }

    /* Styles for table and pagination */
    .table {
        width: 100%;
        margin-bottom: 1rem;
        background-color: #fff;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
    }

    .table th {
        vertical-align: middle;
        border-color: #dee2e6;
        background-color: #343a40;
        color: #fff;
    }

    .table td {
        vertical-align: middle;
        border-color: #dee2e6;
    }

    .table-striped tbody tr:nth-of-type(odd) {
        background-color: rgba(0, 0, 0, 0.05);
    }
    .table-hover tbody tr:hover {
        background-color: rgba(0, 0, 0, 0.075);
        color: #333;
        font-weight: bold;
        transition: background-color 0.3s, color 0.3s;
    }
    .pagination .page-item .page-link {
        color: #007bff;
        background-color: #fff;
        border: 1px solid #dee2e6;
        margin: 0 2px;
        padding: 6px 12px;
        transition: background-color 0.3s, color 0.3s;
    }

    .pagination .page-item .page-link:hover {
        background-color: #e9ecef;
        color: #0056b3;
    }

    .pagination .page-item.active .page-link {
        z-index: 1;
        color: #fff;
        background-color: #007bff;
        border-color: #007bff;
    }

    .dataTables_wrapper .dataTables_paginate .paginate_button {
        display: inline-block;
        padding: 5px 10px;
        margin-right: 5px;
        border: 1px solid #ccc;
        background-color: #fff;
        color: #333;
        cursor: pointer;
    }
</style>
{if isset($message)}
<div class="alert alert-{if $notify_t == 's'}success{else}danger{/if}">
    <button type="button" class="close" data-dismiss="alert">
        <span aria-hidden="true">×</span>
    </button>
    <div>{$message}</div>
</div>
{/if}
<div class="main-content">
    <div class="stats">
        <div class="stat-box">
            <h3>{Lang::T('Successful Payments')} <br> <br> <br><p>{$successfulPayments}</p> </h3>
        </div>
        <div class="stat-box">
            <h3>{Lang::T('Failed Payments')} <br> <br><br><p>{$failedPayments}</p> </h3>
        </div>
        <div class="stat-box">
            <h3>{Lang::T('Pending Payments')}<br> <br><br><p>{$pendingPayments}</p> </h3>
        </div>
    </div>
<br><br><br>
    <div class="table-container">
        <h2>{Lang::T('Payment History')}</h2>
        <table class="table" id="payments-table">
            <thead>
                <tr>
                    <th>{Lang::T('Username')}</th>
                    <th>{Lang::T('Transaction ID')}</th>
                    <th>{Lang::T('Transaction Ref')}</th>
                    <th>{Lang::T('Router Name')}</th>
                    <th>{Lang::T('Plan Name')}</th>
                    <th>{Lang::T('Amount')}</th>
                    <th>{Lang::T('Phone Number')}</th>
                    <th>{Lang::T('Transaction Status')}</th>
                    <th>{Lang::T('Payment Gateway')}</th>
                    <th>{Lang::T('Payment Method')}</th>
                    <!-- <th>{Lang::T('Created Date')}</th> -->
                    <th>{Lang::T('Payment Date')}</th>
                    <th>{Lang::T('Plan Expiry Date')}</th>
                    <!-- <th>{Lang::T('Action')}</th> -->
                </tr>
            </thead>
            <tbody>
                {foreach $payments as $payment}
                <tr>
                    <td>{$payment.username}</td>
                    <td>{$payment.transaction_id}</td>
                    <td>{$payment.transaction_ref}</td>
                    <td>{$payment.router_name}</td>
                    <td>{$payment.plan_name}</td>
                    <td>{$payment.amount}</td>
                    <td>{$payment.phone_number}</td>
                    <td><span
                            class="label {if $payment.transaction_status == paid}label-success {elseif $payment.transaction_status == pending}label-warning {elseif $payment.transaction_status == failed}label-danger {elseif $payment.transaction_status == cancelled}label-danger {/if}">{$payment.transaction_status}</span>
                    </td>
                    <td>{$payment.payment_gateway}</td>
                    <td>{$payment.payment_method}</td>
                    <!-- <td>{$payment.created_date}</td> -->
                    <td>{$payment.payment_date}</td>
                    <td>{$payment.expired_date}</td>
                    {*<td>
                        <div class="btn-group pull-right">
                            <button type="button" class="btn btn-default dropdown-toggle"
                                data-toggle="dropdown">{Lang::T('Action')}</button>
                            <ul class="dropdown-menu pull-right" role="menu">
                                <li>
                                    <a
                                        href="{$_url}plugin/">
                                        Lang::T('Check')</a>
                                </li>
                                <li>
                                    <a
                                        href="{$_url}plugin/">
                                        {Lang::T('Change Status')}</a>
                                </li>
                            </ul>

                        </div>
                    </td>*}
                </tr>
                {/foreach}
            </tbody>
        </table>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.datatables.net/1.11.3/js/jquery.dataTables.min.js"></script>
<script>
    var $j = jQuery.noConflict();

    $j(document).ready(function () {
        $j('#payments-table').DataTable({
            "pagingType": "full_numbers"
        });
    });
</script>

{include file="sections/footer.tpl"}
