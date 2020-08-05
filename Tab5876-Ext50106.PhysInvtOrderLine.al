tableextension 50106 "PhysInvtOrderLine" extends "Phys. Invt. Order Line" //5876
{
    fields
    {
        field(8000; "ID"; GUID)
        {

        }
    }
    trigger OnInsert()
    begin
        ID := CreateGuid();
    end;
}