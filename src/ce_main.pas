unit ce_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, SynEditKeyCmds, SynHighlighterLFM, Forms,
  AnchorDocking, AnchorDockStorage, AnchorDockOptionsDlg, Controls, Graphics,
  Dialogs, Menus, ActnList, ExtCtrls, process, XMLPropStorage, ComCtrls,
  ce_common, ce_dmdwrap, ce_project, ce_synmemo, ce_widget, ce_messages,
  ce_editor, ce_projinspect, ce_projconf, ce_staticexplorer, ce_search, ce_miniexplorer;

type

  TCEMainForm = class;

  //TODO-cfeature: options
  //TODO-cwidget: options editor
  (**
   * Encapsulates the options in a writable component.
   *)
  TCEOptions = class(TComponent)
  private
    fFileMru, fProjMru: TMruFileList;
    fLeft, FTop, fWidth, fHeight: Integer;
    fErrorFlg: boolean;
    procedure setFileMru(aValue: TMruFileList);
    procedure setProjMru(aValue: TMruFileList);
    procedure saveLayout(str: TStream);
    procedure loadLayout(str: TStream);
    //
    procedure readerPropNoFound(Reader: TReader; Instance: TPersistent;
      var PropName: string; IsPath: boolean; var Handled, Skip: Boolean);
    procedure readerError(Reader: TReader; const Message: string;
      var Handled: Boolean);
  published
    property APP_Left: Integer read fLeft write fLeft;
    property APP_Top: Integer read fTop write fTop;
    property APP_Width: Integer read fWidth write fWidth;
    property APP_Height: Integer read fHeight write fHeight;
    //
    property MRU_Files: TMruFileList read fFileMru write setFileMru;
    property MRU_Projects: TMruFileList read fProjMru write setProjMru;
  public
    constructor create(aOwner: TComponent); override;
    destructor destroy; override;
    procedure defineProperties(Filer: TFiler); override;
    procedure saveToFile(const aFilename: string);
    procedure loadFromFile(const aFilename: string);
    procedure beforeSave;
    procedure afterLoad;
    //
    property hasLoaded: boolean read fErrorFlg;
  end;

  { TCEMainForm }
  TCEMainForm = class(TForm)
    actFileCompAndRun: TAction;
    actFileSaveAll: TAction;
    actFileClose: TAction;
    actFileAddToProj: TAction;
    actFileNewRun: TAction;
    actFileNew: TAction;
    actFileOpen: TAction;
    actFileSaveAs: TAction;
    actFileSave: TAction;
    actFileCompAndRunWithArgs: TAction;
    actEdFind: TAction;
    actEdFindNext: TAction;
    actProjOptView: TAction;
    actProjSource: TAction;
    actProjRun: TAction;
    actProjRunWithArgs: TAction;
    actProjCompile: TAction;
    actProjCompileAndRun: TAction;
    actProjCompAndRunWithArgs: TAction;
    actProjClose: TAction;
    actProjOpts: TAction;
    actProjNew: TAction;
    actProjOpen: TAction;
    actProjSave: TAction;
    actProjSaveAs: TAction;
    actEdMacPlay: TAction;
    actEdMacStartStop: TAction;
    actEdCut: TAction;
    actEdRedo: TAction;
    actEdUndo: TAction;
    actEdPaste: TAction;
    actEdCopy: TAction;
    actEdIndent: TAction;
    actEdUnIndent: TAction;
    Actions: TActionList;
    ApplicationProperties1: TApplicationProperties;
    imgList: TImageList;
    mainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    MenuItem18: TMenuItem;
    MenuItem19: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem20: TMenuItem;
    MenuItem21: TMenuItem;
    MenuItem22: TMenuItem;
    MenuItem23: TMenuItem;
    MenuItem24: TMenuItem;
    MenuItem25: TMenuItem;
    MenuItem26: TMenuItem;
    MenuItem27: TMenuItem;
    MenuItem28: TMenuItem;
    MenuItem29: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem30: TMenuItem;
    MenuItem31: TMenuItem;
    MenuItem32: TMenuItem;
    MenuItem33: TMenuItem;
    MenuItem34: TMenuItem;
    MenuItem35: TMenuItem;
    MenuItem36: TMenuItem;
    MenuItem37: TMenuItem;
    MenuItem38: TMenuItem;
    MenuItem39: TMenuItem;
    MenuItem40: TMenuItem;
    MenuItem41: TMenuItem;
    MenuItem42: TMenuItem;
    MenuItem43: TMenuItem;
    MenuItem44: TMenuItem;
    MenuItem45: TMenuItem;
    MenuItem46: TMenuItem;
    MenuItem47: TMenuItem;
    MenuItem48: TMenuItem;
    MenuItem49: TMenuItem;
    MenuItem50: TMenuItem;
    MenuItem51: TMenuItem;
    MenuItem52: TMenuItem;
    MenuItem53: TMenuItem;
    MenuItem54: TMenuItem;
    MenuItem55: TMenuItem;
    MenuItem56: TMenuItem;
    MenuItem57: TMenuItem;
    MenuItem58: TMenuItem;
    mnuItemMruFile: TMenuItem;
    mnuItemMruProj: TMenuItem;
    mnuItemWin: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    LfmSyn: TSynLFMSyn;
    procedure actEdFindExecute(Sender: TObject);
    procedure actEdFindNextExecute(Sender: TObject);
    procedure actFileAddToProjExecute(Sender: TObject);
    procedure actFileCloseExecute(Sender: TObject);
    procedure actFileCompAndRunExecute(Sender: TObject);
    procedure actFileCompAndRunWithArgsExecute(Sender: TObject);
    procedure actFileSaveAllExecute(Sender: TObject);
    procedure actEdIndentExecute(Sender: TObject);
    procedure actProjCompAndRunWithArgsExecute(Sender: TObject);
    procedure actProjCompileAndRunExecute(Sender: TObject);
    procedure actProjCompileExecute(Sender: TObject);
    procedure actEdCopyExecute(Sender: TObject);
    procedure actEdCutExecute(Sender: TObject);
    procedure ActionsUpdate(AAction: TBasicAction; var Handled: Boolean);
    procedure actEdMacPlayExecute(Sender: TObject);
    procedure actEdMacStartStopExecute(Sender: TObject);
    procedure actFileNewExecute(Sender: TObject);
    procedure actProjNewExecute(Sender: TObject);
    procedure actFileNewRunExecute(Sender: TObject);
    procedure actFileOpenExecute(Sender: TObject);
    procedure actProjOpenExecute(Sender: TObject);
    procedure actEdPasteExecute(Sender: TObject);
    procedure actProjCloseExecute(Sender: TObject);
    procedure actProjOptsExecute(Sender: TObject);
    procedure actEdRedoExecute(Sender: TObject);
    procedure actFileSaveAsExecute(Sender: TObject);
    procedure actFileSaveExecute(Sender: TObject);
    procedure actProjOptViewExecute(Sender: TObject);
    procedure actProjRunExecute(Sender: TObject);
    procedure actProjRunWithArgsExecute(Sender: TObject);
    procedure actProjSaveAsExecute(Sender: TObject);
    procedure actProjSaveExecute(Sender: TObject);
    procedure actEdUndoExecute(Sender: TObject);
    procedure actProjSourceExecute(Sender: TObject);
    procedure actEdUnIndentExecute(Sender: TObject);
    procedure ApplicationProperties1Exception(Sender: TObject; E: Exception);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormDropFiles(Sender: TObject; const FileNames: array of String);
  private
    fUpdateCount: NativeInt;
    fProject: TCEProject;
    fWidgList: TCEWidgetList;
    fMesgWidg: TCEMessagesWidget;
    fEditWidg: TCEEditorWidget;
    fProjWidg: TCEProjectInspectWidget;
    fPrjCfWidg: TCEProjectConfigurationWidget;
    fStExpWidg: TCEStaticExplorerWidget;
    fFindWidg:  TCESearchWidget;
    fExplWidg: TCEMiniExplorerWidget;
    fProjMru: TMruFileList;
    fFileMru: TMruFileList;

    //Init - Fina
    procedure InitMRUs;
    procedure InitWidgets;
    procedure InitDocking;
    procedure InitSettings;
    procedure SaveSettings;
    procedure SaveDocking;

    // widget interfaces subroutines
    procedure checkWidgetActions(const aWidget: TCEWidget);
    procedure widgetShowFromAction(sender: TObject);

    // run & exec sub routines
    procedure ProcessOutputToMsg(const aProcess: TProcess;aCtxt: TMessageContext = mcUnknown);
    procedure compileAndRunFile(const edIndex: NativeInt; const runArgs: string = '');
    procedure compileProject(const aProject: TCEProject);
    procedure runProject(const aProject: TCEProject; const runArgs: string = '');

    // file sub routines
    procedure newFile;
    function findFile(const aFilename: string): NativeInt;
    procedure saveFile(const edIndex: NativeInt);
    procedure saveFileAs(const edIndex: NativeInt; const aFilename: string);

    // project sub routines
    procedure saveProjSource(const aEditor: TCESynMemo);
    procedure projChange(sender: TObject);
    procedure newProj;
    procedure saveProj;
    procedure saveProjAs(const aFilename: string);
    procedure openProj(const aFilename: string);
    procedure closeProj;
    procedure addSource(const aFilename: string);

    // mru
    procedure mruChange(Sender: TObject);
    procedure mruFileItemClick(Sender: TObject);
    procedure mruProjItemClick(Sender: TObject);
    procedure mruClearClick(Sender: TObject);

  public
    constructor create(aOwner: TComponent); override;
    destructor destroy; override;
    procedure DockMasterCreateControl(Sender: TObject; aName: string; var
      AControl: TControl; DoDisableAutoSizing: boolean);
    //
    procedure openFile(const aFilename: string);
    procedure docChangeNotify(Sender: TObject; const aIndex: Integer);
    procedure docFocusedNotify(Sender: TObject; const aIndex: Integer);
    //
    property WidgetList: TCEWidgetList read fWidgList;
    property MessageWidget: TCEMessagesWidget read fMesgWidg;
    property EditWidget: TCEEditorWidget read fEditWidg;
    property ProjectWidget: TCEProjectInspectWidget read fProjWidg;
    property ProjectConfWidget: TCEProjectConfigurationWidget read fPrjCfWidg;
  end;

var
  CEMainForm: TCEMainForm;

implementation
{$R *.lfm}

uses
  SynMacroRecorder;

{$REGION Standard Comp/Obj------------------------------------------------------}
constructor TCEMainForm.create(aOwner: TComponent);
begin
  inherited create(aOwner);
  InitMRUs;
  InitWidgets;
  InitDocking;
  InitSettings;
  //
  newProj;
end;

procedure TCEMainForm.InitMRUs;
begin
  fProjMru := TMruFileList.Create;
  fFileMru := TMruFileList.Create;
  fProjMru.objectTag := mnuItemMruProj;
  fFileMru.objectTag := mnuItemMruFile;
  fProjMru.OnChange := @mruChange;
  fFileMru.OnChange := @mruChange;
end;

procedure TCEMainForm.InitWidgets;
var
  widg: TCEWidget;
  act: TAction;
  itm: TMenuItem;
begin
  fWidgList := TCEWidgetList.Create;
  fMesgWidg := TCEMessagesWidget.create(self);
  fEditWidg := TCEEditorWidget.create(self);
  fProjWidg := TCEProjectInspectWidget.create(self);
  fPrjCfWidg:= TCEProjectConfigurationWidget.create(self);
  fStExpWidg:= TCEStaticExplorerWidget.create(self);
  fFindWidg := TCESearchWidget.create(self);
  fExplWidg := TCEMiniExplorerWidget.create(self);

  fWidgList.addWidget(@fMesgWidg);
  fWidgList.addWidget(@fEditWidg);
  fWidgList.addWidget(@fProjWidg);
  fWidgList.addWidget(@fPrjCfWidg);
  fWidgList.addWidget(@fStExpWidg);
  fWidgList.addWidget(@fFindWidg);
  fWidgList.addWidget(@fExplWidg);

  for widg in fWidgList do
  begin
    act := TAction.Create(self);
    act.Category := 'Window';
    act.Caption := widg.Caption;
    act.OnExecute := @widgetShowFromAction;
    act.Tag := ptrInt(widg);
    act.ImageIndex := 25;
    itm := TMenuItem.Create(self);
    itm.Action := act;
    itm.Tag := ptrInt(widg);
    mnuItemWin.Add(itm);
  end;
end;

procedure TCEMainForm.InitDocking;
var
  i: NativeInt;
  aManager: TAnchorDockManager;
begin
  DockMaster.MakeDockSite(Self, [akBottom], admrpChild);
  DockMaster.OnCreateControl := @DockMasterCreateControl;
  DockMaster.OnShowOptions := @ShowAnchorDockOptions;
  DockMaster.HeaderStyle := adhsPoints;

  if DockManager is TAnchorDockManager then begin
    aManager:=TAnchorDockManager(DockManager);
    aManager.PreferredSiteSizeAsSiteMinimum:=false;
  end;
  Height := 0;

    for i := 0 to fWidgList.Count-1 do
  begin
    DockMaster.MakeDockable(fWidgList.widget[i],true);
    DockMaster.GetAnchorSite(fWidgList.widget[i]).Header.HeaderPosition := adlhpTop;
  end;

  DockMaster.ManualDock(DockMaster.GetAnchorSite(fEditWidg), Self, alBottom);
  DockMaster.ManualDock(DockMaster.GetAnchorSite(fMesgWidg), Self, alBottom);
  DockMaster.ManualDock(DockMaster.GetAnchorSite(fStExpWidg), Self, alLeft);
  DockMaster.ManualDock(DockMaster.GetAnchorSite(fFindWidg),
    DockMaster.GetAnchorSite(fStExpWidg), alBottom, fStExpWidg);
  width := width - fProjWidg.Width;
  DockMaster.ManualDock(DockMaster.GetAnchorSite(fProjWidg), Self, alRight);
  DockMaster.ManualDock(DockMaster.GetAnchorSite(fPrjCfWidg),
    DockMaster.GetAnchorSite(fProjWidg), alBottom, fProjWidg);
  DockMaster.GetAnchorSite(fEditWidg).Header.HeaderPosition := adlhpTop;

  DockMaster.GetAnchorSite(fExplWidg).Close;
end;

procedure TCEMainForm.InitSettings;
var
  fname1: string;
  fname2: string;
  opts: TCEOptions;
begin
  fname1 := getDocPath + 'options.txt';
  fname2 := getDocPath + 'options.bak';
  opts := TCEOptions.create(nil);
  try
    if fileExists(fname1) then
    begin
      opts.loadFromFile(fname1);
      if opts.hasLoaded then
      begin
        if fileExists(fname2) then
          deleteFile(fname2);
        if not fileExists(fname2) then
          copyFile(fname1, fname2, false);
      end;
    end;
  finally
    opts.Free;
  end;
end;

procedure TCEMainForm.SaveSettings;
var
  opts: TCEOptions;
begin
  opts := TCEOptions.create(nil);
  try
    forceDirectory(getDocPath);
    opts.saveToFile(getDocPath + 'options.txt');
  finally
    opts.Free;
  end;
end;

procedure TCEMainForm.SaveDocking;
var
  xcfg: TXMLConfigStorage;
begin
  xcfg := TXMLConfigStorage.Create(getDocPath + 'docking.xml',false);
  try
    // <Item1 Name="CEMainForm" Type="CustomSite" ChildCount="..."> is always missing
    DockMaster.SaveLayoutToConfig(xcfg);
    xcfg.WriteToDisk;
  finally
    xcfg.Free;
  end;
end;

destructor TCEMainForm.destroy;
begin
  SaveSettings;
  SaveDocking;
  //
  fWidgList.Free;
  fProjMru.Free;
  fFileMru.Free;
  fProject.Free;
  //
  inherited;
end;

procedure TCEMainForm.ApplicationProperties1Exception(Sender: TObject;E: Exception);
begin
  if fMesgWidg = nil then
    ce_common.dlgOkError(E.Message)
  else fMesgWidg.addCeErr(E.Message);
end;

procedure TCEMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  i: NativeInt;
  ed: TCESynMemo;
begin
  canClose := false;
  if fProject <> nil then if fProject.modified then
    if ce_common.dlgOkCancel('last project modifications are not saved, quit anyway ?')
        <> mrOK then exit;
  for i := 0 to fEditWidg.editorCount-1 do
  begin
    ed := fEditWidg.editor[i];
    if ed.modified then if ce_common.dlgOkCancel(format
      ('last "%s" modifications are not saved, quit anyway ?',
        [shortenPath(ed.fileName, 25)])) <> mrOK then exit;
  end;
  canClose := true;
end;

procedure TCEMainForm.ActionsUpdate(AAction: TBasicAction; var Handled: Boolean);
var
  curr: TCESynMemo;
  hasEd: boolean;
  hasProj: boolean;
begin
  if fEditWidg = nil then exit;
  if fUpdateCount > 0 then exit;
  Inc(fUpdateCount);
  try
    curr := fEditWidg.currentEditor;
    hasEd := curr <> nil;
    if hasEd then
    begin
      actEdCopy.Enabled := curr.SelAvail and fEditWidg.Focused;     // allows copy/cut/paste by shortcut on widgets
      actEdCut.Enabled := curr.SelAvail and fEditWidg.Focused;      //
      actEdPaste.Enabled := curr.CanPaste and fEditWidg.Focused;
      {$IFDEF MSWINDOWS}
      // close file : raises a segfault on linux UndoStuff.>>fList<<.Count...
      actEdUndo.Enabled := curr.CanUndo;
      actEdRedo.Enabled := curr.CanRedo;
      {$ENDIF}
      actEdMacPlay.Enabled := true;
      actEdMacStartStop.Enabled := true;
      actEdIndent.Enabled := true;
      actEdUnIndent.Enabled := true;
      //
      actFileCompAndRun.Enabled := curr.isDSource;
      actFileCompAndRunWithArgs.Enabled := curr.isDSource;
      actFileSave.Enabled := true;
      actFileSaveAs.Enabled := true;
      actFileClose.Enabled := true;
      actFileSaveAll.Enabled := true;
    end
    else begin
      actEdCopy.Enabled := false;
      actEdCut.Enabled := false ;
      actEdPaste.Enabled := false;
      {$IFDEF MSWINDOWS}
      actEdUndo.Enabled := false;
      actEdRedo.Enabled := false;
      {$ENDIF}
      actEdMacPlay.Enabled := false;
      actEdMacStartStop.Enabled := false;
      actEdIndent.Enabled := false;
      actEdUnIndent.Enabled := false;
      //
      actFileCompAndRun.Enabled := false;
      actFileCompAndRunWithArgs.Enabled := false;
      actFileSave.Enabled := false;
      actFileSaveAs.Enabled := false;
      actFileClose.Enabled := false;
      actFileSaveAll.Enabled := false;
    end;

    hasProj := fProject <> nil;
    actProjSave.Enabled := hasProj;
    actProjSaveAs.Enabled := hasProj;
    actProjOpts.Enabled := hasProj;
    actProjClose.Enabled := hasProj;
    actProjCompile.Enabled := hasProj;
    actProjCompileAndRun.Enabled := hasProj;
    actProjCompAndRunWithArgs.Enabled := hasProj;
    actProjRun.Enabled := hasProj;
    actProjRunWithArgs.Enabled := hasProj;
    actProjSource.Enabled := hasProj;
    actProjOptView.Enabled := hasProj;

    actFileAddToProj.Enabled := hasEd and hasProj;

  finally
    Dec(fUpdateCount);
  end;
end;

procedure TCEMainForm.checkWidgetActions(const aWidget: TCEWidget);
var
  tlt: string;
  cnt, i: NativeInt;
  prt, itm: TMenuItem;
begin
  tlt := aWidget.contextName;
  if tlt = '' then exit;
  cnt := aWidget.contextActionCount;
  if cnt = 0 then exit;
  //
  prt := TMenuItem.Create(self);
  prt.Caption := tlt;
  mainMenu.Items.Add(prt);
  for i := 0 to cnt-1 do
  begin
    itm := TMenuItem.Create(prt);
    itm.Action := aWidget.contextAction(i);
    prt.Add(itm);
  end;
end;

procedure TCEMainForm.mruChange(Sender: TObject);
var
  srcLst: TMruFileList;
  trgMnu: TMenuItem;
  itm: TMenuItem;
  fname: string;
  clickTrg: TNotifyEvent;
begin
  srcLst := TMruFileList(Sender);
  if srcLst = nil then exit;
  trgMnu := TMenuItem(srcLst.objectTag);
  if trgMnu = nil then exit;

  if fUpdateCount > 0 then exit;
  Inc(fUpdateCount);
  try
    if srcLst = fFileMru then
      clickTrg := @mruFileItemClick
    else if srcLst = fProjMru then
      clickTrg := @mruProjItemClick;

    trgMnu.Clear;

    itm := TMenuItem.Create(trgMnu);
    itm.Caption := 'Clear';
    itm.OnClick := @mruClearClick;
    itm.Tag := PtrInt(srcLst);
    trgMnu.Add(itm);
    trgMnu.AddSeparator;

    for fname in srcLst do
    begin
      itm := TMenuItem.Create(trgMnu);
      itm.Hint := fname;
      itm.Caption := shortenPath(fname, 50);
      itm.OnClick := clickTrg;
      trgMnu.Add(itm);
    end;

  finally
    Dec(fUpdateCount);
  end;
end;

procedure TCEMainForm.mruClearClick(Sender: TObject);
var
  srcLst: TMruFileList;
begin
  srcLst := TMruFileList(TmenuItem(Sender).Tag);
  if srcLst = nil then exit;
  //
  srcLst.Clear;
end;
{$ENDREGION}

{$REGION file ------------------------------------------------------------------}
procedure TCEMainForm.newFile;
begin
  if fEditWidg = nil then exit;
  fEditWidg.addEditor;
  fEditWidg.focusedEditorChanged;
end;

function TCEMainForm.findFile(const aFilename: string): NativeInt;
var
  i: NativeInt;
begin
  result := -1;
  if fEditWidg = nil then exit;
  for i := 0 to fEditWidg.editorCount-1 do
    if fEditWidg.editor[i].fileName = aFilename then exit(i);
end;

procedure TCEMainForm.openFile(const aFilename: string);
var
  i: NativeInt;
begin
  if fEditWidg = nil then exit;
  //
  i := findFile(aFilename);
  if i > -1 then
  begin
    fEditWidg.PageControl.PageIndex := i;
    exit;
  end;
  i := fEditWidg.editorCount;
  fEditWidg.addEditor;
  fEditWidg.editor[i].loadFromFile(aFilename);
  fEditWidg.focusedEditorChanged;
  fFileMru.Insert(0,aFilename);
end;

procedure TCEMainForm.saveFile(const edIndex: NativeInt);
var
  str: string;
  i: NativeInt;
begin
  if fEditWidg = nil then exit;
  if edIndex >= fEditWidg.editorCount then exit;
  //
  if fEditWidg.editor[edIndex].Highlighter = LfmSyn then
  begin
    saveProjSource(fEditWidg.editor[edIndex]);
    exit;
  end;
  //
  str := fEditWidg.editor[edIndex].fileName;
  if str = '' then exit;
  fEditWidg.editor[edIndex].save;
  //
  for i := 0 to fWidgList.Count-1 do
    fWidgList.widget[i].docChanged(fEditWidg.editor[edIndex]);
end;

procedure TCEMainForm.saveFileAs(const edIndex: NativeInt; const aFilename: string);
begin
  if fEditWidg = nil then exit;
  if edIndex < 0 then exit;
  if edIndex >= fEditWidg.editorCount then exit;
  //
  fEditWidg.editor[edIndex].saveToFile(aFilename);
  fFileMru.Insert(0, aFilename);
end;

procedure TCEMainForm.docChangeNotify(Sender: TObject; const aIndex: Integer);
var
  i: NativeInt;
begin
  for i := 0 to fWidgList.Count-1 do
    if fWidgList.widget[i] <> Sender then
      fWidgList.widget[i].docChanged(fEditWidg.editor[aIndex]);
end;

procedure TCEMainForm.docFocusedNotify(Sender: TObject; const aIndex: Integer);
var
  i: NativeInt;
begin
  for i := 0 to fWidgList.Count-1 do
    if fWidgList.widget[i] <> Sender then
      fWidgList.widget[i].docFocused(fEditWidg.editor[aIndex]);
end;

procedure TCEMainForm.mruFileItemClick(Sender: TObject);
begin
  openFile(TMenuItem(Sender).Hint);
end;

procedure TCEMainForm.actFileOpenExecute(Sender: TObject);
begin
  if fEditWidg = nil then exit;
  //
  with TOpenDialog.Create(nil) do
  try
    filter := DdiagFilter;
    if execute then
    begin
      openFile(filename);
    end;
  finally
    free;
  end;
end;

procedure TCEMainForm.actFileNewExecute(Sender: TObject);
begin
  newFile;
end;

procedure TCEMainForm.actFileNewRunExecute(Sender: TObject);
begin
  newFile;
  fEditWidg.currentEditor.Text :=
  'module runnable;' + LineEnding +
  '' + LineEnding +
  'import std.stdio;' + LineEnding +
  '' + LineEnding +
  'void main(string args[])' + LineEnding +
  '{' + LineEnding +
  '    writeln("this is just a `toy feature`");' + LineEnding +
  '    writeln;' + LineEnding +
  '    writeln("coedit saves a temp d module before compiling it and running it...");' + LineEnding +
  '}';
end;

procedure TCEMainForm.actFileSaveAsExecute(Sender: TObject);
begin
  if fEditWidg = nil then exit;
  if fEditWidg.editorIndex < 0 then exit;
  //
  with TSaveDialog.Create(nil) do
  try
    Filter := DdiagFilter;
    if execute then
      saveFileAs(fEditWidg.editorIndex, filename);
  finally
    free;
  end;
end;

procedure TCEMainForm.actFileSaveExecute(Sender: TObject);
var
  str: string;
begin
  if fEditWidg = nil then exit;
  if fEditWidg.editorIndex < 0 then exit;
  //
  str := fEditWidg.editor[fEditWidg.editorIndex].fileName;
  if fileExists(str) then saveFile(fEditWidg.editorIndex)
  else actFileSaveAs.Execute;
end;

procedure TCEMainForm.actFileAddToProjExecute(Sender: TObject);
var
  str: string;
begin
  if fEditWidg = nil then exit;
  if fEditWidg.editorIndex < 0 then exit;
  if fEditWidg.editor[fEditWidg.editorIndex].isProjectSource
    then exit;
  //
  str := fEditWidg.editor[fEditWidg.editorIndex].fileName;
  if fileExists(str) then fProject.addSource(str)
  else dlgOkInfo('the file has not been added to the project because it does not exist');
end;

procedure TCEMainForm.actFileCloseExecute(Sender: TObject);
var
  curr: TCESynMemo;
  i: NativeInt;
begin
  curr := fEditWidg.currentEditor;
  if curr.modified then if dlgOkCancel(
      'The latest mdofifications are not saved, continue ?') = mrCancel
      then exit;
  //
  for i := 0 to fWidgList.Count-1 do
    fWidgList.widget[i].docClose(fEditWidg.editor[fEditWidg.editorIndex]);
  //
  fEditWidg.removeEditor(fEditWidg.editorIndex);
end;

procedure TCEMainForm.actFileSaveAllExecute(Sender: TObject);
var
  i: NativeInt;
begin
  for i:= 0 to fEditWidg.editorCount-1 do saveFile(i);
end;

procedure TCEMainForm.FormDropFiles(Sender: TObject;const FileNames: array of String);
var
  fname: string;
begin
  for fname in FileNames do
    openFile(fname);
end;
{$ENDREGION}

{$REGION edit ------------------------------------------------------------------}
procedure TCEMainForm.actEdCopyExecute(Sender: TObject);
var
  curr: TCESynMemo;
begin
  curr := fEditWidg.currentEditor;
  if assigned(curr) then curr.CopyToClipboard;
end;

procedure TCEMainForm.actEdCutExecute(Sender: TObject);
var
  curr: TCESynMemo;
begin
  curr := fEditWidg.currentEditor;
  if assigned(curr) then curr.CutToClipboard;
end;

procedure TCEMainForm.actEdPasteExecute(Sender: TObject);
var
  curr: TCESynMemo;
begin
  curr := fEditWidg.currentEditor;
  if assigned(curr) then curr.PasteFromClipboard;
end;

procedure TCEMainForm.actEdUndoExecute(Sender: TObject);
var
  curr: TCESynMemo;
begin
  curr := fEditWidg.currentEditor;
  if assigned(curr) then curr.Undo;
end;

procedure TCEMainForm.actEdRedoExecute(Sender: TObject);
var
  curr: TCESynMemo;
begin
  curr := fEditWidg.currentEditor;
  if assigned(curr) then curr.Redo;
end;

procedure TCEMainForm.actEdMacPlayExecute(Sender: TObject);
var
  curr: TCESynMemo;
begin
  curr := fEditWidg.currentEditor;
  if assigned(curr) then fEditWidg.macRecorder.PlaybackMacro(curr);
end;

procedure TCEMainForm.actEdMacStartStopExecute(Sender: TObject);
var
  curr: TCESynMemo;
begin
  curr := fEditWidg.currentEditor;
  if assigned(curr) then
  begin
    if fEditWidg.macRecorder.State = msRecording then
      fEditWidg.macRecorder.Stop
    else fEditWidg.macRecorder.RecordMacro(curr);
  end;
end;

procedure TCEMainForm.actEdIndentExecute(Sender: TObject);
var
  curr: TCESynMemo;
begin
  curr := fEditWidg.currentEditor;
  if assigned(curr) then curr.ExecuteCommand(ecBlockIndent, '', nil);
end;

procedure TCEMainForm.actEdUnIndentExecute(Sender: TObject);
var
  curr: TCESynMemo;
begin
  curr := fEditWidg.currentEditor;
  if assigned(curr) then curr.ExecuteCommand(ecBlockUnIndent, '', nil);
end;

procedure TCEMainForm.actEdFindExecute(Sender: TObject);
var
  win: TAnchorDockHostSite;
  ed: TCESynMemo;
  str: string;
begin
  win := DockMaster.GetAnchorSite(fFindWidg);
  if win = nil then exit;
  win.Show;
  win.BringToFront;
  ed := fEditWidg.currentEditor;
  if ed = nil then exit;
  if ed.SelAvail then
    str := ed.SelText
  else str := ed.Identifier;
  ffindwidg.cbToFind.Text := str;
  ffindwidg.cbToFindChange(nil);
end;

procedure TCEMainForm.actEdFindNextExecute(Sender: TObject);
begin
  ffindwidg.actFindNextExecute(nil);
end;

{$ENDREGION}

{$REGION run -------------------------------------------------------------------}
procedure TCEMainForm.ProcessOutputToMsg(const aProcess: TProcess; aCtxt: TMessageContext = mcUnknown);
var
  str: TMemoryStream;
  lns: TStringList;
  readCnt: LongInt;
  readSz: LongInt;
  ioBuffSz: LongInt;
  dt: PMessageItemData;
  msg: string;
begin
  If not (poUsePipes in aProcess.Options) then exit;
  //
  ioBuffSz := aProcess.PipeBufferSize;
  str := TMemorystream.Create;
  lns := TStringList.Create;
  readSz := 0;
  try
    while true do
    begin
      str.SetSize(readSz + ioBuffSz);
      readCnt := aProcess.Output.Read((str.Memory + readSz)^, ioBuffSz);
      if readCnt = 0 then break;
      Inc(readSz, readCnt);
    end;
    Str.SetSize(readSz);
    lns.LoadFromStream(Str);
    for msg in lns do begin
      fMesgWidg.addMessage(msg, aCtxt);
      dt := newMessageData;
      dt^.ctxt := aCtxt;
      dt^.position := getLineFromDmdMessage(msg);
      dt^.editor := getFileFromDmdMessage(msg);
      if dt^.editor = nil then
        dt^.editor := EditWidget.currentEditor;
    end;
  finally
    str.Free;
    lns.Free;
    fMesgWidg.scrollToBack;
  end;
end;

// TODO-cfeature: input handling
procedure TCEMainForm.compileAndRunFile(const edIndex: NativeInt; const runArgs: string = '');
var
  dmdproc: TProcess;
  runproc: TProcess;
  fname, temppath, olddir: string;
begin
  olddir  := '';
  dmdproc := TProcess.Create(nil);
  runproc := TProcess.Create(nil);
  getDir(0, olddir);
  try

    fMesgWidg.addCeInf( 'compiling ' + fEditWidg.editor[edIndex].fileName, mcEditor );

    temppath := GetTempDir(false);
    chDir(temppath);
    {$IFDEF DEBUG}{$WARNINGS OFF}{$HINTS OFF}{$ENDIF}
    fname := temppath + 'temp_' + uniqueObjStr(dmdProc);
    {$IFDEF DEBUG}{$WARNINGS ON}{$HINTS ON}{$ENDIF}
    fEditWidg.editor[edIndex].Lines.SaveToFile(fname + '.d');

    {$IFDEF RELEASE}
    dmdProc.ShowWindow := swoHIDE;
    {$ENDIF}
    dmdproc.Options := [poStdErrToOutput, poUsePipes];
    dmdproc.Executable := DCompiler;
    dmdproc.Parameters.Add(fname + '.d');
    dmdproc.Parameters.Add('-w');
    dmdproc.Parameters.Add('-wi');
    try
      dmdproc.Execute;
      while dmdproc.Running do if dmdproc.ExitStatus <> 0 then break;
    finally
      ProcessOutputToMsg(dmdproc, mcEditor);
    end;

    {$IFDEF MSWINDOWS}
    if (dmdProc.ExitStatus = 0) or (dmdProc.ExitStatus = 259) then
    {$ELSE}
    if dmdProc.ExitStatus = 0 then
    {$ENDIF}
    begin

      fMesgWidg.addCeInf( fEditWidg.editor[edIndex].fileName
        + ' successfully compiled', mcEditor );

      runproc.Options:= [poStderrToOutPut, poUsePipes];
      {$IFDEF MSWINDOWS}
      runproc.Executable := fname + '.exe';
      runproc.CurrentDirectory := extractFilePath(runProc.Executable);
      runproc.Parameters.Text := runArgs;
      {$ELSE}
      runproc.Executable := fname;
      {$ENDIF}
      try
        runproc.Execute;
        while runproc.Running do if runproc.ExitStatus <> 0 then break;
        ProcessOutputToMsg(runproc, mcEditor);
      finally
      {$IFDEF MSWINDOWS}
      DeleteFile(fname + '.exe');
      DeleteFile(fname + '.obj');
      {$ELSE}
      DeleteFile(fname);
      DeleteFile(fname + '.o');
      {$ENDIF}
      end;
    end
    else
      fMesgWidg.addCeErr( fEditWidg.editor[edIndex].fileName
        + ' has not been compiled', mcEditor );

  finally
    dmdproc.Free;
    runproc.Free;
    DeleteFile(fname + '.d');
    chDir(olddir);
  end;
end;

procedure TCEMainForm.compileProject(const aProject: TCEProject);
var
  dmdproc: TProcess;
  ppproc: TProcess;
  olddir, prjpath: string;
  i: NativeInt;
begin

  fMesgWidg.ClearMessages(mcProject);

  for i := 0 to fWidgList.Count-1 do
    fWidgList.widget[i].projCompile(aProject);

  if aProject.Sources.Count = 0 then
  begin
    fMesgWidg.addCeErr( aProject.fileName + ' has no source files', mcProject);
    exit;
  end;

  with fProject.currentConfiguration do
  begin
    if preBuildProcess.executable <> '' then
      if fileExists(preBuildProcess.Executable) then
      begin
        ppproc := TProcess.Create(nil);
        try
          preBuildProcess.setProcess(ppproc);
          if ppproc.CurrentDirectory = '' then
            ppproc.CurrentDirectory := extractFilePath(ppproc.Executable);
          ppproc.Execute;
        finally
          ppproc.Free;
        end;
      end
      else fMesgWidg.addCeWarn('the pre-compilation executable does not exist', mcProject);
  end;

  olddir := '';
  dmdproc := TProcess.Create(nil);
  getDir(0, olddir);
  try


    fMesgWidg.addCeInf( 'compiling ' + aProject.fileName, mcProject);
    application.ProcessMessages;

    prjpath := extractFilePath(aProject.fileName);
    if directoryExists(prjpath) then chDir(prjpath);

    {$IFDEF RELEASE}
    dmdProc.ShowWindow := swoHIDE;
    {$ENDIF}
    dmdproc.Options := [{$IFDEF WINDOWS}poNewConsole,{$ENDIF} poStdErrToOutput, poUsePipes];

    dmdproc.Executable := DCompiler;
    aProject.getOpts(dmdproc.Parameters);
    try
      dmdproc.Execute;
      while dmdproc.Running do if dmdproc.ExitStatus <> 0 then break;
      ProcessOutputToMsg(dmdproc, mcProject);
    finally
      {$IFDEF MSWINDOWS} //  STILL_ACTIVE ambiguity
      if (dmdProc.ExitStatus = 0) or (dmdProc.ExitStatus = 259) then
      {$ELSE}
      if dmdProc.ExitStatus = 0 then
      {$ENDIF}
        fMesgWidg.addCeInf( aProject.fileName
          + ' successfully compiled', mcProject)
      else
        fMesgWidg.addCeErr( aProject.fileName
          + ' has not been compiled', mcProject);
    end;

    with fProject.currentConfiguration do
    begin
      if postBuildProcess.executable <> '' then
        if fileExists(postBuildProcess.Executable) then
        begin
          ppproc := TProcess.Create(nil);
          try
            postBuildProcess.setProcess(ppproc);
            if ppproc.CurrentDirectory = '' then
              ppproc.CurrentDirectory := extractFilePath(ppproc.Executable);
            ppproc.Execute;
          finally
            ppproc.Free;
          end;
        end
        else fMesgWidg.addCeWarn('the post-compilation executable does not exist', mcProject);
    end;

  finally
    dmdproc.Free;
    chDir(olddir);
  end;
end;

procedure TCEMainForm.runProject(const aProject: TCEProject; const runArgs: string = '');
var
  runproc: TProcess;
  procname: string;
  i: NativeInt;
begin
  if aProject.currentConfiguration.outputOptions.binaryKind <>
    executable then exit;

  for i := 0 to fWidgList.Count-1 do
    fWidgList.widget[i].projRun(aProject);

  runproc := TProcess.Create(nil);
  try
    aProject.currentConfiguration.runOptions.setProcess(runProc);
    runproc.Parameters.AddText(runArgs);
    procname := aProject.currentConfiguration.pathsOptions.outputFilename;
    if procname <> '' then procname := aProject.getAbsoluteFilename(procname)
    else if aProject.Sources.Count > 0 then
    begin
      procname := extractFilename(aProject.Sources.Strings[0]);
      procname := procname[1..length(procname)-2];
      procname := extractFilePath(aProject.fileName) +
        DirectorySeparator + procname;
      {$IFDEF MSWINDOWS}
      procname += '.exe';
      {$ENDIF}
    end;

    if not fileExists(procname) then
    begin
      fMesgWidg.addCeErr('output executable missing: ' + procname, mcProject);
      exit;
    end;

    runproc.Executable := procname;
    if runproc.CurrentDirectory = '' then
      runproc.CurrentDirectory := extractFilePath(runproc.Executable);
    runproc.Execute;
    while runproc.Running do if runproc.ExitStatus <> 0 then break;
    ProcessOutputToMsg(runproc, mcProject);

  finally
    runproc.Free;
  end;

end;

procedure TCEMainForm.actFileCompAndRunExecute(Sender: TObject);
begin
  if fEditWidg = nil then exit;
  if fEditWidg.editorIndex < 0 then exit;
  //
  compileAndRunFile(fEditWidg.editorIndex);
end;

procedure TCEMainForm.actFileCompAndRunWithArgsExecute(Sender: TObject);
var
  runargs: string;
begin
  if fEditWidg = nil then exit;
  if fEditWidg.editorIndex < 0 then exit;
  //
  runargs := '';
  if InputQuery('Execution arguments', '', runargs) then
    compileAndRunFile(fEditWidg.editorIndex, runargs);
end;

procedure TCEMainForm.actProjCompileExecute(Sender: TObject);
begin
  compileProject(fProject);
end;

procedure TCEMainForm.actProjCompileAndRunExecute(Sender: TObject);
begin
  compileProject(fProject);
  runProject(fProject);
end;

procedure TCEMainForm.actProjCompAndRunWithArgsExecute(Sender: TObject);
var
  runargs: string;
begin
  compileProject(fProject);
  //
  runargs := '';
  if InputQuery('Execution arguments', '', runargs) then
    runProject(fProject, runargs);
end;

procedure TCEMainForm.actProjRunExecute(Sender: TObject);
begin
  runProject(fProject);
end;

procedure TCEMainForm.actProjRunWithArgsExecute(Sender: TObject);
var
  runargs: string;
begin
  runargs := '';
  if InputQuery('Execution arguments', '', runargs) then
    runProject(fProject, runargs);
end;
{$ENDREGION}

{$REGION view ------------------------------------------------------------------}
procedure TCEMainForm.widgetShowFromAction(sender: TObject);
var
  widg: TCEWidget;
  win: TControl;
begin
  widg := TCEWidget( TComponent(sender).tag );
  if widg = nil then exit;
  win := DockMaster.GetAnchorSite(widg);
  if win = nil then exit;
  win.Show;
  win.BringToFront;
end;

procedure TCEMainForm.DockMasterCreateControl(Sender: TObject; aName: string; var
  AControl: TControl; DoDisableAutoSizing: boolean);
var
  i: NativeInt;
begin
  for i := 0 to fWidgList.Count-1 do if fWidgList.widget[i].Name = aName then
  begin
    AControl := fWidgList.widget[i];
    if DoDisableAutoSizing then AControl.DisableAutoSizing;
  end;
end;
{$ENDREGION}

{$REGION project ---------------------------------------------------------------}
procedure TCEMainForm.projChange(sender: TObject);
var
  widg: TCEWidget;
begin
  for widg in WidgetList do
    widg.projChange(fProject);
end;

procedure TCEMainForm.saveProjSource(const aEditor: TCESynMemo);
begin
  if fProject = nil then exit;
  if fProject.fileName <> aEditor.fileName then exit;
  //
  aEditor.saveToFile(fProject.fileName);
  openProj(fProject.fileName);
end;

procedure TCEMainForm.closeProj;
var
  widg: TCEWidget;
begin
  for widg in WidgetList do widg.projClose(fProject);
  fProject.Free;
  fProject := nil;
end;

procedure TCEMainForm.newProj;
var
  widg: TCEWidget;
begin
  fProject := TCEProject.Create(nil);
  fProject.Name := 'CurrentProject';
  for widg in WidgetList do widg.projNew(fProject);
  fProject.onChange := @projChange;
end;

procedure TCEMainForm.saveProj;
begin
  fProject.saveToFile(fProject.fileName);
end;

procedure TCEMainForm.saveProjAs(const aFilename: string);
begin
  fProject.fileName := aFilename;
  fProject.saveToFile(fProject.fileName);
  fProjMru.Insert(0,fProject.fileName);
end;

procedure TCEMainForm.openProj(const aFilename: string);
begin
  closeProj;
  newProj;
  fProject.loadFromFile(aFilename);
  fProjMru.Insert(0,aFilename);
end;

procedure TCEMainForm.mruProjItemClick(Sender: TObject);
begin
  openProj(TMenuItem(Sender).Hint);
end;

procedure TCEMainForm.actProjNewExecute(Sender: TObject);
begin
  if fProject <> nil then if fProject.modified then if dlgOkCancel(
    'The latest mdofifications are not saved, continue ?')
      = mrCancel then exit;

  closeProj;
  newProj;
end;

procedure TCEMainForm.actProjCloseExecute(Sender: TObject);
begin
  if fProject = nil then exit;
  if fProject.modified then if dlgOkCancel(
    'The latest mdofifications are not saved, continue ?')
      = mrCancel then exit;

  closeProj;
end;

procedure TCEMainForm.addSource(const aFilename: string);
begin
  if fProject.Sources.IndexOf(aFilename) >= 0 then exit;
  fProject.addSource(aFilename);
end;

procedure TCEMainForm.actProjSaveAsExecute(Sender: TObject);
begin
  with TSaveDialog.Create(nil) do
  try
    if execute then saveProjAs(filename);
  finally
    Free;
  end;
end;

procedure TCEMainForm.actProjSaveExecute(Sender: TObject);
begin
  if fProject.fileName <> '' then saveProj
  else actProjSaveAs.Execute;
end;

procedure TCEMainForm.actProjOpenExecute(Sender: TObject);
begin
  if fProject <> nil then if fProject.modified then if dlgOkCancel(
    'The latest mdofifications are not saved, continue ?')
      = mrCancel then exit;

  with TOpenDialog.Create(nil) do
  try
    if execute then openProj(filename);
  finally
    Free;
  end;
end;

procedure TCEMainForm.actProjOptsExecute(Sender: TObject);
var
  win: TControl;
begin
  win := DockMaster.GetAnchorSite(fPrjCfWidg);
  if win = nil then exit;
  win.Show;
  win.BringToFront;
end;

procedure TCEMainForm.actProjSourceExecute(Sender: TObject);
begin
  if fProject = nil then exit;
  if not fileExists(fProject.fileName) then exit;
  //
  openFile(fProject.fileName);
  EditWidget.currentEditor.Highlighter := LfmSyn;
end;

procedure TCEMainForm.actProjOptViewExecute(Sender: TObject);
var
  lst: TStringList;
begin
  lst := TStringList.Create;
  try
    fProject.getOpts(lst);
    dlgOkInfo(lst.Text);
  finally
    lst.Free;
  end;
end;
{$ENDREGION}

{$REGION options ---------------------------------------------------------------}
constructor TCEOptions.create(aOwner: TComponent);
begin
  inherited;
  fFileMru := TMruFileList.Create;
  fProjMru := TMruFileList.Create;
  //
  fLeft := 0;
  fTop := 0;
  fWidth := 800;
  fHeight := 600;
end;

destructor TCEOptions.destroy;
begin
  fFileMru.Free;
  fProjMru.Free;
  inherited;
end;

procedure TCEOptions.readerPropNoFound(Reader: TReader; Instance: TPersistent;
  var PropName: string; IsPath: boolean; var Handled, Skip: Boolean);
begin
  Skip := true;
  Handled := true;
end;

procedure TCEOptions.readerError(Reader: TReader; const Message: string;
  var Handled: Boolean);
begin
  Handled := true;
  fErrorFlg := false;
end;

procedure TCEOptions.setFileMru(aValue: TMruFileList);
begin
  fFileMru.Assign(aValue);
end;

procedure TCEOptions.setProjMru(aValue: TMruFileList);
begin
  fProjMru.Assign(aValue);
end;

procedure TCEOptions.saveLayout(str: TStream);
var
  st: TXMLConfigStorage;
  cf: TPropStorageXMLConfig;
begin
  cf := TPropStorageXMLConfig.Create(nil);
  st := TXMLConfigStorage.Create(cf);
  try
    DockMaster.SaveLayoutToConfig(st);
    cf.SaveToStream(str);
    str.Position := 0;
  finally
    st.Free;
    cf.Free;
  end;
end;

procedure TCEOptions.loadLayout(str: TStream);
var
  st: TXMLConfigStorage;
  cf: TPropStorageXMLConfig;
begin
  cf := TPropStorageXMLConfig.Create(nil);
  st := TXMLConfigStorage.Create(cf);
  try
    cf.LoadFromStream(str);
    DockMaster.LoadLayoutFromConfig(st,true);
  finally
    st.Free;
    cf.Free;
  end;
end;

procedure TCEOptions.defineProperties(Filer: TFiler);
var
  widg: TCEWidget;
begin
  inherited;
  // Filer is either a TReader or a TWriter
  for widg in CEMainForm.WidgetList do
    widg.declareProperties(Filer);
end;

procedure TCEOptions.beforeSave;
var
  widg: TCEWidget;
begin
  fLeft   := CEMainForm.Left;
  fTop    := CEMainForm.Top;
  fWidth  := CEMainForm.Width;
  fHeight := CEMainForm.Height;
  //
  fFileMru.Assign(CEMainForm.fFileMru);
  fProjMru.Assign(CEMainForm.fProjMru);
  //
  for widg in CEMainForm.WidgetList do
    widg.beforeSave(nil);
end;

procedure TCEOptions.saveToFile(const aFilename: string);
begin
  fErrorFlg := true;
  beforeSave;
  ce_common.saveCompToTxtFile(self, aFilename);
end;

procedure TCEOptions.loadFromFile(const aFilename: string);
begin
  fErrorFlg := true;
  loadCompFromTxtFile(self, aFilename, @readerPropNoFound, @readerError);
  afterLoad;
end;

procedure TCEOptions.afterLoad;
var
  widg: TCEWidget;
begin
  CEMainForm.Left   := fLeft;
  CEMainForm.Top    := fTop;
  CEMainForm.Width  := fWidth;
  CEMainForm.Height := fHeight;
  //
  CEMainForm.fFileMru.Assign(fFileMru);
  CEMainForm.fProjMru.Assign(fProjMru);
  //
  for widg in CEMainForm.WidgetList do
    widg.afterLoad(nil);
end;
{$ENDREGION}

initialization
  RegisterClasses([TCEOptions]);
end.
