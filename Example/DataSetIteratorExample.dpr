program DataSetIteratorExample;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  DataSetIterator in 'DataSetIterator.pas';

{$R *.res}

begin
  Application.Initialize;
  ReportMemoryLeaksOnShutdown := True;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
