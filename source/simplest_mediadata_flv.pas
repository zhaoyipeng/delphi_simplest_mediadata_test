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
  System.Classes, System.SysUtils;

const
  OUTPUT_DIR = 'output\';

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
  FileSize: Int64;
  tagheader_datasize, tagheader_timestamp: Integer;
  tagtype_str, audiotag_str, videotag_str: string;
  tagdata_first_byte: Byte;
  x, data_size, i: Integer;
  b: Byte;
  myout: TFileStream;
  writer: TStreamWriter;
  temp: PByte;
begin
  //whether output audio/video stream
  output_a := 1;
  output_v := 1;
  vfh := nil;
  afh := nil;

  myout := TFileStream.Create(OUTPUT_DIR + 'simplest_flv_parser_log.txt', fmCreate);
  writer := TStreamWriter.Create(myout);

   //-------------

  previoustagsize_z := 0;
  ts := 0;
  ts_new := 0;

  ifh := TBufferedFileStream.Create(url, fmOpenRead);

  //FLV file header
  ifh.Read(flv, SizeOf(FLV_HEADER));

  writer.writeline('=============== FLV Header ==============');
  writer.writeline(Format('Signature:  0x %s %s %s', [Chr(flv.Signature[0]), Chr(flv.Signature[1]), Chr(flv.Signature[2])]));
  writer.writeline(Format('Version:    0x %X', [flv.Version]));
  writer.writeline(Format('Flags  :    0x %X', [flv.Flags]));
  writer.writeline(Format('HeaderSize: 0x %X', [reverse_bytes(@flv.DataOffset, SizeOf(flv.DataOffset))]));
  writer.writeline('=========================================');

  //move the file pointer to the end of the header
  ifh.Seek(reverse_bytes(PByte(@flv.DataOffset), SizeOf(flv.DataOffset)), TSeekOrigin.soBeginning);

  FileSize := ifh.Size;
  //process each tag
  repeat
    ifh.ReadData(previoustagsize);

    ifh.Read(tagheader, SizeOf(TAG_HEADER));

    tagheader_datasize := tagheader.DataSize[0] * 65536 + tagheader.DataSize[1] * 256 + tagheader.DataSize[2];
    tagheader_timestamp := tagheader.Timestamp[0] * 65536 + tagheader.Timestamp[1] * 256 + tagheader.Timestamp[2];

    tagtype_str := '';
    case tagheader.TagType of
      TAG_TYPE_AUDIO:
        tagtype_str := 'AUDIO';
      TAG_TYPE_VIDEO:
        tagtype_str := 'VIDEO';
      TAG_TYPE_SCRIPT:
        tagtype_str := 'SCRIPT';
    else
      tagtype_str := 'UNKNOWN';
    end;
    writer.write(Format('[%6s] %6d %6d |', [tagtype_str, tagheader_datasize, tagheader_timestamp]));


    //if we are not past the end of file, process the tag
    if (ifh.Position >= FileSize) then
    begin
      Break;
    end;

      //process tag by type
    case tagheader.TagType of
      TAG_TYPE_AUDIO:
        begin
          audiotag_str := '| ';
          ifh.ReadData(tagdata_first_byte);
          x := tagdata_first_byte and $F0;
          x := x shr 4;
          case x of
            0:
              audiotag_str := audiotag_str + 'Linear PCM, platform endian';
            1:
              audiotag_str := audiotag_str + 'ADPCM';
            2:
              audiotag_str := audiotag_str + 'MP3';
            3:
              audiotag_str := audiotag_str + 'Linear PCM, little endian';
            4:
              audiotag_str := audiotag_str + 'Nellymoser 16-kHz mono';
            5:
              audiotag_str := audiotag_str + 'Nellymoser 8-kHz mono';
            6:
              audiotag_str := audiotag_str + 'Nellymoser';
            7:
              audiotag_str := audiotag_str + 'G.711 A-law logarithmic PCM';
            8:
              audiotag_str := audiotag_str + 'G.711 mu-law logarithmic PCM';
            9:
              audiotag_str := audiotag_str + 'reserved';
            10:
              audiotag_str := audiotag_str + 'AAC';
            11:
              audiotag_str := audiotag_str + 'Speex';
            14:
              audiotag_str := audiotag_str + 'MP3 8-Khz';
            15:
              audiotag_str := audiotag_str + 'Device-specific sound';
          else
            audiotag_str := audiotag_str + 'UNKNOWN';
          end;
          audiotag_str := audiotag_str + '| ';
          x := tagdata_first_byte and $0C;
          x := x shr 2;
          case x of
            0:
              audiotag_str := audiotag_str + '5.5-kHz';
            1:
              audiotag_str := audiotag_str + '1-kHz';
            2:
              audiotag_str := audiotag_str + '22-kHz';
            3:
              audiotag_str := audiotag_str + '44-kHz';
          else
            audiotag_str := audiotag_str + 'UNKNOWN';
          end;
          audiotag_str := audiotag_str + '| ';
          x := tagdata_first_byte and $02;
          x := x shr 1;
          case x of
            0:
              audiotag_str := audiotag_str + '8Bit';
            1:
              audiotag_str := audiotag_str + '16Bit';
          else
            audiotag_str := audiotag_str + 'UNKNOWN';
          end;
          audiotag_str := audiotag_str + '| ';
          x := tagdata_first_byte and $01;
          case x of
            0:
              audiotag_str := audiotag_str + 'Mono';
            1:
              audiotag_str := audiotag_str + 'Stereo';
          else
            audiotag_str := audiotag_str + 'UNKNOWN';
          end;
          writer.write(audiotag_str);

          //if the output file hasn't been opened, open it.
          if (output_a <> 0) and (afh = nil) then
          begin
            afh := TBufferedFileStream.Create(OUTPUT_DIR + 'output.mp3', fmCreate);
          end;

          //TagData - First Byte Data
          data_size := reverse_bytes(PByte(@tagheader.DataSize), SizeOf(tagheader.DataSize)) - 1;
          if (output_a <> 0) then
          begin
            //TagData+1
            for i := 0 to data_size - 1 do
            begin
              ifh.ReadData(b);
              afh.WriteData(b);
            end;
          end
          else
          begin
            for i := 0 to data_size - 1 do
              ifh.ReadData(b);
          end;
        end;
      TAG_TYPE_VIDEO:
        begin
          videotag_str := '| ';
          ifh.ReadData(tagdata_first_byte);
          x := tagdata_first_byte and $F0;
          x := x shr 4;
          case x of
            1:
              videotag_str := videotag_str + 'key frame  ';
            2:
              videotag_str := videotag_str + 'inter frame';
            3:
              videotag_str := videotag_str + 'disposable inter frame';
            4:
              videotag_str := videotag_str + 'generated keyframe';
            5:
              videotag_str := videotag_str + 'video info/command frame';
          else
            videotag_str := videotag_str + 'UNKNOWN';
          end;
          videotag_str := videotag_str + '| ';
          x := tagdata_first_byte and $0F;
          case x of
            1:
              videotag_str := videotag_str + 'JPEG (currently unused)';
            2:
              videotag_str := videotag_str + 'Sorenson H.263';
            3:
              videotag_str := videotag_str + 'Screen video';
            4:
              videotag_str := videotag_str + 'On2 VP6';
            5:
              videotag_str := videotag_str + 'On2 VP6 with alpha channel';
            6:
              videotag_str := videotag_str + 'Screen video version 2';
            7:
              videotag_str := videotag_str + 'AVC';
          else
            videotag_str := videotag_str + 'UNKNOWN';
          end;
          writer.write(videotag_str);

          ifh.Seek(-1, TSeekOrigin.soCurrent);
          //if the output file hasn't been opened, open it.
          if (vfh = nil) and (output_v <> 0) then
          begin
            //write the flv header (reuse the original file's hdr) and first previoustagsize
            vfh := TBufferedFileStream.Create(OUTPUT_DIR + 'output.flv', fmCreate);
            vfh.write(flv, SizeOf(flv));
            vfh.write(previoustagsize_z, SizeOf(previoustagsize_z));
          end;
{$IFDEF 0}
          //Change Timestamp
          //Get Timestamp
          ts := reverse_bytes(PByte(@tagheader.Timestamp), SizeOf(tagheader.Timestamp));
          ts := ts * 2;
          //Writeback Timestamp
          ts_new := reverse_bytes(PByte(@ts), SizeOf(ts));
          temp := PByte(@ts_new);
          Inc(temp);
          Move(temp^, tagheader.Timestamp, SizeOf(tagheader.Timestamp));
{$ENDIF}

            //TagData + Previous Tag Size
          data_size := reverse_bytes(PByte(@tagheader.DataSize), SizeOf(tagheader.DataSize)) + 4;
          if (output_v <> 0) then
          begin
                //TagHeader
            vfh.write(tagheader, SizeOf(tagheader));
                //TagData
            for i := 0 to data_size - 1 do
            begin
              ifh.ReadData(b);
              vfh.WriteData(b);
            end;

          end
          else
          begin
            for i := 0 to data_size - 1 do
              ifh.ReadData(b);
          end;
    //rewind 4 bytes, because we need to read the previoustagsize again for the loop's sake
          ifh.Seek(-4, TSeekOrigin.soCurrent);
        end;
    else
      //skip the data of this tag
      ifh.Seek(reverse_bytes(PByte(@tagheader.DataSize), SizeOf(tagheader.DataSize)), TSeekOrigin.soCurrent);
    end;

    writer.WriteLine;
  until ifh.Position >= FileSize;

  writer.Free;
  myout.Free;
  vfh.Free;
  afh.Free;
  ifh.Free;
end;

end.

