unit Multiprocess;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, WinInet;
  type
TmyThread = class (TThread)
private
X, Y, Color : Integer;
protected
procedure Execute; override;
procedure Paint;
end;
type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);

  private
     PT : TMyThread;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
 function GetInetFile(const fileURL, FileName: String): boolean;
const BufferSize = 1024;
var hSession, hURL: HInternet;
Buffer: array[1..BufferSize] of Byte;
BufferLen: DWORD;
f: File;
sAppName: string;
begin
   Result:=False;
   sAppName := ExtractFileName(Application.ExeName);
   hSession := InternetOpen(PChar(sAppName), INTERNET_OPEN_TYPE_PRECONFIG,
         nil, nil, 0);
   try
      hURL := InternetOpenURL(hSession,
      PChar(fileURL),nil,0,0,0);
        if hurl<>nil then
      try
         AssignFile(f, FileName);
         Rewrite(f,1);


         repeat
            InternetReadFile(hURL, @Buffer, SizeOf(Buffer), BufferLen);
            BlockWrite(f, Buffer, BufferLen)
         until BufferLen = 0;
         CloseFile(f);
         Result:=True;
      finally
      InternetCloseHandle(hURL)
      end
   finally
   InternetCloseHandle(hSession)
   end
end;

 procedure TMyThread.Execute;
  var FileOnNet, LocalFileName: string;
begin
 FileOnNet:='https://sites.google.com/site/diminiincupdates/snake/Snake2.txt';
   LocalFileName:='snakeexefile.exe';
   if GetInetFile(FileOnNet,LocalFileName)=True then
      ShowMessage('Download successful version')
   else
      ShowMessage('Error in file download version');
end;

procedure TMyThread.Paint;
begin
with Form1.Canvas do begin
{рисуем крестики :-)}
brush.Color:=clblack;
//pen.Color:=color;
rectangle(x-random(10),y-random(10),x+random(10),y+random(10));
end;
end;



{procedure TForm2.Button1Click(Sender: TObject);
var FileOnNet, LocalFileName: string;
begin
//if InetIsOffline(0) then
 // ShowMessage('This computer is not connected to Internet!')
//else
//  ShowMessage('You are connected to Internet!');

   FileOnNet:='https://sites.google.com/site/diminiincupdates/snake/Lastversion.txt';
   LocalFileName:='lastversioncheck.txt';

    FileOnNet:='https://sites.google.com/site/diminiincupdates/snake/Snake2.txt';
   LocalFileName:='snakeexefile.exe';
   if GetInetFile(FileOnNet,LocalFileName)=True then
      ShowMessage('Download successful version')
   else
      ShowMessage('Error in file download version');


end;  }
 procedure TForm1.Button1Click(Sender: TObject);
begin
 Button1.Enabled:=False;
Button2.Enabled:=True;
PT:=TMyThread.Create(False);

// запустить поток сразу
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
 Button1.Enabled:=True;
Button2.Enabled:=False;
PT.Free; // уничтожить поток
end;




procedure TForm1.FormCreate(Sender: TObject);
begin
 Button1.Enabled:=False;
Button2.Enabled:=True;
PT:=TMyThread.Create(False);
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
begin
 form1.canvas.rectangle(x-10,y-10,x+10,y+10);
end;
end;

end.
