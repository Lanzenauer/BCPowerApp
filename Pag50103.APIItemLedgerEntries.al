page 50103 "APIItemLedgerEntries"
{
    Caption = 'API Items Ledger Entries';
    PageType = API;
    DelayedInsert = true;
    APIPublisher = 'HanseSolution';
    APIGroup = 'HSG';
    APIVersion = 'v1.0';
    SourceTable = "Item Ledger Entry";
    EntityName = 'LoadLedgerEntry';
    EntitySetName = 'LoadedLedgerEntries';
    ODataKeyFields = ID;


    layout
    {
        area(Content)
        {
            group(Groupname)
            {
                field("ID"; ID) { }
                field("EntryNO"; "Entry No.") { }
                field("ItemNo"; "Item No.") { }
                field("LocationCode"; "Location Code") { }
                field("Quantity"; Quantity) { }

            }
        }
    }


    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Insert(true);
        Modify(true);
        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        ItemLedgereEntries_lRec: Record "Item Ledger Entry";
    begin
        ItemLedgereEntries_lRec.SetRange(ID, ID);
        ItemLedgereEntries_lRec.FindFirst();
        if (("Item No." <> ItemLedgereEntries_lRec."Item No.") AND ("Entry No." <> ItemLedgereEntries_lRec."Entry No.")) Then begin
            ItemLedgereEntries_lRec.TransferFields(Rec, false);
            ItemLedgereEntries_lRec.Rename("Item Category Code");
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Delete(true);
    end;
}

