namespace cappo.cds;

using {anubhav.db.master,anubhav.db.transaction } from './datamodel';

context CDSViews{

    define view![POWorklist] as
        select from transaction.purchaseorder{
            key PO_ID as![PurchaseOrderId],
            key Items.PO_ITEM_POS as![ItemPosition],
            PARTNER_GUID.BP_ID as![PartnerId],
            PARTNER_GUID.COMPANY_NAME as![CompanyName],
            GROSS_AMOUNT as![GrossAmount],
            TAX_AMOUNT as![TaxAmount],
            NET_AMOUNT as![NetAmount],
            CURRENCY as![Currency],
            OVERALL_STATUS as![Status],
            Items.PRODUCT_GUID.PRODUCT_ID as![ProductId],
            Items.PRODUCT_GUID.DESCRIPTION as![ProductName],
            PARTNER_GUID.ADDRESS_GUID.CITY as![City],
            PARTNER_GUID.ADDRESS_GUID.COUNTRY as![Country]
        };

        define view![ProducValueHelp] as 
        select from master.product{
            @EndUserText.label:[
                {
                    language:'EN',
                    text:'Product Id'
                },
                {
                    language:'DE',
                    text:'Prodekt Id'
                }
            ]
            PRODUCT_ID as![ProductId],
                @EndUserText.label:[
                {
                    language:'EN',
                    text:'Product Description'
                },
                {
                    language:'DE',
                    text:'Prodekt Description'
                }
            ]
            DESCRIPTION as![Description]

        };

        define view![ItemView] as 
        select from transaction.poitems{
            PARENT_KEY.PARTNER_GUID.NODE_KEY as![CusterId],
            PRODUCT_GUID.NODE_KEY as![ProductId],
            CURRENCY as![currencyCode],
            GROSS_AMOUNT as![GrossAmount],
            NET_AMOUNT as![NetAmount],
            TAX_AMOUNT as![TaxAmount],
            PARENT_KEY.OVERALL_STATUS as![Status]
        };

        define view ProductView as select from master.product
        mixin{
            PO_ORDER: Association[*] to ItemView on PO_ORDER.ProductId = $projection.ProductId
        } into {
            NODE_KEY as![ProductId],
            DESCRIPTION as![Description],
            CATEGORY as![Category],
            PRICE as![Price],
            SUPPLIER_GUID.BP_ID as![SupplierID],
            SUPPLIER_GUID.COMPANY_NAME as![SupplierName],
            SUPPLIER_GUID.ADDRESS_GUID.CITY as![City],
            SUPPLIER_GUID.ADDRESS_GUID.COUNTRY as![Country],

            PO_ORDER as![To_Items]
        };

        define view CProducValuesView as 
        select from ProductView{
            ProductId,
            Country,
            round(sum(To_Items.GrossAmount),2) as![TotalPurchaseAmount] : Decimal(10,2),
            To_Items.currencyCode as![currencyCode]
        }group by ProductId,Country,To_Items.currencyCode;


}