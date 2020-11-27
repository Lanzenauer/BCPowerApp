page 50105 "TransferItemAPI"
{

    Caption = 'transferItemAPI';
    PageType = API;
    DelayedInsert = true;
    APIGroup = 'HSG';
    APIPublisher = 'HanseSolution';
    APIVersion = 'v1.0';
    SourceTable = "TransferItems";
    EntityName = 'TranferItem';
    EntitySetName = 'TranferItems';
    ODataKeyFields = SystemId;
    
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Transfernumber"; Transfernumber) { ApplicationArea = all; }
                field("DestinationLocation"; DestinationLocation) { ApplicationArea = all; }
                field("StartLocation"; StartLocation) { ApplicationArea = all; }
                field("ItemNo"; ItemNo) { ApplicationArea = all; }
                field("Quantity"; Quantity) { ApplicationArea = all; }
                field("EmployeeNo"; EmployeeNo) { ApplicationArea = all; }
                field("ID"; ID) { ApplicationArea = all; }
                field("SystemID"; SystemId) { ApplicationArea = all; }
            }
        }
    }

    /*    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
       begin
           Insert(true);
           Modify(true);
           exit(false);
       end;
    */
    /*     trigger OnModifyRecord(): Boolean
        var

            TransferItems_lRec: Record TransferItems;
        begin
            TransferItems_lRec.SetRange(ID, ID);
            TransferItems_lRec.FindFirst();
            if (Transfernumber <> TransferItems_lRec.Transfernumber) Then begin
                TransferItems_lRec.TransferFields(Rec, false);
                TransferItems_lRec.Rename("Transfernumber");
            end;
        end;

        trigger OnDeleteRecord(): Boolean
        begin
            Delete(true);
        end; */
}

