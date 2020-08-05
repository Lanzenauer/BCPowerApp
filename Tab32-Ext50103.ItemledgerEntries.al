tableextension 50103 "ItemledgerEntries" extends "Item Ledger Entry" //32
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