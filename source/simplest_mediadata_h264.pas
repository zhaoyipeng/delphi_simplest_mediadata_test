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
function GetAnnexbNALU(nalu: PNALU): Integer;

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

function GetAnnexbNALU(nalu: PNALU): Integer;
var
  pos: Integer;
  StartCodeFound, rewind: Integer;
  Buf: PByte;
begin
  pos := 0;
  GetMem(Buf, nalu.max_size);

//  if ((Buf = (unsigned char*)calloc (nalu->max_size , sizeof(char))) == NULL)
//        printf ("GetAnnexbNALU: Could not allocate Buf memory\n");
//
//    nalu->startcodeprefix_len=3;
//
//    if (3 != fread (Buf, 1, 3, h264bitstream)){
//        free(Buf);
//        return 0;
//    }
//    info2 = FindStartCode2 (Buf);
//    if(info2 != 1) {
//        if(1 != fread(Buf+3, 1, 1, h264bitstream)){
//            free(Buf);
//            return 0;
//        }
//        info3 = FindStartCode3 (Buf);
//        if (info3 != 1){
//            free(Buf);
//            return -1;
//        }
//        else {
//            pos = 4;
//            nalu->startcodeprefix_len = 4;
//        }
//    }
//    else{
//        nalu->startcodeprefix_len = 3;
//        pos = 3;
//    }
//    StartCodeFound = 0;
//    info2 = 0;
//    info3 = 0;
//
//    while (!StartCodeFound){
//        if (feof (h264bitstream)){
//            nalu->len = (pos-1)-nalu->startcodeprefix_len;
//            memcpy (nalu->buf, &Buf[nalu->startcodeprefix_len], nalu->len);
//            nalu->forbidden_bit = nalu->buf[0] & 0x80; //1 bit
//            nalu->nal_reference_idc = nalu->buf[0] & 0x60; // 2 bit
//            nalu->nal_unit_type = (nalu->buf[0]) & 0x1f;// 5 bit
//            free(Buf);
//            return pos-1;
//        }
//        Buf[pos++] = fgetc (h264bitstream);
//        info3 = FindStartCode3(&Buf[pos-4]);
//        if(info3 != 1)
//            info2 = FindStartCode2(&Buf[pos-3]);
//        StartCodeFound = (info2 == 1 || info3 == 1);
//    }
//
//    // Here, we have found another start code (and read length of startcode bytes more than we should
//    // have.  Hence, go back in the file
//    rewind = (info3 == 1)? -4 : -3;
//
//    if (0 != fseek (h264bitstream, rewind, SEEK_CUR)){
//        free(Buf);
//        printf("GetAnnexbNALU: Cannot fseek in the bit stream file");
//    }
//
//    // Here the Start code, the complete NALU, and the next start code is in the Buf.
//    // The size of Buf is pos, pos+rewind are the number of bytes excluding the next
//    // start code, and (pos+rewind)-startcodeprefix_len is the size of the NALU excluding the start code
//
//    nalu->len = (pos+rewind)-nalu->startcodeprefix_len;
//    memcpy (nalu->buf, &Buf[nalu->startcodeprefix_len], nalu->len);//
//    nalu->forbidden_bit = nalu->buf[0] & 0x80; //1 bit
//    nalu->nal_reference_idc = nalu->buf[0] & 0x60; // 2 bit
//    nalu->nal_unit_type = (nalu->buf[0]) & 0x1f;// 5 bit
//    free(Buf);
//
//    return (pos+rewind);
end;

end.
