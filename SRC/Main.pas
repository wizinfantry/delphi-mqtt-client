unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, FMX.Layouts,
  MQTT, MQTTReadThread, FMX.ScrollBox, FMX.Memo;

type
  TForm1 = class(TForm)
    grdpnlyt1: TGridPanelLayout;
    btnConnect: TButton;
    btnDisConnect: TButton;
    btnPiing: TButton;
    grdpnlyt2: TGridPanelLayout;
    edtIp: TEdit;
    edtPort: TEdit;
    grdpnlyt3: TGridPanelLayout;
    edtMessage: TEdit;
    btnPublish: TButton;
    grdpnlyt4: TGridPanelLayout;
    edtSubTopic: TEdit;
    btnSubscribe: TButton;
    grdpnlyt5: TGridPanelLayout;
    edtTopic: TEdit;
    mmoLog: TMemo;
    tmr1: TTimer;
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisConnectClick(Sender: TObject);
    procedure btnPiingClick(Sender: TObject);
    procedure btnPublishClick(Sender: TObject);
    procedure btnSubscribeClick(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Log(strMsg: string);
    procedure OnConnAck(Sender: TObject; ReturnCode: Integer);
    procedure OnPingResp(Sender: TObject);
    procedure OnSubAck(Sender: TObject; MessageID: integer; GrantedQoS: integer);
    procedure OnUnSubAck(Sender: TObject);
    procedure OnPublish(Sender: TObject; topic, payload: String);

  end;

var
  Form1: TForm1;
  MQTTClient: TMQTTClient;
  fRL: TBytes;

implementation

{$R *.fmx}

procedure TForm1.btnConnectClick(Sender: TObject);
begin
  MQTTClient := TMQTTClient.Create(edtIp.Text, StrToInt(edtPort.Text));
  MQTTClient.OnConnAck := OnConnAck;
  MQTTClient.OnPingResp := OnPingResp;
  MQTTClient.OnPublish := OnPublish;
  MQTTClient.OnSubAck := OnSubAck;
  MQTTClient.Connect;
end;

procedure TForm1.btnDisConnectClick(Sender: TObject);
begin

  if (Assigned(MQTTClient)) then
  begin
    MQTTClient.Disconnect;
  end;
end;

procedure TForm1.btnPiingClick(Sender: TObject);
begin
  MQTTClient.PingReq;
end;

procedure TForm1.btnPublishClick(Sender: TObject);
begin
  MQTTClient.Publish(edtTopic.Text, edtMessage.Text);
end;

procedure TForm1.btnSubscribeClick(Sender: TObject);
begin
  MQTTClient.Subscribe(edtSubTopic.Text);
end;

procedure TForm1.Log(strMsg: string);
begin
  mmoLog.Lines.Add(FormatDateTime('hh:mm:ss', Now) + ' = ' + strMsg);
  mmoLog.ScrollBy(0, mmoLog.Lines.Count);
end;

procedure TForm1.OnConnAck(Sender: TObject; ReturnCode: Integer);
begin
  Log('Connection Acknowledged, Return Code: ' + IntToStr(Ord(ReturnCode)));
end;

procedure TForm1.OnPingResp(Sender: TObject);
begin
  Log('PING! PONG!');
end;

procedure TForm1.OnPublish(Sender: TObject; topic, payload: String);
begin
  Log('Publish Received. Topic: '+ topic + ' Payload: ' + payload);
end;

procedure TForm1.OnSubAck(Sender: TObject; MessageID: integer; GrantedQoS: integer);
begin
  Log('Sub Ack Received');
end;

procedure TForm1.OnUnSubAck(Sender: TObject);
begin
  Log('Unsubscribe Ack Received');
end;

procedure TForm1.tmr1Timer(Sender: TObject);
begin
  if MQTTClient.isConnected then MQTTClient.PingReq;
end;

end.
