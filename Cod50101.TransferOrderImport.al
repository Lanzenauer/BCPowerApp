codeunit 50101 TransferOrderImport
{

    trigger OnRun()
    var
        ExcelHelper: Codeunit "Excel Helper";
    begin
        ExcelHelper.SetServerFileName('\\nas01\home\Tasks\PowerApp\TransferItems.xlsx');
        ExcelHelper.SetSheetName('TransferOrder');
        ImportTransferOrder();
    end;

    local procedure ImportTransferOrder()
    var
        Excel_lCdu: Codeunit "Excel Helper";
        V_lTxt: Text;
        V_lDec: Decimal;
        V_lDat: Date;
        ImportName_lTxt: Text;
        FirstImportLine_lInt: Integer;
        TransferItems_lRec: Record TransferItems;
        TransferHeader_lRec: Record "Transfer Header";
        TransferLine_lRec: Record "Transfer Line";
        vQuantity_lTxt: Text[20];
        vQuantity_lDec: Decimal;
        ItemLedgerEntries_lRec: Record "Item Ledger Entry";
        QuantityInLocatation: Integer;
        TransferFrom_lTxt: Text;
        ItemNo_lCod: Code[20];
        AdditionalSetup_lRec: Record "Additional Setup";
        newLinesCounter: integer;

    begin
        // Only one example function.
        // Please copy this function to your codeunit.
        AdditionalSetup_lRec.Get();
        newLinesCounter := 0;
        ImportName_lTxt := 'TransferOrder';
        FirstImportLine_lInt := AdditionalSetup_lRec.PowerAppExcelPointer + 1;
        //# Init Excel import
        Excel_lCdu.Init_gFnc('Import of "' + ImportName_lTxt + '"', FirstImportLine_lInt, 0);
        if Excel_lCdu.FindSet_gFnc then
            repeat
                //# Process the line
                //  TransferItems_lRec.SetRange(Transfernumber,Excel_lCdu.Field_gFnc('E'));
                ItemNo_lCod := Excel_lCdu.Field_gFnc('A');
                vQuantity_lTxt := Excel_lCdu.Field_gFnc('B');
                vQuantity_lDec := Excel_lCdu.FieldDec_gFnc(vQuantity_lTxt);
                TransferFrom_lTxt := Excel_lCdu.Field_gFnc('C');
                Clear(ItemLedgerEntries_lRec);
                ItemLedgerEntries_lRec.SetRange("Location Code", TransferFrom_lTxt);
                ItemLedgerEntries_lRec.SetRange("Item No.", ItemNo_lCod);
                if ItemLedgerEntries_lRec.FindSet() then
                    repeat
                        QuantityInLocatation += ItemLedgerEntries_lRec.Quantity;
                    until ItemLedgerEntries_lRec.Next() = 0;

                if QuantityInLocatation >= vQuantity_lDec then begin
                    Clear(TransferHeader_lRec);
                    Clear(TransferLine_lRec);
                    TransferHeader_lRec."Transfer-from Code" := TransferFrom_lTxt;
                    TransferHeader_lRec."Transfer-to Code" := Excel_lCdu.Field_gFnc('D');
                    TransferHeader_lRec.Insert();

                    TransferLine_lRec."Document No." := TransferHeader_lRec."No.";
                    TransferLine_lRec."Item No." := ItemNo_lCod;
                    TransferLine_lRec.Quantity := vQuantity_lDec;
                    newLinesCounter += 1;
                end;

            /*            V_lTxt := Excel_lCdu.Field_gFnc('A');
                       V_lTxt := Excel_lCdu.Field_gFnc('B');
                       V_lDec := Excel_lCdu.FieldDec_gFnc(V_lTxt);
                       V_lDat := Excel_lCdu.FieldDate_gFnc(V_lTxt); */
            //..
            until Excel_lCdu.Next_gFnc = 0;
        Excel_lCdu.Done_gFnc;
        AdditionalSetup_lRec.PowerAppExcelPointer += newLinesCounter;
        AdditionalSetup_lRec.Modify();
    end;


}
