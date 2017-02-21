program TEST001;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {Form1},
  MQTT in '..\LIB\MQTT.pas',
  MQTTReadThread in '..\LIB\MQTTReadThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
