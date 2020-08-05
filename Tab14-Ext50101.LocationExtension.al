tableextension 50101 "LocationExtension" extends Location //14
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