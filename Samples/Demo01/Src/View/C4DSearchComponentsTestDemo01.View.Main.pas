unit C4DSearchComponentsTestDemo01.View.Main;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  Winapi.ShellAPI,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.DBCtrls,
  Vcl.Buttons,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Mask,
  Vcl.Themes,
  C4D.SearchComponents, Vcl.Imaging.pngimage;

type
  TC4DSearchComponentsTestDemo01ViewMain = class(TForm)
    Panel3: TPanel;
    pnBackLogoELinks: TPanel;
    pnBackLogo: TPanel;
    Image1: TImage;
    pnBackLinks: TPanel;
    lbYoutube: TLabel;
    lbGitHub: TLabel;
    lbTelegram: TLabel;
    Panel4: TPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label20: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    SpeedButton1: TSpeedButton;
    lbCountSearch: TLabel;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    GroupBox1: TGroupBox;
    GroupBoxCondicionaisImpreObsFixa: TGroupBox;
    DBMemoCondicionaisImpObsFixa: TDBMemo;
    RadioButton1: TRadioButton;
    DBCheckBox1: TDBCheckBox;
    CheckBox1: TCheckBox;
    Panel1: TPanel;
    Label4: TLabel;
    Panel2: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Button2: TButton;
    Edit3: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label7: TLabel;
    DBText1: TDBText;
    Button3: TButton;
    Edit4: TEdit;
    TabSheet2: TTabSheet;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    PageControl3: TPageControl;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    Label8: TLabel;
    TabSheet3: TTabSheet;
    Panel9: TPanel;
    DBRadioGroup2: TDBRadioGroup;
    dbEdtTrazer: TDBEdit;
    edtTrazer: TEdit;
    edtSearch: TEdit;
    Memo1: TMemo;
    Memo2: TMemo;
    DBLookupComboBox1: TDBLookupComboBox;
    cBoxThemes: TComboBox;
    Button4: TButton;
    btnSearch: TButton;
    BitBtn1: TBitBtn;
    lbSearch: TLabel;
    procedure btnSearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtSearchKeyPress(Sender: TObject; var Key: Char);
    procedure cBoxThemesClick(Sender: TObject);
    procedure lbYoutubeClick(Sender: TObject);
  private
    procedure DoTotalFoundForm(ATotal: Integer);
    procedure FillComboBoxThemes;
  public
  end;

var
  C4DSearchComponentsTestDemo01ViewMain: TC4DSearchComponentsTestDemo01ViewMain;

implementation

{$R *.dfm}

procedure TC4DSearchComponentsTestDemo01ViewMain.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  Self.FillComboBoxThemes;
end;

procedure TC4DSearchComponentsTestDemo01ViewMain.FillComboBoxThemes;
var
  LStyleName: string;
begin
  cBoxThemes.Items.BeginUpdate;
  try
    cBoxThemes.Items.Clear;

    for LStyleName in TStyleManager.StyleNames do
      cBoxThemes.Items.Add(LStyleName);

    cBoxThemes.Sorted := True;
    cBoxThemes.ItemIndex := cBoxThemes.Items.IndexOf(TStyleManager.ActiveStyle.Name);
  finally
    cBoxThemes.Items.EndUpdate;
  end;
end;

procedure TC4DSearchComponentsTestDemo01ViewMain.cBoxThemesClick(Sender: TObject);
begin
  if(Trim(cBoxThemes.Text).IsEmpty)then
    Exit;

  Application.ProcessMessages;
  TStyleManager.TrySetStyle(cBoxThemes.Text, False);
end;

procedure TC4DSearchComponentsTestDemo01ViewMain.btnSearchClick(Sender: TObject);
begin
  TC4DSearchComponents.New
    .FormSearch(Self)
    .StrSearch(edtSearch.Text)
    .OnTotalFoundForm(DoTotalFoundForm)
    .Search;
end;

procedure TC4DSearchComponentsTestDemo01ViewMain.DoTotalFoundForm(ATotal: Integer);
begin
  lbCountSearch.Caption := ATotal.ToString;
end;

procedure TC4DSearchComponentsTestDemo01ViewMain.edtSearchKeyPress(Sender: TObject; var Key: Char);
begin
  if(Key = #13)then
    btnSearch.Click;
end;

procedure TC4DSearchComponentsTestDemo01ViewMain.lbYoutubeClick(Sender: TObject);
begin
  ShellExecute(0, nil, PChar(TLabel(Sender).Caption), '', '', SW_ShowNormal);
end;

end.
