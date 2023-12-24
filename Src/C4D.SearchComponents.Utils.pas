unit C4D.SearchComponents.Utils;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Types,
  Vcl.Graphics,
  Vcl.StdCtrls,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  DBCtrls;

type
  TUtils = class
  private
    class function PageIndexFromTabIndex(const pageControl: TPageControl; const TabIndex: Integer): Integer; static;
  public
    class procedure PageControlUniDrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
    class procedure DesmarcarPageControls(const AForm: TForm);
    class procedure ShapeInComponentON(const AForm: TForm; const AControl: TControl);
    class procedure ShapeInComponentOFF(const AForm: TForm; const AControl: TControl);
    class procedure ShapeInComponent(const AForm: TForm; const AControl: TControl; const AAddShape: Boolean);
    class procedure ContrastComponentsParents(const AComponent: TComponent);
    //class function StyleElementsContrast(const AContrast: Boolean; const AStyleElements: TStyleElements): TStyleElements;
    class function IfThenCor(const ACond: Boolean; const ACor1, ACor2: TColor): TColor;
    class function CompE(const ATxt: string; const ACompletador: string = '0'; const ATam: Integer = 6): string;
    class function RemoveAcento(AStr: string): string;
    class function GetColor(const AContrast: Boolean): TColor;
    class function GetColorDBEdit(const AContrast: Boolean; const ADBEdit: TDBEdit): TColor;
    class function GetColorDBMemo(const AContrast: Boolean; const ADBMemo: TDBMemo): TColor;
    class function GetColorEdit(const AContrast: Boolean; const AEdit: TEdit): TColor;
    class function GetColorMemo(const AContrast: Boolean; const AMemo: TMemo): TColor;
  end;

implementation

uses
  C4D.SearchComponents.Consts;

class procedure TUtils.PageControlUniDrawTab(Control: TCustomTabControl; TabIndex: Integer; const Rect: TRect; Active: Boolean);
var
  LPageControl: TPageControl;
  LTabSheet: TTabSheet;
begin
  LPageControl := (Control as TPageControl);

  LTabSheet := TTabSheet(LPageControl.Pages[Self.PageIndexFromTabIndex(LPageControl, TabIndex)]);
  if(not LTabSheet.TabVisible)then
    Exit;

  if(LTabSheet.Highlighted)then
    Control.Canvas.Brush.Color := clLime
  else
    Control.Canvas.Brush.Color := clBtnFace;

  Control.Canvas.FillRect(Rect);
  Control.Canvas.TextOut(Rect.Left + 5, Rect.Top + 4, LTabSheet.Caption);
end;


class function TUtils.PageIndexFromTabIndex(const pageControl: TPageControl; const TabIndex: Integer): Integer;
var
  i: Integer;
begin
  Result := TabIndex;
  for i := 0 to Pred(pageControl.PageCount) do
  begin
    if not pageControl.Pages[i].TabVisible then
      Inc(Result);

    if TabIndex = pageControl.Pages[i].TabIndex then
      break;
  end;
end;

class procedure TUtils.DesmarcarPageControls(const AForm: TForm);
var
  i: Integer;
  j: Integer;
  LComponente: TComponent;
  LPageControl: TPageControl;
begin
  for i := 0 to Pred(AForm.ComponentCount) do
  begin
    LComponente := AForm.Components[i];
    if(LComponente is TPageControl)then
    begin
      LPageControl := TPageControl(LComponente);
      LPageControl.StyleElements := LPageControl.StyleElements + [seClient];
      LPageControl.OwnerDraw := True;
      LPageControl.OnDrawTab := Self.PageControlUniDrawTab;

      for j := 0 to Pred(LPageControl.PageCount) do
        LPageControl.Pages[j].Highlighted := False;

      LPageControl.Repaint;
    end;
  end;
end;

class procedure TUtils.ShapeInComponent(const AForm: TForm; const AControl: TControl; const AAddShape: Boolean);
begin
  if(AControl is TTabSheet)or(AControl is TShape)then
    Exit;

  if(AAddShape)then
    Self.ShapeInComponentON(AForm, AControl)
  else
    Self.ShapeInComponentOFF(AForm, AControl);

  AControl.BringToFront;
  AControl.Repaint;
end;

class procedure TUtils.ShapeInComponentON(const AForm: TForm; const AControl: TControl);
var
  LShape: TShape;
  LName: string;
  LCompShape: TComponent;
  LLeft: Integer;
  LTop: Integer;
  LWidth: Integer;
  LHeight: Integer;
begin
  LLeft := AControl.Left - 2;
  LTop := AControl.Top - 2;
  LWidth := AControl.Width + 4;
  LHeight := AControl.Height + 4;

  try
    LName := C_PREFIX_NAME_SHAPE + AControl.Name;
    LCompShape := AForm.FindComponent(LName);
    if(LCompShape = nil)then
    begin
      LShape := TShape.Create(AForm);
      LShape.Left := LLeft;
      LShape.Top := LTop;
      LShape.Width := LWidth;
      LShape.Height := LHeight;
      LShape.Parent := AControl.Parent;
      LShape.Name := LName;
      LShape.Brush.Color := clLime;
    end
    else if(LCompShape is TShape)then
      TShape(LCompShape).Visible := True;
  except
    on E: Exception do
      raise Exception.Create('Ocorreu uma exceção ao destacar elemento da tela: ' + E.Message);
  end;
end;

class procedure TUtils.ShapeInComponentOFF(const AForm: TForm; const AControl: TControl);
var
  LName: string;
  LCompShape: TComponent;
begin
  LName := C_PREFIX_NAME_SHAPE + AControl.Name;
  LCompShape := AForm.FindComponent(LName);
  if(LCompShape <> nil)then
    if(LCompShape is TShape)then
      TShape(LCompShape).Visible := False;
end;

class procedure TUtils.ContrastComponentsParents(const AComponent: TComponent);
var
  LComponent: TComponent;
begin
  LComponent := AComponent;
  while(LComponent.ClassParent <> TForm)do
  begin
    if(LComponent is TTabSheet)then
      if(TTabSheet(LComponent).TabVisible)then
      begin
        TTabSheet(LComponent).Highlighted := True;
        TPageControl(TTabSheet(LComponent).Parent).StyleElements := TPageControl(TTabSheet(LComponent).Parent).StyleElements - [seClient];
      end;

    LComponent := TWinControl(LComponent).Parent;
  end;
end;

class function TUtils.IfThenCor(const ACond: Boolean; const ACor1, ACor2: TColor): TColor;
begin
  Result := ACor2;
  if(ACond)then
    Result := ACor1;
end;

class function TUtils.GetColor(const AContrast: Boolean): TColor;
begin
  Result := Self.IfThenCor(AContrast, C_COR_CONTRAST, C_COR_DEFAULT);
end;

class function TUtils.GetColorEdit(const AContrast: Boolean; const AEdit: TEdit): TColor;
begin
  Result := clWindow;
  if(AContrast)then
    Result := C_COR_CONTRAST
  else if(AEdit.ReadOnly)then
    Result := C_COR_DEFAULT;
end;

class function TUtils.GetColorDBEdit(const AContrast: Boolean; const ADBEdit: TDBEdit): TColor;
begin
  Result := clWindow;
  if(AContrast)then
    Result := C_COR_CONTRAST
  else if(ADBEdit.ReadOnly)then
    Result := C_COR_DEFAULT;
end;

class function TUtils.GetColorMemo(const AContrast: Boolean; const AMemo: TMemo): TColor;
begin
  Result := clWindow;
  if(AContrast)then
    Result := C_COR_CONTRAST
  else if(AMemo.ReadOnly)then
    Result := C_COR_DEFAULT;
end;

class function TUtils.GetColorDBMemo(const AContrast: Boolean; const ADBMemo: TDBMemo): TColor;
begin
  Result := clWindow;
  if(AContrast)then
    Result := C_COR_CONTRAST
  else if(ADBMemo.ReadOnly)then
    Result := C_COR_DEFAULT;
end;

class function TUtils.CompE(const ATxt: string; const ACompletador: string = '0'; const ATam: Integer = 6): string;
begin
  Result := ATxt;
  while(Length(Result) < ATam)do
    Result := ACompletador + Result;
end;

class function TUtils.RemoveAcento(AStr: string): string;
const
  COM_ACENTOS = 'àâêôûãõáéíóúçüÀÂÊÔÛÃÕÁÉÍÓÚÇÜ';
  SEM_ACENTOS = 'aaeouaoaeioucuAAEOUAOAEIOUCU';
var
  i: Integer;
begin
  for i := 1 to length(AStr) do
    if(Pos(AStr[i], COM_ACENTOS) <> 0)then
      AStr[i] := SEM_ACENTOS[Pos(AStr[i], COM_ACENTOS)];

  Result := AStr;
end;

end.
