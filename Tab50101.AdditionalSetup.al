/// <summary>
/// Table Additional Setup (ID 50000).
/// </summary>
table 50101 "Additional Setup"
{
    // version EDE

    // HSG Hanse Solution GmbH
    // Wichmannstr. 4, Haus 10 Mitte
    // 22607 Hamburg
    // Germany
    // 
    // Date    Module  ID  Description
    // ==========================================================================================
    // 190217  EDE_01  FC  Created


    fields
    {
        field(1; "Code"; Code[10])
        {
        }
        field(2; "PowerAppExcelPointer"; Integer)
        {

        }
    }
    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        Error('Do not delete ');
    end;
}

