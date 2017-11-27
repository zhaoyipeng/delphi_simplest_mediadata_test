program simplest_mediadata_test;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  simplest_mediadata_raw in 'simplest_mediadata_raw.pas',
  simplest_mediadata_main in 'simplest_mediadata_main.pas',
  simplest_mediadata_h264 in 'simplest_mediadata_h264.pas';

begin
  try
    test_all;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
