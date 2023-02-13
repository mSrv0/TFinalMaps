unit uMaps;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCMapsCommonTypes,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCGeocoding, VCL.TMSFNCCustomComponent, VCL.TMSFNCCloudBase,
  VCL.TMSFNCStaticMap, VCL.TMSFNCCustomControl, VCL.TMSFNCWebBrowser,
  VCL.TMSFNCMaps, VCL.TMSFNCMapsImage, Vcl.Buttons, Vcl.ExtCtrls,
  VCL.TMSFNCRouteCalculator, Vcl.StdCtrls ;

type
  TForm1 = class(TForm)
    SpeedButton1: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    {procedure SpeedButton1Click(Sender: TObject);
    procedure TM_ActualizarTimer(Sender: TObject);}
  private
    rute : TTMSFNCRouteCalculatorRoute;
    FFNCGeocoding: TTMSFNCGeocoding;
    FFNCMaps: TTMSFNCMaps;
    FFNCRouteCalculator : TTMSFNCRouteCalculator;
    FInicie: Boolean;
    procedure CrearMapa;
    procedure generarRutas(Sender: TObject; const ARequest: TTMSFNCGeocodingRequest; const ARequestResult: TTMSFNCCloudBaseRequestResult);

   // procedure routeGeocoding(Sender: TObject; const ARequest: TTMSFNCGeocodingRequest; const ARequestResult: TTMSFNCCloudBaseRequestResult);

    procedure FFNCRouteCalculatorGetGeocoding(Sender: TObject;
      const ARequest: TTMSFNCGeocodingRequest;
      const ARequestResult: TTMSFNCCloudBaseRequestResult);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.CrearMapa;
var x: TTMSFNCGeocodingRequest;
    y: TTMSFNCCloudBaseRequestResult;
    item: TTMSFNCGeocodingRequest;
    itemgO, itemgD, itemgN: TTMSFNCGeocodingItem;
begin
  FInicie:= True;

  FFNCRouteCalculator := TTMSFNCRouteCalculator.Create(self);
  //FFNCRouteCalculator.OnGetGeocoding:= generarRutas;
  //FNCRouteCalculator.OnGetRouteGeocoding:= routeGeocoding;

  FFNCMaps:= TTMSFNCMaps.Create(nil);
  FFNCGeocoding:= TTMSFNCGeocoding.Create(Self);
  FFNCMaps.APIKey:= 'APIKEY';
  FFNCGeocoding.APIKey := 'APIKEY';
  FFNCRouteCalculator.APIKey := 'APIKEY';

  FFNCMaps.Parent:= Self;
  FFNCMaps.Align:= TAlign.alClient;
  FFNCMaps.Service := msGoogleMaps;
  FFNCMaps.RouteCalculator := FFNCRouteCalculator;

  //FFNCGeocoding.OnGetGeocoding:= generarRutas;
  FFNCGeocoding.Service := gsGoogle;
  item:= FFNCGeocoding.GeocodingRequests.Add;
  itemgO:= item.Items.Add;
  itemgO.Address:= 'Presidente Arturo H. Illia 517 Neuquen';
  itemgD:= item.Items.Add;
  itemgD.Address:= 'Entre Rios 1015 Neuquen';
  itemgN := item.Items.Add;
  itemgN.Address := 'Velez Sarsfield 863 Neuquen';
  //FFNCGeocoding.GetGeocoding(itemgO.Address, nil, 'origin');
  //FFNCGeocoding.GetGeocoding(itemgD.Address, nil, 'destination');
  //FFNCRouteCalculator.GetGeocoding(itemgO.Address, nil, 'origin');
  //FFNCRouteCalculator.GetGeocoding(itemgD.Address, nil, 'destination');

  //FFNCRouteCalculatorGetGeocoding(FFNCGeocoding, item, TTMSFNCCloudBaseRequestResult);

  FFNCRouteCalculator.Active := True;
  FFNCRouteCalculator.Options.HistoryEnabled := True;
  FFNCRouteCalculator.Service := csGoogle;
  //FFNCRouteCalculator.OnGetRouteGeocoding(item,);
  {//  x:= FFNCRouteCalculator.Routes.Add;
  FFNCRouteCalculator.OnGetGeocoding := FFNCRouteCalculatorGetGeocoding;
  FFNCRouteCalculator.GetGeocoding('Presidente Arturo H. Illia 517 Neuquen', nil, 'origin');
  FFNCRouteCalculator.GetGeocoding('Entre Rios 1015 Neuquen', nil, 'destination');}
  {x:= TTMSFNCGeocodingRequest.Create(item.Items);
  y:= TTMSFNCCloudBaseRequestResult.Create;
  FFNCRouteCalculatorGetGeocoding(FFNCGeocoding, x, y);}
  //routeGeocoding(FFNCRouteCalculator, item, nil);
  rute := TTMSFNCRouteCalculatorRoute.Create(nil);
  rute.RouteName := 'Recorrido PW';
  //FFNCRouteCalculator.AddRouteSegment(rute ,itemgN.Address);
  FFNCRouteCalculator.CalculateRoute(itemgO.Address, itemgD.Address, nil);
  //FFNCRouteCalculator.OnCalculateRoute := rute;
  rute.FirstSegment.Create(itemgO.Create();
  FFNCRouteCalculator.first;
  FFNCRouteCalculator.AddRouteSegment(rute, itemgN.Address);
  Refresh
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  if (not FInicie) then
    CrearMapa
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FInicie:= False;
end;

procedure TForm1.generarRutas(Sender: TObject; const ARequest: TTMSFNCGeocodingRequest; const ARequestResult: TTMSFNCCloudBaseRequestResult);
var
 I: Integer;
 it: TTMSFNCGeocodingItem;
 FStartAddress, FEndAddress: TTMSFNCMapsCoordinateRec;
begin
  for I := 0 to ARequest.Items.Count - 1 do
    begin
    it := ARequest.Items[I];
    if ARequest.ID = 'origin' then
    begin
    FStartAddress := it.Coordinate.ToRec;
    FFNCMaps.SetCenterCoordinate(FStartAddress);
    FFNCMaps.AddMarker(FStartAddress);
    end;
    if ARequest.ID = 'destination' then
      begin
      FEndAddress := it.Coordinate.ToRec;
      FFNCMaps.AddMarker(FEndAddress);
      end;
    end;
end;

{procedure TForm1.routeGeocoding(Sender: TObject; const ARequest: TTMSFNCGeocodingRequest; const ARequestResult: TTMSFNCCloudBaseRequestResult);
var ACallback: TTMSFNCRouteCalculatorCalculateRouteCallback;
    origen, destino : string;
begin
  origen:= ARequest.Items[0].Address;//'Presidente Arturo H. Illia 517 Neuquen';//;
  destino:= ARequest.Items[1].Address; //'Entre Rios 1015 Neuquen';//;
  FFNCRouteCalculator.CalculateRoute(origen, destino, ACallback);
end;  }

procedure TForm1.FFNCRouteCalculatorGetGeocoding(Sender: TObject; const ARequest: TTMSFNCGeocodingRequest; const ARequestResult: TTMSFNCCloudBaseRequestResult);
begin
  if ARequestResult.Success then
    FFNCMaps.SetCenterCoordinate(ARequest.Items[0].Coordinate.ToRec);
end;

end.
