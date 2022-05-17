program ebanny_Cursach;

uses TimeStaticText ,Objects, Drivers, Views, Menus, App, Dialogs, CURSACH1, dos, crt, sysutils, DateUtils;

const
  cmNewWin          = 101;
  WinCount : integer = 0;
  cmNewTime 		= 102;
  cmText 		= 103;
  cmCancel 		= 104;

{type
  DialogData = record
    InputLineData: string[128];
  end;}


type
  TMyApp = object(TApplication)
    constructor Init;
    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;
    procedure NewWindow;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;


  PDemoWindow = ^TDemoWindow;
  TDemoWindow = object(TDialog)
    Text : PTimeStaticText;
	constructor Init(R : TRect; WinTitle: String; WindowNo: Word);
	procedure HandleEvent(var Event: TEvent); virtual;
  end;
  

{ TDemoWindow }
constructor TDemoWindow.Init(R: TRect; WinTitle: String; WindowNo: Word);
var s : string;
h, m , se , ms : Word;
hour, min , sec : Integer;
StatStr : TStaticText;
begin
  Str(WindowNo, S);
  TDialog.Init(R, WinTitle + ' ' + S);{, wnNoNumber);}
  
  
  {R.Assign(6, 2, 36, 3);
  StatStr := new (StaticText, Init(R, 'Here is ur countdown'));}
  R.Assign(6, 2, 36, 3);
  GetTime(h, m, se, ms);
  Text :=  New(PTimeStaticText, Init(R, 0, 0, 9));
  Insert(Text);
  R.Assign(6, 8, 20, 9);
  Insert(New(PButton, Init(R, '~S~et Clock', cmText, bfDefault)));
  R.Assign(22, 8, 30, 9);
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
	  //Writeln('dick');
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

{ TMyApp }

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
      cmNewWin: NewWindow;
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
      NewItem('~N~ew', 'F4', kbF4, cmNewWin, hcNoContext,
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

procedure TMyApp.NewWindow;
var
  Window: PDemoWindow;
  R: TRect;
begin
  Inc(WinCount);
  R.Assign(0, 0, 40, 16);
  R.Move(Random(40), Random(9));
  Window := New(PDemoWindow, Init(R, 'Demo Window', WinCount));
  DeskTop^.Insert(Window);
end;


var
  MyApp: TMyApp;


begin
  {with DemoDialogData do
  begin
    InputLineData := '19:00';
  end;}
  MyApp.Init;
  MyApp.Run;
  MyApp.Done;
end.
