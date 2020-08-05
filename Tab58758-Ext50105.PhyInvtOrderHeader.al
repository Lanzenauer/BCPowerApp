tableextension 50105 "PhyInvtOrderHeader" extends "Phys. Invt. Order Header"  //58758
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