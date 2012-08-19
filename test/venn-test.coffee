window.onload = ->
  venn2 "container", {cards: [100, 200], overlap: 50}, 75
  venn2 "container", {cards: [100, 200], overlap: 100}, 50
  venn2 "container", {cards: [100, 200], overlap: 300}
  venn2 "container", {cards: [100, 200], overlap: 90}
  venn2 "container", {cards: [100, 200], overlap: -1}
  venn2 "container", {cards: [100, 200], overlap: 90, labels: ['Small', 'Large']}
  venn2 "container", {cards: [100, 60], overlap: 30, labels: ['Large', 'Small']}
  venn2 "container", {cards: [100, 60], overlap: 30, labels: ['Large', 'Small']}, 5

  venn3 "container", {cards: [100, 200, 200], overlap: [20, 40, 40], labels: ["100", "200,1", "200,2"]}
  venn3 "container", {cards: [200, 200, 200], overlap: [40, 40, 40], labels: ["200,1", "200,2", "200,3"]}
  venn3 "container", {cards: [100, 200, 150], overlap: [40, 40, 40], labels: ["100", "200", "150"]}
  venn3 "container", {cards: [100, 200, 80], overlap: [20, 40, 70], labels: ["Second", "Largest", "Smallest"]}
  venn3 "container", {cards: [100, 200, 80], overlap: [20, 40, 0]}
  venn3 "container", {cards: [100, 200, 80], overlap: [20, 0, 70]}
  venn3 "container", {cards: [100, 200, 80], overlap: [0, 40, 70]}
  venn3 "container", {cards: [100, 200, 80], overlap: [0, 0, 70]}
  venn3 "container", {cards: [100, 200, 80], overlap: [20, 0, 0]}
  venn3 "container", {cards: [100, 200, 80], overlap: [0, 40, 0]}
  venn3 "container", {cards: [100, 200, 80], overlap: [0, 0, 0]}

