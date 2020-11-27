/// <summary>
/// Table TransferItems (ID 50100).
/// </summary>
table 50100 TransferItems
{
    Caption = 'TransferItems';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Transfernumber; Code[30])
        {
            Caption = 'Transfernumber';
            DataClassification = ToBeClassified;
        }
        field(2; DestinationLocation; Code[10])
        {
            Caption = 'DestinationLocation';
            DataClassification = ToBeClassified;
        }
        field(3; StartLocation; Code[10])
        {
            Caption = 'StartLocation';
            DataClassification = ToBeClassified;
        }
        field(4; ItemNo; Code[20])
        {
            Caption = 'ItemNo';
            DataClassification = ToBeClassified;
        }
        field(5; Quantity; Integer)
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
        field(6; EmployeeNo; Code[20])
        {
            Caption = 'EmployeeNo';
            DataClassification = ToBeClassified;
        }
        field(7; EmployeeEmail; Text[80])
        {
            Caption = 'Employee E-Mail';
            DataClassification = ToBeClassified;
        }
        field(8; TransToTransferOrderStarted; Boolean)
        {
            Caption = 'Employee E-Mail';
            DataClassification = ToBeClassified;
        }
        field(9; TransferOrderCreated; Boolean)
        {
            Caption = 'Transfer Order Created';
            DataClassification = ToBeClassified;
        }
        field(8000; "ID"; GUID)
        {

        }
    }

    keys
    {
        key(PK; Transfernumber)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        ID := CreateGuid();
    end;
}
