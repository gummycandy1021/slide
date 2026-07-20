#import "@preview/polylux:0.4.0": *
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/codelst:2.0.2": sourcecode
#import "@preview/enja-bib:0.1.0": *
#import bib-setting-plain: *

#show: bib-init

#set page(
    paper: "presentation-16-9",
    numbering: (current, total) => text(
        size: 9pt
    )[
        #current / #total
    ]
)
#set text(font: ("Yu Gothic"), size: 24pt)

#set quote(block: true)

#let todo(msg) = {
    set text(red, size: 2em)
    [#msg]
}

#let ja(body) = text(font: "Yu Gothic", body)

#let reflink(x) = {
    [
        #text(size: 0.5em)[
            参考：#link(x)
        ]
    ]
}

#slide[
    #align(horizon)[
        = Haskellと圏論：
        = パフォーマンス改善からKan拡張へ
    
    ]

  #align(bottom)[
    #text(size: 0.75em)[
        グミ\@GummyCandy1206

        関数型まつり2026 2026-07-11

        \#fp_matsuri_b
    ]
  ]
]

#let new-section-slide(title) = slide[
    #set align(center + horizon)
    #set text(size: 48pt)
    #strong(title)
]

#slide[
    == 自己紹介

    === グミ \@GummyCandy1206

    - 富山県のエンジニア
    - 好きな言語: Haskell, Lean
    - 趣味で関数型と圏論を勉強しています。
    - 仕事でも関数型使いたい！

    最近は圏論のKan拡張とHaskellの関係について勉強していました。この発表ではそのことについて話します。

]

#slide[
    Haskellは圏論に由来するいくつかの概念を取り入れている。
    
    例えば…
    
    #text(size: 14pt)[
    // https://q.uiver.app/#r=typst&q=WzAsOCxbMSwxLCJBIl0sWzEsMywiQyJdLFswLDIsIkIiXSxbMCwwLCLlnI/oq5YiXSxbNCwxLCJcImFcIiJdLFs0LDMsIlwiY1wiIl0sWzMsMiwiXCJiXCIiXSxbMywwLCJIYXNrZWxsIl0sWzAsMSwiZyBjb21wb3NlIGYiXSxbMCwyLCJmIiwyXSxbMiwxLCJnIiwyXSxbNCw2LCJcImZcIiIsMl0sWzYsNSwiXCJnXCIiLDJdLFs0LDUsIlwiZyAuIGZcIiJdLFswLDAsImlkX0EiXSxbMiwyLCJpZF9CIiwwLHsiYW5nbGUiOi05MH1dLFsxLDEsImlkX0MiLDAseyJhbmdsZSI6LTE4MH1dLFs0LDQsIlwiaWRcIiJdLFs2LDYsIlwiaWRcIiIsMCx7ImFuZ2xlIjotOTB9XSxbNSw1LCJcImlkXCIiLDAseyJhbmdsZSI6LTE4MH1dXQ==
    #align(center, diagram({
        node((1, 1), [$A$])
        node((1, 3), [$C$])
        node((0, 2), [$B$])
        node((0, 0), [圏論における、対象と射])
        node((4, 1), [```hs a```])
        node((4, 3), [```hs c ```])
        node((3, 2), [```hs b ```])
        node((3, 0), [Haskellにおける、型と関数])
        edge((1, 1), (1, 3), [$g compose f$], label-side: left, "->")
        edge((1, 1), (0, 2), [$f$], label-side: right, "->")
        edge((0, 2), (1, 3), [$g$], label-side: right, "->")
        edge((4, 1), (3, 2), [```hs f ```], label-side: right, "->")
        edge((3, 2), (4, 3), [```hs g ```], label-side: right, "->")
        edge((4, 1), (4, 3), [```hs g . f ```], label-side: left, "->")
        edge((1, 1), (1, 1), [$id_A$], label-side: left, "->", bend: 140deg, loop-angle: 90deg)
        edge((0, 2), (0, 2), [$id_B$], label-side: left, "->", bend: 140deg, loop-angle: 180deg)
        edge((1, 3), (1, 3), [$id_C$], label-side: left, "->", bend: 140deg, loop-angle: 270deg)
        edge((4, 1), (4, 1), [```hs id ```], label-side: left, "->", bend: 140deg, loop-angle: 90deg)
        edge((3, 2), (3, 2), [```hs id ```], label-side: left, "->", bend: 140deg, loop-angle: 180deg)
        edge((4, 3), (4, 3), [```hs id ```], label-side: left, "->", bend: 140deg, loop-angle: 270deg)
    }))
    ]

]

#slide[  
    もちろん、それだけではなく…
    
    #text(size: 14pt)[
    // https://q.uiver.app/#r=typst&q=WzAsOCxbMSwxLCJGIEEiXSxbMSwzLCJGIEMiXSxbMCwyLCJGIEIiXSxbMCwwLCLlnI/oq5YiXSxbNCwxLCJcImYgYVwiIl0sWzQsMywiXCJmIGNcIiJdLFszLDIsIlwiZiBiXCIiXSxbMywwLCJIYXNrZWxsIl0sWzAsMSwiRiAoZyBjb21wb3NlIGYpIl0sWzAsMiwiRiBmIiwyXSxbMiwxLCJGIGciLDJdLFs0LDYsIlwiZm1hcCBmXCIiLDJdLFs2LDUsIlwiZm1hcCBnXCIiLDJdLFs0LDUsIlwiZm1hcCAoZyAuIGYpXCIiXV0=
    #align(center, diagram({
        node((-2, -1), [$F A$])
        node((-2, 1), [$F C$])
        node((-3, 0), [$F B$])
        node((-3, -2), [圏論における、Functor])
        node((1, -1), [```hs f a```])
        node((1, 1), [```hs f c```])
        node((0, 0), [```hs f b```])
        node((0, -2), [Haskellにおける、Functor])
        edge((-2, -1), (-2, 1), [$F (g compose f)$], label-side: left, "->")
        edge((-2, -1), (-3, 0), [$F f$], label-side: right, "->")
        edge((-3, 0), (-2, 1), [$F g$], label-side: right, "->")
        edge((1, -1), (0, 0), [```hs fmap f```], label-side: right, "->")
        edge((0, 0), (1, 1), [```hs fmap g```], label-side: right, "->")
        edge((1, -1), (1, 1), [```hs fmap (g . f)```], label-side: left, "->")
        edge((-2, -1), (-2, -1), [$F id_A$], label-side: left, "->", bend: 140deg, loop-angle: 90deg)
        edge((-3, 0), (-3, 0), [$F id_B$], label-side: left, "->", bend: 140deg, loop-angle: 180deg)
        edge((-2, 1), (-2, 1), [$F id_C$], label-side: left, "->", bend: 140deg, loop-angle: 270deg)
        edge((1, -1), (1, -1), [```hs fmap id ```], label-side: left, "->", bend: 140deg, loop-angle: 90deg)
        edge((0, 0), (0, 0), [```hs fmap id ```], label-side: left, "->", bend: 140deg, loop-angle: 180deg)
        edge((1, 1), (1, 1), [```hs fmap id ```], label-side: left, "->", bend: 140deg, loop-angle: 270deg)
    }))
    ]
]

#slide[
    他にも…

    #table(
        columns: 2,
        inset: 0.75em,
        table.header([*圏論*],[*Haskell*]),
        [自然変換$alpha : F => G$],[多相関数```hs forall a. f a -> g a```],
        [モナド$(T,eta,mu)$],[```hs Monad m```],
    )
]

#slide[
    一方で、圏論には次の有名な言葉がある。
    #quote(attribution: [Mac Lane, Saunders. Categories for the Working Mathematician.])[We end with the observations that *all concepts of category theory are Kan extensions*.]

    圏論における*すべての概念はKan拡張*！

]

#slide[
    圏論はHaskellに影響を与えている。

    #align(horizon + center, diagram({
        node((0, 0), [圏論])
        node((0, -2), [Haskell])
        edge((0, 0), (0, -2), [影響], label-side: left, "->")
    }))
]

#slide[
    一方で、圏論におけるすべての概念はKan拡張である。

    #align(horizon + center, diagram({
        node((0, 0), [圏論])
        node((0, -2), [Haskell])
        node((2, 0), [Kan拡張])
        edge((0, 0), (0, -2), [影響], label-side: left, "->")
        edge((0, 0), (2, 0), [すべての概念], label-side: right, "->")
    }))
]

#slide[
    では、Haskellの概念もKan拡張として理解できるのでは？

    #align(horizon + center, diagram({
        node((0, 0), [圏論])
        node((0, -2), [Haskell])
        node((2, 0), [Kan拡張])
        edge((0, 0), (0, -2), [影響], label-side: left, "->")
        edge((0, 0), (2, 0), [すべての概念], label-side: right, "->")
        edge((0, -2), (2, 0), text(fill: red)[?], label-side: left, "->",stroke: red)
    }))
]

#slide[
    "Haskell Kan extension"で調べてみると、なんとKan拡張に関するHaskellのパッケージが見つかる！

    #figure(
        image("assets/package-kan-extensions.png", width: 80%),
    )
    #reflink("https://hackage.haskell.org/package/kan-extensions")
]

#slide[
    = この発表のゴール
    #text(size: 32pt)[
        #align(horizon)[
            kan-extensionsパッケージのコードを通じて、HaskellとKan拡張の関係を理解する。
        ]
    ]
]

#slide[
    Data.Functor.Kan.Ranに右Kan拡張が定義されている。

    #align(horizon)[
        #text(size: 28pt)[
            #sourcecode[```hs
                newtype Ran g h a
                  = Ran { runRan :: forall b. (a -> g b) -> h b }
            ```]
        ]
    ]
]

#slide[
        #text(size: 28pt)[
            #sourcecode[```hs
                newtype Ran g h a
                  = Ran { runRan :: forall b. (a -> g b) -> h b }
            ```]
        ]
    一見しただけでは
    - どのように利用できるのかがわからない
    - 圏論の右Kan拡張との関係が分からない

    kan-extensionsの中でも簡単で具体的な例から徐々に一般化してHaskellとKan拡張の関係を観察する。
]

#new-section-slide("Yoneda")

#slide[
    #text(size: 0.7em)[

        次のようなコードを考える。

        #sourcecode[```hs
            import Debug.Trace

            data Box a = Box [a] deriving Show

            instance Functor Box where
            fmap f (Box xs) = trace "重い処理" $ Box (fmap f xs)

            g :: Int -> Int
            g x = x + 1

            plain :: Box Int
            plain = fmap g $
                    fmap g $
                    fmap g $
                    Box [1,2]
        ```]

        つまり、```hs fmap```が重い場合を考える。

        （```hs Box```は説明用に定義したFunctor）
    ]
]

#slide[

    このコードの実行結果は以下の通り。
    
    #set align(horizon)
    #text(size: 1.25em)[
    #sourcecode[```
        ghci> plain 
        重い処理
        重い処理
        重い処理
        Box [4,5]
    ```]
    ]

    重い処理が3回呼び出されている。
]

/*
#slide[
    ```hs fmap g```を繰り返す処理が重い。
    #set text(size: 22pt)
    // https://q.uiver.app/#r=typst&q=WzAsNixbMCwwLCJcIkludFwiIl0sWzAsMSwiXCJJbnRcIiJdLFsxLDAsIlwiW0ludF1cIiJdLFsxLDEsIlwiW0ludF1cIiJdLFsxLDIsIlwiW0ludF1cIiJdLFsxLDMsIlwiW0ludF1cIiJdLFswLDEsIlwiZ1wiIl0sWzIsMywiXCJmbWFwIGdcIiJdLFszLDQsIlwi77yI5Lit55Wl77yJXCIiLDAseyJzdHlsZSI6eyJib2R5Ijp7Im5hbWUiOiJkYXNoZWQifX19XSxbNCw1LCJcImZtYXAgZ1wiIl1d
    #align(center, diagram({
        node((0, -1), [```hs a```])
        node((0, 0), [```hs a```])
        node((1, -1), [```hs f a```])
        node((1, 0), [```hs f a```])
        node((1, 1), [```hs f a```])
        node((1, 2), [```hs f a```])
        edge((0, -1), (0, 0), [```hs g```], label-side: left, "->")
        edge((1, -1), (1, 0), [```hs fmap g```], label-side: left, "->")
        edge((1, 0), (1, 1), [```hs fmap g```], label-side: left, "->")
        edge((1, 1), (1, 2), [```hs fmap g```], label-side: left, "->")
    }))

]
*/

#slide[
    #set text(size: 0.8em)
    先程のコードの```hs plain```を次のように修正する。
    #sourcecode[```hs
        import Data.Functor.Yoneda

        yoneda :: Box Int
        yoneda = lowerYoneda $
                 fmap g $
                 fmap g $
                 fmap g $
                 liftYoneda $
                 Box [1,2]
    ```]
    kan-extensionsの``` Data.Functor.Yoneda ```で定義された関数を利用する。
]

#slide[
    #set text(size: 20pt)
    修正は2箇所だけ。
    #sourcecode[```hs
        plain :: Box Int
        plain = fmap g $
                fmap g $
                fmap g $
                Box [1,2]

        yoneda :: Box Int
        yoneda = lowerYoneda $
                 fmap g $
                 fmap g $
                 fmap g $
                 liftYoneda $
                 Box [1,2]
    ```]
    ```hs liftYoneda```と```hs lowerYoneda```が追加されている。
]

#slide[
    修正後のコードの実行結果は以下の通り。
    #text(size: 1.25em)[
        #set align(horizon)
        #sourcecode[```
            ghci> yoneda
            重い処理
            Box [4,5]
        ```]
    ]
    重い処理の呼び出しが1回だけになった。
    
    一方で、出力結果に変化はない。

    *計算結果を変えずに高速化できた！*
]

#slide[
    高速化の謎を探るため、```hs liftYoneda```と```hs lowerYoneda```の実装を調べる。
    #sourcecode[```hs
    liftYoneda :: Functor f => f a -> Yoneda f a
    liftYoneda a = Yoneda (\f -> fmap f a)

    lowerYoneda :: Yoneda f a -> f a
    lowerYoneda (Yoneda f) = f id
    ```]
    
    #reflink("https://hackage-content.haskell.org/package/kan-extensions-5.2.8/docs/src/Data.Functor.Yoneda.html")
    
]

#slide[
    図で書くと…
    // https://q.uiver.app/#r=typst&q=WzAsMixbMCwwLCJcImYgYVwiIl0sWzIsMCwiXCJZb25lZGEgZiBhXCIiXSxbMCwxLCJcImxpZnRZb25lZGFcIiIsMCx7Im9mZnNldCI6LTF9XSxbMSwwLCJcImxvd2VyWW9uZWRhXCIiLDAseyJvZmZzZXQiOi0xfV1d
    #text(size: 1em)[
    #align(center, diagram({
        node((0, 0), [```hs f a```])
        node((2, 0), [```hs Yoneda f a```])
        edge((0, 0), (2, 0), [```hs liftYoneda```], label-side: left, shift: 0.1, "->")
        edge((2, 0), (0, 0), [```hs lowerYoneda```], label-side: left, shift: 0.1, "->")
    }))
    ]
    
    ```hs f a == [Int]```の場合は…
    #text(size: 1em)[
    #align(center, diagram({
        node((0, 0), [```hs [Int]```])
        node((2, 0), [```hs Yoneda [] Int```])
        edge((0, 0), (2, 0), [```hs liftYoneda```], label-side: left, shift: 0.1, "->")
        edge((2, 0), (0, 0), [```hs lowerYoneda```], label-side: left, shift: 0.1, "->")
    }))
    ]
]

#slide[
    具体例

    ```hs [Int]```の例として、```hs [1,2]```を考える。
    #align(center, diagram({
        node((0,0), [```hs [1,2]```])
        node((2,0), [```hs Yoneda (\f -> fmap f [1,2])```])

        node((0,1), [```hs fmap id [1,2]```])
        node((2,1), [```hs Yoneda (\f -> fmap f [1,2])```])

        edge((0,0),(2,0),[```hs liftYoneda```], label-side: left, "|->")
        edge((2,1),(0,1),[```hs lowerYoneda```], label-side: left, "|->")

        edge((0,0),(0,1), "=")
        edge((2,0),(2,1), "=")
    }))

    ```hs liftYoneda```と```hs lowerYoneda```は互いに逆関数になっている。
]

#slide[
    #columns(2)[
        #text(size: 0.75em)[
        ```hs yoneda```は右図の赤い経路で計算している。    
        ]
        #text(size: 0.75em)[
            #sourcecode[```hs
                yoneda :: Box Int
                yoneda = lowerYoneda $
                        fmap g $
                        fmap g $
                        fmap g $
                        liftYoneda $
                        Box [1,2]
            ```]
        ]

        #text(size: 0.75em)[
        高速化の理由を調べるため、```hs Yoneda f```の```hs fmap```の定義を確認する。
        ]
        #colbreak()
        
        #text(size: 0.6em)[
        #align(center, diagram({
            node((1, -1), [```hs Box Int```])
            node((1, 1), [```hs Box Int```])
            node((1, 3), [```hs Box Int```])
            node((1, 5), [```hs Box Int```])
            
            node((3, -1), [```hs Yoneda Box Int```])
            node((3, 1), [```hs Yoneda Box Int```])
            node((3, 3), [```hs Yoneda Box Int```])
            node((3, 5), [```hs Yoneda Box Int```])
            
            edge((1, -1), (1, 1), [```hs fmap g```], label-side: left, "->")
            edge((1, 1), (1, 3), [```hs fmap g```], label-side: left, "->")
            edge((1, 3), (1, 5), [```hs fmap g```], label-side: left, "->")
            
            edge((3, -1), (3, 1), [```hs fmap g```], label-side: left, "->",stroke: red)
            edge((3, 1), (3, 3), [```hs fmap g```], label-side: left, "->",stroke: red)
            edge((3, 3), (3, 5), [```hs fmap g```], label-side: left, "->",stroke: red)

            edge((1, -1), (3, -1), [```hs liftYoneda```], label-side: left, "->",stroke: red)
            edge((3, 5), (1, 5), [```hs lowerYoneda```], label-side: left, "->",stroke: red)
            
        }))
        ]
    ]
]

#slide[
    ```hs Yoneda f```の```hs fmap```の定義
    #sourcecode[```hs
        instance Functor (Yoneda f) where
        fmap f m = Yoneda (\k -> runYoneda m (k . f))
    ```]

    ```hs Yoneda```の定義
    #sourcecode[```hs
        newtype Yoneda f a
          = Yoneda { runYoneda :: forall b. (a -> b) -> f b }
    ```]
    
    #reflink("https://hackage-content.haskell.org/package/kan-extensions-5.2.8/docs/src/Data.Functor.Yoneda.html")
    
]

#slide[
    具体例

    ```hs g x = x + 1```として考える。
    #align(center, diagram({
        node((0,0),[```hs [1,2]```])
        node((2,0), [```hs Yoneda (\f -> fmap f [1,2])```])
        node((2,2), [```hs Yoneda (\f -> fmap (f.g) [1,2])```])
        node((0,2), [```hs fmap (id.g) [1,2]```])
        node((0,1), [```hs [2,3]```])

        edge((0,0),(2,0),[```hs liftYoneda```], label-side: left, "|->")
        edge((2,0),(2,2),[```hs fmap g```], label-side: left, "|->")
        edge((2,2),(0,2),[```hs lowerYoneda```], label-side: left, "|->")
        edge((0,1),(0,2), "=")
        edge((0,0),(0,1), [```hs fmap g```], label-side: left, "|->")
    }))
]

#slide[
    ```hs fmap g```を繰り返す場合
    #text(size: 0.6em)[
    #align(center, diagram({
        node((1, -1), [```hs xs```])
        node((1, 1), [```hs fmap g xs```])
        node((1, 3), [```hs fmap g (fmap g xs)```])
        
        node((2, 3), [```hs fmap ((id.g).g) xs```])

        node((3, -1), [```hs Yoneda (\f -> fmap f xs)```])
        node((3, 1), [```hs Yoneda (\f -> fmap (f.g) xs)```])
        node((3, 3), [```hs Yoneda (\f -> fmap ((f.g).g) xs)```])
        
        edge((1, -1), (1, 1), [```hs fmap g```], label-side: left, "|->")
        
        edge((1, 1), (1, 3), [```hs fmap g```], label-side: left, "|->")
        edge((3, -1), (3, 1), [```hs fmap g```], label-side: left, "|->",stroke: red)
        
        edge((1, -1), (3, -1), [```hs liftYoneda```], label-side: left, "|->",stroke: red)
        edge((3, 3), (2, 3), [```hs lowerYoneda```], label-side: left, "|->",stroke: red)
        edge((3, 1), (3, 3), [```hs fmap g```], label-side: left, "|->",stroke: red)
        edge((2, 3), (1, 3), "=", stroke: red)
    }))

    ```hs fmap```が満たすべき性質
    ```hs (fmap f) . (fmap g) == fmap (f . g)```
    ]
]

#slide[
    パフォーマンス改善の理由

    ```hs Yoneda```を経由することで、```hs fmap g```の合成が、```hs g```の合成の```hs fmap```に変わった。
    重い```hs fmap g```の処理が1回だけになり、パフォーマンスが改善した。

    #align(center + horizon, diagram({
        node((0,0), [```hs (fmap g) . (fmap g) . (fmap g)```])
        node((0,1), [```hs fmap (g . g . g)```])

        edge((0,0), (0,1), [改善], "->")
    }))
]

#slide[
    注意

    実際には```hs Yoneda```を用いたからといって直ちに```hs fmap```の合成のパフォーマンスが改善するわけではない。

    GHCはfmapの合成を自動で最適化することがあるため、工夫しなくても十分に速い場合がある。
]

#slide[
    ここまでのまとめ
    - HaskellとKan拡張の関係を知りたい
    - Kan拡張に関するパッケージkan-extensionsがある
    - kan-extensionsパッケージの使い道を知りたい
    - 使い道の一つとして、```hs Yoneda```を用いた```fs fmap```の合成を最適化する例がある
    - ```hs Yoneda```は```hs fmap```の合成を合成の```hs fmap```に変換することで```hs fmap```の回数を1回にまとめることができる
    
]

#new-section-slide("Codensity")

#slide[
    == 🙇謝罪

    プロポーザルでは```hs Codensity```でパフォーマンス改善する具体例を紹介すると書いていましたが、時間が足りないことと数式を並べるよりも良い説明を思いつかないことから割愛いたします。

    この発表では具体例ではなく概要だけを紹介します。
]

#slide[
    ここまで、```hs fmap```の合成の最適化について扱った。

    ↓

    ```hs fmap```以外はどうか？

    ```hs Codensity```を用いると、次のような例について同様の最適化ができる。

    ```hs ((m >>= k1) >>= k2) >>= k3```
]

#slide[


    ```hs Codensity```は```hs Yoneda```と似たような感じで定義されている。
    #sourcecode[```hs
        newtype Yoneda f a = Yoneda
            { runYoneda :: forall b. (a -> b) -> f b }

        newtype Codensity m a = Codensity
            { runCodensity :: forall b. (a -> m b) -> m b }
    ```]
    
    #reflink("https://hackage-content.haskell.org/package/kan-extensions-5.2.8/docs/src/Control.Monad.Codensity.html")
    
]
/*
#slide[
    ```hs Yoneda```のときと同様に、次の2つの関数で```hs Codensity```との間を行ったり来たりできる。
    #sourcecode[```hs
        instance MonadTrans Codensity where
            lift m = Codensity (m >>=)
        
        lowerCodensity :: Applicative f => Codensity f a -> f a
        lowerCodensity a = runCodensity a pure
    ```]

    #text(size: 0.75em)[
        なぜか```hs liftCodensity```自体はなく、```hs MonadTrans```の```hs lift```を使っている。
    ]
]

#slide[
    図で書くと…

    #align(center, diagram({
        node((0, 0), [```hs f a```])
        node((2, 0), [```hs Yoneda f a```])
        edge((0, 0), (2, 0), [```hs liftYoneda```], label-side: left, shift: 0.1, "->")
        edge((2, 0), (0, 0), [```hs lowerYoneda```], label-side: left, shift: 0.1, "->")
    }))
    

    #align(center, diagram({
        node((0, 0), [```hs m a```])
        node((2, 0), [```hs Codensity m a```])
        edge((0, 0), (2, 0), [```hs lift```], label-side: left, shift: 0.1, "->")
        edge((2, 0), (0, 0), [```hs lowerCodensity```], label-side: left, shift: 0.1, "->")
    }))

]
*/
/*
#slide[
    具体例

    ```hs [Int]```の例として、```hs [1,2]```を考える。

    #align(center, diagram({
        node((0,0), [```hs [1,2]```])
        node((2,0), [```hs Codensity ([1,2] >>=)```])

        node((0,1), [```hs [1,2] >>= pure```])
        node((2,1), [```hs Codensity ([1,2] >>=)```])

        edge((0,0),(2,0),[```hs lift```], label-side: left, "|->")
        edge((2,1),(0,1),[```hs lowerCodensity```], label-side: left, "|->")

        edge((0,0),(0,1), "=")
        edge((2,0),(2,1), "=")
    }))

    ```hs lowerCodensity . lift ≡ id```だが、```hs lift```と```hs lowerCodensity```は互いに逆関数になっていない。
]

#slide[
    ```hs Codensity```は```hs (>>=)```の合成を最適化する。
    ```hs Codensity```の```hs (>>=)```の定義は以下の通り。
    
    #sourcecode[```hs
        instance Monad (Codensity f) where
            return = pure
            m >>= k　= Codensity
                (\c -> runCodensity m (\a -> runCodensity (k a) c))
            
    ```]
]
*/

#slide[
    ```hs fmap```の合成は```hs Yoneda```を経由することで合成の```hs fmap```に変換できた。
    
    #align(center, diagram({
        node((0,0),[```hs (fmap g) . (fmap f)```])
        node((1,0),[```hs fmap (g . f)```])

        edge((0,0),(1,0),[変換],"->")

    }))


    ```hs (>>=)```の合成```hs (m >>= k) >>= h```は```hs Codensity```を経由することで次の形に変換できる。

    #align(center, diagram({
        node((0,0),[```hs (m >>= k) >>= h```])
        node((1,0),[```hs m >>= (\x -> k x >>= h)```])

        edge((0,0),(1,0),[変換],"->")
    }))

    #text(size: 0.75em)[
    ```hs (>>=)```が満たすべき性質```hs (m >>= k) >>= h ≡ m >>= (\x -> k x >>= h)```
    ]
]

#slide[
    ```hs Codensity```を経由することで、```hs (>>=)```の計算方法を変えることができる。
    ```hs m >>= k```の処理が重い場合、これを回避することでパフォーマンスを改善することができる。

    #align(center, diagram({
        node((0,0),[```hs (m >>= k) >>= h```])
        node((0,1),[```hs m >>= (\x -> k x >>= h)```])

        edge((0,0),(0,1),[改善],"->")
    }))
]

#slide[
    ここまでのまとめ

    - ```hs Yoneda```とよく似た```hs Codensity```がkan-extensionsに存在する。
    - ```hs fmap```の合成は```hs Yoneda```で高速化できる
    - ```hs (>>=)```の合成は```hs Codensity```で高速化できる
]

#new-section-slide("Ran")

#slide[
    ```hs Yoneda```と```hs Codensity```はよく似ている。

    #text(size: 0.8em)[
    #align(center + horizon)[
        #sourcecode[```hs
        newtype Yoneda    f a
            = Yoneda    { runYoneda    :: forall b. (a ->   b) -> f b }

        newtype Codensity m a
            = Codensity { runCodensity :: forall b. (a -> m b) -> m b }
        ```]
    ]
    ]
]

/*
#slide[
    ```hs Yoneda```と```hs Codensity```で異なっている箇所（赤色）

    newtype Yoneda f a\
    #h(1em)\= Yoneda { runYoneda :: forall b. (a -> #text(red)[\_] b) -> f b }

    newtype Codensity m a\
    #h(1em)\= Codensity { runCodensity :: forall b. (a -> #text(red)[m] b) -> m b }

    ```hs forall b. (a -> g b) -> h b```のような型を考えれば、この2つを一般化できそう。

]
*/

#slide[
    Rを次のように定義すると、この2つを一般化できそう。

    #text(size: 0.8em)[
    #align(center + horizon)[
        #sourcecode[```hs
        newtype Yoneda      f a
            = Yoneda    { runYoneda    :: forall b. (a ->   b) -> f b }

        newtype Codensity   m a
            = Codensity { runCodensity :: forall b. (a -> m b) -> m b }

        newtype R         g h a
            = R         { run          :: forall b. (a -> g b) -> h b }
        ```]
    ]
    ]
]

/*
#slide[

```hs g = Identity```とすると、```hs Yoneda```になる。

#sourcecode[```hs
newtype R g h a
 = R { run :: forall b. (a -> g b) -> h b }
```]

#sourcecode[```hs
newtype Yoneda f a 
 = Yoneda { runYoneda :: forall b. (a -> b) -> f b }
```]
]

#slide[
一方、```hs g = h```とすると、```hs Codensity```になる。
#sourcecode[```hs
newtype R g h a
 = R { run :: forall b. (a -> g b) -> h b }
```]

#sourcecode[```hs
newtype Codensity m a
 = Codensity { runCodensity :: forall b. (a -> m b) -> m b }
```]
]
*/

#slide[
実はこの```hs R```こそが、kan-extensionsで定義されている右Kan拡張```hs Ran g h a```。
#sourcecode[```hs
newtype Ran g h a
 = Ran { runRan :: forall b. (a -> g b) -> h b }
```]

```
Yoneda f a ≅ Ran Identity f a
Codensity g a ≅ Ran g g a
```

```hs Ran```は```hs Yoneda```と```hs Codensity```の一般化になっている。
]

#slide[
    あとは、```hs Ran```が圏論の右Kan拡張に対応していることを確認すればよい。

    次の順番で確認する。
    - ```hs Ran g h a```を圏論的に表すと$"Hom" ("Hom" (a, G -), H)$
    - 右Kan拡張の随伴より、上記が$"Hom"("Hom"(a,-), "Ran"_G H)$と同型
    - 米田の補題より、上記が$"Ran"_G H(a)$と同型
]

#slide[
Haskellと圏論の関係を見るために、Haskellの型、関数などを圏論の言葉で書き直す。

- 型 ```hs a``` は対象 $a$
- 関数 ```hs a -> b``` は $"Hom" (a,b)$ の元。
- ``` f a``` は 関手 $F$ で $a$を移したもの $F(a)$ に対応する。
- ```hs forall a. f a -> g a``` は自然変換 $"Hom" (F,G)$ に対応する。

#text(size: 0.75em)[※厳密には違うと思うが、一旦これで進める。]

]

#slide[
Haskellの右Kan拡張の定義は以下のとおり。

#sourcecode[```hs
newtype Ran g h a
 = Ran { runRan :: forall b. (a -> g b) -> h b }
```]

これを圏の言葉に書き換えると、次のようになる。

$ "Hom" ("Hom" (a,G -), H) $
]

#slide[
    #align(horizon)[
        - ```hs Ran g h a```を圏論的に表すと$"Hom" ("Hom" (a, G -), H)$ #text(red)[*←OK*]
        - 右Kan拡張の随伴より、上記が$"Hom"("Hom"(a,-), "Ran"_G H)$と同型
        - 米田の補題より、上記が$"Ran"_G H(a)$と同型
    ]
]

#slide[
圏論における右Kan拡張の定義

$C,D,E$を圏として、$G:C -> D, H:C -> E$を関手とする。

#align(center, diagram({
	node((0, 0), [$C$])
	node((0, -1), [$D$])
	node((1, 0), [$E$])
	edge((0, 0), (1, 0), [$H$], label-side: right, "->")
	edge((0, 0), (0, -1), [$G$], label-side: left, "->")
}))
]

//#text(size: 0.75em)[※この状況を俗に#text(red)[*Kan拡張チャンス!!*]と呼ぶ。]

#slide[
次の2つの条件を満たす$("Ran"_G H,epsilon)$を*$G$に沿った$H$の右Kan拡張*と呼ぶ。

1. $"Ran"_G H$は関手$D -> E$で、$epsilon$は自然変換$"Ran"_G H compose G => H$

#align(center)[
#image("assets/ran-1.png", width: 30%)
]

]

#slide[
2. 関手$S:D ->E$と、自然変換$theta:S compose G => H$に対して、次を満たす自然変換$tau:S => "Ran"_G H$が一意に存在する。

$ theta = epsilon compose tau G $

#align(center)[
#image("assets/ran-2.png")
]

]


#slide[

$H$を$"Ran"_G H$に送る関手を$"Ran"_G$で表す。

関手$C->E$からなる圏を$E^C$のように書くと、$"Ran"_G$は関手$E^C->E^D$。

#align(center + horizon, diagram({
	node((0, 0), [$C$])
	node((0, -2), [$D$])
	node((2, 0), [$E$])
	node((4, 0), [$E^C$])
	node((6, 0), [$E^D$])
	edge((0, 0), (2, 0), [$H$], label-side: right, "->")
	edge((0, 0), (0, -2), [$G$], label-side: left, "->")
	edge((0, -2), (2, 0), [$"Ran"_G H$], label-side: left, "->")
	edge((4, 0), (6, 0), [$"Ran"_G$], label-side: left, "->")
}))

]

#slide[
関手$"Ran"_G:E^C->E^D$には随伴関手（良い性質を持つ逆向きの関手）がある。
$G^(-1):E^D->E^C$を$S |-> S compose G$とすると、$G^(-1)$は$"Ran"_G$の左随伴になる。

// https://q.uiver.app/#r=typst&q=WzAsMixbMCwwLCJFXkMiXSxbMiwwLCJFXkQiXSxbMCwxLCJcIlJhblwiX0ciLDIseyJvZmZzZXQiOjN9XSxbMSwwLCJHXigtMSkiLDIseyJvZmZzZXQiOjN9XSxbMywyLCIiLDIseyJsZXZlbCI6MSwic3R5bGUiOnsibmFtZSI6ImFkanVuY3Rpb24ifX1dXQ==
#align(center + horizon)[
#image("assets/adjunction.png", width:50%)
]
]

#slide[
議論しやすいように、Haskellの圏 $"Hask"$ の代わりに 集合の圏 $"Set"$ で考える。

$E$を$"Set"$に置き換える。
#text(size: 0.9em)[
#align(center + horizon, diagram({
	node((0, 0), [$C$])
	node((0, -2), [$D$])
	node((2, 0), [#text(red)[$"Set"$]])
	
	node((4, 0), [#text(red)[$"Set"^C$]])
	node((6, 0), [#text(red)[$"Set"^D$]])

	edge((0, 0), (2, 0), [$H$], label-side: right, "->")
	edge((0, 0), (0, -2), [$G$], label-side: left, "->")
	edge((0, -2), (2, 0), [$"Ran"_G H$], label-side: left, "->")
	edge((4, 0), (6, 0), [$"Ran"_G$], shift: -0.15, label-side: right, "->")
	edge((6, 0), (4, 0), [$G^(-1)$], shift: -0.15, label-side: right, "->")
}))
]
]

#slide[

随伴と$G^(-1) tack.l "Ran"_G$と、随伴の定義より任意の$S in E^D$と$H in E^C$に対して、以下が成り立つ。
$ "Hom"_("Set"^C) (G^(-1) S, H) tilde.equiv "Hom"_("Set"^D) (S, "Ran"_G H) $

$S$は任意なので、$S = "Hom"_D (a,-)$ でも成り立つ。

$ "Hom"_("Set"^C) (G^(-1) "Hom"_D (a,-), H) tilde.equiv "Hom"_("Set"^D) ("Hom"_D (a,-), "Ran"_G H) $

#text(size: 0.75em)[
    ※任意の$b in D$に対して、$"Hom"_D (a,b)$は集合であると仮定する。つまり、$D$は局所小圏とする。
]

]

#slide[
    $G^(-1):E^D->E^C$は$S |-> S compose G$なので、次のように書き換えられる。
    $ "Hom"_("Set"^C) (G^(-1) "Hom"_D (a,-), H) = "Hom"_("Set"^C) ("Hom"_D (a,G -), H) $

    まとめると

    $
        &"Hom"_("Set"^C) ("Hom"_D (a,G -), H) \
        = &"Hom"_("Set"^C) (G^(-1) "Hom"_D (a,-), H) & #ja[（$G^(-1)$に書き換え）] \
        tilde.equiv &"Hom"_("Set"^D) ("Hom"_D (a,-), "Ran"_G H) & (G^(-1) tack.l "Ran"_G)
    $
]

#slide[
    #text(size: 0.9em)[
    #align(horizon)[
        - ```hs Ran g h a```を圏論的に表すと$"Hom" ("Hom" (a, G -), H)$ #text(red)[←OK]
        - 右Kan拡張の随伴より、上記が$"Hom"("Hom"(a,-), "Ran"_G H)$と同型 #text(red)[*←OK*]
        - 米田の補題より、上記が$"Ran"_G H(a)$と同型
    ]
    ]
]

#slide[
示すべきこと

$ "Hom"_("Set"^D) ("Hom"_D (a,-), "Ran"_G H) tilde.equiv "Ran"_G H (a) $

これは米田の補題より成り立つ。

*米田の補題*

$D$を局所小圏、$F: D -> "Set"$を関手とする。このとき次が成り立つ。
$ "Hom"_("Set"^D) ("Hom"_D (a,-), F) tilde.equiv F (a) $

]

 #slide[
    Yonedaと米田の補題の関係

    ```hs Yoneda f a = Yoneda { runYoneda :: forall b. (a -> b) -> f b }```

    #align(center, diagram({
        node((0, 0), [```hs f a```])
        node((2, 0), [```hs Yoneda f a```])
        edge((0, 0), (2, 0), [```hs liftYoneda```], label-side: left, shift: 0.1, "->")
        edge((2, 0), (0, 0), [```hs lowerYoneda```], label-side: left, shift: 0.1, "->")
    }))

    #align(center, diagram({
        node((0, 0), [$F(a)$])
        node((2, 0), [$"Hom"_("Set"^D) ("Hom"_D (a,-), F)$])
        edge((0, 0), (2, 0), label-side: left, shift: 0.1, "->")
        edge((2, 0), (0, 0), label-side: left, shift: 0.1, "->")
    }))
 ]

#slide[
    #text(size: 0.9em)[
    #align(horizon)[
        - ```hs Ran g h a```を圏論的に表すと$"Hom" ("Hom" (a, G -), H)$ #text(red)[←OK]
        - 右Kan拡張の随伴より、上記が$"Hom"("Hom"(a,-), "Ran"_G H)$と同型 #text(red)[←OK]
        - 米田の補題より、上記が$"Ran"_G H(a)$と同型 #text(red)[*←OK*]
    ]
    ]
]

#slide[
まとめ

集合の圏$"Set"$をHaskellの圏だと思うと、```hs Ran g h a```と右Kan拡張$"Ran"_G H(a)$が同型であることを確認できる。

$
&"Hom"_("Set"^C) ("Hom"_D (a,G -), H) & #ja[（Haskellの右Kan拡張）] \
tilde.equiv &"Hom"_("Set"^D) ("Hom"_D (a,-), "Ran"_G H) & (G^(-1) tack.l "Ran"_G) \
tilde.equiv &"Ran"_G H(a) & #ja[（米田の補題）] \
$
]

#new-section-slide("まとめ")

#slide[
    最初の問い

    Haskellの概念もKan拡張として理解できるのでは？

    #align(horizon + center, diagram({
        node((0, 0), [圏論])
        node((0, -2), [Haskell])
        node((2, 0), [Kan拡張])
        edge((0, 0), (0, -2), [影響], label-side: left, "->")
        edge((0, 0), (2, 0), [すべての概念], label-side: right, "->")
        edge((0, -2), (2, 0), text(fill: red)[?], label-side: left, "->",stroke: red)
    }))
]

#slide[
    パフォーマンス改善に利用できる```hs Yoneda```や```hs Codensity```がKan拡張の例となっている。

    #align(horizon + center, diagram({
        node((0, 0), [圏論])
        node((0, -2), [Haskell])
        node((2, 0), [Kan拡張])
        edge((0, 0), (0, -2), [影響], label-side: left, "->")
        edge((0, 0), (2, 0), [すべての概念], label-side: right, "->")
        edge((0, -2), (2, 0), text(fill: red)[```hs Yoneda```、```hs Codensity```など], label-side: left, "->",stroke: red)
    }))
]

#slide[
    まとめ

    - ```hs Yoneda```は```hs fmap```の合成のパフォーマンスを改善できる
    - ```hs Codensity```は```hs (>>=)```の合成のパフォーマンスを改善できる
    - ```hs Ran```は```hs Yoneda```と```hs Codensity```の一般化である
    - ```hs Ran```と右Kan拡張の対応は、右Kan拡張の随伴と米田の補題を用いて示せる

    #align(bottom + center)[
        #text(size: 1.25em)[
        ご清聴ありがとうございました。
        ]
    ]
]

#slide[
    余談

    #align(horizon + center, diagram({
        node((0, 0), [圏論])
        node((0, -2), [Haskell])
        node((2, 0), [Kan拡張])
        edge((0, 0), (0, -2), [影響], label-side: left, "->")
        edge((0, 0), (2, 0), [すべての概念], label-side: right, "->")
        
    })) 

    この状況は#text(red)[Kan拡張チャンス!!]である。
]

#slide[

    #align(horizon + center, diagram({
        node((0, 0), [圏論])
        node((0, -2), [Haskell])
        node((2, 0), [Kan拡張])
        edge((0, 0), (0, -2), [影響], label-side: left, "->")
        edge((0, 0), (2, 0), [すべての概念], label-side: right, "->")
        edge((0, -2), (2, 0), text(fill: red)[$"Ran"_#ja[影響] #ja[すべての概念]$], label-side: left, "->",stroke: red)
    })) 

    「実はこの発表内容自体がKan拡張になっていたのだ」と言えると面白かったが、これは過言。
 ]
 
#slide[
    == すべての概念はKan拡張

    === Kan拡張の例

    - 関手$F : C -> D$が右随伴を持つとき、その右随伴は$"Lan"_F id_C$
    - 関手$G : D -> C$が左随伴を持つとき、その左随伴は$"Ran"_G id_D$
    - 極限は右Kan拡張
    - 余極限は左Kan拡張

    随伴も極限も抽象的な概念。
]

#slide[
    #columns(2)[
    === 随伴の例

    - 自由群関手は忘却関手の左随伴
    - 集合$A$に対して$- times A$は$(-)^A$の左随伴

    #colbreak()

    === 極限の例

    - 終対象
    - 直積
    - 等化子
    - 引き戻し
    - 逆極限
    ]
]

#slide[
    #text(size: 1em)[
        #columns(3)[
            === 終対象の例
            - 一元集合
            - 自明群（始対象でもある）
            - 整数の整除関係の圏における0
            - Unit型 ```hs ()```
            
            #colbreak()
            
            === 直積の例
            - 集合の直積
            - 位相空間の直積
            - 整数の整除関係の圏における最大公約数
            - タプル ```hs (a,b)```

            #colbreak()
            
            === 逆極限の例
            - $p$-進整数
            - 副有限群

        ]
    ]
]

 #slide[
    #text(size: 0.75em)[
        #bibliography-list(
            title: [参考文献],
            ..bib-file(read("reference.bib")),
        )
    ]
 ]