unit Model.Callback;

interface
type
  TProgressCallback = reference to procedure(const TableName: string;
    TotalRecords, CurrentRecord: Integer);

implementation

end.
