unit simplest_mediadata_raw;

interface

uses
  System.Classes,
  System.SysUtils;

/// <summary>
/// Split Y, U, V planes in YUV420P file.
/// </summary>
/// <param name="url">Location of Input YUV file.</param>
/// <param name="w">Width of Input YUV file.</param>
/// <param name="h">Height of Input YUV file.</param>
/// <param name="num">Number of frames to process.</param>
function simplest_yuv420_split(const url: string; w, h, num: Integer): Integer;

implementation

function simplest_yuv420_split(const url: string; w, h, num: Integer): Integer;
var
  fp, fp1, fp2, fp3: TFileStream;
  pic: TArray<Byte>;
  I: Integer;
begin
  fp := TFileStream.Create(url, fmOpenRead);
  fp1 := TFileStream.Create('output_420_y.y', fmCreate);
  fp2 := TFileStream.Create('output_420_u.y', fmCreate);
  fp3 := TFileStream.Create('output_420_v.y', fmCreate);

  SetLength(pic, w*h*3 div 2);

  for I := 0 to num-1 do
  begin
    fp.ReadBuffer(pic[0], w*h*3 div 2);
    //Y
    fp1.WriteBuffer(pic[0], w*h);
    //U
    fp2.WriteBuffer(pic[w*h], w*h div 4);
    //V
    fp3.WriteBuffer(pic[w*h*5 div 4], w*h div 4);
  end;

  fp3.Free;
  fp2.Free;
  fp1.Free;
  fp.Free;

  Result := 0;
end;
end.
