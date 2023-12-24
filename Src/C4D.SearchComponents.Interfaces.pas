unit C4D.SearchComponents.Interfaces;

interface

uses
  Vcl.Forms,
  System.SysUtils;

type
  IC4DSearchComponents = interface
    ['{17EDE65D-0219-407E-BFF5-EF13F9671748}']
    function FormSearch(const Value: TForm): IC4DSearchComponents; overload;
    function StrSearch(const Value: string): IC4DSearchComponents; overload;
    function OnTotalFoundForm(Value: TProc<Integer>): IC4DSearchComponents;
    procedure Search;
  end;

implementation

end.
