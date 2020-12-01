page 50108 "AdditionalSetupPage"
{

    PageType = Card;
    SourceTable = "Additional Setup";
    UsageCategory = Administration;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            repeater(general)
            {
                field("Code"; "Code") { }
                field("PowerAppExcelPointer"; PowerAppExcelPointer) { }
            }
        }
    }

}
