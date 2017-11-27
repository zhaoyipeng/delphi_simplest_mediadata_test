unit simplest_mediadata_main;

interface

uses
  simplest_mediadata_raw;

procedure test_all;
implementation

procedure test_all;
begin
  //Test
//  simplest_yuv420_split('lena_256x256_yuv420p.yuv',256,256,1);
//  simplest_yuv444_split('lena_256x256_yuv444p.yuv',256,256,1);
//  simplest_yuv420_gray('lena_256x256_yuv420p.yuv',256,256,1);
//  simplest_yuv420_halfy('lena_256x256_yuv420p.yuv',256,256,1);
//  simplest_yuv420_graybar(640, 360,0,255,10,'graybar_640x360.yuv');
//  simplest_yuv420_psnr('lena_256x256_yuv420p.yuv','lena_distort_256x256_yuv420p.yuv',256,256,1);
//  simplest_rgb24_split('cie1931_500x500.rgb', 500, 500,1);
//  simplest_rgb24_to_bmp('lena_256x256_rgb24.rgb',256,256,'output_lena.bmp');
//  simplest_rgb24_to_yuv420('lena_256x256_rgb24.rgb',256,256,1,'output_lena.yuv');

  simplest_rgb24_colorbar(640, 360,'colorbar_640x360.rgb');


  Readln;
end;
end.
