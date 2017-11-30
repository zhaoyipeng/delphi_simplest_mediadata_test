program simplest_mediadata_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  simplest_mediadata_raw in 'simplest_mediadata_raw.pas',
  simplest_mediadata_main in 'simplest_mediadata_main.pas',
  simplest_mediadata_h264 in 'simplest_mediadata_h264.pas',
  simplest_mediadata_aac in 'simplest_mediadata_aac.pas',
  simplest_mediadata_flv in 'simplest_mediadata_flv.pas',
  simplest_mediadata_udp in 'simplest_mediadata_udp.pas';

begin
  try
    test_all;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
