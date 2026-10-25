#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "@preview/polylux:0.4.0": *
#import "@preview/cetz:0.5.2"
#import "@preview/cetz-plot:0.1.4": chart

#import "@preview/merman:0.3.0": mermaid

// enja-bib
#import "@preview/enja-bib:0.2.0": *
#import bib-setting-plain: *
#show: bib-init

#set page(
    paper: "presentation-16-9",
    numbering: (current, total) => text(
        size: 9pt
    )[
        // #current / #total
        #current
    ]
)

// #let font-size = float(sys.inputs.font_size) * 1pt
// #set text(font: ("BIZ UDPGothic"), size: font-size)
#set text(font: ("BIZ UDPGothic"), size: 26pt, lang: "ja")

#show link: underline

#set quote(block: true)

#let superchat(
    color,
    name,
    amount,
    message,
) = {
  box(
    width: 75%,
    fill: color,
    radius: 8pt,
    inset: 12pt,
    [
        #text(fill: white, weight: "bold")[#name]

        #text(fill: white, weight: "bold")[#amount]

        #v(16pt)

        #text(fill: white)[#message]
    ]
  )
}

#slide[
    #align(horizon)[
        = 推しに#text(fill: red, size: 2em)[5,000兆]円スパチャしたら
        = 日本の産業どうなっちゃうのか？
    
    ]

  #align(bottom)[
    #text(size: 0.75em)[
        2026-10-25

        グミ\@GummyCandy1206

        第37回日曜数学会 
    ]
  ]
]

#slide[
    = 推し

    人にすすめたいほど気に入っている人

    #text(size: 0.5em)[
        #figure(
            image("images/pose_heart_hand_idol_woman.png", width: 30%),
            caption: [ファンサービスをするアイドルのイラスト（女性） | かわいいフリー素材集 いらすとや]
        )
    ]
]

#slide[
    = スパチャ

    「スーパーチャット」の略

    YouTubeで配信者に、応援のメッセージを添えて投げ銭すること

    #text(size: 0.75em)[
        #align(horizon)[
            #superchat(
                blue,
                "グミ",
                "¥200",
                "音出てないです",
            )
        ]
    ]
]

#slide[
    = 口座に#text(fill: red, size: 1.5em)[5,000兆]円あるとする

    #text(size: 0.5em)[
        #figure(
            image("images/bank_app.png", width: 60%),
            caption: [口座に5,000兆円ある図]
        )
    ]
    /*
    #align(horizon+center)[
        #text(size: 14pt)[
            #table(
                columns: 5,
                align: right,
                inset: 0.75em,
                table.header(
                    [#align(center)[*年月日*]],[#align(center)[*摘要*]],[#align(center)[*お預り金額*]],[#align(center)[*お支払金額*]],[#align(center)[*残高*]]
                ),
                [2026-10-25],[],[],[],[\*5,000,000,000,000,000]
            )
        ]
    ]
    */
]

#slide[
    = 全額推しにスパチャする
    
    #align(horizon)[
        #superchat(
            rgb("#FF0000"),
            "グミ",
            "¥5,000,000,000,000,000",
            "画面映ってないです",
        )
    ]
]

#slide[
    = このときの日本の産業への影響を考える

    #text(size: 0.5em)[
        #figure(
            image("images/CC176164632.jpg", width: 50%),
            caption: [株の大暴落を示すローソク足チャート分析図の写真素材 - フリー素材ぱくたそ]
        )
    ]
]

#slide[
    = 影響

    以下のような感じで影響が波及するはず

    → #text(fill: red)[具体的な金額を計算したい！]

    #align(center)[

        #mermaid("
            flowchart LR
            Me[ぼく] --> Google --> Office[事務所] --> Streamer[配信者]
            Google --> GPU[GPUメーカー] --> SC[半導体メーカー]
            Office --> Ad[広告代理店]
        ")
    ]
]

#slide[
    = どうやって計算するか？

    #align(horizon)[
        → #text(size: 3em, fill: red)[産業連関分析]を用いる
    ]
]

#slide[
    = 産業連関分析とは？

    #align(horizon)[

    産業の生産額と需要の関係等を
    
    #text(fill: red, size: 3em)[線形代数]を使って分析する方法

    ]
]

#slide[
    = データ

    以下の情報をもとに計算する

    #text(size: 0.5em)[

    産業連関表 令和2年（2020年）産業連関表 2020年 | ファイル | 統計データを探す | 政府統計の総合窓口
    
    #link("https://www.e-stat.go.jp/stat-search/files?page=1&layout=datalist&toukei=00200603&tstat=000001218140&cycle=0&year=20200&month=0")

    ]
]

#let emphred(x) = {
    text(fill: red, size: 1.5em)[#x]
}

#slide[
    = 計算結果

    サービス業の需要を#emphred[5,000兆]円増加させた場合

    誘発される生産額は#emphred[8,883兆]円

    そのうちサービス業は#emphred[5,916兆]円

    内訳が最も小さい建設業でさえ#emphred[37兆]円

    #text(size: 0.5em)[（Googleなど海外への支払いは考えない）]
]

#slide[
    = 結論

    #text(size: 1.2em)[
    推しに#text(fill: red, size: 1.5em)[5,000兆]円スパチャする#text(size: 0.5em)[
        ことを、
        
        サービス業の需要を5,000兆円増加させることと仮定すると、


    ]日本全体で誘発される生産額は#text(fill: red, size: 1.5em)[8,883兆]円！

    ]
    
]

#slide[
    = 産業連関分析の個人的おもしろポイント 1

    #text(size: 1.5em, fill: red)[線形代数]のわかりやすい応用例である

    #text(size: 0.75em)[
    - 今回の計算だけなら逆行列の計算までの知識でOK

    - 数学教育に取り入れられた例あり @kajitori2010
    ]
]

#slide[
    = 産業連関分析の個人的おもしろポイント 2

    産業連関分析を考案・発展させた経済学者レオンチェフは、その功績で#text(fill: red, size: 2em)[ノーベル経済学賞]を受賞している！
    
    #text(size: 0.75em)[
        歴史的経緯も含めておもしろい！
    ]
]

#slide[
    = まとめ

    - 推しに#emphred[5,000兆]円スパチャすると、日本の産業全体で誘発される生産額は#emphred[8,883兆]円#footnote[#text(size: 0.5em)[推しに5,000兆円スパチャすることを、サービス業の需要を5,000兆円増加させることと仮定し、Googleなど海外への支払いは考えないこととした場合]]
    - 産業連関分析は#emphred[線形代数]を学ぶ人にとって良い題材
    - 産業連関分析は#emphred[ノーベル経済学賞]を受賞した研究であり、歴史的にもおもしろい題材
]

#slide[
    = 補足：産業連関分析

    産業間の取引額を記載した#text(fill :red)[産業連関表]を線形代数の言葉で表すと以下のようになる

    #align(horizon)[

    $
        A X + F = X
    $

    #text(size: 0.5em)[
    $
        A: "投入係数行列"、X = mat(
            "農林漁業の生産額";
            "鉱業の生産額";
            dots.v;
            "分類不明の生産額"
        )、F = mat(
            "農林漁業の需要";
            "鉱業の需要";
            dots.v;
            "分類不明の需要"
        )
    $
    ]

    ]
]

#slide[
    = 補足：産業連関分析
    誘発される生産額を予想する

    #align(horizon)[

    $
        X = (I - A)^(-1) F
    $

    #text(size: 0.5em)[
    $A$: 投入係数行列、$X$: 国内生産額の列ベクトル、$F$: 最終需要の列ベクトル、$I$: 単位行列
    ]

    ]
]

#slide[
    = 補足：追加のおもしろポイント
    誘発される生産額を求める式は、等比級数の極限に似ている。

    $
        "誘発される生産額" X &= (I - A)^(-1) F \
          &= F + A F + A^2 F + dots \
        "等比級数の極限" x &= f / (1 - a) \
          &= f + a f + a^2 f + dots
    $
]

#slide[
    = 補足：マネタリーベースとの比較

    マネタリーベースとは、「日本銀行が供給する通貨」のこと。 @exbase

    平均残高：約533兆円 @base2609

    #text(size: 0.75em)[
    #align(center)[
    #cetz.canvas({
    let data = (
        ("マネタリーベース", 533),
        ("5,000兆円", 5000)
    )

    chart.columnchart(
        size: (20, 6),
        data,
    )
    })
    ]
    ]

]

#slide[
    = 補足：広義流動性との比較

    #text(size: 0.5em)[
    広義流動性 = 現金通貨＋預金通貨＋準通貨＋CD（預金通貨、準通貨、CDの発行者は、全預金取扱機関）＋金銭の信託＋投資信託＋金融債＋銀行発行普通社債＋金融機関発行 CP＋国債＋外債 @exms01
    ]

    残高：約2,343兆円 @ms2608

    #text(size: 0.75em)[
    #align(center)[
    #cetz.canvas({
    let data = (
        ("広義流動性", 2343),
        ("5,000兆円", 5000)
    )

    chart.columnchart(
        size: (20, 6),
        data,
    )
    })
    ]
    ]

]

#slide[
    #text(size: 12pt)[
        #bibliography(
            "reference.bib", 
            full: true
        )
    ]
]