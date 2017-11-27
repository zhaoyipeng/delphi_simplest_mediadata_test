unit simplest_mediadata_main;

interface

uses
  simplest_mediadata_raw;

procedure test_all;
implementation

procedure test_all;
begin
  //Test
  simplest_yuv420_split('lena_256x256_yuv420p.yuv',256,256,1);
end;
end.
