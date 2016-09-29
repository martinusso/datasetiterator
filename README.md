# datasetiterator

This fork has slight differences with the original repository, that's hosted on BitBucket at https://bitbucket.org/magnomp/datasetiterator.

## Using

```Delphi				   
uses
  DataSetIterator;

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
```

## Author

DataSetIterator.pas was originally developed by [Magno Machado](https://github.com/magnomp).
