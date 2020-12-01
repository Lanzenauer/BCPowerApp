/* codeunit 50102 ExcelImport
{
    var
        Rec_ExcelBuffer: Record "Excel Buffer";
        Rows: Integer;
        Columns: Integer;
        Filename: Text;
        FileMgmt: Codeunit "File Management";
        ExcelFile: File;
        Instr: InStream;
        Sheetname: Text;
        FileUploaded: Boolean;
        RowNo: Integer;
        ColNo: Integer;
        Rec_GenJnl: Record "Gen. Journal Line";

    procedure ImportGenJnlExcel()
    var
    begin
        Rec_ExcelBuffer.DeleteAll();
        Rows := 0;
        Columns := 0;
        FileUploaded := UploadIntoStream('Select File to Upload', '', '', Filename, Instr);

        if Filename <> '' then
            Sheetname := Rec_ExcelBuffer.SelectSheetsNameStream(Instr)
        else
            exit;


        Rec_ExcelBuffer.Reset;
        Rec_ExcelBuffer.OpenBookStream(Instr, Sheetname);
        Rec_ExcelBuffer.ReadSheet();

        Commit();
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Column No.", 1);
        if Rec_ExcelBuffer.FindFirst() then
            repeat
                Rows := Rows + 1;
            until Rec_ExcelBuffer.Next() = 0;
        //Message(Format(Rows));

        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Row No.", 1);
        if Rec_ExcelBuffer.FindFirst() then
            repeat
                Columns := Columns + 1;
            until Rec_ExcelBuffer.Next() = 0;
        //Message(Format(Columns));
        //Modify or Insert
        for RowNo := 2 to Rows do begin
            Rec_GenJnl.Reset();
            if Rec_GenJnl.Get(GetValueAtIndex(RowNo, 1), GetValueAtIndex(RowNo, 2), GetValueAtIndex(RowNo, 3)) then begin
                Evaluate(Rec_GenJnl."Posting Date", GetValueAtIndex(RowNo, 4));
                Rec_GenJnl.Validate("Posting Date");
                Evaluate(Rec_GenJnl."Document No.", GetValueAtIndex(RowNo, 5));
                Rec_GenJnl.Validate("Document No.");
                Evaluate(Rec_GenJnl."Account Type", GetValueAtIndex(RowNo, 6));
                Rec_GenJnl.Validate("Account Type");
                Evaluate(Rec_GenJnl."Account No.", GetValueAtIndex(RowNo, 7));
                Rec_GenJnl.Validate("Account No.");
                Evaluate(Rec_GenJnl."Shortcut Dimension 1 Code", GetValueAtIndex(RowNo, 8));
                Rec_GenJnl.Validate("Shortcut Dimension 1 Code");
                Evaluate(Rec_GenJnl.LeaseNo, GetValueAtIndex(RowNo, 9));
                Rec_GenJnl.Validate(LeaseNo);
                Evaluate(Rec_GenJnl.Description, GetValueAtIndex(RowNo, 10));
                Rec_GenJnl.Validate(Description);
                Evaluate(Rec_GenJnl.Amount, GetValueAtIndex(RowNo, 11));
                Rec_GenJnl.Validate(Amount);
                Evaluate(Rec_GenJnl."Shortcut Dimension 2 Code", GetValueAtIndex(RowNo, 12));
                Rec_GenJnl.Validate(Rec_GenJnl."Shortcut Dimension 2 Code");
                Rec_GenJnl.Modify(true);

            end
            else begin
                Rec_GenJnl.Init();
                Evaluate(Rec_GenJnl."Journal Template Name", GetValueAtIndex(RowNo, 1));

                Evaluate(Rec_GenJnl."Journal Batch Name", GetValueAtIndex(RowNo, 2));
                Evaluate(Rec_GenJnl."Line No.", GetValueAtIndex(RowNo, 3));
                Evaluate(Rec_GenJnl."Posting Date", GetValueAtIndex(RowNo, 4));
                Evaluate(Rec_GenJnl."Document No.", GetValueAtIndex(RowNo, 5));
                Evaluate(Rec_GenJnl."Account Type", GetValueAtIndex(RowNo, 6));
                Evaluate(Rec_GenJnl."Account No.", GetValueAtIndex(RowNo, 7));
                Rec_GenJnl.Validate("Account No.");
                Evaluate(Rec_GenJnl."Shortcut Dimension 1 Code", GetValueAtIndex(RowNo, 8));
                Evaluate(Rec_GenJnl.LeaseNo, GetValueAtIndex(RowNo, 9));
                Evaluate(Rec_GenJnl.Description, GetValueAtIndex(RowNo, 10));
                Evaluate(Rec_GenJnl.Amount, GetValueAtIndex(RowNo, 11));
                Evaluate(Rec_GenJnl."Shortcut Dimension 2 Code", GetValueAtIndex(RowNo, 12));
                Rec_GenJnl.Validate(Amount);
                Rec_GenJnl.Validate("Posting Date");
                Rec_GenJnl.Validate("Document No.");
                Rec_GenJnl.Validate(LeaseNo);
                Rec_GenJnl.Validate("Shortcut Dimension 1 Code");
                Rec_GenJnl.Validate("Shortcut Dimension 2 Code");
                Rec_GenJnl.Insert();
            end;
        end;
    end;

    local procedure GetValueAtIndex(RowNo: Integer; ColNo: Integer): Text
    var
    begin
        Rec_ExcelBuffer.Reset();
        IF Rec_ExcelBuffer.Get(RowNo, ColNo) then
            exit(Rec_ExcelBuffer."Cell Value as Text");
    end;

}
 */