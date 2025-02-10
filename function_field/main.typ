#import "@preview/slydst:0.1.1": *

#set text(lang: "ja")
#set text(font: ("Yu Gothic"), size: 11pt)

#set table(
  stroke: gray
)

#show: slides.with(
  title: "関数体の紹介\nRiemann予想とABC予想の類似",
  subtitle: "第32回日曜数学会",
  authors: "グミ",
  date: "2025-02-16"
)

== 自己紹介

一時期主食がグミだったので、グミと名乗っています。

（今はグミをあまり食べないため、汁なし担々麺と名乗るべき）

数学科の修士卒で、専攻は整数論でした。

今は数学とあまり関係ない仕事をしてしまっています。

== 記号

$FF_q$を位数が$q$の有限体とする。

$FF_q$上の1変数多項式環$FF_q [T]$を、以降は単に$A$と表記する。

=== $A$の元の具体例

$ T+2 in FF_3 [T] $
$ 2T+3 in FF_7 [T] $

*有限体上の多項式環$A$は整数環$ZZ$と似ている*ことが知られている。

以降のスライドで、その類似点を紹介する。

== 有限体上の多項式環$A$と整数環$ZZ$の類似点

$A$には整数論のもとの似た定義・定理が多数ある。

たとえば……

- 単項ideal整域である。
- 剰余環は有限環である。
- 剰余環の乗法群は巡回群である。
- Eulerの定理、Fermatの小定理が成り立つ。
- zeta関数が定義できる。
- Wilsonの定理が成り立つ。
- 平方（n乗）剰余の相互法則が成り立つ。
- 素数定理が成り立つ。
- Dirichletの定理 が成り立つ。

詳細は @zbMATH01716471 を参照。

== 関数体と代数体の類似

有限体上の多項式環$A$と整数環$ZZ$に限らず、より一般に関数体と代数体の間に類似がある。
→関数体類似

#table(
  columns: 2,
  [整数環$ZZ$], [有限体上の多項式環$A$],
  [有理数体$QQ$], [有限体上の1変数有理関数体$FF_q (T)$],
  [代数体（$QQ$の有限次拡大体）], [関数体（$FF_q (T)$の有限次拡大体）]
)

では、相違点は……？

== 相違点

相違点のうち特に興味深いこととして、整数の場合より証明が容易なケースがあるということが挙げられる。

例えば……

関数体バージョンのRiemann予想は1948年にWeilによって既に証明されている。

#theorem(title: "関数体バージョンのRiemann予想")[
  $K$を大域関数体で、位数$q$の定数体を持つとする。

  $zeta_K (s)$の零点の実部は$1/2$である。
]

Bombieriによる、より初等的な証明が院生向けの教科書に載っている。@zbMATH01716471

== さらに……

関数体バージョンのFermatの最終定理も証明済み。

#theorem(title: "関数体バージョンのFermatの最終定理")[
  $K$を関数体とし、その定数体$F$は完全であるとする。
  $N$を$F$の標数$p$を割り切らない数とする。

  次の場合は$X^N + Y^N = 1$は定数以外の解を持たない。
  - $K$の種数$g_K$が$0$で、$N gt.eq 3$のとき。
  - $g_K gt.eq 1$で、$N gt 6g_K - 3$のとき。
]

※ $x^n + y^n = z^n$の両辺を$z^n$で割れば、$X^n + Y^n = 1$の形になる。

誰が最初に証明したかはリサーチ不足……

== さらにさらに……

関数体バージョンのABC予想も証明済み。

#theorem(title: "関数体バージョンのABC予想（定理）")[
  $K$を関数体とし、その定数体$F$は完全であるとする。
  $u,v in K^*$を$u+v=1$を満たすものとする。
  このとき、次が成り立つ。
  $ deg_s u = deg_s v lt.eq 2g_K - 2 + sum_(P in text("Supp")(A+B+C))deg_K P $
  ここで、$A$と$B$はそれぞれ$u$と$v$の$K$におけるzero divisorで、$C$はそれらの$K$におけるpolar divisorである。
]

※ 元のABC予想は次のように書きなおせる。
$ u := A/C, v := B/C, text("ht")(m/n) := max(log |m|, log |n|) $
$ max(text("ht")(u),text("ht")(v)) lt.eq m_epsilon + (1+epsilon) sum_(p | A B C) log p $

== まとめ

- 関数体は代数体と似ている。
- 関数体バージョンのRiemann予想、Fermatの最終定理、ABC予想は証明済み。
- それらの証明は院生向けの教科書に載っている。@zbMATH01716471


関数体バージョンなら、比較的容易に理解できるかもしれない。

また、関数体を調べることで、これらの整数論の難問に対するヒントを得られるかもしれない。

#figure(
  image("qrcode.png",width: 23%),
  caption: [Xへのリンク。本スライドはこちらに掲載します。]
)

== QRコードデカい版

#figure(
  image("qrcode.png",width: 80%)
)

== （補記）

- 関数体では整数論の定理だけでなく、他にもRiemann-Rochの定理や、Riemann-Hurwitzの定理も同様に成り立つ。
- 関数体バージョンのABC定理の証明はRiemann-Huwitzの定理を用いる。
- 関数体バージョンのFermatの最終定理の証明はABC定理を用いる。
- 円分体に対応する円分関数体が定義できる。
- ideal類群も同様に定義できる。
- 関数体バージョンのKronecker-Weberの定理も成り立つ。

== （補記）年表

#table(
  columns: 2,
  [西暦], [出来事],
  [1670], [Fermat予想が提示される],
  [1859], [Riemann予想が提示される],
  [1948], [Weilが関数体バージョンのRiemann予想を証明する],
  [1985], [ABC予想が提示される],
  [（不明）], [関数体バージョンのABC予想、Fermatの最終定理が証明される],
  [1995], [WilesがFermatの最終定理を証明する],
  [2020], [望月氏のABC予想の証明論文が『RIMS』に掲載される]
)

すべて関数体バージョンが先行して証明されている（と思う）。

※ 年表のソースはWikipediaです。

== （補記）一般の関数体

本スライドでは有限体上の1変数代数関数体を扱ったが、有限体・1変数に限らず一般の体$k$上の$n$変数代数関数体も定義できる。

Wikipedia @wikipedia_Algebraic_function_field によると、正規射影既約代数曲線の圏は$1$変数函数体の圏と反変同値であるらしい。

また$k$が$CC$の場合、$CC$上の1変数代数関数体の圏は閉Riemann面の圏と反変同値であるらしい。 @alg-d @yanagida

== 全くの余談

$ 11^(ln 11) = 314.159789... $

$100 pi$に近い。なんで？

== 参考文献

#bibliography("reference.bib")