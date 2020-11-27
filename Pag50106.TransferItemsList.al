page 50106 TransferItemsList
{

    ApplicationArea = All;
    Caption = 'TransferItemsList';
    PageType = List;
    SourceTable = TransferItems;
    UsageCategory = Documents;
    CardPageId = 50107;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Transfernumber; Rec.Transfernumber)
                {
                    ApplicationArea = All;
                }
                field(StartLocation; Rec.StartLocation)
                {
                    ApplicationArea = All;
                }
                field(DestinationLocation; Rec.DestinationLocation)
                {
                    ApplicationArea = All;
                }
                field(ItemNo; Rec.ItemNo)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field(EmployeeNo; Rec.EmployeeNo)
                {
                    ApplicationArea = All;
                }
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
