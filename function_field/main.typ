#import "@preview/slydst:0.1.1": *

#set text(lang: "ja")
#set text(font: ("Yu Gothic"), size: 11pt)

#set table(
  stroke: gray
)

#show: slides.with(
  title: "関数体の紹介\nRiemann予想とABC予想の類似",
  authors: "グミ",
)

== 自己紹介

一時期主食がグミだったので、グミと名乗っています。

（今はグミをあまり食べないため、汁なし担々麺と名乗るべき）

数学科の修士卒で、専攻は整数論でした。

今は数学とあまり関係ない仕事をしてしまっています。

#figure(
  image("qrcode.png",width: 35%),
  caption: [https://x.com/GummyCandy1206]
)

== 関数体とは

このスライドでは有限体上の1変数有理関数体やその有限次拡大体のことを単に関数体と呼ぶ。

たとえば……

$ (2T+1)/(T+2) in FF_3 (T) $
$ (2T+3)/(4T+5) in FF_7 (T) $

※ $FF_q$は位数は$q$の有限体

== 関数体と特徴

関数体は代数体と似ている。

たとえば……

#table(
  columns: 2,
  [有理数体],[有限体上の1変数有理関数体],
  [整数環],[有限体上の1変数多項式環$A$],
  [素数$p$],[既約多項式$P$],
  [$ZZ slash m ZZ, (m eq.not 0)$は有限], [$A slash f A, (f eq.not 0)$は有限],
  [$(ZZ slash p ZZ)^*$は位数$p-1$の巡回群], [$(A slash P A)^*$は位数$|P|-1$の巡回群],
)

※ $A:=F_q [T]$

※ $|P| := hash (A slash P A)$

== 類似点

Eulerのトーシェント関数が同様に定義出来る。
また、Eulerの定理も同様に成り立つ。

#theorem(title: "Eulerの定理")[
  $f in A, A eq.not 0$とする。また、$a in A$を$f$と互いに素な元とする。
  このとき、次が成り立つ。
  $ a^(Phi(f)) eq.triple 1 (mod f) $
]

よって、Fermatの小定理も同様に成り立つ。

また、zeta関数も同様に定義できる。

#definition(title: "zeta関数")[
  $ zeta_A (s) := sum_(f in A, f text("monic")) 1/(|f|^s) $
]

では、相違点は……？

== 相違点

整数の場合より、証明が容易なケースがある。

例えば……

関数体バージョンのRiemann予想は1948年にWeilによって既に証明されている。

#theorem(title: "関数体バージョンのRiemann予想")[
  $K$を$FF_q (T)$の有限次拡大体とする。
  $zeta_K (s)$の零点の実部は$1/2$である。
]

Bombieriによる、より初等的な証明が院生向けの教科書に載っている。@zbMATH01716471

→頑張れば修士・学部生でも理解できるかも？

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

整数論に興味のある方は、関数体も学んでみるとこれらの証明を理解できるかも？

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

== 全くの余談

$ 11^(ln 11) = 314.159789... $

$100 pi$に近い。なんで？

== 参考文献

#bibliography("reference.bib")