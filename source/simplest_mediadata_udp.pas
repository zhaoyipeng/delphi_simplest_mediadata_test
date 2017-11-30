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
unit simplest_mediadata_udp;

interface

uses
  System.Classes,
  System.SysUtils,
  Winapi.Windows,
  Winapi.Winsock2;

const
  OUTPUT_DIR = 'output\';

type
  RTP_FIXED_HEADER = packed record
    flag0: word;
    seq_no: word;
    timestamp: dword;
    ssrc: dword;
  end;

const
  bm_RTP_FIXED_HEADER_csrc_len = $F;
  bp_RTP_FIXED_HEADER_csrc_len = 0;
  bm_RTP_FIXED_HEADER_extension = $10;
  bp_RTP_FIXED_HEADER_extension = 4;
  bm_RTP_FIXED_HEADER_padding = $20;
  bp_RTP_FIXED_HEADER_padding = 5;
  bm_RTP_FIXED_HEADER_version = $C0;
  bp_RTP_FIXED_HEADER_version = 6;
  bm_RTP_FIXED_HEADER_payload = $7F00;
  bp_RTP_FIXED_HEADER_payload = 8;
  bm_RTP_FIXED_HEADER_marker = $8000;
  bp_RTP_FIXED_HEADER_marker = 15;

function csrc_len(var a: RTP_FIXED_HEADER): Byte;

procedure set_csrc_len(var a: RTP_FIXED_HEADER; __csrc_len: byte);

function extension(var a: RTP_FIXED_HEADER): byte;

procedure set_extension(var a: RTP_FIXED_HEADER; __extension: byte);

function padding(var a: RTP_FIXED_HEADER): byte;

procedure set_padding(var a: RTP_FIXED_HEADER; __padding: byte);

function version(var a: RTP_FIXED_HEADER): byte;

procedure set_version(var a: RTP_FIXED_HEADER; __version: byte);

function payload(var a: RTP_FIXED_HEADER): byte;

procedure set_payload(var a: RTP_FIXED_HEADER; __payload: byte);

function marker(var a: RTP_FIXED_HEADER): byte;

procedure set_marker(var a: RTP_FIXED_HEADER; __marker: byte);

type
  MPEGTS_FIXED_HEADER = record
    flag0: longint;
  end;

const
  bm_MPEGTS_FIXED_HEADER_sync_byte = $FF;
  bp_MPEGTS_FIXED_HEADER_sync_byte = 0;
  bm_MPEGTS_FIXED_HEADER_transport_error_indicator = $100;
  bp_MPEGTS_FIXED_HEADER_transport_error_indicator = 8;
  bm_MPEGTS_FIXED_HEADER_payload_unit_start_indicator = $200;
  bp_MPEGTS_FIXED_HEADER_payload_unit_start_indicator = 9;
  bm_MPEGTS_FIXED_HEADER_transport_priority = $400;
  bp_MPEGTS_FIXED_HEADER_transport_priority = 10;
  bm_MPEGTS_FIXED_HEADER_PID = $FFF800;
  bp_MPEGTS_FIXED_HEADER_PID = 11;
  bm_MPEGTS_FIXED_HEADER_scrambling_control = $3000000;
  bp_MPEGTS_FIXED_HEADER_scrambling_control = 24;
  bm_MPEGTS_FIXED_HEADER_adaptation_field_exist = $C000000;
  bp_MPEGTS_FIXED_HEADER_adaptation_field_exist = 26;
  bm_MPEGTS_FIXED_HEADER_continuity_counter = $F0000000;
  bp_MPEGTS_FIXED_HEADER_continuity_counter = 28;

function sync_byte(var a: MPEGTS_FIXED_HEADER): dword;

procedure set_sync_byte(var a: MPEGTS_FIXED_HEADER; __sync_byte: dword);

function transport_error_indicator(var a: MPEGTS_FIXED_HEADER): dword;

procedure set_transport_error_indicator(var a: MPEGTS_FIXED_HEADER; __transport_error_indicator: dword);

function payload_unit_start_indicator(var a: MPEGTS_FIXED_HEADER): dword;

procedure set_payload_unit_start_indicator(var a: MPEGTS_FIXED_HEADER; __payload_unit_start_indicator: dword);

function transport_priority(var a: MPEGTS_FIXED_HEADER): dword;

procedure set_transport_priority(var a: MPEGTS_FIXED_HEADER; __transport_priority: dword);

function PID(var a: MPEGTS_FIXED_HEADER): dword;

procedure set_PID(var a: MPEGTS_FIXED_HEADER; __PID: dword);

function scrambling_control(var a: MPEGTS_FIXED_HEADER): dword;

procedure set_scrambling_control(var a: MPEGTS_FIXED_HEADER; __scrambling_control: dword);

function adaptation_field_exist(var a: MPEGTS_FIXED_HEADER): dword;

procedure set_adaptation_field_exist(var a: MPEGTS_FIXED_HEADER; __adaptation_field_exist: dword);

function continuity_counter(var a: MPEGTS_FIXED_HEADER): dword;

procedure set_continuity_counter(var a: MPEGTS_FIXED_HEADER; __continuity_counter: dword);

function simplest_udp_parser(port: integer): integer;

implementation

function csrc_len(var a: RTP_FIXED_HEADER): byte;
begin
  csrc_len := (a.flag0 and bm_RTP_FIXED_HEADER_csrc_len) shr bp_RTP_FIXED_HEADER_csrc_len;
end;

procedure set_csrc_len(var a: RTP_FIXED_HEADER; __csrc_len: byte);
begin
  a.flag0 := a.flag0 or ((__csrc_len shl bp_RTP_FIXED_HEADER_csrc_len) and bm_RTP_FIXED_HEADER_csrc_len);
end;

function extension(var a: RTP_FIXED_HEADER): byte;
begin
  extension := (a.flag0 and bm_RTP_FIXED_HEADER_extension) shr bp_RTP_FIXED_HEADER_extension;
end;

procedure set_extension(var a: RTP_FIXED_HEADER; __extension: byte);
begin
  a.flag0 := a.flag0 or ((__extension shl bp_RTP_FIXED_HEADER_extension) and bm_RTP_FIXED_HEADER_extension);
end;

function padding(var a: RTP_FIXED_HEADER): byte;
begin
  padding := (a.flag0 and bm_RTP_FIXED_HEADER_padding) shr bp_RTP_FIXED_HEADER_padding;
end;

procedure set_padding(var a: RTP_FIXED_HEADER; __padding: byte);
begin
  a.flag0 := a.flag0 or ((__padding shl bp_RTP_FIXED_HEADER_padding) and bm_RTP_FIXED_HEADER_padding);
end;

function version(var a: RTP_FIXED_HEADER): byte;
begin
  version := (a.flag0 and bm_RTP_FIXED_HEADER_version) shr bp_RTP_FIXED_HEADER_version;
end;

procedure set_version(var a: RTP_FIXED_HEADER; __version: byte);
begin
  a.flag0 := a.flag0 or ((__version shl bp_RTP_FIXED_HEADER_version) and bm_RTP_FIXED_HEADER_version);
end;

function payload(var a: RTP_FIXED_HEADER): byte;
begin
  payload := (a.flag0 and bm_RTP_FIXED_HEADER_payload) shr bp_RTP_FIXED_HEADER_payload;
end;

procedure set_payload(var a: RTP_FIXED_HEADER; __payload: byte);
begin
  a.flag0 := a.flag0 or ((__payload shl bp_RTP_FIXED_HEADER_payload) and bm_RTP_FIXED_HEADER_payload);
end;

function marker(var a: RTP_FIXED_HEADER): byte;
begin
  marker := (a.flag0 and bm_RTP_FIXED_HEADER_marker) shr bp_RTP_FIXED_HEADER_marker;
end;

procedure set_marker(var a: RTP_FIXED_HEADER; __marker: byte);
begin
  a.flag0 := a.flag0 or ((__marker shl bp_RTP_FIXED_HEADER_marker) and bm_RTP_FIXED_HEADER_marker);
end;

function sync_byte(var a: MPEGTS_FIXED_HEADER): dword;
begin
  sync_byte := (a.flag0 and bm_MPEGTS_FIXED_HEADER_sync_byte) shr bp_MPEGTS_FIXED_HEADER_sync_byte;
end;

procedure set_sync_byte(var a: MPEGTS_FIXED_HEADER; __sync_byte: dword);
begin
  a.flag0 := a.flag0 or ((__sync_byte shl bp_MPEGTS_FIXED_HEADER_sync_byte) and bm_MPEGTS_FIXED_HEADER_sync_byte);
end;

function transport_error_indicator(var a: MPEGTS_FIXED_HEADER): dword;
begin
  transport_error_indicator := (a.flag0 and bm_MPEGTS_FIXED_HEADER_transport_error_indicator) shr bp_MPEGTS_FIXED_HEADER_transport_error_indicator;
end;

procedure set_transport_error_indicator(var a: MPEGTS_FIXED_HEADER; __transport_error_indicator: dword);
begin
  a.flag0 := a.flag0 or ((__transport_error_indicator shl bp_MPEGTS_FIXED_HEADER_transport_error_indicator) and bm_MPEGTS_FIXED_HEADER_transport_error_indicator);
end;

function payload_unit_start_indicator(var a: MPEGTS_FIXED_HEADER): dword;
begin
  payload_unit_start_indicator := (a.flag0 and bm_MPEGTS_FIXED_HEADER_payload_unit_start_indicator) shr bp_MPEGTS_FIXED_HEADER_payload_unit_start_indicator;
end;

procedure set_payload_unit_start_indicator(var a: MPEGTS_FIXED_HEADER; __payload_unit_start_indicator: dword);
begin
  a.flag0 := a.flag0 or ((__payload_unit_start_indicator shl bp_MPEGTS_FIXED_HEADER_payload_unit_start_indicator) and bm_MPEGTS_FIXED_HEADER_payload_unit_start_indicator);
end;

function transport_priority(var a: MPEGTS_FIXED_HEADER): dword;
begin
  transport_priority := (a.flag0 and bm_MPEGTS_FIXED_HEADER_transport_priority) shr bp_MPEGTS_FIXED_HEADER_transport_priority;
end;

procedure set_transport_priority(var a: MPEGTS_FIXED_HEADER; __transport_priority: dword);
begin
  a.flag0 := a.flag0 or ((__transport_priority shl bp_MPEGTS_FIXED_HEADER_transport_priority) and bm_MPEGTS_FIXED_HEADER_transport_priority);
end;

function PID(var a: MPEGTS_FIXED_HEADER): dword;
begin
  PID := (a.flag0 and bm_MPEGTS_FIXED_HEADER_PID) shr bp_MPEGTS_FIXED_HEADER_PID;
end;

procedure set_PID(var a: MPEGTS_FIXED_HEADER; __PID: dword);
begin
  a.flag0 := a.flag0 or ((__PID shl bp_MPEGTS_FIXED_HEADER_PID) and bm_MPEGTS_FIXED_HEADER_PID);
end;

function scrambling_control(var a: MPEGTS_FIXED_HEADER): dword;
begin
  scrambling_control := (a.flag0 and bm_MPEGTS_FIXED_HEADER_scrambling_control) shr bp_MPEGTS_FIXED_HEADER_scrambling_control;
end;

procedure set_scrambling_control(var a: MPEGTS_FIXED_HEADER; __scrambling_control: dword);
begin
  a.flag0 := a.flag0 or ((__scrambling_control shl bp_MPEGTS_FIXED_HEADER_scrambling_control) and bm_MPEGTS_FIXED_HEADER_scrambling_control);
end;

function adaptation_field_exist(var a: MPEGTS_FIXED_HEADER): dword;
begin
  adaptation_field_exist := (a.flag0 and bm_MPEGTS_FIXED_HEADER_adaptation_field_exist) shr bp_MPEGTS_FIXED_HEADER_adaptation_field_exist;
end;

procedure set_adaptation_field_exist(var a: MPEGTS_FIXED_HEADER; __adaptation_field_exist: dword);
begin
  a.flag0 := a.flag0 or ((__adaptation_field_exist shl bp_MPEGTS_FIXED_HEADER_adaptation_field_exist) and bm_MPEGTS_FIXED_HEADER_adaptation_field_exist);
end;

function continuity_counter(var a: MPEGTS_FIXED_HEADER): dword;
begin
  continuity_counter := (a.flag0 and bm_MPEGTS_FIXED_HEADER_continuity_counter) shr bp_MPEGTS_FIXED_HEADER_continuity_counter;
end;

procedure set_continuity_counter(var a: MPEGTS_FIXED_HEADER; __continuity_counter: dword);
begin
  a.flag0 := a.flag0 or ((__continuity_counter shl bp_MPEGTS_FIXED_HEADER_continuity_counter) and bm_MPEGTS_FIXED_HEADER_continuity_counter);
end;

function simplest_udp_parser(port: integer): integer;
var
  wsaData: TWsaData;
  sockVersion: WORD;
  cnt: integer;
  myout, fp1: TFileStream;
  serSocket: TSocket;
  serAddr: sockaddr_in;
  nAddrLen, parse_rtp, parse_mpegts: integer;
  recvData: array[0..9999] of byte;
  pktsize: integer;
  payload_str: string;
  rtp_header: RTP_FIXED_HEADER;
  rtp_header_size: integer;
  _payload: byte;
  rtp_data: PByte;
  rtp_data_size: integer;
  mpegts_header: MPEGTS_FIXED_HEADER;
  writer: TStreamWriter;
  addr, remoteAddr: TSockAddr;
  timestamp, seq_no: DWord;
  i: Integer;
begin
  sockVersion := $0202;
  cnt := 0;
  myout := TFileStream.Create(OUTPUT_DIR + 'simplest_udp_parser_log.txt', fmCreate);
  writer := TStreamWriter.Create(myout);

  fp1 := TBufferedFileStream.Create(OUTPUT_DIR + 'output_dump.ts', fmCreate);
  try
    if WSAStartup(sockVersion, wsaData) <> 0 then
    begin
      Exit(0);
    end;

    serSocket := socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if serSocket = INVALID_SOCKET then
    begin
      Write('socket error !');
      Exit(0);
    end;
    serAddr.sin_family := AF_INET;
    serAddr.sin_port := htons(port);
    serAddr.sin_addr.S_addr := INADDR_ANY;
    Move(serAddr, addr, SizeOf(serAddr));
    if bind(serSocket, addr, sizeof(addr)) = SOCKET_ERROR then
    begin
      writer.Write('bind error !');
      Exit(0);
    end;

    nAddrLen := sizeof(remoteAddr);
    //How to parse?
    parse_rtp := 1;
    parse_mpegts := 1;
    writer.WriteLine(Format('Listening on port %d', [port]));
    while True do
    begin
      pktsize := recvfrom(serSocket, recvData, 10000, 0, remoteAddr, nAddrLen);
      if pktsize > 0 then
      begin
      //writeln(format('Addr:%s\r',[inet_ntoa(remoteAddr.sin_addr)]));
      //writeln(format('packet size:%d\r',[pktsize]));
      //Parse RTP
      //
        if parse_rtp <> 0 then
        begin
          payload_str := '';
          rtp_header_size := sizeof(RTP_FIXED_HEADER);
        //RTP Header
          Move(recvData, rtp_header, rtp_header_size);
        //RFC3351
          _payload := payload(rtp_header);
          case _payload of
            0..18:
              payload_str := 'Audio';
            31:
              payload_str := 'H.261';
            32:
              payload_str := 'MPV';
            33:
              payload_str := 'MP2T';
            34:
              payload_str := 'H.263';
            96:
              payload_str := 'H.264';
          else
            payload_str := 'other';
          end;
          timestamp := ntohl(rtp_header.timestamp);
          seq_no := ntohs(rtp_header.seq_no);
          writer.WriteLine(Format('[RTP Pkt] %5d| %5s| %10u| %5d| %5d|', [cnt, payload_str, timestamp, seq_no, pktsize]));
        //RTP Data
          rtp_data := @recvData[rtp_header_size];
          rtp_data_size := pktsize - rtp_header_size;
          fp1.Write(rtp_data, rtp_data_size);
        //Parse MPEGTS
          if (parse_mpegts <> 0) and (_payload = 33) then
          begin
            i := 0;
            while i < rtp_data_size do
            begin
              if rtp_data[i] <> $47 then
                break;
              //MPEGTS Header
              //memcpy((void *)&mpegts_header,rtp_data+i,sizeof(MPEGTS_FIXED_HEADER));
              writer.WriteLine('   [MPEGTS Pkt]');
              i := i + 188;
            end;
          end;
        end
        else
        begin
          writer.WriteLine(Format('[UDP Pkt] %5d| %5d|', [cnt, pktsize]));
          fp1.Write(recvData, pktsize);
        end;
        Inc(cnt);
      end;
    end;
  finally
    closesocket(serSocket);
    WSACleanup();
    writer.Free;
    myout.Free;
    fp1.Free;
  end;
  Result := 0;
end;

end.

