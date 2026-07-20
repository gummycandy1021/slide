#import "@preview/commute:0.3.0": node, arr, commutative-diagram
#import "@preview/slydst:0.1.5": *
#import "@preview/tdtr:0.4.3" : *

#set text(lang: "ja")
#set text(font: ("Yu Gothic"), size: 13pt)
// #set text(font: ("Yu Gothic"))
// #set text(font: "UD Digi Kyokasho NK")

#set table(
  stroke: gray
)

#set align(horizon)

#show: slides.with(
  title: "Recursion Scheme の紹介",
  subtitle: "λ Kansai in Winter 2026",
  authors: "グミ (@GummyCandy1206)",
  date: "2026-01-17"
)

#show link: set text(fill: blue)

#show raw.where(block: true): it => {
  // set text(font: "MS Gothic")
  block(
    fill: rgb("#f0f0f0"), // 背景色（薄いグレー）
    inset: 8pt,          // 内側の余白
    radius: 4pt,         // 角丸
    width: 100%,         // 横幅いっぱい
    // it
  )[
    #set text(font: "MS Gothic", size: 8pt)
    #it
  ]
}

= はじめに

== はじめに

=== 動機

- LT会での発表の経験がほぼないので、発表したい
- 関数型プログラミングに興味がある

↓

λ Kansai in Winter 2026 が凄くちょうどよい！

== 本スライドで紹介すること

- *Recursion Scheme*（再帰関数から再帰に関する部分だけを抜き出して抽象化したもの）
- 本スライドでは特に```haskell foldr```の一般化である*catamorphism*について紹介する

== 個人的おもしろポイント

- 圏論をプログラミングに応用している例である
  - 圏論の言葉を用いることでシンプルに説明できる
  - 可換になるように定義すると、正しいコードになる
  - 双対や射の合成によって、新たなアルゴリズムが生まれる

== 仮定する事前知識
- Haskell の基礎知識（Functor、型クラスなど）
- 圏論の基礎知識（関手、始対象など）

= ```haskell foldr```

== ```haskell foldr```

たし算やかけ算、文字列の結合などの二項演算を各要素に順番に適用する関数
```haskell
foldr (+)  0  [1,2,3]             == 6              -- すべてたす
foldr (*)  1  [2,3,4]             == 24             -- すべてかける
foldr (++) "" ["Hello ","World!"] == "Hello World!" -- すべて結合する
```

== 計算の流れ

```haskell
foldr (+) 0 [1,2,3]
1 + foldr (+) 0 [2,3]
1 + (2 + foldr (+) 0 [3])
1 + (2 + (3 + foldr (+) 0 []))
1 + (2 + (3 + 0))
1 + (2 + 3)
1 + 5
6
```

```hs foldr```は*再帰的*に計算する。

== リストについてもう少し詳しく

リスト型は以下のように定義されている。
```haskell
data List a = [] | a : List a
```

リスト型は*再帰的*に定義されている。

リスト```haskell [1,2,3]```の表記はシンタックスシュガーなので、定義に戻したものを確認する。

```haskell
[1,2,3] == 1 : (2 : (3 : []))
```

== ここまでのまとめ

- ```hs foldr```は再帰的に計算する
- リスト型は再帰的に定義されている

= 再帰と再帰以外に分離する

== ```haskell ListF```

```haskell List```の再帰的な構造を再帰に関する部分とそれ以外の部分に分ける。
```haskell
data List a = [] | a : List a

-- ↓ 再帰とそれ以外に分解

newtype Fix f = Fix { unFix :: f (Fix f) } -- 再帰に関する部分
data ListF a b = Nil | Cons a b deriving (Functor) -- 再帰以外の部分
```

```haskell Fix (ListF a)```が```haskell List a```に対応している。

// ```haskell ListF```を```haskell List```の base fuctor と呼ぶ。

// 定義は recursion-schemes パッケージを参考にした。

== ```haskell List```と```haskell ListF```の対応
```haskell [1,2,3]```は```haskell ListF```では次のように書ける。
```haskell
Fix (Cons 1 (Fix (Cons 2 (Fix (Cons 3 (Fix Nil))))))
```

```haskell nil = Fix Nil```、```haskell cons a b = Fix (Cons a b)```とすれば、リストとの対応がわかりやすい。

```haskell
1 :      (2 :      (3 :      [] )) :: List a
1 `cons` (2 `cons` (3 `cons` nil)) :: Fix (ListF a)
```

== catamorphism の定義
```haskell foldr```の一般化である catamorphism を定義する。
以降、```haskell cata```と表記する。
```haskell
foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b

cata :: Functor f => (f a -> a) -> Fix f -> a
cata f = f . fmap (cata f) . unFix 
```
これだけ見ても```haskell foldr```の一般化であることは分かりづらい。
証明も少し面倒なので、計算例をいくつか見るだけにしておく。

== リストの和に対応する例

```haskell foldr (+) 0 [1,2,3]```に対応する例は以下の通り。
```haskell
newtype Fix f = Fix { unFix :: f (Fix f) }

cata :: Functor f => (f a -> a) -> Fix f -> a
cata f = f . fmap (cata f) . unFix 

data ListF a b = Nil | Cons a b deriving (Functor)

listSumAlgebra :: ListF Int Int -> Int
listSumAlgebra Nil        = 0
listSumAlgebra (Cons a b) = a + b

main = do
    let xs = Fix (Cons 1 (Fix (Cons 2 (Fix (Cons 3 (Fix Nil))))))
    print (cata listSumAlgebra xs) -- 6
```

== 計算の流れ

```haskell
cata listSumAlgebra (Fix Nil)
(listSumAlgebra . fmap (cata listSumAlgebra) . unFix ) (Fix Nil)
(listSumAlgebra . fmap (cata listSumAlgebra)) (unFix (Fix Nil))
(listSumAlgebra . fmap (cata listSumAlgebra)) Nil
listSumAlgebra (fmap (cata listSumAlgebra) Nil)
listSumAlgebra Nil
0
```
これは```haskell foldr (+) 0 [] == 0```に対応している。

== 計算の流れ
```haskell x :: a ```、```haskell xs :: Fix (ListF a)```とする。
このとき、```haskell Fix (Cons x xs)```について計算してみる。
```haskell
cata listSumAlgebra (Fix (Cons x xs))
(listSumAlgebra . fmap (cata listSumAlgebra) . unFix ) (Fix (Cons x xs))
(listSumAlgebra . fmap (cata listSumAlgebra)) (unFix (Fix (Cons x xs)))
(listSumAlgebra . fmap (cata listSumAlgebra)) (Cons x xs)
listSumAlgebra ((fmap (cata listSumAlgebra)) (Cons x xs))
listSumAlgebra (Cons x (cata listSumAlgebra xs))
x + cata listSumAlgebra xs
```
これは```haskell foldr (+) 0 (x:xs) == x + foldr (+) 0 xs```に対応している。

== ここまでのまとめ

- ```hs List```は再帰に関する部分の```hs Fix```とそれ以外の部分の```hs ListF```に分解できる。
- ```hs foldr (+) 0```は再帰に関する部分の```hs cata```とそれ以外の部分の```hs listSumAlgebra```に分解できる。

= 圏論で見る```haskell cata```

== ```haskell cata```の定義

```haskell
newtype Fix f = Fix { unFix :: f (Fix f) }

cata :: Functor f => (f a -> a) -> Fix f -> a
cata f = f . fmap (cata f) . unFix 
```

```haskell cata```の定義が初見時に理解できなかったので、圏論を用いて大雑把に説明する。

== 可換図式

簡単のために、```haskell a = Int```、```haskell b = Int```の場合を考える。

```haskell foldr (+) 0 :: [Int] -> Int```の catamorphism バージョンを考える。

#align(center)[#commutative-diagram(
  node((0, 0), "[Int]"),
  node((1, 0), "Int", "b"),

  arr("[Int]","b","foldr (+) 0"),

  node((0, 1), "Fix (ListF Int)", "Fixf"),
  node((1, 1), "Int", "Int"),

  arr("Fixf","Int","?"),
)]

#pagebreak()

右の図式を関手```haskell ListF Int```で移す。

#align(center)[#commutative-diagram(
  node((0, 0), "(ListF Int) (Fix (ListF Int))", "fFixf"),
  node((2, 0), "ListF Int Int", "fInt"),

  arr("fFixf","fInt","fmap ?", label-pos: right),

  node((0, 2), "Fix (ListF Int)", "Fixf"),
  node((2, 2), "Int", "Int"),

  arr("Fixf","Int","?"),

  arr((1, 2), (1, 0), "ListF Int"),
)]

#pagebreak()
```haskell unFix```の定義より、以下の矢印がある。

```haskell newtype Fix f = Fix { unFix :: f (Fix f) }```

#align(center)[#commutative-diagram(
  node((0, 0), "(ListF Int) (Fix (ListF Int))", "fFixf"),
  node((1, 0), "ListF Int Int", "fInt"),

  arr("fFixf","fInt","fmap ?", label-pos: right),

  node((0, 1), "Fix (ListF Int)", "Fixf"),
  node((1, 1), "Int", "Int"),

  arr("Fixf","Int","?"),

  arr("Fixf", "fFixf", "unFix")
)]

#pagebreak()
もし、```haskell f :: ListF Int Int -> Int```という関数を与えると、以下の図式を可換にする ? は次の等式を満たす。

``` ? == f . (fmap ?) . unFix```

#align(center)[#commutative-diagram(
  node((0, 0), "(ListF Int) (Fix (ListF Int))", "fFixf"),
  node((1, 0), "ListF Int Int", "fInt"),

  arr("fFixf","fInt","fmap ?", label-pos: right),

  node((0, 1), "Fix (ListF Int)", "Fixf"),
  node((1, 1), "Int", "Int"),

  arr("Fixf","Int","?"),

  arr("Fixf", "fFixf", "unFix"),
  arr("fInt", "Int", "f"),
)]

#pagebreak()

? を```hs cata f```と書けば、```hs cata f == f . (fmap (cata f)) . unFix```となるが、これは```hs cata f```の定義そのもの。

#align(center)[#commutative-diagram(
  node((0, 0), "(ListF Int) (Fix (ListF Int))", "fFixf"),
  node((1, 0), "ListF Int Int", "fInt"),

  arr("fFixf","fInt","fmap (cata f)", label-pos: right),

  node((0, 1), "Fix (ListF Int)", "Fixf"),
  node((1, 1), "Int", "Int"),

  arr("Fixf","Int","cata f"),

  arr("Fixf", "fFixf", "unFix"),
  arr("fInt", "Int", "f"),
)]

定義の説明としては不十分だと思うが、図式が可換になるように考えると定義が導かれる。

== ここまでのまとめ

- 図式が可換になるように考えると、自然に```hs cata```の定義が得られる。

= $F$代数

== $F$代数について

関手$F:C arrow.r C$に対して、対象$a in C$と射$f : F a arrow a$の組$(a,f)$を$F$代数と呼ぶ。

#align(center)[#commutative-diagram(
  node((0, 0), "(ListF Int) (Fix (ListF Int))", "fFixf"),
  node((1, 0), "ListF Int Int", "fInt"),

  arr("fFixf","fInt","fmap (cata f)", label-pos: right),

  node((0, 1), "Fix (ListF Int)", "Fixf"),
  node((1, 1), "Int", "Int"),

  arr("Fixf","Int","cata f"),

  arr("Fixf", "fFixf", "unFix"),
  arr("fFixf", "Fixf", "Fix", curve: 15deg),
  arr("fInt", "Int", "f"),
)]

```hs ListF Int```は関手なので、```hs (Fix (ListF Int), Fix)```や```hs (Int,f)```は```hs (ListF Int)```代数である。

== $F$代数の射

$F$代数の射$phi : (a,f) arrow (b,g)$は圏$C$の射$phi : a arrow b$であって、$phi compose f = F phi compose g$を満たすもの。

#align(center)[#commutative-diagram(
  node((0, 0), "(ListF Int) (Fix (ListF Int))", "fFixf"),
  node((1, 0), "ListF Int Int", "fInt"),

  arr("fFixf","fInt","fmap (cata f)", label-pos: right),

  node((0, 1), "Fix (ListF Int)", "Fixf"),
  node((1, 1), "Int", "Int"),

  arr("Fixf","Int","cata f"),

  arr("Fixf", "fFixf", "unFix"),
  arr("fFixf", "Fixf", "Fix", curve: 15deg),
  arr("fInt", "Int", "f"),
)]


```hs cata f```は```hs (ListF Int)```代数の射である。

#pagebreak()

// #align(center)[#commutative-diagram(
//   node((0,0),$(a,f)$),
//   node((1,0),$(b,g)$),
//   arr($(a,f)$,$(b,g)$,$phi$),

//   node((0,1),"(Fix (ListF Int),Fix)", "Fixf"),
//   node((1,1),"(Int,f)", "Int"),
//   arr("Fixf","Int","cata f"),
// )]

#align(center)[#commutative-diagram(
  node((0, 0), "(ListF Int) (Fix (ListF Int))", "fFixf"),
  node((1, 0), "ListF Int Int", "fInt"),

  arr("fFixf","fInt","fmap (cata f)", label-pos: right),

  node((0, 1), "Fix (ListF Int)", "Fixf"),
  node((1, 1), "Int", "Int"),

  arr("Fixf","Int","cata f"),

  arr("Fixf", "fFixf", "unFix"),
  arr("fFixf", "Fixf", "Fix", curve: 15deg),
  arr("fInt", "Int", "f"),
)]

実は、```hs (Fix (ListF Int), Fix)```は```hs (ListF Int)```代数の始対象となっている（$F$始代数）。
```hs cata f``` は始対象からの唯一の射である。

== anamorphism

catamorphismの図式の双対は、anamorphismと呼ばれる（以降、```hs ana```と表記する）。

// ```hs cata```が「要約」するイメージなのに対して、```hs ana```は値を「展開」するイメージ。

// ```hs cata```が$F$代数であるのに対して、```hs ana```は$F$終余代数である。

#align(center)[#commutative-diagram(
  node((0, 0), "(ListF Int) (Fix (ListF Int))", "fFixf"),
  node((1, 0), "ListF Int Int", "fInt"),

  arr("fInt","fFixf","fmap (ana f)", label-pos: right),

  node((0, 1), "Fix (ListF Int)", "Fixf"),
  node((1, 1), "Int", "Int"),

  arr("Int","Fixf","ana f"),

  arr("fFixf", "Fixf", "Fix"),
  arr("Int", "fInt", "f"),
)]

双対を考えることで、新たなアルゴリズムを得られる。

== hylomorpshism

```hs cata f```と```hs ana g```の合成を考えることで新たなアルゴリズムが得られる。

```hs
hylo f g = cata f . ana g
```
一度リストを作って、それを畳み込むイメージ。

（例） $n$以下の整数のリストの積（階乗）

== metamorphism

```hs cata f```と```hs ana g```の合成の順番を逆にすることで別のアルゴリズムが得られる。

```hs
meta f g = ana f . cata g
```
一度集約してそれを展開するイメージ。

（例）
- AtCoderのある問題をmetamorphismで考えた例
  #link("https://zenn.dev/nobsun/articles/runlength-2025-07-09")[連長圧縮したリスト上の分割(Haskell)]

その他にも様々なmorphismが考えられている。

== ここまでのまとめ

- ```hs Fix (ListF Int)```は```hs ListF Int```代数の始対象。
- ```hs cata```は始対象からの唯一の射。
- 双対や射の合成で、新たなアルゴリズムが得られる。

= 全体のまとめ

== まとめ

- Recursion Schemeは再帰とそれ以外に分離して考える
- catamorphismは```hs foldr```の一般化である
- 図式が可換になるように考えると、勝手にcatamorphismの定義を導ける
- catamorphismは圏論（$F$代数）を用いるとシンプルに説明できる
- 双対や射の合成で新たなアルゴリズムを得られる

↓

関数型プログラミングと圏論の両方の学習者にとって面白い例

*ご清聴ありがとうございました。*

= 補記

== ```haskell foldr```の型

```haskell
foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b

foldr (+) 0 [1,2,3] -- 6
```

```haskell Foldable```はリストの一般化。
リストとは限らないが、```haskell toList :: Foldable t => t a -> [a]```でリストにできる。
リストっぽい型と思うことができる。

== リスト以外の型に対する```haskell foldr```

二分木の値の和を求める例。

#tidy-tree-graph(compact: true)[
  - 1
    - 2
      - 4
      - Empty
    - 3
]

```haskell
{-# LANGUAGE DeriveFoldable #-}
data Tree a = Empty | Leaf a | Node (Tree a) a (Tree a) deriving Foldable

tree = Node (Node (Leaf 4) 2 Empty) 1 (Leaf 3)

main = do
    print (foldr (+) 0 tree) -- 10 リストでなくても計算できる！
```

== ```haskell ListF a```が Functor であることについて
```haskell ListF```の定義の```haskell deriving```宣言で```haskell Functor```であることを宣言している。
```haskell
data ListF a b = Nil | Cons a b deriving (Functor)
```

初見時に混乱したので、少し補足しておく。
```haskell ListF```が```haskell Functor```になるのではなく、```haskell ListF a```が```haskell Functor```になる。

以下のような自明なFunctorが導出される。

```haskell
instance Functor (ListF a) where
  fmap f Nil        = Nil
  fmap f (Cons a b) = Cons a (f b)
```

== リスト以外の例

リストだけだと```haskell cata```のメリットが分かりづらい。
他の例として、抽象構文木を文字列に変換する例を見る。

```haskell
data ExprF x = LitF Int | AddF x x | MulF x x deriving (Functor)

type Expr = Fix ExprF

astToStr :: ExprF String -> String
astToStr (LitF n)   = show n
astToStr (AddF a b) = "(" ++ a ++ " + " ++ b ++ ")"
astToStr (MulF a b) = "(" ++ a ++ " × " ++ b ++ ")"

ast :: Expr
ast = Fix (AddF (Fix (MulF (Fix (LitF 1)) (Fix (LitF 2))))
               (Fix (AddF (Fix (LitF 3)) (Fix (LitF 4)))))

main = do
  putStrLn (cata astToStr ast) -- ((1 × 2) + (3 + 4))
```
