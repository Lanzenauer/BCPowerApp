/// <summary>
/// TableExtension ItemledgerEntries (ID 50103) extends Record Item Ledger Entry //32.
/// </summary>
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