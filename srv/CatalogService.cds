using {anubhav.db} from '../db/datamodel';
using { cappo.cds } from '../db/CDSViews';

service CatalogService @(path:'CatalogService') {

    @Capabilities : {Insertable,Deletable:true}
    entity BusinessPartnerSet as projection on db.master.businesspartner;
    entity AddressSet as projection on db.master.address;
    entity EmployeeSet as projection on db.master.employees;
    entity PurchaseOrderItems as projection on db.transaction.poitems;
    entity POs as projection on db.transaction.purchaseorder{

        *,
        round(GROSS_AMOUNT) as GROSS_AMOUNT:Decimal(10,3),
        Items: redirected to PurchaseOrderItems
    }actions{
        action boost();
        function largestOrder() returns array of POs;
    };

    entity CProducValuesView as projection on cds.CDSViews.CProducValuesView;
    

}