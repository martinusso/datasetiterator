unit DataSetIterator;

interface

uses
  DB;

type
  IDataSetIterator = interface
    ['{56F65708-4DD8-4C44-841E-7AE91D66D47F}']
    function Next: Boolean;
  end;

  TDataSetIterator = class(TInterfacedObject, IDataSetIterator)
  strict private
    FDataSet: TDataSet;
    FBookmark: TBookmark;
    FCalledNext: Boolean;
  public
    constructor Create(const DataSet: TDataSet);
    destructor Destroy; override;
    function Next: Boolean;
  end;

function Iterator(const DataSet: TDataSet): IDataSetIterator;

implementation

function Iterator(const DataSet: TDataSet): IDataSetIterator;
begin
  Result := TDataSetIterator.Create(DataSet);
end;

{ TDataSetIterator }

constructor TDataSetIterator.Create(const DataSet: TDataSet);
begin
  FBookmark := DataSet.Bookmark;
  FDataSet := DataSet;
  FDataSet.DisableControls;
  FDataSet.First;
end;

destructor TDataSetIterator.Destroy;
begin
  if Assigned(FBookmark) and FDataSet.BookmarkValid(FBookmark) then
    FDataSet.Bookmark := FBookmark;
  FDataSet.FreeBookmark(FBookmark);
  FDataSet.EnableControls;
  inherited;
end;

function TDataSetIterator.Next: Boolean;
begin
  if not FCalledNext then
  begin
    Result := not FDataSet.IsEmpty;
    FCalledNext := True;
  end
  else
  begin
    FDataSet.Next;
    Result := not FDataSet.Eof;
  end;
end;

end.
