window.onload = ->
  venn2 "container", {cards: [100, 200], overlap: 50}, 75
  venn2 "container", {cards: [100, 200], overlap: 100}, 50
  venn2 "container", {cards: [100, 200], overlap: 300}
  venn2 "container", {cards: [100, 200], overlap: 90}
  venn2 "container", {cards: [100, 200], overlap: -1}

  venn3 "container", {cards: [100, 200, 200], overlap: [20, 40, 40]}
  venn3 "container", {cards: [200, 200, 200], overlap: [40, 40, 40]}
  venn3 "container", {cards: [100, 200, 150], overlap: [40, 40, 40]}
  venn3 "container", {cards: [100, 200, 80], overlap: [20, 40, 70]}
  venn3 "container", {cards: [100, 200, 80], overlap: [20, 40, 0]}
  venn3 "container", {cards: [100, 200, 80], overlap: [20, 0, 70]}
  venn3 "container", {cards: [100, 200, 80], overlap: [0, 40, 70]}
  venn3 "container", {cards: [100, 200, 80], overlap: [0, 0, 70]}
  venn3 "container", {cards: [100, 200, 80], overlap: [20, 0, 0]}
  venn3 "container", {cards: [100, 200, 80], overlap: [0, 40, 0]}
  venn3 "container", {cards: [100, 200, 80], overlap: [0, 0, 0]}

