page 50100 "Phys. Invt. Order Header" // 58875
{

    APIPublisher = 'HanseSolution';
    APIGroup = 'HSG';
    APIVersion = 'v1.0';
    Caption = 'PhysInvtOrderHeader';
    DelayedInsert = true;
    EntityName = 'PyhsInvtOrderHeader';
    EntitySetName = 'PyhsInvtOrderHeader';
    PageType = API;
    SourceTable = "Phys. Invt. Order Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No; "No.")
                {
                    ApplicationArea = All;
                    Caption = 'No';
                }
                field(OrderDate; "Order Date")
                {
                    ApplicationArea = All;
                    Caption = 'OrderDate';
                }
                field(GenBusPostingGroup; "Gen. Bus. Posting Group")
                {
                    ApplicationArea = All;
                    Caption = 'GenBusPostingGroup';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comment';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    Caption = 'Status';
                }
                field(BinCode; "Bin Code")
                {
                    ApplicationArea = All;
                    Caption = 'BinCode';
                }
                field(LocationCode; "Location Code")
                {
                    ApplicationArea = All;
                    Caption = 'LocationCode';
                }
                field(ReasonCode; "Reason Code")
                {
                    ApplicationArea = All;
                    Caption = 'ReasonCode';
                }
                field(PostingDate; "Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'PostingDate';
                }
                field(PostingNo; "Posting No.")
                {
                    ApplicationArea = All;
                    Caption = 'PostingNo';
                }
                field(LastPostingNo; "Last Posting No.")
                {
                    ApplicationArea = All;
                    Caption = 'LastPostingNo';
                }
            }
        }
    }

}
