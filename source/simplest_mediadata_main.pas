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
 unit simplest_mediadata_main;

interface

uses
  System.SysUtils,
  simplest_mediadata_raw,
  simplest_mediadata_h264,
  simplest_mediadata_aac,
  simplest_mediadata_flv,
  simplest_mediadata_udp;

procedure test_all;
implementation

procedure test_all;
begin
  Writeln(GetCurrentDir);
  //Test
//  simplest_yuv420_split('lena_256x256_yuv420p.yuv',256,256,1);
//
//  simplest_yuv444_split('lena_256x256_yuv444p.yuv',256,256,1);
//
//  simplest_yuv420_gray('lena_256x256_yuv420p.yuv',256,256,1);
//
//  simplest_yuv420_halfy('lena_256x256_yuv420p.yuv',256,256,1);
//
//  simplest_yuv420_graybar(640, 360,0,255,10,'graybar_640x360.yuv');
//
//  simplest_yuv420_psnr('lena_256x256_yuv420p.yuv','lena_distort_256x256_yuv420p.yuv',256,256,1);
//
//  simplest_rgb24_split('cie1931_500x500.rgb', 500, 500,1);
//
//  simplest_rgb24_to_bmp('lena_256x256_rgb24.rgb',256,256,'output_lena.bmp');
//
//  simplest_rgb24_to_yuv420('lena_256x256_rgb24.rgb',256,256,1,'output_lena.yuv');
//
//  simplest_rgb24_colorbar(640, 360,'colorbar_640x360.rgb');
//
//  simplest_pcm16le_split('NocturneNo2inEflat_44.1k_s16le.pcm');
//
//  simplest_pcm16le_halfvolumeleft('NocturneNo2inEflat_44.1k_s16le.pcm');
//
//  simplest_pcm16le_doublespeed('NocturneNo2inEflat_44.1k_s16le.pcm');
//
//  simplest_pcm16le_to_pcm8('NocturneNo2inEflat_44.1k_s16le.pcm');
//
//  simplest_pcm16le_cut_singlechannel('drum.pcm',2360,120);
//
//  simplest_pcm16le_to_wave('NocturneNo2inEflat_44.1k_s16le.pcm',2,44100,'output_nocturne.wav');
//
//  simplest_h264_parser('sintel.h264');
//
//  simplest_aac_parser('nocturne.aac');
//
//  simplest_flv_parser('cuc_ieschool.flv');

  simplest_udp_parser(8880);

  Writeln('all tests done.');
  Readln;
end;
end.
