pageextension 50104 "LocationPageExtension" extends "Location List" //15
{
    actions
    {
        addfirst(navigation)
        {
            action("SetLocationGuid")
            {
                Promoted = true;
                PromotedIsBig = true;
                ApplicationArea = all;
                trigger OnAction();
                var
                    location_lRec: Record Location;
                begin
                    if (location_lRec.FindSet()) then
                        repeat
                            location_lRec.ID := CreateGuid();
                            location_lRec.Modify(false);
                        until location_lRec.Next() = 0;
                end;
            }
        }
    }
}