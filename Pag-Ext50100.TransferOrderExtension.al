pageextension 50100 "TransferOrderExtension" extends "Transfer Orders" //OriginalId
{
    layout
    {

    }

    actions
    {
        addfirst(navigation)
        {
            action(LoadFromExcel)
            {
                ApplicationArea = All;
                Caption = 'LoadFromExcel', comment = 'DEU="Daten von Excel laden"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    TransferOrderImport_lCu: Codeunit TransferOrderImport;
                begin
                    TransferOrderImport_lCu.Run();
                end;
            }
        }
    }

}