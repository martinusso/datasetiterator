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
```

### Motivation

Why the DataSetIterator exists? Let's answer it with some code.

The code below is a common way to iterate over the Dataset. DataSetIterator does this in a simple, efficient, safe and elegant way.

```Delphi
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
    ClientDataSet1.EnableControls; { ...or called EnableContraints instead of
                                        EnableControls here? }
  end;
 ```

## Author

DataSetIterator.pas was originally developed by [Magno Machado](https://github.com/magnomp).
