unit C4D.SearchComponents;

interface

uses
  Vcl.Forms,
  System.SysUtils,
  C4D.SearchComponents.Interfaces,
  C4D.SearchComponents.Search;

type
  TC4DSearchComponents = class(TInterfacedObject, IC4DSearchComponents)
  private
    FFormSearch: TForm;
    FStrSearch: string;
    FOnTotalFoundForm: TProc<Integer>;
  protected
    function FormSearch(const Value: TForm): IC4DSearchComponents;
    function StrSearch(const Value: string): IC4DSearchComponents;
    function OnTotalFoundForm(Value: TProc<Integer>): IC4DSearchComponents;
    procedure Search;
  public
    class function New: IC4DSearchComponents;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

class function TC4DSearchComponents.New: IC4DSearchComponents;
begin
  Result := Self.Create;
end;

constructor TC4DSearchComponents.Create;
begin
  FFormSearch := nil;
end;

destructor TC4DSearchComponents.Destroy;
begin
  inherited;
end;

function TC4DSearchComponents.FormSearch(const Value: TForm): IC4DSearchComponents;
begin
  Result := Self;
  FFormSearch := Value;
end;

function TC4DSearchComponents.OnTotalFoundForm(Value: TProc<Integer>): IC4DSearchComponents;
begin
  Result := Self;
  FOnTotalFoundForm := Value;
end;

function TC4DSearchComponents.StrSearch(const Value: string): IC4DSearchComponents;
begin
  Result := Self;
  FStrSearch := Value;
end;

procedure TC4DSearchComponents.Search;
var
  LSearch: TC4DSearchComponentsSearch;
begin
  if(FFormSearch = nil)then
    raise Exception.Create('A tela onde deve ser buscado não foi informada');

  LSearch := TC4DSearchComponentsSearch.Create;
  try
    LSearch.Form := FFormSearch;
    LSearch.StrSearch := FStrSearch;
    LSearch.Buscar;

    if(Assigned(FOnTotalFoundForm))then
      FOnTotalFoundForm(LSearch.TotalEncontrados);
  finally
    LSearch.Free;
  end;
end;

end.
