program C4DSearchComponentsTestDemo01;

uses
  Vcl.Forms,
  C4DSearchComponentsTestDemo01.View.Main in 'Src\View\C4DSearchComponentsTestDemo01.View.Main.pas' {C4DSearchComponentsTestDemo01ViewMain},
  C4D.SearchComponents.Interfaces in '..\..\Src\C4D.SearchComponents.Interfaces.pas',
  C4D.SearchComponents in '..\..\Src\C4D.SearchComponents.pas',
  C4D.SearchComponents.Search in '..\..\Src\C4D.SearchComponents.Search.pas',
  C4D.SearchComponents.Utils in '..\..\Src\C4D.SearchComponents.Utils.pas',
  C4D.SearchComponents.Consts in '..\..\Src\C4D.SearchComponents.Consts.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'C4D Search Components';
  Application.CreateForm(TC4DSearchComponentsTestDemo01ViewMain, C4DSearchComponentsTestDemo01ViewMain);
  Application.Run;
end.
