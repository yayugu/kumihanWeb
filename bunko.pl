#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use Encode;
use PDFJ 'EUC';

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
my $pdfDoc = PDFJ::Doc->new(1.3, $PaperW, $PaperH); # PDF ver1.3

# フォントオブジェクトを作成
my $oFont = $pdfDoc->new_font('Ryumin-Light', 'EUC-V', 'Times-Roman');

# テキストスタイルオブジェクトを作成
my $oTextStyle = TStyle(font => $oFont, fontsize => $fSize);

# 段落スタイルのオブジェクトを作成
my $oPStyle = PStyle(size=>$iHeight, linefeed=>$linefeed, align=>'b', preskip=>"35%", postskip=>"35%");

# テキストファイルの読み込み
open(FH, "<", $ARGV[0]);
my @lines  = <FH>;
close(FH);

# 文ごとに段落の配列を作成
my @Paragraphes = ();
for my $line (@lines){
  chomp($line);
  $line = encode("eucjp", '　') unless $line;
  my $oTexe = Text($line, $oTextStyle);
  push @Paragraphes, Paragraph($oTexe, $oPStyle);
}

# 段落の配列をブロックにまとめる
my $oBlock = Block('R', \@Paragraphes, BStyle());

# ブロックをページ毎に分割してページに割り付ける
for my $oB ($oBlock->break($iWidth)) {
  my $oPage = $pdfDoc->new_page();
  $oB->show($oPage, $iWidth+$PaperSL, $iHeight+$PaperSD, 'rt');
}

# PDFを出力
$pdfDoc->print('sample.pdf');
