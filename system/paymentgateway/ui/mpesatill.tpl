{include file="sections/header.tpl"}

<form class="form-horizontal" method="post" role="form" action="{$_url}paymentgateway/MpesatillStk" >
    <div class="row">
        <div class="col-sm-12 col-md-12">
            <div class="panel panel-primary panel-hovered panel-stacked mb30">
                <div class="panel-heading">M-Pesa Till</div>
                <div class="panel-body">
                    <div class="form-group">
                        <label class="col-md-2 control-label">Consumer Key</label>
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="mpesa_consumer_key" name="mpesa_till_consumer_key" placeholder="xxxxxxxxxxxxxxxxx" value="{$_c['mpesa_till_consumer_key']}">
                            <small class="form-text text-muted"><a href="https://developer.safaricom.co.ke/MyApps" target="_blank">https://developer.safaricom.co.ke/MyApps</a></small>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-2 control-label">Consumer Secret</label>
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="" name="mpesa_till_consumer_secret" placeholder="xxxxxxxxxxxxxxxxx" value="{$_c['mpesa_till_consumer_secret']}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-2 control-label">Business Shortcode(Store number/H.O)</label>
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="" name="mpesa_till_business_code" placeholder="xxxxxxx" maxlength="7" value="{$_c['mpesa_till_shortcode_code']}">
                        </div>
                    </div>
                      <div class="form-group">
                        <label class="col-md-2 control-label">Business Shortcode(Till number)</label>
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="" name="mpesa_till_partyb" placeholder="xxxxxxx" maxlength="7" value="{$_c['mpesa_till_partyb']}">
                        </div>
                    </div>
					<div class="form-group">
                        <label class="col-md-2 control-label">Pass Key</label>
                        <div class="col-md-6">
                            <input type="text" class="form-control" id="" name="mpesa_till_pass_key" placeholder="bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919" maxlength="" value="{$_c['mpesa_till_pass_key']}">
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="col-md-2 control-label">{Lang::T('Transaction Type')}</label>
                        <div class="col-md-6">
                            <select class="form-control" name="mpesa_till_transaction" id="mpesa_till_transaction">
                                <option value="CustomerPayBillOnline" {if $_c['mpesa_till_transaction']=='CustomerPayBillOnline' }selected{/if}>{Lang::T('
                                    PayBill')}</option>
                                <option value="CustomerBuyGoodsOnline" {if $_c['mpesa_till_transaction']=='CustomerBuyGoodsOnline' }selected{/if}>{Lang::T('Till')}
                                </option>
                            </select>
                            <small class="form-text text-muted">
                                <font color="red"><b>{Lang::T('CustomerPayBillOnline')}</b></font> {Lang::T('for PayBill and')} <font
                                    color="green"><b>{Lang::T('CustomerBuyGoodsOnline')}</b></font> {Lang::T('For Till Number')}
                            </small>
                        </div>
                    </div>
					<div class="form-group">
                        <label class="col-md-2 control-label">{Lang::T('M-Pesa Environment')}</label>
                        <div class="col-md-6">
                            <select class="form-control" name="mpesa_till_env" id="mpesa_till_env">
                                <option value="sandbox" {if $_c['mpesa_till_env']=='sandbox' }selected{/if}>{Lang::T('SandBox or
                                    Testing')}</option>
                                <option value="live" {if $_c['mpesa_till_env']=='live' }selected{/if}>{Lang::T('Live or Production')}
                                </option>
                            </select>
                            <small class="form-text text-muted">
                                <font color="red"><b>{Lang::T('Sandbox')}</b></font> {Lang::T('is for testing purpose, please switch to')} <font
                                    color="green"><b>{Lang::T('Live')}</b></font> {Lang::T('in production.')}'
                            </small>
                        </div>
                    </div>                 
                    <div class="form-group">
                        <div class="col-lg-offset-2 col-lg-10">
                            <button class="btn btn-primary waves-effect waves-light" type="submit">{Lang::T('Save')}</button>
                        </div>
                    </div>
                        <pre>/ip hotspot walled-garden
                   add dst-host=safaricom.co.ke
                   add dst-host=*.safaricom.co.ke</pre>
                </div>
            </div>

        </div>
    </div>
</form>
{include file="sections/footer.tpl"}


