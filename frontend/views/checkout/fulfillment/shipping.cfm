<!---

    Slatwall - An e-commerce plugin for Mura CMS
    Copyright (C) 2011 ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    
    Linking this library statically or dynamically with other modules is
    making a combined work based on this library.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.
 
    As a special exception, the copyright holders of this library give you
    permission to link this library with independent modules to produce an
    executable, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting executable under
    terms of your choice, provided that you also meet, for each linked
    independent module, the terms and conditions of the license of that
    module.  An independent module is a module which is not derived from
    or based on this library.  If you modify this library, you may extend
    this exception to your version of the library, but you are not
    obligated to do so.  If you do not wish to do so, delete this
    exception statement from your version.

Notes:

--->
<cfparam name="params.orderFulfillment" type="any" />
<cfparam name="params.orderFulfillmentIndex" type="string" />
<cfparam name="params.edit" type="boolean" />
<cfparam name="params.selectedAccountAddressID" type="string" default="" />

<cfset local.address = $.slatwall.getService("addressService").newAddress() />
<cfif not isNull(params.orderFulfillment.getShippingAddress())>
	<cfset local.address = params.orderFulfillment.getShippingAddress() />
<cfelseif not isNull(params.orderFulfillment.getAccountAddress())>
	<cfset params.selectedAccountAddressID = params.orderFulfillment.getAccountAddress().getAccountAddressID() />
<cfelseif arrayLen($.slatwall.account().getAccountAddresses())>
	<!--- Todo: change to primary address --->
	<cfset params.selectedAccountAddressID = $.slatwall.account().getAccountAddresses()[1].getAccountAddressID() />
</cfif>

<cfoutput>
	<div class="svocheckoutfulfillmentshipping">
		<div class="shippingAddress">
			<h4>Shipping Address</h4>
			<cfif arrayLen(params.orderFulfillment.getAccountAddressOptions())>
				<p>Select an Address</p>
				<select name="orderFulfillments[#params.orderFulfillmentIndex#].accountAddress.accountAddressID">
					<option value="0">New Address</option>
					<cfloop array="#params.orderFulfillment.getAccountAddressOptions()#" index="local.option">
						<option value="#local.option['id']#" <cfif params.selectedAccountAddressID EQ local.option['id']>Selected</cfif>>#local.option['name']#</option>
					</cfloop>
				</select>
				<cfloop array="#$.slatwall.account().getAccountAddresses()#" index="local.accountAddress">
					<div id="accountAddress_#local.accountAddress.getAccountAddressID()#" class="addressBlock" style="display:none;">
						<cf_SlatwallAddressDisplay address="#local.accountAddress.getAddress()#" fieldNamePrefix="orderFulfillments[#params.orderFulfillmentIndex#].accountAddress.#local.accountAddress.getAccountAddressID()#.address." edit="#params.edit#">
					</div>
				</cfloop>
			<cfelse>
				<input type="hidden" name="orderFulfillments[#params.orderFulfillmentIndex#].accountAddress.accountAddressID" value="" />
			</cfif>
			<div id="shippingAddress" class="addressBlock" style="display:none;">
				<cf_SlatwallAddressDisplay address="#local.address#" fieldNamePrefix="orderFulfillments[#params.orderFulfillmentIndex#].shippingAddress." edit="#params.edit#">
				<span><input type="checkbox" name="orderFulfillments[#params.orderFulfillmentIndex#].saveAddress" value="1">&nbsp;Save this address</span>
			</div>
			<input type="hidden" name="orderFulfillments[#params.orderFulfillmentIndex#].saveAddress" value="" />
			<input type="hidden" name="orderFulfillments[#params.orderFulfillmentIndex#].orderFulfillmentID" value="#params.orderFulfillment.getOrderFulfillmentID()#" />
		</div>
		<div class="shippingMethod">
			<h4>Shipping Method</h4>
			<cfif arrayLen(params.orderFulfillment.getOrderShippingMethodOptions())>
				<cf_SlatwallShippingMethodDisplay orderFulfillmentIndex="#params.orderFulfillmentIndex#" orderFulfillmentShipping="#params.orderFulfillment#" edit="#local.edit#">
				<button type="submit">Save & Continue</button>
			<cfelse>
				<p>Please enter a valid Shipping Address so shipping rates can be calculated.</p>
				<button type="submit">Get Shipping Rates</button>
			</cfif>
		</div>
	</div>
	
	<script type="text/javascript">
		jQuery(document).ready(function(){
			jQuery('.addressBlock').hide();
			jQuery('select[name="orderFulfillments[#params.orderFulfillmentIndex#].accountAddress.accountAddressID"]').change(function(){
				jQuery('.addressBlock').hide();
				var selectedAccountAddressID = jQuery('select[name="orderFulfillments[#params.orderFulfillmentIndex#].accountAddress.accountAddressID"]').val();
				if(selectedAccountAddressID == 0){
					jQuery('##shippingAddress').show();
				} else {
					jQuery('##accountAddress_'+selectedAccountAddressID).show();
				}
			});
			<cfif Not arrayLen($.slatwall.account().getAccountAddresses())>
				jQuery('##shippingAddress').show();
			<cfelse>
				jQuery('select[name="orderFulfillments[#params.orderFulfillmentIndex#].accountAddress.accountAddressID"]').change();
			</cfif>
		});
	</script>
</cfoutput>
