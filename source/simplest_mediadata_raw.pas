unit simplest_mediadata_raw;

interface

uses
  System.Classes,
  System.SysUtils,
  System.Math;

/// <summary>
/// Split Y, U, V planes in YUV420P file.
/// </summary>
/// <param name="url">Location of Input YUV file.</param>
/// <param name="w">Width of Input YUV file.</param>
/// <param name="h">Height of Input YUV file.</param>
/// <param name="num">Number of frames to process.</param>
function simplest_yuv420_split(const url: string; w, h, num: Integer): Integer;


/// <summary>
/// Convert YUV420P file to gray picture
/// </summary>
/// <param name="url">Location of Input YUV file.</param>
/// <param name="w">Width of Input YUV file.</param>
/// <param name="h">Height of Input YUV file.</param>
/// <param name="num">Number of frames to process.</param>
function simplest_yuv444_split(const url: string; w, h, num: Integer): Integer;

/// <summary>
/// Split Y, U, V planes in YUV444P file.
/// </summary>
/// <param name="url">Location of Input YUV file.</param>
/// <param name="w">Width of Input YUV file.</param>
/// <param name="h">Height of Input YUV file.</param>
/// <param name="num">Number of frames to process.</param>
function simplest_yuv420_gray(const url: string; w, h, num: Integer): Integer;

/// <summary>
/// Halve Y value of YUV420P file
/// </summary>
/// <param name="url">Location of Input YUV file.</param>
/// <param name="w">Width of Input YUV file.</param>
/// <param name="h">Height of Input YUV file.</param>
/// <param name="num">Number of frames to process.</param>
function simplest_yuv420_halfy(const url: string; w, h, num: Integer): Integer;


/// <summary>
/// Add border for YUV420P file
/// </summary>
/// <param name="url">Location of Input YUV file.</param>
/// <param name="w">Width of Input YUV file.</param>
/// <param name="h">Height of Input YUV file.</param>
/// <param name="border">Width of Border.</param>
/// <param name="num">Number of frames to process.</param>
function simplest_yuv420_border(const url: string; w, h, border, num: Integer): Integer;


/// <summary>
/// Add border for YUV420P file
/// </summary>
/// <param name="width">Width of Output YUV file.</param>
/// <param name="height">Height of Output YUV file.</param>
/// <param name="ymin">Max value of Y</param>
/// <param name="ymax">Min value of Y</param>
/// <param name="barnum">Number of bars</param>
/// <param name="url_out">Location of Output YUV file.</param>
function simplest_yuv420_graybar(width, height, ymin, ymax, barnum: Integer; const url_out: string): Integer;


/// <summary>
/// Calculate PSNR between 2 YUV420P file
/// </summary>
/// <param name="url1">Location of first Input YUV file.</param>
/// <param name="url2">Location of another Input YUV file.</param>
/// <param name="w">Width of Input YUV file.</param>
/// <param name="h">Height of Input YUV file.</param>
/// <param name="num">Number of frames to process.</param>
function simplest_yuv420_psnr(const url1, url2: string; w, h, num: Integer): Integer;

implementation

function simplest_yuv420_split(const url: string; w, h, num: Integer): Integer;
var
  fp, fp1, fp2, fp3: TFileStream;
  pic: TArray<Byte>;
  I: Integer;
begin
  fp := TFileStream.Create(url, fmOpenRead);
  fp1 := TFileStream.Create('output\output_420_y.y', fmCreate);
  fp2 := TFileStream.Create('output\output_420_u.y', fmCreate);
  fp3 := TFileStream.Create('output\output_420_v.y', fmCreate);

  SetLength(pic, w * h * 3 div 2);

  for I := 0 to num - 1 do
  begin
    fp.ReadBuffer(pic[0], w * h * 3 div 2);
    //Y
    fp1.WriteBuffer(pic[0], w * h);
    //U
    fp2.WriteBuffer(pic[w * h], w * h div 4);
    //V
    fp3.WriteBuffer(pic[w * h * 5 div 4], w * h div 4);
  end;

  fp3.Free;
  fp2.Free;
  fp1.Free;
  fp.Free;

  Result := 0;
end;

function simplest_yuv444_split(const url: string; w, h, num: Integer): Integer;
var
  fp, fp1, fp2, fp3: TFileStream;
  pic: TArray<Byte>;
  I: Integer;
begin
  fp := TFileStream.Create(url, fmOpenRead);
  fp1 := TFileStream.Create('output\output_444_y.y', fmCreate);
  fp2 := TFileStream.Create('output\output_444_u.y', fmCreate);
  fp3 := TFileStream.Create('output\output_444_v.y', fmCreate);

  SetLength(pic, w * h * 3);

  for I := 0 to num - 1 do
  begin
    fp.ReadBuffer(pic[0], w * h * 3);
    //Y
    fp1.WriteBuffer(pic[0], w * h);
    //U
    fp2.WriteBuffer(pic[w * h], w * h);
    //V
    fp3.WriteBuffer(pic[w * h * 2], w * h);
  end;

  fp3.Free;
  fp2.Free;
  fp1.Free;
  fp.Free;

  Result := 0;
end;

function simplest_yuv420_gray(const url: string; w, h, num: Integer): Integer;
var
  fp, fp1: TFileStream;
  pic: TArray<Byte>;
  I: Integer;
begin
  fp := TFileStream.Create(url, fmOpenRead);
  fp1 := TFileStream.Create('output\output_gray.yuv', fmCreate);

  SetLength(pic, w * h * 3 div 2);

  for I := 0 to num - 1 do
  begin
    fp.ReadBuffer(pic[0], w * h * 3 div 2);
    //Gray
    FillChar(pic[w * h], w * h div 2, 128);
    fp1.WriteBuffer(pic[0], w * h * 3 div 2);
  end;

  fp1.Free;
  fp.Free;

  Result := 0;
end;

function simplest_yuv420_halfy(const url: string; w, h, num: Integer): Integer;
var
  fp, fp1: TFileStream;
  pic: TArray<Byte>;
  temp: Byte;
  I: Integer;
  J: Integer;
begin
  fp := TFileStream.Create(url, fmOpenRead);
  fp1 := TFileStream.Create('output\output_half.yuv', fmCreate);

  SetLength(pic, w * h * 3 div 2);

  for I := 0 to num - 1 do
  begin
    fp.ReadBuffer(pic[0], w * h * 3 div 2);
    //Half
    for J := 0 to w * h - 1 do
    begin
      temp := pic[J] div 2;
      pic[J] := temp;
    end;

    fp1.WriteBuffer(pic[0], w * h * 3 div 2);
  end;

  fp1.Free;
  fp.Free;

  Result := 0;
end;

function simplest_yuv420_border(const url: string; w, h, border, num: Integer): Integer;
var
  fp, fp1: TFileStream;
  pic: TArray<Byte>;
  I: Integer;
  J: Integer;
  K: Integer;
begin
  fp := TFileStream.Create(url, fmOpenRead);
  fp1 := TFileStream.Create('output\output_border.yuv', fmCreate);

  SetLength(pic, w * h * 3 div 2);

  for I := 0 to num - 1 do
  begin
    fp.ReadBuffer(pic[0], w * h * 3 div 2);
    //Half
    for J := 0 to h - 1 do
    begin
      for K := 0 to w - 1 do
      begin
        if (K < border) or (K > (w - border)) or (J < border) or (J > (h - border)) then
          pic[J * w + K] := 255;
      end;
    end;

    fp1.WriteBuffer(pic[0], w * h * 3 div 2);
  end;

  fp1.Free;
  fp.Free;

  Result := 0;
end;

function simplest_yuv420_graybar(width, height, ymin, ymax, barnum: Integer; const url_out: string): Integer;
var
  barwidth: Integer;
  lum_inc: Single;
  lum_temp: Byte;
  uv_width, uv_height: Integer;
  fp: TFileStream;
  data_y, data_u, data_v: TArray<Byte>;
  t, i, j: Integer;
begin
  t := 0;
  i := 0;
  j := 0;
  barwidth := width div barnum;
  lum_inc := (ymax - ymin) / (barnum - 1);
  uv_width := width div 2;
  uv_height := height div 2;

  SetLength(data_y, width * height);
  SetLength(data_u, uv_width * uv_height);
  SetLength(data_v, uv_width * uv_height);

  fp := TFileStream.Create('output\' + url_out, fmCreate);

  //Output Info
  Writeln('Y, U, V value from picture''s left to right:');
  for t := 0 to (width div barwidth) - 1 do
  begin
    lum_temp := Round(ymin + (t * lum_inc));
    WriteLn(Format('%3d, 128, 128', [lum_temp]));
  end;

  //Gen Data
  for j := 0 to height - 1 do
  begin
    for i := 0 to width - 1 do
    begin
      t := i div barwidth;
      lum_temp := Round(ymin + (t * lum_inc));
      data_y[j * width + i] := lum_temp;
    end;
  end;

  for j := 0 to uv_height - 1 do
  begin
    for i := 0 to uv_width - 1 do
      data_u[j * uv_width + i] := 128;
  end;

  for j := 0 to uv_height - 1 do
  begin
    for i := 0 to uv_width - 1 do
      data_v[j * uv_width + i] := 128;
  end;
  fp.WriteBuffer(data_y[0], width * height);
  fp.WriteBuffer(data_u[0], uv_width * uv_height);
  fp.WriteBuffer(data_v[0], uv_width * uv_height);

  fp.Free;
  Result := 0;
end;

function simplest_yuv420_psnr(const url1, url2: string; w, h, num: Integer): Integer;
var
  fp1, fp2: TFileStream;
  pic1, pic2: TArray<Byte>;
  mse_sum, mse, psnr: Double;
  I: Integer;
  J: Integer;
  K: Integer;
begin
  fp1 := TFileStream.Create(url1, fmOpenRead);
  fp2 := TFileStream.Create(url2, fmOpenRead);

  SetLength(pic1, w * h);
  SetLength(pic2, w * h);

  mse_sum := 0;
  mse := 0;
  psnr := 0;
  for I := 0 to num - 1 do
  begin
    fp1.ReadBuffer(pic1[0], w * h);
    fp2.ReadBuffer(pic2[0], w * h);

    for J := 0 to w * h - 1 do
    begin
      mse_sum := mse_sum + Power(pic1[J] - pic2[J], 2);
    end;
    mse := mse_sum / (w * h);
    psnr := 10 * Log10(255.0 * 255.0 / mse);
    Writeln(Format('%5.3f', [psnr]));

    fp1.Seek(w * h div 2, TSeekOrigin.soCurrent);
    fp2.Seek(w * h div 2, TSeekOrigin.soCurrent);
  end;

  fp2.Free;
  fp1.Free;

  Result := 0;
end;

end.

