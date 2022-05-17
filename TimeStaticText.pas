unit TimeStaticText;

interface 

uses Objects, Drivers, Views, Menus, App, Dialogs, CURSACH1, dos, crt, sysutils, DateUtils;

const 
	cmText 		= 103;

type
	PTimeStaticText = ^TTimeStaticText;
	  TTimeStaticText = object(TStaticText)
		hour, min, sec: integer;
		//Helper : PTimerHelper;
		constructor Init(var R: TRect; h: integer; m: integer; ss:integer);
		procedure HandleEvent(var Event: TEvent); virtual;
		function Time(i: word): string;
		procedure Check(var h: integer; var m: integer);
end;


implementation


constructor TTimeStaticText.Init(var R: TRect; h: integer; m: integer; ss: integer);
var
s, s1, s2: string;
TutuTime, Ime : TDateTime;
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
Writeln(h);
min:= m;
sec:=ss;
if Event.Command = cmText then
begin
i:= 1;
repeat
//writeln('cycle works');

DisposeStr(Text);
Text:= NewStr(Time(i));
Draw;
clearEvent(Event);
dec(sec);
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
if (hour = 0) and (min = 0) and (sec = 0) then
Time := 'Timer done!';
end;

procedure TTimeStaticText.Check(var h: integer; var m: integer);
var tmpHooour : Word;
begin
if sec = -1 then
begin
sec:= 59;
dec(m);
end;
if m = -1 then
begin
m:= 59;
dec(h);
end;
if h > 23  then
h:= h-24;
if (h < 0) or (hour > 6000) then
h:= HourOf(Now); {could be rewritten to different }
end;

begin
end.