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

// ADTS全称是(Audio Data Transport Stream)，是AAC的一种十分常见的传输格式。
//
// ADTS内容及结构
// 一般情况下ADTS的头信息都是7个字节，分为2部分：
// adts_fixed_header();
// adts_variable_header();
//
// syntax
// adts_fixed_header(){
// syncword; 12 bslbf
// ID; 1 bslbf
// layer;2 uimsbf
// protection_absent;1 bslbf
// profile;2 uimsbf
// sampling_frequency_index;4 uimsbf
// private_bit;1 bslbf
// channel_configuration;3 uimsbf
// original_copy;1 bslbf
// home;1 bslbf
// }
// syncword ：同步头 总是0xFFF, all bits must be 1，代表着一个ADTS帧的开始
//
// ID：MPEG Version: 0 for MPEG-4, 1 for MPEG-2
//
// Layer：always: '00'
//
// profile：表示使用哪个级别的AAC，有些芯片只支持AAC LC 。在MPEG-2 AAC中定义了3种：
// 0:Main profile
// 1:Low Complexity profile(LC)
// 2:Scalable sampling Rate Profile(SSR)
// 3:Reserved
//
//
// sampling_frequency_index：表示使用的采样率下标，通过这个下标在 Sampling Frequencies[ ]数组中查找得知采样率的值。
// There are 13 supported frequencies:
// 0: 96000 Hz
// 1: 88200 Hz
// 2: 64000 Hz
// 3: 48000 Hz
// 4: 44100 Hz
// 5: 32000 Hz
// 6: 24000 Hz
// 7: 22050 Hz
// 8: 16000 Hz
// 9: 12000 Hz
// 10: 11025 Hz
// 11: 8000 Hz
// 12: 7350 Hz
// 13: Reserved
// 14: Reserved
// 15: frequency is written explictly
//
//
// channel_configuration: 表示声道数
// 0: Defined in AOT Specifc Config
// 1: 1 channel: front-center
// 2: 2 channels: front-left, front-right
// 3: 3 channels: front-center, front-left, front-right
// 4: 4 channels: front-center, front-left, front-right, back-center
// 5: 5 channels: front-center, front-left, front-right, back-left, back-right
// 6: 6 channels: front-center, front-left, front-right, back-left, back-right, LFE-channel
// 7: 8 channels: front-center, front-left, front-right, side-left, side-right, back-left, back-right, LFE-channel
// 8-15: Reserved
//
// syntax
// adts_variable_header(){
// copyright_identiflaction_bit;1 bslbf
// copyright_identification_start;1 bslbf
// acc_frame_length;13 bslbf;
// adts_buffer_fullness; 11 bslbf
// number_of_raw_data_blocks_in_frame;2 uimsfb
// }
//
// frame_length : 一个ADTS帧的长度包括ADTS头和AAC原始流.
//
// adts_buffer_fullness：0x7FF 说明是码率可变的码流

unit simplest_mediadata_aac;

interface

uses
  System.Classes,
  System.SysUtils;

function simplest_aac_parser(const url: string): Integer;

implementation

function getADTSframe(buffer: PByte; buf_size: Integer; data: PByte; var data_size: Integer): Integer;
var
  size: Integer;
begin
  size := 0;

  if (buffer = nil) or (data = nil) then
  begin
    Exit(-1);
  end;

  while (True) do
  begin
    if (buf_size < 7) then
    begin
      Exit(-1);
    end;

    // Sync words
    if ((buffer[0] = $FF) and ((buffer[1] and $F0) = $F0)) then
    begin
      size := size or ((buffer[3] and $03) shl 11); // high 2 bit
      size := size or buffer[4] shl 3; // middle 8 bit
      size := size or ((buffer[5] and $E0) shr 5); // low 3bit
      break;
    end;
    Dec(buf_size);
    Inc(buffer);
  end;

  if (buf_size < size) then
  begin
    Exit(1);
  end;

  Move(buffer^, data^, size);
  data_size := size;

  Result := 0;
end;

function simplest_aac_parser(const url: string): Integer;
var
  data_size: Integer;
  size: Integer;
  cnt: Integer;
  offset: Integer;
  aacframe, aacbuffer: TArray<Byte>;
  ifile: TBufferedFileStream;
  FileSize: Int64;
  input_data: PByte;
  ret: Integer;
  profile_str, frequence_str: string;
  profile, sampling_frequency_index: Byte;
begin
  data_size := 0;
  size := 0;
  cnt := 0;
  offset := 0;

  SetLength(aacframe, 1024 * 5);
  SetLength(aacbuffer, 1024 * 1024);

  ifile := TBufferedFileStream.Create(url, fmOpenRead);

  WriteLn('-----+- ADTS Frame Table -+------+');
  WriteLn(' NUM | Profile | Frequency| Size |');
  WriteLn('-----+---------+----------+------+');

  FileSize := ifile.size;
  while (ifile.Position < FileSize) do
  begin
    data_size := ifile.Read(aacbuffer[offset], 1024 * 1024 - offset);
    input_data := @aacbuffer[0];

    while (True) do
    begin
      ret := getADTSframe(input_data, data_size, @aacframe[0], size);
      if (ret = -1) then
      begin
        break;
      end
      else if (ret = 1) then
      begin
        Move(input_data[0], aacbuffer[0], data_size);
        offset := data_size;
        break;
      end;

      profile_str := '';
      frequence_str := '';

      profile := aacframe[2] and $C0;
      profile := profile shr 6;
      case profile of
        0:
          profile_str := 'Main';
        1:
          profile_str := 'LC';
        2:
          profile_str := 'SSR';
      else
        profile_str := 'unknown';
      end;

      sampling_frequency_index := aacframe[2] and $3C;
      sampling_frequency_index := sampling_frequency_index shr 2;
      case sampling_frequency_index of
        0:
          frequence_str := '96000Hz';
        1:
          frequence_str := '88200Hz';
        2:
          frequence_str := '64000Hz';
        3:
          frequence_str := '48000Hz';
        4:
          frequence_str := '44100Hz';
        5:
          frequence_str := '32000Hz';
        6:
          frequence_str := '24000Hz';
        7:
          frequence_str := '22050Hz';
        8:
          frequence_str := '16000Hz';
        9:
          frequence_str := '12000Hz';
        10:
          frequence_str := '11025Hz';
        11:
          frequence_str := '8000Hz';
      else
        frequence_str := 'unknown';
      end;

      WriteLn(Format('%5d| %8s|  %8s| %5d|', [cnt, profile_str, frequence_str, size]));
      Dec(data_size, size);
      Inc(input_data, size);
      Inc(cnt);
    end;

  end;
  ifile.Free;

  Result := 0;
end;

end.
