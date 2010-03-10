#!/usr/bin/perl
use strict;
use warnings;
use utf8;

use Encode;
use lib './pdfj';
use PDFJ 'UTF8';

# 用紙の設定( 1pt = 0.35278mm で計算)
my $PaperW  = 298;  #文庫の横(105mm) 
my $PaperH  = 420;  #文庫の縦(148mm)
my $PaperSU =  42;  #上余白(15mm)
my $PaperSD =  28;  #下余白(10mm)
my $PaperSR =  28;  #右余白(10mm)
my $PaperSL =  34;  #左余白(12mm)
my $iWidth  = $PaperW - $PaperSR - $PaperSL; #印刷可能幅
my $iHeight = $PaperH - $PaperSU - $PaperSD; #印刷可能高

# フォントサイズとラインフィードの設定
my $fSize    = 8;     #フォントサイズ
my $linefeed ='170%'; #ラインフィード

# pdfオブジェクトを作成
my $pdfDoc = PDFJ::Doc->new(1.6, $PaperW, $PaperH); # PDF ver1.3

# フォントオブジェクトを作成
#my $oFont = $pdfDoc->new_font('IPAfont/ipam.ttf', 'UniJIS-UCS2-HW-V', 'Times-Roman');
my $oFont = $pdfDoc->new_font('/mnt/c/rb/msmincho.ttc:0', 'UniJIS-UCS2-HW-V', 'Times-Roman');

# テキストスタイルオブジェクトを作成
my $oTextStyle = TStyle(font => $oFont, fontsize => $fSize);

# 段落スタイルのオブジェクトを作成
my $oPStyle = PStyle(size=>$iHeight, linefeed=>$linefeed, align=>'b', preskip=>"35%", postskip=>"35%");

# テキストファイルの読み込み
print "read text\n";
my $text_file = $ARGV[0];
open(FH, "<", $text_file);
my @lines  = <FH>;
close(FH);

# 文ごとに段落の配列を作成
print "make paragraphes\n";
my @Paragraphes = ();
for my $line (@lines){
  chomp($line);
  $line = encode("utf8", '　') unless $line;
  my $oTexe = Text($line, $oTextStyle);
  push @Paragraphes, Paragraph($oTexe, $oPStyle);
}

# 段落の配列をブロックにまとめる
print "make block\n";
my $oBlock = Block('R', \@Paragraphes, BStyle());

# ブロックをページ毎に分割してページに割り付ける
my $i=0;
for my $oB ($oBlock->break($iWidth)) {
  my $oPage = $pdfDoc->new_page();
  $oB->show($oPage, $iWidth+$PaperSL, $iHeight+$PaperSD, 'rt');
  print $i++;
  print "page \n";
}

# PDFを出力
$pdfDoc->print($text_file . ".pdf")
  or die "can't save pdf";
