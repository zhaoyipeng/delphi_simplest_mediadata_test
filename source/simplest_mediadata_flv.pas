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
*)

unit simplest_mediadata_flv;

interface

uses
  System.Classes,
  System.SysUtils;

const
  TAG_TYPE_SCRIPT = 18;
  TAG_TYPE_AUDIO = 8;
  TAG_TYPE_VIDEO = 9;

type
  FLV_HEADER = packed record
    Signature: array[0..2] of Byte;
    Version: Byte;
    Flags: Byte;
    DataOffset: UInt32;
  end;

  TAG_HEADER = packed record
    TagType: Byte;
    DataSize: array[0..2] of Byte;
    Timestamp: array[0..2] of Byte;
    Reserved: UInt32;
  end;

/// <summary>
/// Analysis FLV file
/// </summary>
/// <param name="url">Location of input FLV file.</param>
function simplest_flv_parser(const url: string): Integer;

implementation

//reverse_bytes - turn a BigEndian byte array into a LittleEndian integer
function reverse_bytes(p: PByte; c: Byte): UInt32;
var
  r, i: Integer;
begin
  r := 0;
  for i := 0 to c - 1 do
  begin
    r := r or (p[i] shl (((c - 1) * 8) - 8 * i));
  end;
  Result := r;
end;

function simplest_flv_parser(const url: string): Integer;
var
  output_a: Integer;
  output_v: Integer;
  ifh, vfh, afh: TFileStream;
  flv: FLV_HEADER;
  tagheader: TAG_HEADER;
  previoustagsize, previoustagsize_z: UInt32;
  ts, ts_new: UInt32;
begin
  //whether output audio/video stream
  output_a := 1;
  output_v := 1;

   //-------------

  previoustagsize_z := 0;
  ts := 0;
  ts_new := 0;

  ifh := TBufferedFileStream.Create(url, fmOpenRead);

  //FLV file header
  ifh.Read(flv, sizeof(FLV_HEADER));

  Writeln('=============== FLV Header ==============');
  Writeln(Format('Signature:  0x %s %s %s', [Chr(flv.Signature[0]), Chr(flv.Signature[1]), Chr(flv.Signature[2])]));
  Writeln(Format('Version:    0x %X', [flv.Version]));
  Writeln(Format('Flags  :    0x %X', [flv.Flags]));
  Writeln(Format('HeaderSize: 0x %X', [reverse_bytes(@flv.DataOffset, sizeof(flv.DataOffset))]));
  Writeln('=========================================');

  ifh.Free;
end;

end.

