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
    FDataSet: TClientDataSet;
    procedure NewIterator;
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

procedure TDataSetIteratorTests.NewIterator;
var
  SUT: IDataSetIterator;
begin
  SUT := Iterator(FDataSet);
  while SUT.Next do
    Continue;
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
var
  SUT: IDataSetIterator;
begin
  FDataSet.InsertRecord([1]);
  FDataSet.InsertRecord([2]);
  FDataSet.InsertRecord([3]);
  FDataSet.InsertRecord([4]);
  FDataSet.InsertRecord([5]);

  FDataSet.Locate('ID', 3, []);

  NewIterator;

  CheckEquals(3, FDataSet.FieldByName('ID').Value);
end;

procedure TDataSetIteratorTests.TestNextShouldIterateOverAllRecords;
var
  SUT: IDataSetIterator;
begin
  FDataSet.InsertRecord([1]);
  FDataSet.InsertRecord([2]);
  FDataSet.InsertRecord([3]);

  SUT := Iterator(FDataSet);

  CheckEquals(1, FDataSet.FieldByName('ID').Value, 'Should be Id 1 before first next');
  SUT.Next;
  CheckEquals(1, FDataSet.FieldByName('ID').Value, 'Should be Id 1');
  SUT.Next;
  CheckEquals(2, FDataSet.FieldByName('ID').Value, 'Should be Id 2');
  SUT.Next;
  CheckEquals(3, FDataSet.FieldByName('ID').Value, 'Should be Id 3');
end;

procedure TDataSetIteratorTests.TestNextShouldReturnFalseIfDataSetIsEmpty;
var
  SUT: IDataSetIterator;
begin
  SUT := Iterator(FDataSet);

  CheckFalse(SUT.Next, 'Next should return False if DataSet is Empty');
end;

procedure TDataSetIteratorTests.TestNextShouldReturnFalseWhenLastRecord;
var
  SUT: IDataSetIterator;
begin
  FDataSet.InsertRecord([1]);
  FDataSet.InsertRecord([2]);
  FDataSet.InsertRecord([3]);

  SUT := Iterator(FDataSet);

  CheckTrue(SUT.Next, 'Next should return True when first record');
  CheckTrue(SUT.Next, 'Next should return True when second record');
  CheckTrue(SUT.Next, 'Next should return True when third record');
  CheckFalse(SUT.Next, 'Next should return False when last record');
end;

procedure TDataSetIteratorTests.TestShouldDisableControlsInNewIterator;
var
  SUT: IDataSetIterator;
begin
  SUT := Iterator(FDataSet);

  CheckTrue(FDataSet.ControlsDisabled);
end;

procedure TDataSetIteratorTests.TestShouldEnableControlsWhenDestroyed;
begin
  NewIterator;
  CheckFalse(FDataSet.ControlsDisabled);
end;

procedure TDataSetIteratorTests.TestShouldGoToFirstRecordOnCreate;
var
  SUT: IDataSetIterator;
begin
  FDataSet.InsertRecord([1]);
  FDataSet.InsertRecord([2]);
  FDataSet.InsertRecord([3]);

  SUT := Iterator(FDataSet);

  CheckEquals(1, FDataSet.RecNo);
end;

initialization
  RegisterTest(TDataSetIteratorTests.Suite);

end.
