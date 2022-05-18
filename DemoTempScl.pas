program ebanny_Cursach;

uses TimeStaticText ,Objects, Drivers, Views, Menus, App, Dialogs, CURSACH1, dos, crt, sysutils, DateUtils;

const
  cmNewWin          = 101;
  WinCount : integer = 0;
  cmNewTime 		= 102;
  cmText 		= 103;
  cmCancel 		= 104;
  cmMainWindow = 105;
  cmZaglushka = 106;

type
  DialogData = record
    InputLineData: string[128];
  end;





type
  TMyApp = object(TApplication)
    constructor Init;
    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;
    procedure NewWindow(serviceHour : Integer; serviceMin : Integer; serviceSec : Integer);
    procedure HandleEvent(var Event: TEvent); virtual;
	procedure NewMainWindow;
  end;




  PMyWindow = ^TMyWindow;
  TMyWindow = object(TWindow)
    MyInput : PInputLine;
	constructor Init(Bounds: TRect; WinTitle: String; WindowNo: Word);
	procedure HandleEvent(var Event: TEvent); virtual;
  end;

  {PDemoInputLine = ^TDemoInputLine
  TDemoInputLine = object (TInputLine)
  procedure HandleEvent(var Event: TEvent); virtual;
end; } 

  PDemoWindow = ^TDemoWindow;
  TDemoWindow = object(TDialog)
    Text : PTimeStaticText;
	constructor Init(R: TRect; WinTitle: String; WindowNo: Word; sHour: integer; sMin : Integer; sSec : integer);
	procedure HandleEvent(var Event: TEvent); virtual;
  end;
  
var
  DemoDialogData: DialogData;
  MyApp: TMyApp;
  

{procedure TDemoInputLine.HandleEvent(var Event: TEvent);
begin
inherited HandleEvent(Event);
if Event.What = evCommand then
  begin
    case Event.Command of
      cmNewTime: begin
	  message(Owner, evBroadCast, cmNewTime, nil);
	  Writeln(DemoDialogData.InputLineData);
	  end;
    else
      Exit;
    end;
    ClearEvent(Event);
  end;
end;}

{   TMyWindow  }
constructor TMyWindow.Init(Bounds: TRect; WinTitle: String; WindowNo: Word);
var
  S: string[3];
  R : TRect;
begin
  Str(WindowNo, S);
  TWindow.Init(Bounds, WinTitle + ' ' + S, wnNoNumber);
  R.Assign(6, 5, 25, 6);
  MyInput := New(PInputLine, Init(R, 128));
  Insert(MyInput);
  R.Assign(6, 10, 20, 11);
  Insert(New(PButton, Init(R, '~C~lock', cmZaglushka, bfNormal)));
  R.Assign(22, 10, 36, 11);
  Insert(New(PButton, Init(R, '~C~ancel', cmCancel, bfDefault)));
end;
procedure TMyWindow.HandleEvent(var Event: TEvent);
var difTime, futTime, nowTime, oneMoreDate : TDateTime;
hhh, mmm, sss : integer;
Cmp : Integer;
begin
inherited HandleEvent(Event);
	case Event.Command of
	  cmCancel : Done;
	  cmZaglushka : 
	  begin
		MyInput^.getdata(DemoDialogData);
		futTime := StrToTime(DemoDialogData.InputLineData);
		nowTime := now;
		Cmp:=CompareDateTime(futTime, nowTime);
		if Cmp < 0 then begin
		difTime := nowTime - futTime;
		hhh := 24 - hourof(difTime);
		mmm := 60 - MinuteOf(difTime);
		sss := 60 - SecondOf(difTime);
		end;
		if Cmp > 0 then begin
		difTime := futTime - nowTime;
		hhh := 24 - hourof(difTime);
		mmm := 60 - MinuteOf(difTime);
		sss := 60 - SecondOf(difTime);
		end;
		MyApp.NewWindow(hhh, mmm, sss);
	  end;
    else
      Exit;
    end;
end;




{ TDemoWindow }
constructor TDemoWindow.Init(R: TRect; WinTitle: String; WindowNo: Word; sHour: integer; sMin : Integer; sSec : integer);
var s : string;
h, m , se , ms : Word;
hour, min , sec : Integer;
StatStr : TStaticText;
Bruce: PView;
begin
  Str(WindowNo, S);
  TDialog.Init(R, WinTitle + ' ' + S);{, wnNoNumber);}
  
  
  {R.Assign(6, 2, 36, 3);
  StatStr := new (StaticText, Init(R, 'Here is ur countdown'));}
  R.Assign(6, 2, 36, 3);
  Text :=  New(PTimeStaticText, Init(R, sHour, sMin, sSec));
  Insert(Text);
  R.Assign(6, 5, 20, 6);
  {Bruce := New(PInputLine, Init(R, 128));
  Insert(Bruce);
  R.Assign(6, 8, 20, 9);}
  Insert(New(PButton, Init(R, '~S~et Clock', cmText, bfDefault)));
  R.Assign(6, 10, 20, 11);
  //Insert(New(PButton, Init(R, '~C~ancel', cmCancel, bfNormal)));
  //Insert(New(PButton, Init(R, '~T~ime', cmNewTime, bfNormal)));
end;

procedure TDemoWindow.HandleEvent(var Event: TEvent);
begin
inherited HandleEvent(Event);

if Event.What = evCommand then
  begin
    case Event.Command of
      cmNewTime: begin
	  message(Owner, evBroadCast, cmNewTime, nil);
	  Writeln(DemoDialogData.InputLineData);
	  end;
	  cmText: begin
		//Writeln('worked');
		message(Owner, evBroadCast, cmText, nil);
	  end;
	  cmCancel : Done;
    else
      Exit;
    end;
    ClearEvent(Event);
  end;

end;

{  TMyApp  }

constructor TMyApp.Init;
begin
  TApplication.Init;
end;

procedure TMyApp.HandleEvent(var Event: TEvent);
begin
  TApplication.HandleEvent(Event);
  if Event.What = evCommand then
  begin
    case Event.Command of
      //cmNewWin: NewWindow;
	  cmMainWindow : NewMainWindow;
    else
      Exit;
    end;
    ClearEvent(Event);
  end;
end;

procedure TMyApp.InitMenuBar;
var R: TRect;
begin
  GetExtent(R);
  R.B.Y := R.A.Y + 1;
  MenuBar := New(PMenuBar, Init(R, NewMenu(
    NewSubMenu('~F~ile', hcNoContext, NewMenu(
      NewItem('~N~ew', 'F4', kbF4, cmMainWindow, hcNoContext,
      NewLine(
      NewItem('E~x~it', 'Alt-X', kbAltX, cmQuit, hcNoContext,
      nil)))),
    NewSubMenu('~W~indow', hcNoContext, NewMenu(
      NewItem('~N~ext', 'F6', kbF6, cmNext, hcNoContext,
      NewItem('~Z~oom', 'F5', kbF5, cmZoom, hcNoContext,
      nil))),
    nil))
  )));
end;

procedure TMyApp.InitStatusLine;
var R: TRect;
begin
  GetExtent(R);
  R.A.Y := R.B.Y - 1;
  StatusLine := New(PStatusLine, Init(R,
    NewStatusDef(0, $FFFF,
      NewStatusKey('', kbF10, cmMenu,
      NewStatusKey('~Alt-X~ Exit', kbAltX, cmQuit,
      NewStatusKey('~F4~ New', kbF4, cmNewWin,
      NewStatusKey('~Alt-F3~ Close', kbAltF3, cmClose,
      nil)))),
    nil)
  ));
end;

procedure TMyApp.NewWindow(serviceHour : Integer; serviceMin : Integer; serviceSec : Integer);
var
  Window: PDemoWindow;
  R: TRect;
  C : Word;
begin
  Inc(WinCount);
  R.Assign(0, 0, 40, 16);
  R.Move(Random(40), Random(9));
  Window := New(PDemoWindow, Init(R, 'Demo Window', WinCount, serviceHour, serviceMin, serviceSec));
  Window^.SetData(DemoDialogData);
  C := DeskTop^.ExecView(Window);
  if C = cmCancel then Window^.GetData(DemoDialogData);
  DeskTop^.Insert(Window);
end;

procedure TMyApp.NewMainWindow;
var
  Window: PMyWindow;
  R: TRect;
begin
  Inc(WinCount);
  R.Assign(0, 0, 50, 20);
  R.Move(15, 5);
  Window := New(PMyWindow, Init(R, 'Demo Window', WinCount));
  DeskTop^.Insert(Window);
end;


{var
  MyApp: TMyApp;}


begin
  with DemoDialogData do
  begin
    InputLineData := '19:00';
  end;
  MyApp.Init;
  MyApp.Run;
  MyApp.Done;
end.
