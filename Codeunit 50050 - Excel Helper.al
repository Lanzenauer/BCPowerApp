codeunit 50100 "Excel Helper"
{
    // version HSG

    // HSG Hanse Solution GmbH
    // Brandstücken 27
    // 2249 Hamburg
    // Germany
    // 
    // Date    Module  ID  Description
    // ==========================================================================================
    // 080916  RHD_00  FC  Excel import
    // 220916  RHD_01  FC  New Example_Excelimport_gFnc
    // 071116  RHD_02  FC  Moved to NAV_Tools with new number
    // 120117  HSG_03  FC  Use column number
    // 170217  HSG_04  FC  Rename Example_Excelimport_lFnc
    // 260317  HSG_05  FC  Changed ExcelBuf to temporary
    // 051017  HSG_06  FC  Set SheetName_gTxt to global
    // 290319  HSG_07  FC  Changed Init_gFnc
    // 110419  HSG_08  FC  New function FieldExt_gFnc
    // 300819  HSG_09  FC  New InitCaptionList_gFnc
    // 160919  HSG_10  FC  Save FileName_gTxt and GetFileName_gFnc
    // 081119  HSG_11  FC  Implemented functions to export data to Excel file


    trigger OnRun()
    begin

        //UT_Example_Import_lFnc;
        UT_Example_Export_lFnc;
    end;

    var
        ExcelBuf: Record "Excel Buffer" temporary;
        Window_gDia: Dialog;
        Start_gCtx: Label 'Import Excel File';
        ExcelExtensionTok: Label '.xlsx', Locked = true;
        Text016: Label 'Analyzing Data...\\';
        Text007: Label 'Table Data';
        Text011: Label 'The text %1 can only be specified once in the Excel worksheet.';
        TotalColumns_gInt: Integer;
        TotalRows_gInt: Integer;
        Text020_gCtx: Label 'Inserted lines: %1\ Updated lines: %2';
        Done_gCtx: Label 'Excel import ''%1'' with %2 lines is done. \%3 lines were processed.';
        ImportName_gTxt: Text;
        FirstImportLine_gInt: Integer;
        LastImportLine_gInt: Integer;
        CurrRow_gInt: Integer;
        Window_gCtx: Label 'Excelimport is processing @1@@@@@@@@';
        SheetName_gTxt: Text;
        ColumnListTmp_gRec: Record "Excel Buffer" temporary;
        Rec_gRecRef: RecordRef;
        FieldNotFound_gCtx: Label 'Field ''%1'' not found in table ''%2''.';
        FieldNotFoundExcel_gCtx: Label 'Excel-Column-No ''%1'' not found in table ''%2''.';
        FieldNotFoundExceBuff_gCtx: Label 'ExcelBuffer-Column-No ''%1'' not found in table ''%2''.';
        FieldNotFoundinDB_gCtx: Label '-> Excel-Fields not found in the database:\';
        FieldNotEditable_gCtx: Label '-> Fields not editable in the NAV-table:\';
        StartNow_gCtx: Label '<- Start Excel import now? ->';
        FileName_gTxt: Text;
        ParamError_gCtx: Label 'Param ''%1'' in function ''%2'' has an invalid value: %3';
        SaveAs_gCtx: Label 'Save as';
        Stop_gCtx: Label 'Stopped by User';
        FormatExcelBufTmp_gRec: Record "Excel Buffer" temporary;
        RowNo_gInt: Integer;
        ColumnNo_gInt: Integer;
        ServerTempFile_gTxt: Text;
        FormatId_gInt: Integer;
        Text001: Label 'You must enter a file name.';
        FileManagement: Codeunit "File Management";
        ServerFileName_gTxt: Text[80];

    local procedure UT_Example_Import_lFnc()
    var
        Excel_lCdu: Codeunit "Excel Helper";
        V_lTxt: Text;
        V_lDec: Decimal;
        V_lDat: Date;
        ImportName_lTxt: Text;
        FirstImportLine_lInt: Integer;
    begin
        // Only one example function.
        // Please copy this function to your codeunit.
        ImportName_lTxt := '??';
        FirstImportLine_lInt := 1;
        //# Init Excel import
        Excel_lCdu.Init_gFnc('Import of "' + ImportName_lTxt + '"', FirstImportLine_lInt, 0);
        if Excel_lCdu.FindSet_gFnc then
            repeat
                //# Process the line
                V_lTxt := Excel_lCdu.Field_gFnc('A');
                V_lTxt := Excel_lCdu.Field_gFnc('B');
                V_lDec := Excel_lCdu.FieldDec_gFnc(V_lTxt);
                V_lDat := Excel_lCdu.FieldDate_gFnc(V_lTxt);
            //..
            until Excel_lCdu.Next_gFnc = 0;
        Excel_lCdu.Done_gFnc;
    end;

    local procedure UT_Example_Export_lFnc()
    var
        Excel_lCdu: Codeunit "Excel Helper";
        CellType_lOpt: Option Number,Text,Date,Time;
        V_lTxt: Text;
        V_lDec: Decimal;
        V_lDat: Date;
        Cust_lRec: Record Customer;
        Ven_lRec: Record Vendor;
        Line_lInt: Integer;


    begin
        // Only one example function.
        Excel_lCdu.Exp_InitFormatGrp_gFnc(0);
        if Excel_lCdu.Export_Start_gFnc('', 'Debitoren') then begin
            //## Export Customers
            Excel_lCdu.Exp_SetFormatId_gFnc(1);
            Excel_lCdu.Exp_Field_gFnc('Debitor-Nr.');
            Excel_lCdu.Exp_Field_gFnc(Cust_lRec.FieldCaption(Cust_lRec.Name));
            Excel_lCdu.Exp_Field_gFnc(Cust_lRec.FieldCaption(Cust_lRec."Name 2"));
            Excel_lCdu.Exp_Field_gFnc(Cust_lRec.FieldCaption(Cust_lRec.Balance));
            Excel_lCdu.Exp_NewLine_gFnc;
            Excel_lCdu.Exp_SetFormatId_gFnc(2);
            Line_lInt := 0;
            if Cust_lRec.FindSet then
                repeat
                    Excel_lCdu.Exp_Field_gFnc(Cust_lRec."No.");
                    Excel_lCdu.Exp_Field_gFnc(Cust_lRec.Name);
                    Excel_lCdu.Exp_Field_gFnc(Cust_lRec."Name 2");
                    Cust_lRec.CalcFields(Balance);
                    Excel_lCdu.Exp_FieldFormat_gFnc(10, Cust_lRec.Balance);
                    Excel_lCdu.Exp_NewLine_gFnc;
                    Line_lInt += 1;
                until (Cust_lRec.Next = 0) or (Line_lInt > 10);
            Excel_lCdu.Exp_WriteSheet_gFnc();

            //## Export Vendor
            Excel_lCdu.Exp_SelectOrAddSheet_gFnc('Kreditoren');
            Excel_lCdu.Exp_SetFormatId_gFnc(1);
            Excel_lCdu.Exp_Field_gFnc('Kreditor-Nr.');
            Excel_lCdu.Exp_Field_gFnc(Ven_lRec.FieldCaption(Ven_lRec.Name));
            Excel_lCdu.Exp_Field_gFnc(Ven_lRec.FieldCaption(Ven_lRec."Name 2"));
            Excel_lCdu.Exp_Field_gFnc(Ven_lRec.FieldCaption(Ven_lRec.Balance));
            Excel_lCdu.Exp_NewLine_gFnc;
            Excel_lCdu.Exp_SetFormatId_gFnc(2);
            Line_lInt := 0;
            if Ven_lRec.FindSet then
                repeat
                    Excel_lCdu.Exp_Field_gFnc(Ven_lRec."No.");
                    Excel_lCdu.Exp_Field_gFnc(Ven_lRec.Name);
                    Excel_lCdu.Exp_Field_gFnc(Ven_lRec."Name 2");
                    Ven_lRec.CalcFields(Balance);
                    Excel_lCdu.Exp_FieldFormat_gFnc(10, Ven_lRec.Balance);
                    Excel_lCdu.Exp_NewLine_gFnc;
                    Line_lInt += 1;
                until (Ven_lRec.Next = 0) or (Line_lInt > 10);
            Excel_lCdu.Exp_WriteSheet_gFnc();

            V_lTxt := Excel_lCdu.Export_End_gFnc;
            V_lTxt := Excel_lCdu.GetFileName_gFnc(5);
            //MESSAGE('Exportiert:\'+V_lTxt);
        end;
    end;

    /// <summary>
    /// Init_gFnc.
    /// </summary>
    /// <param name="ImportName_iTxt">Text.</param>
    /// <param name="FirstImportLine_iInt">Integer.</param>
    /// <param name="LastImportLine_iInt">Integer.</param>
    /// <returns>Return value of type Boolean.</returns>
    procedure SetServerFileName(ServerFileName: Text)
    var
    begin
        ServerFileName_gTxt := ServerFileName;
    end;

    procedure SetSheetName(Sheetname: Text)
    var
    begin
        SheetName_gTxt := Sheetname;
    end;


    procedure Init_gFnc(ImportName_iTxt: Text; FirstImportLine_iInt: Integer; LastImportLine_iInt: Integer): Boolean
    var
        FileMgt_lCdu: Codeunit "File Management";
        IJL_Tmp_lRec: Record "Item Journal Line" temporary;
        V_lTxt: Text;
        ServerFileName_gTxt: Text;
    begin
        //SheetName_gTxt:= '';
        ImportName_gTxt := ImportName_iTxt;
        FirstImportLine_gInt := FirstImportLine_iInt;
        if FirstImportLine_gInt = 0 then begin
            FirstImportLine_gInt := 1;
        end;
        LastImportLine_gInt := LastImportLine_iInt;
        FileName_gTxt := '';//HSG_10
        // -HSG_07
        //V_lTxt:= STRSUBSTNO(Start_gCtx,ImportName_gTxt);
        V_lTxt := CopyStr(ImportName_gTxt, 1, 50);
        // +HSG_07
        //  ServerFileName_gTxt !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
        if ServerFileName_gTxt = '' then
            ServerFileName_gTxt := FileMgt_lCdu.UploadFile(V_lTxt, ExcelExtensionTok);

        if ServerFileName_gTxt = '' then begin
            FileName_gTxt := '';//HSG_10
            exit(false);
        end;
        FileName_gTxt := ServerFileName_gTxt;//HSG_10
        if SheetName_gTxt = '' then begin// HSG_10
            SheetName_gTxt := ExcelBuf.SelectSheetsName(ServerFileName_gTxt);
        end;// HSG_10
        if SheetName_gTxt = '' then
            exit(false);
        ExcelBuf.LockTable;
        ExcelBuf.OpenBook(ServerFileName_gTxt, SheetName_gTxt);
        ExcelBuf.ReadSheet;
        GetLastRowandColumn_lFnc;
        exit(true);
    end;

    procedure InitCaptionList_gFnc(CaptionLine_iInt: Integer; TableNo_iInt: Integer; InklGuid_Fields_iBln: Boolean; var NotFound_rTxt: Text; var LastCol_rInt: Integer) NotFound_rInt: Integer
    var
        ColNo_lInt: Integer;
        Ok_lBln: Boolean;
        Fieldname_lTxt: Text;
        Field_lRec: Record "Field";
        Found_lInt: Integer;
        NotFoundCalcFields_rTxt: Text;
        Found_lBln: Boolean;
    begin
        // -HSG_xx
        ColumnListTmp_gRec.Reset;
        Clear(ColumnListTmp_gRec);
        ColumnListTmp_gRec.DeleteAll;
        Found_lInt := 0;
        NotFound_rInt := 0;
        NotFound_rTxt := '';
        NotFoundCalcFields_rTxt := '';
        Ok_lBln := true;
        ColNo_lInt := 1;
        while Ok_lBln do begin
            if not ExcelBuf.Get(CaptionLine_iInt, ColNo_lInt) then begin
                Ok_lBln := false;
            end else begin
                Fieldname_lTxt := ExcelBuf."Cell Value as Text";
                if StrLen(Fieldname_lTxt) > 30 then begin
                    NotFound_rTxt += Format(ColNo_lInt) + '  ' + Fieldname_lTxt + ' \';
                    NotFound_rInt += 1;
                    Fieldname_lTxt := '';
                end;
                if Fieldname_lTxt = '' then begin
                    Ok_lBln := false;
                end else begin
                    Field_lRec.SetRange(TableNo, TableNo_iInt);
                    Field_lRec.SetRange(FieldName, Fieldname_lTxt);
                    if Field_lRec.FindFirst then begin
                        ColumnListTmp_gRec.Init;
                        ColumnListTmp_gRec."Row No." := Field_lRec."No.";
                        //ColumnListTmp_gRec."Row No.":= 0;
                        ColumnListTmp_gRec."Column No." := ColNo_lInt;
                        ColumnListTmp_gRec."Cell Value as Text" := Fieldname_lTxt;
                        //ColumnListTmp_gRec."Cell Type":= Field_lRec."No.";
                        //ColumnListTmp_gRec."Cell Type":=
                        //ColumnListTmp_gRec.Comment:= Field_lRec."Type Name";
                        ColumnListTmp_gRec.Comment := Format(Field_lRec.Type);
                        ColumnListTmp_gRec.Italic := Field_lRec.Class <> Field_lRec.Class::Normal;
                        Found_lBln := true;
                        Found_lBln := Field_lRec.Class = Field_lRec.Class::Normal;
                        case Field_lRec.Type of
                            Field_lRec.Type::Text, Field_lRec.Type::Code:
                                ColumnListTmp_gRec."Cell Type" := ColumnListTmp_gRec."Cell Type"::Text;
                            //Field_lRec.Type::GUID : ColumnListTmp_gRec."Cell Type":= ColumnListTmp_gRec."Cell Type"::Text;
                            Field_lRec.Type::Date, Field_lRec.Type::DateTime, Field_lRec.Type::Time:
                                ColumnListTmp_gRec."Cell Type" := ColumnListTmp_gRec."Cell Type"::Date;
                            Field_lRec.Type::BigInteger, Field_lRec.Type::Decimal, Field_lRec.Type::Integer, Field_lRec.Type::Option:
                                ColumnListTmp_gRec."Cell Type" := ColumnListTmp_gRec."Cell Type"::Number;
                            Field_lRec.Type::Boolean:
                                ColumnListTmp_gRec."Cell Type" := ColumnListTmp_gRec."Cell Type"::Number;
                            else
                                Found_lBln := false;
                        end;
                        if (Field_lRec.Type = Field_lRec.Type::GUID) then begin
                            Found_lBln := InklGuid_Fields_iBln;
                        end;
                        if not Found_lBln then begin
                            NotFoundCalcFields_rTxt += Format(ColNo_lInt) + '  ' + Fieldname_lTxt + ' \';
                            NotFound_rInt += 1;
                        end else begin
                            ColumnListTmp_gRec.Insert;
                            Found_lInt += 1;
                        end;
                    end else begin
                        NotFound_rTxt += Format(ColNo_lInt) + '  ' + Fieldname_lTxt + ' \';
                        NotFound_rInt += 1;
                    end;
                    //FldRef := Rec_gRecRef.FIELD(Field."No.");
                    //Value_rTxt := FldRef.VALUE;
                end;
            end;
            ColNo_lInt += 1;
        end;
        LastCol_rInt := ColNo_lInt - 1;
        //NotFound_rTxt+= NotFoundCalcFields_rTxt;
        if (NotFound_rTxt > '') then begin
            NotFound_rTxt := FieldNotFoundinDB_gCtx + NotFound_rTxt;
        end;
        if (NotFoundCalcFields_rTxt > '') then begin
            NotFound_rTxt += FieldNotEditable_gCtx + NotFoundCalcFields_rTxt;
        end;
        if (NotFound_rTxt > '') then begin
            NotFound_rTxt += StartNow_gCtx;
        end;


        // +HSG_xx
    end;

    procedure Done_gFnc()
    begin
        ExcelBuf.DeleteAll;
        Commit;
        //MESSAGE(Done_gCtx,ImportName_gTxt, TotalRows_gInt,CurrRow_gInt-FirstImportLine_gInt);
        Message(Done_gCtx, ImportName_gTxt, TotalRows_gInt - (FirstImportLine_gInt - 1), CurrRow_gInt - (FirstImportLine_gInt));
    end;

    procedure GetLastRowandColumn_lFnc(): Decimal
    begin
        ExcelBuf.SetRange("Row No.", 1);
        TotalColumns_gInt := ExcelBuf.Count;
        ExcelBuf.Reset;
        if ExcelBuf.FindLast then
            TotalRows_gInt := ExcelBuf."Row No.";
        if (LastImportLine_gInt > TotalRows_gInt) or (LastImportLine_gInt = 0) then begin
            LastImportLine_gInt := TotalRows_gInt;
        end;
        exit(TotalColumns_gInt);
    end;

    local procedure GetValueAtCell_lFnc(RowNo: Integer; ColNo: Integer): Text
    var
        ExcelBuf1: Record "Excel Buffer";
    begin
        if not ExcelBuf.Get(RowNo, ColNo) then begin
            exit('');
        end else begin
            exit(ExcelBuf."Cell Value as Text");
        end;
    end;

    procedure Txt2Dec_gFnc(In_iTxt: Text) Out_rDec: Decimal
    var
        Text_lTxt: Text;
    begin
        if In_iTxt = '' then begin
            exit(0);
        end;
        // -CUO_03
        Out_rDec := 1.6;
        Text_lTxt := Format(Out_rDec);
        //In_iTxt:= CONVERTSTR(In_iTxt,'.',',');
        if CopyStr(Text_lTxt, 2, 1) = ',' then begin//Check what is the decimal character
            In_iTxt := ConvertStr(In_iTxt, '.', ',');
        end;
        // +CUO_03
        Evaluate(Out_rDec, In_iTxt);
    end;

    procedure Txt2Dat_gFnc(In_iTxt: Text) Out_rDat: Date
    var
        Text_lTxt: Text;
    begin
        if In_iTxt = '' then begin
            exit(0D);
        end;
        In_iTxt := CopyStr(In_iTxt, 1, 10);
        if (StrPos(In_iTxt, '.') = 0) and (StrPos(In_iTxt, '/') = 0) then begin
            In_iTxt := CopyStr(In_iTxt, 9, 2) + '.' + CopyStr(In_iTxt, 6, 2) + '.' + CopyStr(In_iTxt, 1, 4);
        end;
        Evaluate(Out_rDat, In_iTxt);
    end;

    procedure ProcessLines_lFnc()
    var
        SalesLine_lRec: Record "Sales Line";
        Line_lInt: Integer;
        V_lTxt: Text;
        V_lDec: Decimal;
        V_lDat: Date;
        "-": Integer;
    begin
        //# Process of the lines
        for Line_lInt := FirstImportLine_gInt to TotalRows_gInt do begin
            V_lTxt := GetValueAtCell_lFnc(Line_lInt, 1);
            V_lDec := Txt2Dec_gFnc(GetValueAtCell_lFnc(Line_lInt, 2));
            V_lDat := Txt2Dat_gFnc(GetValueAtCell_lFnc(Line_lInt, 5));
            //todo: Process line

        end;
    end;

    local procedure TransfCol2Int_lFnc(Col_iCod: Code[3]) Col_rInt: Integer
    var
        V1_lInt: Integer;
        V2_lInt: Integer;
        V1_lChr: Char;
        V2_lChr: Integer;
    begin
        // -HSG_03
        if Evaluate(Col_rInt, Col_iCod) then begin
            exit(Col_rInt);
        end;
        // +HSG_03
        Col_iCod := UpperCase(Col_iCod);
        V1_lInt := 0;
        V2_lInt := 0;
        V1_lChr := Col_iCod[1];
        V1_lInt := V1_lChr;
        V1_lInt := V1_lInt - 64;
        if StrLen(Col_iCod) = 2 then begin
            V2_lChr := Col_iCod[2];
            V2_lInt := V2_lChr;
            V2_lInt := V2_lInt - 64;
            // -HSG_08
            //Col_rInt:= V2_lInt + 26;
            Col_rInt := V2_lInt + (26 * V1_lInt);
            // +HSG_08
        end else begin
            Col_rInt := V1_lInt;
        end;
        //MESSAGE(FORMAT(Col_rInt));
    end;

    procedure FindSet_gFnc(): Boolean
    var
        Progress_lDec: Decimal;
    begin
        CurrRow_gInt := FirstImportLine_gInt;
        if TotalRows_gInt >= FirstImportLine_gInt then begin
            Progress_lDec := Round(CurrRow_gInt / TotalRows_gInt * 10000, 1);
            Window_gDia.Open(Window_gCtx, Progress_lDec);
            //ROUND(CurrRow_gInt / TotalRows_gInt * 10000,1)
            exit(true);
        end else begin
            exit(false);
        end;
    end;

    procedure Next_gFnc(): Integer
    var
        Progress_lDec: Decimal;
    begin
        CurrRow_gInt += 1;
        if (TotalRows_gInt >= CurrRow_gInt) and (CurrRow_gInt <= LastImportLine_gInt) then begin
            Progress_lDec := Round(CurrRow_gInt / TotalRows_gInt * 10000, 1);
            Window_gDia.Update(1, Progress_lDec);
            //EXIT(TRUE);
            exit(1);
        end else begin
            Window_gDia.Close;
            //EXIT(FALSE);
            exit(0);
        end;
    end;

    procedure Field_gFnc(Col_iCod: Code[10]): Text
    var
        ExcelBuf1: Record "Excel Buffer";
        RowNo_lInt: Integer;
        ColNo_lInt: Integer;
    begin
        ColNo_lInt := TransfCol2Int_lFnc(Col_iCod);
        if not ExcelBuf.Get(CurrRow_gInt, ColNo_lInt) then begin
            exit('');
        end else begin
            exit(ExcelBuf."Cell Value as Text");
        end;
    end;

    procedure FieldExt_gFnc(Col_iCod: Code[10]; MaxLength_iInt: Integer): Text
    var
        V_lTxt: Text;
        RowNo_lInt: Integer;
        ColNo_lInt: Integer;
    begin
        // -HSG_08  MAXSTRLEN()
        ColNo_lInt := TransfCol2Int_lFnc(Col_iCod);
        if not ExcelBuf.Get(CurrRow_gInt, ColNo_lInt) then begin
            exit('');
        end else begin
            V_lTxt := ExcelBuf."Cell Value as Text";
            if MaxLength_iInt <> 0 then begin
                V_lTxt := CopyStr(V_lTxt, 1, MaxLength_iInt);
            end;
            exit(V_lTxt);
        end;
        // +HSG_08
    end;

    procedure FieldDec_gFnc(Col_iCod: Code[10]): Decimal
    var
        ExcelBuf1: Record "Excel Buffer";
        RowNo_lInt: Integer;
        ColNo_lInt: Integer;
    begin
        ColNo_lInt := TransfCol2Int_lFnc(Col_iCod);
        if not ExcelBuf.Get(CurrRow_gInt, ColNo_lInt) then begin
            exit(0);
        end else begin
            exit(Txt2Dec_gFnc(ExcelBuf."Cell Value as Text"));
        end;
    end;

    procedure FieldDate_gFnc(Col_iCod: Code[10]): Date
    var
        ExcelBuf1: Record "Excel Buffer";
        RowNo_lInt: Integer;
        ColNo_lInt: Integer;
    begin
        ColNo_lInt := TransfCol2Int_lFnc(Col_iCod);
        if not ExcelBuf.Get(CurrRow_gInt, ColNo_lInt) then begin
            exit(0D);
        end else begin
            exit(Txt2Dat_gFnc(ExcelBuf."Cell Value as Text"));
        end;
    end;

    procedure SheetNameSetGet_gFnc(SheetName_iTxt: Text) SheetName_rTxt: Text
    begin
        if SheetName_iTxt > '' then
            SheetName_gTxt := SheetName_iTxt;
        exit(SheetName_gTxt);
    end;

    procedure RecRef_SetTable_gFnc(Rec_iVar: Variant) TableId_rInt: Integer
    begin
        //RecRefLib_lCdu.ConvertToRecRef(Rec_iVar, Rec_gRecRef);//CODEUNIT "ForNAV RecordRef Library" can be used too.
        ConvertToRecRef_gFnc(Rec_iVar, Rec_gRecRef);//CODEUNIT "ForNAV RecordRef Library" can be used too.
        TableId_rInt := Rec_gRecRef.Number;
    end;

    procedure RecRef_FieldSetValueVar_gFnc(Fieldname_iTxt: Text; Value_iVar: Variant) Value_rTxt: Text
    var
        "Field": Record "Field";
        FldRef: FieldRef;
        NotAValidTableErr: Label 'This table is not valid to be used with the Update No. Printed Function. Please contact your system administrator or ForNAV support.';
    begin
        Field.SetRange(TableNo, Rec_gRecRef.Number);
        Field.SetRange(FieldName, Fieldname_iTxt);
        if not Field.FindFirst then begin
            Error(FieldNotFound_gCtx, Fieldname_iTxt, Rec_gRecRef.Caption);
        end;
        FldRef := Rec_gRecRef.Field(Field."No.");
        FldRef.Value := Value_iVar;
    end;

    procedure RecRef_FieldSetValue_gFnc(ExcelCol_iInt: Integer; Value_iVar: Variant; Validate_iBln: Boolean) Return_rBln: Boolean
    var
        "Field": Record "Field";
        FldRef: FieldRef;
        NotAValidTableErr: Label 'This table is not valid to be used with the Update No. Printed Function. Please contact your system administrator or ForNAV support.';
        V_lTxt: Text;
        Type_lTxt: Text;
        LengthMax_lInt: Integer;
        Value_lTxt: Text;
    begin
        Return_rBln := false;
        ColumnListTmp_gRec.Reset;
        ColumnListTmp_gRec.SetRange("Column No.", ExcelCol_iInt);
        if not ColumnListTmp_gRec.FindFirst then begin
            //ERROR(FieldNotFoundExcel_gCtx,ExcelCol_iInt,Rec_gRecRef.CAPTION);
            exit(false);
        end;
        FldRef := Rec_gRecRef.Field(ColumnListTmp_gRec."Row No.");
        Type_lTxt := Format(FldRef.Type);
        if Type_lTxt = 'Text' then begin
            LengthMax_lInt := FldRef.Length;
            Value_lTxt := Value_iVar;
            if StrLen(Value_lTxt) > LengthMax_lInt then begin
                Value_lTxt := CopyStr(Value_lTxt, 1, LengthMax_lInt);
            end;
            if Validate_iBln then begin
                FldRef.Validate(Value_lTxt);
            end else begin
                FldRef.Value := Value_lTxt;
            end;
        end else begin
            if Validate_iBln then begin
                FldRef.Validate(Value_iVar);
            end else begin
                FldRef.Value := Value_iVar;
            end;
        end;
        Return_rBln := true;
    end;

    procedure RecRef_FieldSetColumn_gFnc(ExcelCol_iInt: Integer; Validate_iBln: Boolean) Return_rBln: Boolean
    var
        "Field": Record "Field";
        FldRef: FieldRef;
        NotAValidTableErr: Label 'This table is not valid to be used with the Update No. Printed Function. Please contact your system administrator or ForNAV support.';
        V_lTxt: Text;
        Type_lTxt: Text;
        LengthMax_lInt: Integer;
        Value_iVar: Variant;
        Value_lTxt: Text;
    begin
        Return_rBln := false;
        ColumnListTmp_gRec.Reset;
        ColumnListTmp_gRec.SetRange("Column No.", ExcelCol_iInt);
        if not ColumnListTmp_gRec.FindFirst then begin
            //ERROR(FieldNotFoundExcel_gCtx,ExcelCol_iInt,Rec_gRecRef.CAPTION);
            exit(false);
        end;
        FldRef := Rec_gRecRef.Field(ColumnListTmp_gRec."Row No.");
        Type_lTxt := Format(FldRef.Type);
        if not ExcelBuf.Get(CurrRow_gInt, ExcelCol_iInt) then begin
            if ColumnListTmp_gRec."Cell Type" = ColumnListTmp_gRec."Cell Type"::Text then begin
                Value_iVar := '';
            end else begin
                exit;//Cell is empty
            end;
        end else begin
            Value_iVar := ExcelBuf."Cell Value as Text";
        end;


        //# Check MaxLength of the text field
        if Type_lTxt = 'Text' then begin
            LengthMax_lInt := FldRef.Length;
            Value_lTxt := Value_iVar;
            if StrLen(Value_lTxt) > LengthMax_lInt then begin
                Value_lTxt := CopyStr(Value_lTxt, 1, LengthMax_lInt);
                Value_iVar := Value_lTxt;
            end;
        end;
        if Type_lTxt = 'Boolean' then begin
            Value_lTxt := Format(Value_iVar);
            if (UpperCase(Value_lTxt) = 'TRUE')
            or (UpperCase(Value_lTxt) = 'YES')
            or (UpperCase(Value_lTxt) = 'JA')
            or (UpperCase(Value_lTxt) = 'Y')
            or (UpperCase(Value_lTxt) = 'J')
            or (UpperCase(Value_lTxt) = '1') then begin
                Value_iVar := true;
            end else begin
                Value_iVar := false;
            end;
        end;

        if Validate_iBln then begin
            FldRef.Validate(Value_iVar);
        end else begin
            FldRef.Value := Value_iVar;
        end;

        Return_rBln := true;
    end;

    procedure RecRef_ModifyCommit_gFnc(Commit_iBln: Boolean)
    begin
        Rec_gRecRef.Modify;
        if Commit_iBln then begin
            Commit;
        end;
    end;

    /// <summary>
    /// GetFileName_gFnc.
    /// </summary>
    /// <param name="Type_iInt">Integer.</param>
    /// <returns>Return variable Filename_rTxt of type Text.</returns>
  //  [Scope('Personalization')]
    procedure GetFileName_gFnc(Type_iInt: Integer) Filename_rTxt: Text
    var
        FileMgt_lCdu: Codeunit "File Management";
    begin
        // -HSG_10
        case Type_iInt of
            1:
                Filename_rTxt := FileMgt_lCdu.GetFileName(FileName_gTxt);
            2:
                Filename_rTxt := FileMgt_lCdu.GetExtension(FileName_gTxt);
            3:
                Filename_rTxt := FileMgt_lCdu.GetFileNameWithoutExtension(FileName_gTxt);
            4:
                Filename_rTxt := FileName_gTxt;
            5:
                Filename_rTxt := ConvertStr(FileName_gTxt, '\', '/');
            else
                Error(ParamError_gCtx, 'Type_iInt', 'GetFileName_gFnc', Type_iInt);
        end;
    end;

    procedure ConvertToRecRef_gFnc(var Rec: Variant; RecRef: RecordRef)
    var
        WrongDataTypeErr: Label 'Runtime Error: Wrong Datatype. Please contact your ForNAV reseller.';
    begin
        // -HSG_10
        case true of
            Rec.IsRecordRef:
                RecRef := Rec;
            Rec.IsRecord:
                RecRef.GetTable(Rec);
            else
                Error(WrongDataTypeErr);
        end;
    end;

    procedure FindAndFilterFieldNo_gFnc(var RecRef: RecordRef; var LineRec: RecordRef; var FldRef: FieldRef; Value: Text)
    var
        "Field": Record "Field";
        DocumentNoField: FieldRef;
    begin
        // -HSG_10
        Field.SetRange(TableNo, RecRef.Number);
        Field.SetRange(FieldName, Value);
        if not Field.FindFirst then
            exit;

        DocumentNoField := RecRef.Field(Field."No.");

        Field.Reset;
        Field.SetRange(TableNo, RecRef.Number + 1);
        Field.SetRange("No.", Field."No.");
        if not Field.FindFirst then
            exit;

        FldRef := LineRec.Field(Field."No.");
        FldRef.SetRange(DocumentNoField.Value);
    end;

    local procedure "-"()
    begin
    end;

    procedure Export_Start_gFnc(Filename_iTxt: Text; SheetName_iTxt: Text) Result_rBln: Boolean
    var
        FileMgt_lCdu: Codeunit "File Management";
    begin
        FileName_gTxt := '.xlsx';
        if Filename_iTxt > '' then begin
            if StrPos(Filename_iTxt, '.xlsx') = 0 then begin
                FileName_gTxt := Filename_iTxt + FileName_gTxt;
            end else begin
                FileName_gTxt := Filename_iTxt;
            end;
        end;
        //PathWithFileName_gTxt := FileMgt_lCdu.SaveFileDialog(SaveAs_gCtx,Filename_gTxt,FileMgt_lCdu.GetToFilterText('',Filename_gTxt));
        FileName_gTxt := FileMgt_lCdu.SaveFileDialog(SaveAs_gCtx, FileName_gTxt, FileMgt_lCdu.GetToFilterText('', FileName_gTxt));
        if FileName_gTxt = '' then
            exit(false);
        ServerTempFile_gTxt := FileMgt_lCdu.ServerTempFileName(FileMgt_lCdu.GetExtension(FileName_gTxt));
        ExcelBuf.DeleteAll;
        Clear(ExcelBuf);
        //FormatExcelBufTmp_gRec.DELETEALL;
        //CLEAR(FormatExcelBufTmp_gRec);
        SheetName_gTxt := SheetName_iTxt;
        ExcelBuf.CreateBook(ServerTempFile_gTxt, SheetName_gTxt);
        RowNo_gInt := 1;
        ColumnNo_gInt := 1;
        exit(FileName_gTxt > '');
    end;

    procedure Export_End_gFnc() File_rTxt: Text
    var
        FileMgt_lCdu: Codeunit "File Management";
    begin
        ExcelBuf.CloseBook;
        if FileMgt_lCdu.ClientFileExists(FileName_gTxt) then
            FileMgt_lCdu.DeleteClientFile(FileName_gTxt);
        FileMgt_lCdu.DownloadToFile(ServerTempFile_gTxt, FileName_gTxt);
        FileMgt_lCdu.DeleteServerFile(ServerTempFile_gTxt);
        exit(FileName_gTxt);
    end;

    procedure Exp_InitFormatGrp_gFnc(GroupId_iInt: Integer)
    var
        CellType_lOpt: Option Number,Text,Date,Time;
    begin
        case GroupId_iInt of
            0, 1:
                begin
                    Exp_SetFormat_gFnc(1, true, false, true, false, '@', CellType_lOpt::Text, '');//Header Text: Bold, Underline
                    Exp_SetFormat_gFnc(2, false, false, false, false, '@', CellType_lOpt::Text, '');//Text
                    Exp_SetFormat_gFnc(3, true, false, false, false, '@', CellType_lOpt::Text, '');//Header Text: Bold
                    Exp_SetFormat_gFnc(10, false, false, false, false, '#,##0.00', CellType_lOpt::Number, '');//Decimal
                    Exp_SetFormat_gFnc(11, false, false, false, false, 'DD.MM.YYYY', CellType_lOpt::Date, '');//Date
                    Exp_SetFormat_gFnc(12, false, false, false, false, '0.00" "%', CellType_lOpt::Number, '');//Percent
                    Exp_SetFormat_gFnc(13, false, false, false, false, '0', CellType_lOpt::Number, '');//Integer
                    Exp_SetFormat_gFnc(14, false, false, false, false, '#', CellType_lOpt::Text, '');//EAN
                                                                                                     //Excel_lCdu.SetFormat_Exp_gFnc(21,FALSE,FALSE,FALSE,FALSE,'#,##0.00',CellType_lOpt::Number,'=N17+O17');
                    Exp_SetFormat_gFnc(21, false, false, false, false, '#,##0.00', CellType_lOpt::Number, '=N{CR}+O{CR}');
                end;
            else
                Error(ParamError_gCtx, 'GroupId_iInt', 'Exp_SetFormatInit_gFnc', GroupId_iInt);
        end;
    end;

    procedure Exp_SetFormat_gFnc(FormatId_iInt: Integer; Bold_iBln: Boolean; Italic_iBln: Boolean; UnderLine_iBln: Boolean; DoubleUnderLine_iBln: Boolean; NumberFormat_iTxt: Text[30]; CellType_iOpt: Option; Formula_iTxt: Text)
    begin
        if not FormatExcelBufTmp_gRec.Get(FormatId_iInt, 0) then begin
            FormatExcelBufTmp_gRec."Row No." := FormatId_iInt;
            FormatExcelBufTmp_gRec."Column No." := 0;
            FormatExcelBufTmp_gRec.Insert;
        end;
        //FormatExcelBufTmp_gRec.Formula:= Formula_iTxt;
        if Formula_iTxt > '' then
            FormatExcelBufTmp_gRec.SetFormula(Formula_iTxt);
        FormatExcelBufTmp_gRec.Bold := Bold_iBln;
        FormatExcelBufTmp_gRec.Italic := Italic_iBln;
        FormatExcelBufTmp_gRec.Underline := UnderLine_iBln;
        FormatExcelBufTmp_gRec.NumberFormat := NumberFormat_iTxt;
        FormatExcelBufTmp_gRec."Cell Type" := CellType_iOpt;
        FormatExcelBufTmp_gRec.Modify;
    end;

    procedure Exp_SetFormatId_gFnc(FormatId_iInt: Integer)
    begin
        FormatId_gInt := FormatId_iInt;
    end;

    local procedure Exp_GetFormat_lFnc(FormatId_iInt: Integer; var ExcelBuf_vRec: Record "Excel Buffer" temporary)
    var
        V_lTxt: Text;
    begin
        if FormatExcelBufTmp_gRec.Get(FormatId_iInt, 0) then begin
            ExcelBuf_vRec.Formula := FormatExcelBufTmp_gRec.Formula;
            ExcelBuf_vRec.Bold := FormatExcelBufTmp_gRec.Bold;
            ExcelBuf_vRec.Italic := FormatExcelBufTmp_gRec.Italic;
            ExcelBuf_vRec.Underline := FormatExcelBufTmp_gRec.Underline;
            ExcelBuf_vRec.NumberFormat := FormatExcelBufTmp_gRec.NumberFormat;
            ExcelBuf_vRec.Formula2 := FormatExcelBufTmp_gRec.Formula2;
            ExcelBuf_vRec.Formula3 := FormatExcelBufTmp_gRec.Formula3;
        end;
    end;

    procedure Exp_Field_gFnc(Value_iVar: Variant) Result_rBln: Boolean
    var
        IsFormula_lBln: Boolean;
        V_lDat: Date;
        Null_lDat: Date;
        V_lInt: Integer;
        V_lBln: Boolean;
    begin
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo_gInt);
        ExcelBuf.Validate("Column No.", ColumnNo_gInt);
        ExcelBuf."Cell Value as Text" := CopyStr(Format(Value_iVar), 1, MaxStrLen(ExcelBuf."Cell Value as Text"));
        Exp_GetFormat_lFnc(FormatId_gInt, ExcelBuf);

        if Value_iVar.IsDate then begin
            ExcelBuf.NumberFormat := 'DD.MM.YYYY';
            if ExcelBuf."Cell Value as Text" > '' then begin
                V_lDat := Value_iVar;
                Null_lDat := 19000101D;//Excel stores dates since January 1, 1900 (DATEVALUE)
                V_lInt := V_lDat - Null_lDat + 2;
                ExcelBuf."Cell Value as Text" := Format(V_lInt);
            end;
        end;
        if Value_iVar.IsDecimal then begin
            ExcelBuf.NumberFormat := '#,##0.00';
        end;
        if Value_iVar.IsCode or Value_iVar.IsText then begin
            ExcelBuf.NumberFormat := '@';
        end;
        if Value_iVar.IsBoolean then begin
            ExcelBuf.NumberFormat := 'LOGISCH';
            if ExcelBuf."Cell Value as Text" > '' then begin
                V_lBln := Value_iVar;
                if V_lBln then
                    ExcelBuf."Cell Value as Text" := '1'
                else
                    ExcelBuf."Cell Value as Text" := '0';
            end;
        end;
        if IsFormula_lBln then begin
            ExcelBuf.SetFormula(Format(Value_iVar))
        end;
        ExcelBuf.Insert;
        ColumnNo_gInt += 1;
    end;

    procedure Exp_FieldFormat_gFnc(Format_iInt: Integer; Value_iVar: Variant) Result_rBln: Boolean
    var
        IsFormula_lBln: Boolean;
        V_lDat: Date;
        Null_lDat: Date;
        V_lInt: Integer;
        Formula_lTxt: Text;
        V_lBln: Boolean;
    begin
        ExcelBuf.Init;
        ExcelBuf.Validate("Row No.", RowNo_gInt);
        ExcelBuf.Validate("Column No.", ColumnNo_gInt);
        ExcelBuf."Cell Value as Text" := CopyStr(Format(Value_iVar), 1, MaxStrLen(ExcelBuf."Cell Value as Text"));
        if ExcelBuf."Cell Value as Text" > '' then begin
            if Value_iVar.IsDate then begin
                V_lDat := Value_iVar;
                Null_lDat := 19000101D;//Excel stores dates since January 1, 1900 (DATEVALUE)
                V_lInt := V_lDat - Null_lDat + 2;
                ExcelBuf."Cell Value as Text" := Format(V_lInt);
            end;
        end;
        if Value_iVar.IsBoolean then begin
            ExcelBuf.NumberFormat := 'LOGISCH';
            if ExcelBuf."Cell Value as Text" > '' then begin
                V_lBln := Value_iVar;
                if V_lBln then
                    ExcelBuf."Cell Value as Text" := '1'
                else
                    ExcelBuf."Cell Value as Text" := '0';
            end;
        end;
        Exp_GetFormat_lFnc(Format_iInt, ExcelBuf);

        if ExcelBuf.Formula > '' then begin
            if ExcelBuf."Cell Value as Text" > '' then begin
                Formula_lTxt := StrReplace_gFnc(ExcelBuf."Cell Value as Text", '{CR}', Format(RowNo_gInt));
                ExcelBuf.SetFormula(Formula_lTxt)
            end else begin
                Formula_lTxt := StrReplace_gFnc(ExcelBuf.GetFormula, '{CR}', Format(RowNo_gInt));
                ExcelBuf.SetFormula(Formula_lTxt)
            end;
        end;
        ExcelBuf.Insert;
        ColumnNo_gInt += 1;
    end;

    procedure Exp_NewLine_gFnc()
    begin
        RowNo_gInt += 1;
        ColumnNo_gInt := 1;
    end;

    procedure Exp_NewLineExt_gFnc(RowNoOffset_iInt: Integer; ColumnNo_iInt: Integer)
    begin
        if RowNoOffset_iInt > 1 then begin
            RowNo_gInt += RowNoOffset_iInt;
        end else begin
            RowNo_gInt += 1;
        end;
        ColumnNo_gInt := 1;
        if ColumnNo_iInt > 1 then begin
            ColumnNo_gInt := ColumnNo_iInt;
        end;
    end;

    procedure Exp_WriteSheet_gFnc()
    begin
        ExcelBuf.WriteSheet('', CompanyName, UserId);
        if ExcelBuf.HasFilter then begin
            Error('Filter on internal tmp table not allowed');
        end;
        ExcelBuf.DeleteAll;
        RowNo_gInt := 1;
        ColumnNo_gInt := 1;
    end;

    procedure Exp_SelectOrAddSheet_gFnc(NewSheetName_iTxt: Text)
    begin
        ExcelBuf.SelectOrAddSheet(NewSheetName_iTxt);
    end;

    procedure Exp_HeaderInsert_gFnc()
    var
        CompanyInfo_lRec: Record "Company Information";
    begin
        CompanyInfo_lRec.Get;
        ColumnNo_gInt := 5;
        /*
        Excel_lCdu.Field_Exp_gFnc(1,CompanyInfo_lRec.Name );
        Excel_lCdu.Field_Exp_gFnc(1, CompanyInfo_lRec.Address);
        Excel_lCdu.Field_Exp_gFnc(1,CompanyInfo_lRec."Post Code"+' '+CompanyInfo_lRec.City);
        Excel_lCdu.Field_Exp_gFnc(1,
        Excel_lCdu.Field_Exp_gFnc(1,
        */

    end;

    local procedure "--"()
    begin
    end;

    procedure StrReplace_gFnc(Base_iTxt: Text; Old_iTxt: Text; New_iTxt: Text) Result_rTxt: Text
    var
        Pos_lInt: Integer;
        V_lTxt: Text;
    begin
        V_lTxt := Base_iTxt;
        Pos_lInt := StrPos(V_lTxt, Old_iTxt);
        while Pos_lInt <> 0 do begin
            V_lTxt := DelStr(V_lTxt, Pos_lInt, StrLen(Old_iTxt));
            V_lTxt := InsStr(V_lTxt, New_iTxt, Pos_lInt);
            Pos_lInt := StrPos(V_lTxt, Old_iTxt);
        end;
        exit(V_lTxt);
    end;
    /* 
        procedure SelectSheetsName(FileName: Text): Text[250]
        var
            TempBlob: Codeunit "Temp Blob";
            InStr: InStream;
        begin
            if FileName = '' then
                Error(Text001);

            FileManagement.BLOBImportFromServerFile(TempBlob, FileName);
            TempBlob.CreateInStream(InStr);
            exit(SelectSheetsNameStream(InStr));
        end;

     */
    /*    procedure SelectSheetsNameStream(FileStream: InStream): Text[250]
       var
           TempNameValueBuffer: Record "Name/Value Buffer" temporary;
           SelectedSheetName: Text[250];
       begin
           if GetSheetsNameListFromStream(FileStream, TempNameValueBuffer) then
               if TempNameValueBuffer.Count = 1 then
                   SelectedSheetName := TempNameValueBuffer.Value
               else begin
                   TempNameValueBuffer.FindFirst;
                   if PAGE.RunModal(PAGE::"Name/Value Lookup", TempNameValueBuffer) = ACTION::LookupOK then
                       SelectedSheetName := TempNameValueBuffer.Value;
               end;

           exit(SelectedSheetName);
       end; */
}

