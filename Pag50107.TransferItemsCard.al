page 50107 "TransferItemsCard"
{

    Caption = 'TransferItemsCard';
    PageType = Card;
    SourceTable = TransferItems;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Transfernumber; Rec.Transfernumber)
                {
                    ApplicationArea = All;
                }
                field(DestinationLocation; Rec.DestinationLocation)
                {
                    ApplicationArea = All;
                }
                field(StartLocation; Rec.StartLocation)
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
