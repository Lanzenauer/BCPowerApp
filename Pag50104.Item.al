page 50104 "Item"
{
    Caption = 'Item';
    PageType = API;
    DelayedInsert = true;
    APIPublisher = 'HanseSolution';
    APIGroup = 'HSG';
    APIVersion = 'v1.0';
    SourceTable = "Item";
    EntityName = 'Item';
    EntitySetName = 'Items';
    ODataKeyFields = systemID;
    layout
    {
        area(Content)
        {
            group(Groupname)
            {
                field("systemID"; systemID) { }
                field("No"; "No.") { }
                field("Picture"; "Picture") { }

            }
        }
    }


    /*     trigger OnInsertRecord(BelowxRec: Boolean): Boolean
        begin
            Insert(true);
            Modify(true);
            exit(false);
        end;

        trigger OnModifyRecord(): Boolean
        var
            Item_lRec: Record "Item";
        begin
            Item_lRec.SetRange(systemID, systemID);
            Item_lRec.FindFirst();
            if (("No." <> Item_lRec."No.") AND ("No." <> Item_lRec."No.")) Then begin
                Item_lRec.TransferFields(Rec, false);
                Item_lRec.Rename("Item Category Code");
            end;
        end;

        trigger OnDeleteRecord(): Boolean
        begin
            Delete(true);
        end; */
}

