codeunit 50101 "TransferOrderImport"
{
    trigger OnRun()
    begin
        //if 
        ImportTransferOrder()
        // then begin end;
    end;

    //[TryFunction]
    local procedure ImportTransferOrder()
    var
        ImportName_lTxt: Text;
        FirstImportLine_lInt: Integer;
        TransferHeader_lRec: Record "Transfer Header";
        TransferLine_lRec: Record "Transfer Line";
        vQuantity_lTxt: Text[20];
        vQuantity_lDec: Decimal;
        ItemLedgerEntries_lRec: Record "Item Ledger Entry";
        QuantityInLocatation: Integer;
        TransferFrom_lTxt: Text;
        ItemNo_lCod: Code[20];
        AdditionalSetup_lRec: Record "Additional Setup";
        NewLinesCounter: integer;
        Excel_lCdu: Codeunit "Excel Helper";
    begin
        Excel_lCdu.SetServerFileName_gFnc('\\nas01\home\Tasks\PowerApp\TransferItems.xlsx');
        Excel_lCdu.SetSheetName_gFnc('TransferOrder');
        Excel_lCdu.SetSilent_gFnc(true);
        AdditionalSetup_lRec.FindFirst();
        NewLinesCounter := 0;
        ImportName_lTxt := 'TransferOrder';
        FirstImportLine_lInt := AdditionalSetup_lRec.PowerAppExcelPointer + 1;
        Excel_lCdu.Init_gFnc('Import of "' + ImportName_lTxt + '"', FirstImportLine_lInt, 0);
        if Excel_lCdu.FindSet_gFnc then
            repeat
                QuantityInLocatation := 0;
                ItemNo_lCod := Excel_lCdu.Field_gFnc('A');
                vQuantity_lDec := Excel_lCdu.FieldDec_gFnc('B');
                TransferFrom_lTxt := Excel_lCdu.Field_gFnc('C');
                Clear(ItemLedgerEntries_lRec);
                ItemLedgerEntries_lRec.SetRange("Location Code", TransferFrom_lTxt);
                ItemLedgerEntries_lRec.SetRange("Item No.", ItemNo_lCod);
                if ItemLedgerEntries_lRec.FindSet() then
                    repeat
                        QuantityInLocatation += ItemLedgerEntries_lRec.Quantity;
                    until ItemLedgerEntries_lRec.Next() = 0;
                if (QuantityInLocatation > 0) then
                    if (QuantityInLocatation >= vQuantity_lDec) then begin
                        Clear(TransferHeader_lRec);
                        Clear(TransferLine_lRec);
                        TransferHeader_lRec.validate("Transfer-from Code", TransferFrom_lTxt);
                        TransferHeader_lRec.validate("Transfer-to Code", Excel_lCdu.Field_gFnc('D'));
                        TransferHeader_lRec."In-Transit Code" := AdditionalSetup_lRec.TransitCodePowerapp;
                        TransferHeader_lRec.Insert(true);

                        TransferLine_lRec."Document No." := TransferHeader_lRec."No.";
                        TransferLine_lRec."Line No." := 10000;
                        TransferLine_lRec.validate("Item No.", ItemNo_lCod);
                        TransferLine_lRec.validate(Quantity, vQuantity_lDec);
                        TransferLine_lRec.Insert(true);
                        NewLinesCounter += 1;
                    end;
            until Excel_lCdu.Next_gFnc = 0;
        Excel_lCdu.Done_gFnc;
        AdditionalSetup_lRec.PowerAppExcelPointer += NewLinesCounter;
        AdditionalSetup_lRec.Modify();
    end;
}
