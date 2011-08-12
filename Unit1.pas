unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, StdCtrls, Mask, DBCtrls, Grids, DBGrids, DBClient;

type
  TForm1 = class(TForm)
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ClientDataSet1FOOBAR: TIntegerField;
    Button1: TButton;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  UDataSetIterator;

procedure TForm1.Button1Click(Sender: TObject);
var
  I: IDataSetIterator;
  Sum: Integer;
begin
  { Ok, using aggregates here would be even better. This is just an example }

  Sum := 0;
  I := Iterator(ClientDataSet1);
  while I.Next do
    Inc(Sum, ClientDataSet1FOOBAR.AsInteger);

  ShowMessage(Format('The sum is %d.', [Sum]));
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  Bookmark: TBookmark;
  Sum: Integer;
begin
  Sum := 0;
  Bookmark := ClientDataSet1.Bookmark;
  ClientDataSet1.DisableControls;
  try
    ClientDataSet1.First;
    while not ClientDataSet1.Eof do
    begin
      Inc(Sum, ClientDataSet1FOOBAR.AsInteger);
      ClientDataSet1.Next; { Who haven't ever forgot to call Next here... }
    end;
  finally
    ClientDataSet1.Bookmark := Bookmark;
    ClientDataSet1.FreeBookmark(Bookmark);
    ClientDataSet1.EnableControls; { ..o8r called EnableContraints instead of
                                     EnableControls here? }
  end;

  ShowMessage(Format('The sum is %d.', [Sum]));
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  ClientDataSet1.CreateDataSet;
  for i := 1 to 3 do
    ClientDataSet1.InsertRecord([i]);
end;

end.
