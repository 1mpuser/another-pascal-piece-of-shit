program ebanny_Cursach;
uses Objects, Drivers, Views, Menus, App, Dialogs, CURSACH1, dos, sysutils;

const
  cmNewWin          = 101;
  WinCount : integer = 0;
  cmNewTime 		= 102;
  cmText 		= 103;
type
  TMyApp = object(TApplication)
    constructor Init;
    procedure InitStatusLine; virtual;
    procedure InitMenuBar; virtual;
    procedure NewWindow;
    procedure HandleEvent(var Event: TEvent); virtual;
  end;

  PTimeStaticText = ^TTimeStaticText;
  TTimeStaticText = object(TStaticText)
    hour, min, sec: integer;
	Helper : TTimeHelper;
    constructor Init(var R: TRect; h: integer; m: integer; ss:integer);
    procedure HandleEvent(var Event: TEvent); virtual;
    function Time(i: word): string;
    procedure Check(var h: integer; var m: integer);
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
begin
  Str(WindowNo, S);
  TDialog.Init(R, WinTitle + ' ' + S);{, wnNoNumber);}
  R.Assign(6, 2, 36, 3);
  gettime(h, m, se, ms );
  Text :=  New(PTimeStaticText, Init(R, h,m,se));
  Insert(Text);
  R.Assign(6, 14, 30, 15);
  Insert(New(PButton, Init(R, '~K~hui', cmText, bfDefault)));
  R.Assign(6, 4, 30, 5);
  Insert(New(PButton, Init(R, '~T~ime', cmNewTime, bfDefault)));
end;

procedure TDemoWindow.HandleEvent(var Event: TEvent);
begin
inherited HandleEvent(Event);
if Event.What = evCommand then
  begin
    case Event.Command of
      cmNewTime: begin
	  Writeln('dick');
	  end;
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

{   TTimeStaticText   }
constructor TTimeStaticText.Init(var R: TRect; h: integer; m: integer; ss: integer);
var
s, s1, s2: string;
begin
str(h:2, s);
s:= s+':';
str(m:2, s1);
s:= s+s1+':';
str(ss:2, s2);
s:= s+s2;
TStaticText.Init(R, s);
EventMask:= EventMask or evBroadCast;
end;


procedure TTimeStaticText.HandleEvent(var Event: TEvent);
var
i: integer;
h, m, ss, ms: word;
s: string;
begin
inherited HandleEvent(Event);
GetTime(h, m, ss, ms);
hour := h;
min:= m;
sec:=ss;
if Event.Command = cmText then
begin
i:= 1;
writeln('handleev works!');
repeat
DisposeStr(Text);
Text:= NewStr(Time(i));
Draw;
clearEvent(Event);
inc(sec);
sleep(1000);
GetEvent(Event);
i:= 0;
until (event.what = evKeyDown);
end;
ClearEvent(Event);
end;

function TTimeStaticText.Time(i: word): string;
var
h, m: integer;
s, s1: string;
begin
m:= min;
if i <> 0 then begin
end
else begin
h:=hour;
m:=min;
end;
Check(h, m);
str(h:2, s);
s:= s+':';
str(m:2, s1);
s:= s+s1+':';
str(sec:2, s1);
s:= s+s1;
min:= m;
hour:= h;
Time:=s;
end;

procedure TTimeStaticText.Check(var h: integer; var m: integer);
begin
if sec = 59 then
begin
sec:= 0;
inc(m);
end;
if m > 59 then
begin
m:= m-60;
inc(h);
end;
if h > 23 then
h:= h-24;
end;






var
  MyApp: TMyApp;

begin
  MyApp.Init;
  MyApp.Run;
  MyApp.Done;
end.