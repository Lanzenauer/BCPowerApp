page 50102 "APILocation"
{
    Caption = 'Location API';
    PageType = API;
    DelayedInsert = true;
    APIPublisher = 'HanseSolution';
    APIGroup = 'HSG';
    APIVersion = 'v1.0';
    SourceTable = "Location";
    EntityName = 'LoadLocation';
    EntitySetName = 'LoadedLocations';
    ODataKeyFields = ID;

    layout
    {
        area(Content)
        {
            group(Groupname)
            {
                field("ID"; ID)
                {
                    ApplicationArea = all;
                }
                field("Name"; Name)
                {
                    ApplicationArea = all;
                }
                field("Name2"; "Name 2")
                {
                    ApplicationArea = all;
                }
                field("DefaultBincode"; "Default Bin Code")
                {
                    ApplicationArea = all;
                }
                field("Code"; Code)
                {
                    ApplicationArea = all;
                }
                field(Address; Address)
                {
                    ApplicationArea = all;
                }
                field(Address2; "Address 2")
                {
                    ApplicationArea = all;
                }
                field(PostCode; "Post Code")
                {
                    ApplicationArea = all;
                }
                field(City; City)
                {
                    ApplicationArea = all;
                }

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
        Location_lRec: Record Location;
    begin
        Location_lRec.SetRange(ID, ID);
        Location_lRec.FindFirst();
        if (Code <> Location_lRec.Code) Then begin
            Location_lRec.TransferFields(Rec, false);
            Location_lRec.Rename(code);
        end;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        Delete(true);
    end;
}

