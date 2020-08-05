page 50101 "PhysInvtOrderLine"
{

    APIPublisher = 'HanseSolution';
    APIGroup = 'HSG';
    APIVersion = 'v1.0';
    Caption = 'PhysInvtOrderLine';
    DelayedInsert = true;
    EntityName = 'PhysInvtOrderLine';
    EntitySetName = 'PhysInvtOrderLines';
    PageType = API;
    SourceTable = "Phys. Invt. Order Line";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("ItemNo"; "Item No.") { }
                field("QuantityBase"; "Quantity (Base)") { }
                field(Description; Description) { }
                field("Description2"; "Description 2") { }
                field("LocationCode"; "Location Code") { }

            }
        }
    }

}
