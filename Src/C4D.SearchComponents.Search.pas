unit C4D.SearchComponents.Search;

interface

uses
  Winapi.Windows,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  ComCtrls,
  Vcl.StdCtrls,
  DBCtrls,
  Buttons,
  Vcl.ExtCtrls,
  C4D.SearchComponents.Utils,
  C4D.SearchComponents.Consts;

type
  TC4DSearchComponentsSearch = class
  private
    FForm: TForm;
    FStrSearch: string;
    FTotalEncontrados: Integer;
    FContrast: Boolean;
    procedure SetStrSearch(const Value: string);
    function TrataStrings(const Value: string): string;
    function ContrastString(const Value: string): Boolean;
    procedure ContrastComponent(const AComponent: TButton); overload;
    procedure ContrastComponent(const AComponent: TEdit); overload;
    procedure ContrastComponent(const AComponent: TDBEdit); overload;
    procedure ContrastComponent(const AComponent: TTabSheet); overload;
    procedure ContrastComponent(const AComponent: TLabel); overload;
    procedure ContrastComponent(const AComponent: TRadioButton); overload;
    procedure ContrastComponent(const AComponent: TCheckBox); overload;
    procedure ContrastComponent(const AComponent: TDBCheckBox); overload;
    function ValidateSkipComponentName(const AComponent: TComponent): Boolean;
  public
    constructor Create;
    Destructor Destroy; override;
    procedure Buscar;
    property Form: TForm read FForm write FForm;
    property StrSearch: string read FStrSearch write SetStrSearch;
    property TotalEncontrados: Integer read FTotalEncontrados;
  end;

implementation

constructor TC4DSearchComponentsSearch.Create;
begin
  FStrSearch := '';
  FTotalEncontrados := 0;
end;

destructor TC4DSearchComponentsSearch.Destroy;
begin
  inherited;
end;

procedure TC4DSearchComponentsSearch.SetStrSearch(const Value: string);
begin
  FStrSearch := TrataStrings(Value);
end;

function TC4DSearchComponentsSearch.TrataStrings(const Value: string): string;
begin
  Result := TUtils.RemoveAcento(AnsiUpperCase(Value));
end;

function TC4DSearchComponentsSearch.ContrastString(const Value: string): Boolean;
begin
  Result := False;

  if(FStrSearch.Trim.IsEmpty)then
    Exit;

  Result := pos(FStrSearch, TrataStrings(Value)) > 0;
end;

function TC4DSearchComponentsSearch.ValidateSkipComponentName(const AComponent: TComponent): Boolean;
begin
  Result := AComponent.Tag = 1234;
end;

procedure TC4DSearchComponentsSearch.Buscar;
var
  i: Integer;
  LComponent: TComponent;
begin
  FTotalEncontrados := 0;
  TUtils.DesmarcarPageControls(FForm);

  for i := 0 to Pred(FForm.ComponentCount) do
  begin
    FContrast := False;
    LComponent := FForm.Components[i];

    if(Self.ValidateSkipComponentName(LComponent))then
      Continue;

    if(not FStrSearch.IsEmpty)then
    begin
      if(LComponent is TTabSheet)then
        Self.ContrastComponent(TTabSheet(LComponent))
      else if(LComponent is TLabel)then
        Self.ContrastComponent(TLabel(LComponent))
      else if(LComponent is TButton)or(LComponent is TBitBtn)then
        Self.ContrastComponent(TButton(LComponent))
      else if(LComponent is TEdit)then
        Self.ContrastComponent(TEdit(LComponent))
      else if(LComponent is TDBEdit)then
        Self.ContrastComponent(TDBEdit(LComponent))
      else if(LComponent is TRadioButton)then
        Self.ContrastComponent(TRadioButton(LComponent))
      else if(LComponent is TCheckBox)then
        Self.ContrastComponent(TCheckBox(LComponent))
      else if(LComponent is TDBCheckBox)then
        Self.ContrastComponent(TDBCheckBox(LComponent));
    end;

    TUtils.ShapeInComponent(FForm, TControl(LComponent), FContrast);

    if(FContrast)then
    begin
      Inc(FTotalEncontrados);
      TUtils.ContrastComponentsParents(LComponent);
    end;
  end;
end;

procedure TC4DSearchComponentsSearch.ContrastComponent(const AComponent: TTabSheet);
begin
  if(AComponent.TabVisible)then
    FContrast := ContrastString(AComponent.Caption);

  if(FContrast)then
  begin
    TPageControl(AComponent.Parent).StyleElements := TPageControl(AComponent.Parent).StyleElements - [seClient];
    AComponent.Highlighted := True;
    AComponent.Repaint;
  end;
end;

procedure TC4DSearchComponentsSearch.ContrastComponent(const AComponent: TLabel);
begin
  FContrast := (ContrastString(AComponent.Name))
    or(ContrastString(AComponent.Hint))
    or(ContrastString(AComponent.Caption));
end;

procedure TC4DSearchComponentsSearch.ContrastComponent(const AComponent: TButton);
begin
  FContrast := (ContrastString(AComponent.Name))
    or(ContrastString(AComponent.Hint))
    or(ContrastString(AComponent.Caption));
end;

procedure TC4DSearchComponentsSearch.ContrastComponent(const AComponent: TEdit);
begin
  if(AComponent.PasswordChar = #0)then
    FContrast := (ContrastString(AComponent.Name))
      or(ContrastString(AComponent.Hint))
      or(ContrastString(AComponent.Text));
end;

procedure TC4DSearchComponentsSearch.ContrastComponent(const AComponent: TDBEdit);
begin
  if(AComponent.PasswordChar = #0)then
    FContrast := (ContrastString(AComponent.Name))
      or(ContrastString(AComponent.Hint))
      or(ContrastString(AComponent.Text))
      or(ContrastString(AComponent.DataField));
end;

procedure TC4DSearchComponentsSearch.ContrastComponent(const AComponent: TRadioButton);
begin
  FContrast := (ContrastString(AComponent.Name))
    or(ContrastString(AComponent.Hint))
    or(ContrastString(AComponent.Caption));
end;

procedure TC4DSearchComponentsSearch.ContrastComponent(const AComponent: TCheckBox);
begin
  FContrast := (ContrastString(AComponent.Name))
    or(ContrastString(AComponent.Hint))
    or(ContrastString(AComponent.Caption));
end;

procedure TC4DSearchComponentsSearch.ContrastComponent(const AComponent: TDBCheckBox);
begin
  FContrast := (ContrastString(AComponent.Name))
    or(ContrastString(AComponent.Hint))
    or(ContrastString(AComponent.Caption))
    or(ContrastString(AComponent.DataField));
end;

end.
