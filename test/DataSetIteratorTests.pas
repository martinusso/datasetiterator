unit DataSetIteratorTests;

interface

uses
  TestFramework,
  DB,
  DBClient,
  DataSetIterator;

type
  TDataSetIteratorTests = class(TTestCase)
  private
    FSUT: IDataSetIterator;
    FDataSet: TClientDataSet;
    procedure ForceRelease;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestNextShouldReturnFalseIfDataSetIsEmpty;
    procedure TestNextShouldReturnFalseWhenLastRecord;
    procedure TestNextShouldIterateOverAllRecords;
    procedure TestShouldDisableControlsInNewIterator;
    procedure TestShouldEnableControlsWhenDestroyed;
    procedure TestShouldGoToFirstRecordOnCreate;
    procedure TestAfterIteratorShouldReturnToSameRecord;
  end;

implementation

{ TDataSetIteratorTests }

procedure TDataSetIteratorTests.ForceRelease;
var
  P: Pointer;
begin
  { TODO : find another way to release the interface }
  P := Pointer(FSUT);
  IDataSetIterator(P)._Release;
  FSUT := nil;
  P := nil;
end;

procedure TDataSetIteratorTests.SetUp;
begin
  inherited;

  FDataSet := TClientDataSet.Create(nil);
  FDataSet.Close;
  FDataSet.FieldDefs.Clear;
  FDataSet.FieldDefs.Add('ID', ftInteger);
  FDataSet.CreateDataSet;
end;

procedure TDataSetIteratorTests.TearDown;
begin
  FDataSet.Free;
  inherited;
end;

procedure TDataSetIteratorTests.TestAfterIteratorShouldReturnToSameRecord;
begin
  FDataSet.AppendData([1]);
  FDataSet.AppendData([2]);
  FDataSet.AppendData([3]);
  FDataSet.AppendData([4]);
  FDataSet.AppendData([5]);

  FDataSet.Locate('ID', 3, []);

  FSUT := Iterator(FDataSet);
  while FSUT.Next do
    Continue;

  ForceRelease;

  CheckEquals(3, FDataSet.FieldByName('ID').Value);
end;

procedure TDataSetIteratorTests.TestNextShouldIterateOverAllRecords;
begin
  FDataSet.AppendData([1]);
  FDataSet.AppendData([2]);
  FDataSet.AppendData([3]);

  FSUT := Iterator(FDataSet);

  CheckEquals(1, FDataSet.FieldByName('ID').Value, 'Should be Id 1 before first next');
  FSUT.Next;
  CheckEquals(1, FDataSet.FieldByName('ID').Value, 'Should be Id 1');
  FSUT.Next;
  CheckEquals(2, FDataSet.FieldByName('ID').Value, 'Should be Id 2');
  FSUT.Next;
  CheckEquals(3, FDataSet.FieldByName('ID').Value, 'Should be Id 3');
end;

procedure TDataSetIteratorTests.TestNextShouldReturnFalseIfDataSetIsEmpty;
begin
  FSUT := Iterator(FDataSet);

  CheckFalse(FSUT.Next, 'Next should return False if DataSet is Empty');
end;

procedure TDataSetIteratorTests.TestNextShouldReturnFalseWhenLastRecord;
begin
  FDataSet.AppendData([1]);
  FDataSet.AppendData([2]);
  FDataSet.AppendData([3]);

  FSUT := Iterator(FDataSet);

  CheckTrue(FSUT.Next, 'Next should return True when first record');
  CheckTrue(FSUT.Next, 'Next should return True when second record');
  CheckTrue(FSUT.Next, 'Next should return True when third record');
  CheckFalse(FSUT.Next, 'Next should return False when last record');
end;

procedure TDataSetIteratorTests.TestShouldDisableControlsInNewIterator;
begin
  FSUT := Iterator(FDataSet);

  CheckTrue(FDataSet.ControlsDisabled);
end;

procedure TDataSetIteratorTests.TestShouldEnableControlsWhenDestroyed;
begin
  FSUT := Iterator(FDataSet);
  FSUT.Next;

  ForceRelease;

  CheckFalse(FDataSet.ControlsDisabled);
end;

procedure TDataSetIteratorTests.TestShouldGoToFirstRecordOnCreate;
begin
  FDataSet.AppendData([1]);
  FDataSet.AppendData([2]);
  FDataSet.AppendData([3]);

  FSUT := Iterator(FDataSet);

  CheckEquals(1, FDataSet.RecNo);
end;

initialization
  RegisterTest(TDataSetIteratorTests.Suite);

end.
