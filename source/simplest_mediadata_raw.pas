(**
 * 最简单的视音频数据处理示例
 * Simplest MediaData Test
 *
 * 雷霄骅 Lei Xiaohua
 * leixiaohua1020@126.com
 * 中国传媒大学/数字电视技术
 * Communication University of China / Digital TV Technology
 * http://blog.csdn.net/leixiaohua1020
 *
 * 本项目包含如下几种视音频测试示例：
 *  (1)像素数据处理程序。包含RGB和YUV像素格式处理的函数。
 *  (2)音频采样数据处理程序。包含PCM音频采样格式处理的函数。
 *  (3)H.264码流分析程序。可以分离并解析NALU。
 *  (4)AAC码流分析程序。可以分离并解析ADTS帧。
 *  (5)FLV封装格式分析程序。可以将FLV中的MP3音频码流分离出来。
 *  (6)UDP-RTP协议分析程序。可以将分析UDP/RTP/MPEG-TS数据包。
 *
 * This project contains following samples to handling multimedia data:
 *  (1) Video pixel data handling program. It contains several examples to handle RGB and YUV data.
 *  (2) Audio sample data handling program. It contains several examples to handle PCM data.
 *  (3) H.264 stream analysis program. It can parse H.264 bitstream and analysis NALU of stream.
 *  (4) AAC stream analysis program. It can parse AAC bitstream and analysis ADTS frame of stream.
 *  (5) FLV format analysis program. It can analysis FLV file and extract MP3 audio stream.
 *  (6) UDP-RTP protocol analysis program. It can analysis UDP/RTP/MPEG-TS Packet.
 *
 * Translated to delphi by Zhao Yipeng
 * zhaoyipeng@hotmail.com
 * https://github.com/zhaoyipeng/delphi_simplest_mediadata_test
 *)
unit simplest_mediadata_raw;

interface

uses
  Winapi.Windows,
  Winapi.MMSystem,
  System.Classes,
  System.SysUtils,
  System.Math;

const
  OUTPUT_DIR = 'output\';

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
///  Generate YUV420P gray scale bar.
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

/// <summary>
/// Split R, G, B planes in RGB24 file.
/// </summary>
/// <param name="url">Location of Input RGB file.</param>
/// <param name="w">Width of Input RGB file.</param>
/// <param name="h">Height of Input RGB file.</param>
/// <param name="num">Number of frames to process.</param>
function simplest_rgb24_split(const url: string; w, h, num: Integer): Integer;

/// <summary>
/// Convert RGB24 file to BMP file
/// </summary>
/// <param name="rgb24path">Location of Input RGB file.</param>
/// <param name="width">Width of Input RGB file.</param>
/// <param name="height">Height of Input RGB file.</param>
/// <param name="bmppath">Location of Output BMP file.</param>
function simplest_rgb24_to_bmp(const rgb24path: string; width, height: Integer; const bmppath: string): Integer;

/// <summary>
/// Convert RGB24 file to YUV420P file
/// </summary>
/// <param name="url_in">Location of Input RGB file.</param>
/// <param name="w">Width of Input RGB file.</param>
/// <param name="h">Height of Input RGB file.</param>
/// <param name="num">Number of frames to process.</param>
/// <param name="url_out">Location of Output YUV file.</param>
function simplest_rgb24_to_yuv420(const url_in: string; w, h, num: Integer; const url_out: string): Integer;

/// <summary>
///  Generate RGB24 colorbar.
/// </summary>
/// <param name="width">Width of Output RGB file.</param>
/// <param name="height">Height of Output RGB file.</param>
/// <param name="url_out">Location of Output RGB file.</param>
function simplest_rgb24_colorbar(width, height: Integer; const url_out: string): Integer;


/// <summary>
/// Split Left and Right channel of 16LE PCM file.
/// </summary>
/// <param name="url">Location of PCM file.</param>
function simplest_pcm16le_split(const url: string): Integer;

/// <summary>
/// Halve volume of Left channel of 16LE PCM file
/// </summary>
/// <param name="url">Location of PCM file.</param>
function simplest_pcm16le_halfvolumeleft(const url: string): Integer;

/// <summary>
/// Re-sample to double the speed of 16LE PCM file
/// </summary>
/// <param name="url">Location of PCM file.</param>
function simplest_pcm16le_doublespeed(const url: string): Integer;

/// <summary>
/// Convert PCM-16 data to PCM-8 data.
/// </summary>
/// <param name="url">Location of PCM file.</param>
function simplest_pcm16le_to_pcm8(const url: string): Integer;

/// <summary>
/// Cut a 16LE PCM single channel file.
/// </summary>
/// <param name="url">Location of PCM file.</param>
/// <param name="start_num">start point</param>
/// <param name="dur_num">how much point to cut</param>
function simplest_pcm16le_cut_singlechannel(const url: string; start_num, dur_num: Integer): Integer;


/// <summary>
///  Convert PCM16LE raw data to WAVE format
/// </summary>
/// <param name="pcmpath">Input PCM file.</param>
/// <param name="channels">Channel number of PCM file.</param>
/// <param name="sample_rate">Sample rate of PCM file.</param>
/// <param name="wavepath">Output WAVE file.</param>
function simplest_pcm16le_to_wave(const pcmpath: string; channels, sample_rate: Integer; const wavepath: string): Integer;

implementation

function simplest_yuv420_split(const url: string; w, h, num: Integer): Integer;
var
  fp, fp1, fp2, fp3: TBufferedFileStream;
  pic: TArray<Byte>;
  I: Integer;
begin
  fp := TBufferedFileStream.Create(url, fmOpenRead);
  fp1 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_420_y.y', fmCreate);
  fp2 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_420_u.y', fmCreate);
  fp3 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_420_v.y', fmCreate);

  SetLength(pic, w * h * 3 div 2);

  for I := 0 to num - 1 do
  begin
    fp.ReadBuffer(pic[0], w * h * 3 div 2);
    //Y
    fp1.Write(pic[0], w * h);
    //U
    fp2.Write(pic[w * h], w * h div 4);
    //V
    fp3.Write(pic[w * h * 5 div 4], w * h div 4);
  end;

  fp3.Free;
  fp2.Free;
  fp1.Free;
  fp.Free;

  Result := 0;
end;

function simplest_yuv444_split(const url: string; w, h, num: Integer): Integer;
var
  fp, fp1, fp2, fp3: TBufferedFileStream;
  pic: TArray<Byte>;
  I: Integer;
begin
  fp := TBufferedFileStream.Create(url, fmOpenRead);
  fp1 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_444_y.y', fmCreate);
  fp2 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_444_u.y', fmCreate);
  fp3 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_444_v.y', fmCreate);

  SetLength(pic, w * h * 3);

  for I := 0 to num - 1 do
  begin
    fp.ReadBuffer(pic[0], w * h * 3);
    //Y
    fp1.Write(pic[0], w * h);
    //U
    fp2.Write(pic[w * h], w * h);
    //V
    fp3.Write(pic[w * h * 2], w * h);
  end;

  fp3.Free;
  fp2.Free;
  fp1.Free;
  fp.Free;

  Result := 0;
end;

function simplest_yuv420_gray(const url: string; w, h, num: Integer): Integer;
var
  fp, fp1: TBufferedFileStream;
  pic: TArray<Byte>;
  I: Integer;
begin
  fp := TBufferedFileStream.Create(url, fmOpenRead);
  fp1 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_gray.yuv', fmCreate);

  SetLength(pic, w * h * 3 div 2);

  for I := 0 to num - 1 do
  begin
    fp.ReadBuffer(pic[0], w * h * 3 div 2);
    //Gray
    FillChar(pic[w * h], w * h div 2, 128);
    fp1.Write(pic[0], w * h * 3 div 2);
  end;

  fp1.Free;
  fp.Free;

  Result := 0;
end;

function simplest_yuv420_halfy(const url: string; w, h, num: Integer): Integer;
var
  fp, fp1: TBufferedFileStream;
  pic: TArray<Byte>;
  temp: Byte;
  I: Integer;
  J: Integer;
begin
  fp := TBufferedFileStream.Create(url, fmOpenRead);
  fp1 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_half.yuv', fmCreate);

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

    fp1.Write(pic[0], w * h * 3 div 2);
  end;

  fp1.Free;
  fp.Free;

  Result := 0;
end;

function simplest_yuv420_border(const url: string; w, h, border, num: Integer): Integer;
var
  fp, fp1: TBufferedFileStream;
  pic: TArray<Byte>;
  I: Integer;
  J: Integer;
  K: Integer;
begin
  fp := TBufferedFileStream.Create(url, fmOpenRead);
  fp1 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_border.yuv', fmCreate);

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

    fp1.Write(pic[0], w * h * 3 div 2);
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
  fp: TBufferedFileStream;
  data_y, data_u, data_v: TArray<Byte>;
  t, i, j: Integer;
begin
  barwidth := width div barnum;
  lum_inc := (ymax - ymin) / (barnum - 1);
  uv_width := width div 2;
  uv_height := height div 2;

  SetLength(data_y, width * height);
  SetLength(data_u, uv_width * uv_height);
  SetLength(data_v, uv_width * uv_height);

  fp := TBufferedFileStream.Create(OUTPUT_DIR + url_out, fmCreate);

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
  fp.Write(data_y[0], width * height);
  fp.Write(data_u[0], uv_width * uv_height);
  fp.Write(data_v[0], uv_width * uv_height);

  fp.Free;
  Result := 0;
end;

function simplest_yuv420_psnr(const url1, url2: string; w, h, num: Integer): Integer;
var
  fp1, fp2: TBufferedFileStream;
  pic1, pic2: TArray<Byte>;
  mse_sum, mse, psnr: Double;
  I: Integer;
  J: Integer;
begin
  fp1 := TBufferedFileStream.Create(url1, fmOpenRead);
  fp2 := TBufferedFileStream.Create(url2, fmOpenRead);

  SetLength(pic1, w * h);
  SetLength(pic2, w * h);

  mse_sum := 0;
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

function simplest_rgb24_split(const url: string; w, h, num: Integer): Integer;
var
  fp, fp1, fp2, fp3: TBufferedFileStream;
  pic: TArray<Byte>;
  I: Integer;
  j: Integer;
begin
  fp := TBufferedFileStream.Create(url, fmOpenRead);
  fp1 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_r.y', fmCreate);
  fp2 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_g.y', fmCreate);
  fp3 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_b.y', fmCreate);

  SetLength(pic, w * h * 3);

  for I := 0 to num - 1 do
  begin
    fp.ReadBuffer(pic[0], w * h * 3);
    j := 0;
    while j < w * h * 3 do
    begin
      //R
      fp1.Write(pic[j], 1);
      //G
      fp2.Write(pic[j + 1], 1);
      //B
      fp3.Write(pic[j + 2], 1);

      Inc(j, 3);
    end;
  end;

  fp3.Free;
  fp2.Free;
  fp1.Free;
  fp.Free;

  Result := 0;
end;

function simplest_rgb24_to_bmp(const rgb24path: string; width, height: Integer; const bmppath: string): Integer;
var
  m_BMPHeader: TBitmapFileHeader;
  m_BMPInfoHeader: TBitmapInfoHeader;
  header_size: Integer;
  rgb24_buffer: TArray<Byte>;
  fp_rgb24, fp_bmp: TBufferedFileStream;
  J: Integer;
  I: Integer;
  temp: Byte;
begin
  FillChar(m_BMPHeader, SizeOf(TBitmapFileHeader), 0);
  FillChar(m_BMPInfoHeader, SizeOf(TBitmapInfoHeader), 0);

  m_BMPHeader.bfType := $4D42;
  header_size := SizeOf(TBitmapFileHeader) + SizeOf(TBitmapInfoHeader);
  fp_rgb24 := TBufferedFileStream.Create(rgb24path, fmOpenRead);
  fp_bmp := TBufferedFileStream.Create(OUTPUT_DIR + bmppath, fmCreate);

  SetLength(rgb24_buffer, width * height * 3);
  fp_rgb24.ReadBuffer(rgb24_buffer[0], width * height * 3);

  m_BMPHeader.bfSize := 3 * width * height + header_size;
  m_BMPHeader.bfOffBits := header_size;

  m_BMPInfoHeader.biSize := SizeOf(TBitmapInfoHeader);
  m_BMPInfoHeader.biWidth := width;
  //BMP storage pixel data in opposite direction of Y-axis (from bottom to top).
  m_BMPInfoHeader.biHeight := -height;
  m_BMPInfoHeader.biPlanes := 1;
  m_BMPInfoHeader.biBitCount := 24;
  m_BMPInfoHeader.biSizeImage := width * height * 3;

  fp_bmp.Write(m_BMPHeader, SizeOf(TBitmapFileHeader));
  fp_bmp.Write(m_BMPInfoHeader, SizeOf(TBitmapInfoHeader));

  //BMP save R1|G1|B1,R2|G2|B2 as B1|G1|R1,B2|G2|R2
  //It saves pixel data in Little Endian
  //So we change 'R' and 'B'
  for J := 0 to height - 1 do
    for I := 0 to width - 1 do
    begin
      temp := rgb24_buffer[(J * width + I) * 3 + 2];
      rgb24_buffer[(J * width + I) * 3 + 2] := rgb24_buffer[(J * width + I) * 3 + 0];
      rgb24_buffer[(J * width + I) * 3 + 0] := temp;
    end;
  fp_bmp.Write(rgb24_buffer, width * height * 3);
  fp_bmp.Free;
  fp_rgb24.Free;
  Writeln(Format('Finish generate %s', [bmppath]));
  Result := 0;
end;

function clip_value(x, min_val, max_val: Byte): Byte;
begin
  if (x > max_val) then
    Exit(max_val)
  else if (x < min_val) then
    Exit(min_val)
  else
    Exit(x);
end;

//RGB to YUV420
function RGB24_TO_YUV420(RgbBuf: PByte; w, h: Integer; yuvBuf: PByte): Boolean;
var
  ptrY, ptrU, ptrV, ptrRGB: PByte;
  J: Integer;
  I: Integer;
  y, u, v, r, g, b: Byte;
begin
  FillChar(yuvBuf^, w * h * 3 div 2, 0);
  ptrY := yuvBuf;
  ptrU := yuvBuf + w * h;
  ptrV := ptrU + w * h div 4;
  for J := 0 to h - 1 do
  begin
    ptrRGB := RgbBuf + w * J * 3;
    for I := 0 to w - 1 do
    begin
      r := ptrRGB^;
      Inc(ptrRGB);
      g := ptrRGB^;
      Inc(ptrRGB);
      b := ptrRGB^;
      Inc(ptrRGB);
      y := ((66 * r + 129 * g + 25 * b + 128) shr 8) + 16;
      u := ((-38 * r - 74 * g + 112 * b + 128) shr 8) + 128;
      v := ((112 * r - 94 * g - 18 * b + 128) shr 8) + 128;

      ptrY^ := clip_value(y, 0, 255);
      Inc(ptrY);
      if ((J mod 2) = 0) and ((I mod 2) = 0) then
      begin
        ptrU^ := clip_value(u, 0, 255);
        Inc(ptrU);
      end
      else
      begin
        if (I mod 2 = 0) then
        begin
          ptrV^ := clip_value(v, 0, 255);
          Inc(ptrV);
        end;
      end;
    end;
  end;
  Result := True;
end;

function simplest_rgb24_to_yuv420(const url_in: string; w, h, num: Integer; const url_out: string): Integer;
var
  fp, fp1: TBufferedFileStream;
  pic_rgb24, pic_yuv420: TArray<Byte>;
  I: Integer;
begin
  fp := TBufferedFileStream.Create(url_in, fmOpenRead);
  fp1 := TBufferedFileStream.Create(OUTPUT_DIR + url_out, fmCreate);

  SetLength(pic_rgb24, w * h * 3);
  SetLength(pic_yuv420, w * h * 3 div 2);

  for I := 0 to num - 1 do
  begin
    fp.ReadBuffer(pic_rgb24[0], w * h * 3);
    RGB24_TO_YUV420(@pic_rgb24[0], w, h, @pic_yuv420[0]);
    fp1.Write(pic_yuv420[0], w * h * 3 div 2);
  end;

  fp1.Free;
  fp.Free;

  Result := 0;
end;

function simplest_rgb24_colorbar(width, height: Integer; const url_out: string): Integer;
var
  data: TArray<Byte>;
  barwidth: Integer;
  fp: TBufferedFileStream;
  i, j, barnum: Integer;
begin
  SetLength(data, width * height * 3);
  barwidth := width div 8;

  fp := TBufferedFileStream.Create(OUTPUT_DIR + url_out, fmCreate);

  for j := 0 to height - 1 do
  begin
    for i := 0 to width - 1 do
    begin
      barnum := i div barwidth;
      case barnum of
        0:
          begin
            data[(j * width + i) * 3 + 0] := 255;
            data[(j * width + i) * 3 + 1] := 255;
            data[(j * width + i) * 3 + 2] := 255;
          end;
        1:
          begin
            data[(j * width + i) * 3 + 0] := 255;
            data[(j * width + i) * 3 + 1] := 255;
            data[(j * width + i) * 3 + 2] := 0;
          end;
        2:
          begin
            data[(j * width + i) * 3 + 0] := 0;
            data[(j * width + i) * 3 + 1] := 255;
            data[(j * width + i) * 3 + 2] := 255;
          end;
        3:
          begin
            data[(j * width + i) * 3 + 0] := 0;
            data[(j * width + i) * 3 + 1] := 255;
            data[(j * width + i) * 3 + 2] := 0;
          end;
        4:
          begin
            data[(j * width + i) * 3 + 0] := 255;
            data[(j * width + i) * 3 + 1] := 0;
            data[(j * width + i) * 3 + 2] := 255;
          end;
        5:
          begin
            data[(j * width + i) * 3 + 0] := 255;
            data[(j * width + i) * 3 + 1] := 0;
            data[(j * width + i) * 3 + 2] := 0;
          end;
        6:
          begin
            data[(j * width + i) * 3 + 0] := 0;
            data[(j * width + i) * 3 + 1] := 0;
            data[(j * width + i) * 3 + 2] := 255;
          end;
        7:
          begin
            data[(j * width + i) * 3 + 0] := 0;
            data[(j * width + i) * 3 + 1] := 0;
            data[(j * width + i) * 3 + 2] := 0;
          end;
      end;
    end;
  end;
  fp.Write(data[0], width * height * 3);
  fp.Free;
  Result := 0;
end;

function simplest_pcm16le_split(const url: string): Integer;
var
  fp, fp1, fp2: TBufferedFileStream;
  sample: TArray<Byte>;
begin
  fp := TBufferedFileStream.Create(url, fmOpenRead);
  fp1 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_l.pcm', fmCreate);
  fp2 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_r.pcm', fmCreate);

  SetLength(sample, 4);
  while fp.Read(sample[0], 4) = 4 do
  begin
    // L
    fp1.Write(sample[0], 2);
    // R
    fp2.Write(sample[2], 2);
  end;

  fp2.Free;
  fp1.Free;
  fp.Free;
  Result := 0;
end;

function simplest_pcm16le_halfvolumeleft(const url: string): Integer;
var
  fp, fp1: TBufferedFileStream;
  sample: TArray<Byte>;
  samplenum: PSmallInt;
begin
  fp := TBufferedFileStream.Create(url, fmOpenRead);
  fp1 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_halfleft.pcm', fmCreate);

  SetLength(sample, 4);

  while fp.Read(sample[0], 4) = 4 do
  begin
    samplenum := @sample[0];
    samplenum^ := samplenum^ div 2;

    // L
    fp1.Write(sample[0], 2);
    // R
    fp1.Write(sample[2], 2);
  end;

  fp1.Free;
  fp.Free;
  Result := 0;
end;

function simplest_pcm16le_doublespeed(const url: string): Integer;
var
  fp, fp1: TBufferedFileStream;
  sample: TArray<Byte>;
  cnt: Integer;
begin
  fp := TBufferedFileStream.Create(url, fmOpenRead);
  fp1 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_doublespeed.pcm', fmCreate);

  cnt := 0;
  SetLength(sample, 4);

  while fp.Read(sample[0], 4) = 4 do
  begin
    if (cnt mod 2) = 0 then
    begin
      // L
      fp1.Write(sample[0], 2);
      // R
      fp1.Write(sample[2], 2);
    end;
    Inc(cnt);
  end;

  Writeln(Format('Sample Cnt:%d', [cnt]));

  fp1.Free;
  fp.Free;
  Result := 0;
end;

function simplest_pcm16le_to_pcm8(const url: string): Integer;
var
  fp, fp1: TBufferedFileStream;
  sample: TArray<Byte>;
  cnt: Integer;
  samplenum16: PSmallInt;
  samplenum8: Int8;
  samplenum8_u: UInt8;
begin
  fp := TBufferedFileStream.Create(url, fmOpenRead);
  fp1 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_8.pcm', fmCreate);

  cnt := 0;
  SetLength(sample, 4);

  while fp.Read(sample[0], 4) = 4 do
  begin
    samplenum16 := @sample[0];
    samplenum8 := samplenum16^ shr 8;
    //(0-255)
    samplenum8_u := samplenum8 + 128;
    // L
    fp1.WriteData(samplenum8_u);

    samplenum16 := @sample[2];
    samplenum8 := samplenum16^ shr 8;
    samplenum8_u := samplenum8 + 128;
    // R
    fp1.WriteData(samplenum8_u);
    Inc(cnt);
  end;

  Writeln(Format('Sample Cnt:%d', [cnt]));

  fp1.Free;
  fp.Free;
  Result := 0;
end;

function simplest_pcm16le_cut_singlechannel(const url: string; start_num, dur_num: Integer): Integer;
var
  fp, fp1, fp_stat: TBufferedFileStream;
  writer: TStreamWriter;
  sample: TArray<Byte>;
  cnt: Integer;
  samplenum: Int16;
begin
  fp := TBufferedFileStream.Create(url, fmOpenRead);
  fp1 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_cut.pcm', fmCreate);
  fp_stat := TBufferedFileStream.Create(OUTPUT_DIR + 'output_cut.txt', fmCreate);
  writer := TStreamWriter.Create(fp_stat);

  cnt := 0;
  SetLength(sample, 4);

  while fp.Read(sample[0], 2) = 2 do
  begin
    if (cnt > start_num) and (cnt <= (start_num + dur_num)) then
    begin
      fp1.Write(sample[0], 2);
      samplenum := sample[1];
      samplenum := samplenum * 256;
      samplenum := samplenum + sample[0];
      writer.Write(Format('%6d,', [samplenum]));
      if (cnt mod 10) = 0 then
        writer.WriteLine;
    end;
    Inc(cnt);
  end;

  writer.Free;
  fp_stat.Free;
  fp1.Free;
  fp.Free;
  Result := 0;
end;

function simplest_pcm16le_to_wave(const pcmpath: string; channels, sample_rate: Integer; const wavepath: string): Integer;
type
  WAVE_HEADER = packed record
    fccID: DWORD; {'RIFF'}
    dwSize: DWORD; {文件大小, 不包括前 8 个字节}
    fccType: DWORD; {'WAVE'}
  end;

  WAVE_FMT = packed record
    fccID: DWORD;
    dwSize: DWord;
    wFormatTag: Word;         { format type }
    wChannels: Word;          { number of channels (i.e. mono, stereo, etc.) }
    dwSamplesPerSec: DWORD;  { sample rate }
    dwAvgBytesPerSec: DWORD; { for buffer estimation }
    wBlockAlign: Word;
    wBitsPerSample: Word;
  end;

  WAVE_DATA = packed record
    fccID: DWORD;
    dwSize: DWORD;
  end;
var
  bits: Integer;
  pcmHEADER: WAVE_HEADER;
  pcmFMT: WAVE_FMT;
  pcmDATA: WAVE_DATA;
  m_pcmData: Word;
  fp, fpout: TBufferedFileStream;
begin
  if (channels = 0) or (sample_rate = 0) then
  begin
    channels := 2;
    sample_rate := 44100;
  end;
  bits := 16;

  fp := TBufferedFileStream.Create(pcmpath, fmOpenRead);
  fpout := TBufferedFileStream.Create(OUTPUT_DIR + wavepath, fmCreate);

  pcmHEADER.fccID := FOURCC_RIFF;
  pcmHEADER.fccType := mmioStringToFOURCC('WAVE', 0);
  fpout.Seek(SizeOf(WAVE_HEADER), TSeekOrigin.soCurrent);
  //WAVE_FMT
  pcmFMT.dwSamplesPerSec := sample_rate;
  pcmFMT.dwAvgBytesPerSec := channels * pcmFMT.dwSamplesPerSec * sizeof(m_pcmData);
  pcmFMT.wBitsPerSample := bits;

  pcmFMT.fccID := mmioStringToFOURCC('fmt ', 0);
  pcmFMT.dwSize := 16;
  pcmFMT.wBlockAlign := channels * bits div 8;
  pcmFMT.wChannels := channels;
  pcmFMT.wFormatTag := WAVE_FORMAT_PCM;

  fpout.Write(pcmFMT, SizeOf(WAVE_FMT));

  //WAVE_DATA;
  pcmDATA.fccID := mmioStringToFOURCC('data', 0);
  pcmDATA.dwSize := 0;
  fpout.Seek(SizeOf(WAVE_DATA), TSeekOrigin.soCurrent);
  while fp.Read(m_pcmData, 2) = 2 do
  begin
    fpout.Write(m_pcmData, 2);
    Inc(pcmDATA.dwSize, 2);
  end;

  pcmHEADER.dwSize := 36 + pcmDATA.dwSize;

  fpout.Seek(0, TSeekOrigin.soBeginning);
  fpout.Write(pcmHEADER, sizeof(WAVE_HEADER));
  fpout.Seek(sizeof(WAVE_FMT), TSeekOrigin.soCurrent);
  fpout.Write(pcmDATA, sizeof(WAVE_DATA));

  fpout.Free;
  fp.Free;
  Result := 0;
end;

end.

