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

unit simplest_mediadata_h264;

interface

uses
  System.Classes,
  System.SysUtils;

const
  OUTPUT_DIR = 'output\';

type
  TNaluType = (
    NALU_TYPE_SLICE    = 1,
    NALU_TYPE_DPA      = 2,
    NALU_TYPE_DPB      = 3,
    NALU_TYPE_DPC      = 4,
    NALU_TYPE_IDR      = 5,
    NALU_TYPE_SEI      = 6,
    NALU_TYPE_SPS      = 7,
    NALU_TYPE_PPS      = 8,
    NALU_TYPE_AUD      = 9,
    NALU_TYPE_EOSEQ    = 10,
    NALU_TYPE_EOSTREAM = 11,
    NALU_TYPE_FILL     = 12
  );

  TNaluPriority = (
    NALU_PRIORITY_DISPOSABLE = 0,
    NALU_PRIRITY_LOW         = 1,
    NALU_PRIORITY_HIGH       = 2,
    NALU_PRIORITY_HIGHEST    = 3
  );

  PNALU = ^TNALU;
  TNALU = packed record
    startcodeprefix_len: Int32;      //! 4 for parameter sets and first slice in picture, 3 for everything else (suggested)
    len: UInt32;                     //! Length of the NAL unit (Excluding the start code, which does not belong to the NALU)
    max_size: UInt32;                //! Nal Unit Buffer size
    forbidden_bit: Int32;            //! should be always FALSE
    nal_reference_idc: Int32;        //! NALU_PRIORITY_xxxx
    nal_unit_type: Int32;            //! NALU_TYPE_xxxx
    buf: PByte;                    //! contains the first byte followed by the EBSP
  end;

function FindStartCode2(Buf: PByte): Integer;
function FindStartCode3(Buf: PByte): Integer;
function GetAnnexbNALU(var nalu: TNALU): Integer;

/// <summary>
/// Analysis H.264 Bitstream
/// </summary>
/// <param name="url">Location of input H.264 bitstream file.</param>
function simplest_h264_parser(const url: string): Integer;

var
  h264bitstream: TFileStream;
  info2: Integer = 0;
  info3: Integer = 0;
implementation

function FindStartCode2(Buf: PByte): Integer;
begin
  if (Buf[0] <> 0) or (Buf[1] <> 0) or (Buf[2] <> 1) then
    Result := 0 //0x000001?
  else
    Result := 1;
end;

function FindStartCode3(Buf: PByte): Integer;
begin
  if (Buf[0] <> 0) or (Buf[1] <> 0) or (Buf[2] <> 0) or (Buf[3] <> 1) then
    Result := 0 //0x00000001?
  else
    Result := 1;
end;

function GetAnnexbNALU(var nalu: TNALU): Integer;
var
  pos: Integer;
  rewind: Integer;
  StartCodeFound: Boolean;
  Buf: TArray<Byte>;
  FileSize: Int64;
begin
  pos := 0;
  SetLength(Buf, nalu.max_size);
  nalu.startcodeprefix_len := 3;
  if 3 <> h264bitstream.Read(Buf[0], 3) then
  begin
    Exit(0);
  end;

  info2 := FindStartCode2(@Buf[0]);
  if(info2 <> 1) then
  begin
    if(1 <> h264bitstream.Read(Buf[3], 1)) then
    begin
      Exit(0);
    end;
    info3 := FindStartCode3(@Buf[0]);
    if (info3 <> 1) then
    begin
      Exit(-1);
    end
    else
    begin
      pos := 4;
      nalu.startcodeprefix_len := 4;
    end;
  end
  else
  begin
    nalu.startcodeprefix_len := 3;
    pos := 3;
  end;
  StartCodeFound := False;
  info2 := 0;
  info3 := 0;

  FileSize := h264bitstream.Size;
  while (not StartCodeFound) do
  begin
      if (h264bitstream.Position >= FileSize) then
      begin
        nalu.len := (pos-1)-nalu.startcodeprefix_len;
        Move(Buf[nalu.startcodeprefix_len], nalu.buf^, nalu.len);
        nalu.forbidden_bit := nalu.buf[0] and $80; //1 bit
        nalu.nal_reference_idc := nalu.buf[0] and $60; // 2 bit
        nalu.nal_unit_type := (nalu.buf[0]) and $1f;// 5 bit
        Exit(pos-1);
      end;
      h264bitstream.Read(Buf[pos], 1);

      Inc(pos);
      info3 := FindStartCode3(@Buf[pos-4]);
      if(info3 <> 1) then
        info2 := FindStartCode2(@Buf[pos-3]);
      StartCodeFound := (info2 = 1) or (info3 = 1);
    end;

    // Here, we have found another start code (and read length of startcode bytes more than we should
    // have.  Hence, go back in the file
    if info3 = 1 then
      rewind := -4
    else
      rewind := -3;

    if h264bitstream.Seek(rewind, TSeekOrigin.soCurrent) = -1 then
    begin
      Writeln('GetAnnexbNALU: Cannot fseek in the bit stream file');
    end;

    // Here the Start code, the complete NALU, and the next start code is in the Buf.
    // The size of Buf is pos, pos+rewind are the number of bytes excluding the next
    // start code, and (pos+rewind)-startcodeprefix_len is the size of the NALU excluding the start code
    nalu.len := (pos+rewind)-nalu.startcodeprefix_len;
    Move(Buf[nalu.startcodeprefix_len], nalu.buf^, nalu.len);//
    nalu.forbidden_bit := nalu.buf[0] and $80; //1 bit
    nalu.nal_reference_idc := nalu.buf[0] and $60; // 2 bit
    nalu.nal_unit_type := (nalu.buf[0]) and $1f;// 5 bit        00000000000000
    Result := (pos+rewind);
end;

function simplest_h264_parser(const url: string): Integer;
var
  n: TNALU;
  buffersize: Integer;
  myout: TFileStream;
  writer: TStreamWriter;
  data_offset, nal_num, data_lenth: Integer;
  type_str, idc_str: string;
begin
  buffersize := 100000;

  myout := TFileStream.Create(OUTPUT_DIR + 'output_log.txt', fmCreate);
  writer := TStreamWriter.Create(myout);

  h264bitstream := TBufferedFileStream.Create(url, fmOpenRead);

  n.max_size := buffersize;
  GetMem(n.buf, buffersize);

  data_offset := 0;
  nal_num := 0;
  WriteLn('-----+-------- NALU Table ------+---------+');
  WriteLn(' NUM |    POS  |    IDC |  TYPE |   LEN   |');
  WriteLn('-----+---------+--------+-------+---------+');

  while (h264bitstream.Position < h264bitstream.Size) do
  begin
    data_lenth := GetAnnexbNALU(n);

    type_str := '';
    case TNaluType(n.nal_unit_type) of
      NALU_TYPE_SLICE:
        type_str := 'SLICE';
      NALU_TYPE_DPA:
        type_str := 'DPA';
      NALU_TYPE_DPB:
        type_str := 'DPB';
      NALU_TYPE_DPC:
        type_str := 'DPC';
      NALU_TYPE_IDR:
        type_str := 'IDR';
      NALU_TYPE_SEI:
        type_str := 'SEI';
      NALU_TYPE_SPS:
        type_str := 'SPS';
      NALU_TYPE_PPS:
        type_str := 'PPS';
      NALU_TYPE_AUD:
        type_str := 'AUD';
      NALU_TYPE_EOSEQ:
        type_str := 'EOSEQ';
      NALU_TYPE_EOSTREAM:
        type_str := 'EOSTREAM';
      NALU_TYPE_FILL:
        type_str := 'FILL';
    end;
    idc_str := '';
    case TNaluPriority(n.nal_reference_idc shr 5) of
      NALU_PRIORITY_DISPOSABLE:
        idc_str := 'DISPOS';
      NALU_PRIRITY_LOW:
        idc_str := 'LOW';
      NALU_PRIORITY_HIGH:
        idc_str := 'HIGH';
      NALU_PRIORITY_HIGHEST:
        idc_str := 'HIGHEST';
    end;
    WriteLn(Format('%5d| %8d| %7s| %6s| %8d|', [nal_num, data_offset, idc_str, type_str, n.len]));

    data_offset := data_offset + data_lenth;

    Inc(nal_num);
  end;

  //Free
  if (n.buf <> nil) then
  begin
    FreeMem(n.buf);
    n.buf := nil;
  end;

  h264bitstream.Free;
  writer.Free;
  myout.Free;
  Result := 0;
end;
end.
