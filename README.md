Area proportional Venn diagram for JavaScript
===================
Inspired by Google Chart API Venn Chart. This is a minimal implementation. Supports 2-Set and 3-Set area proportional area Venn Chart using circles. There're differences between the Google Chart API and this implementation. See Limitations and Known Issues at the end of the document.

+ You can customize circle fill color and opacity.
+ Largest circle radius is customizable, smaller circle radiuses and graph width/height is calculated on the fly.
+ Optional data labels

Usage
======
**Requires Raphael.js**

**Written in CoffeeScript, the JavaScript files are auto generated. DO NOT edit them.**

    <script type="text/javascript" src="raphael-min.js"></script>
    <script type="text/javascript" src="../lib/venn.js"></script>

    venn2 "container", {cards: [100, 200], overlap: 50}, 75
    venn2 "container", {cards: [100, 200], overlap: 100}, 50
    venn2 "container", {cards: [100, 200], overlap: 300}
    venn2 "container", {cards: [100, 200], overlap: 90}
    venn2 "container", {cards: [100, 200], overlap: -1}
    venn2 "container", {cards: [100, 200], overlap: 90, labels: ['Small', 'Large']}
    venn2 "container", {cards: [100, 60], overlap: 30, labels: ['Large', 'Small']}
    venn2 "container", {cards: [100, 60], overlap: 30, labels: ['Large', 'Small']}, 5

    // {cards: [A, B, C], overlap: [AB, AC, BC]}
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

    # you can customize drawing options
    venn2("container", {cards: [100, 200], overlap: 50}, 75, {
      fill: ["#FF6633", "#7FC633"],
      "fill-opacity": [0.8, 0.8]
    });

Limitations and Known Issues
==============
+ For 3-set area proportional Venn diagrams, there're weight distrubutions that can not be properly represented using circles. To simplify implementation, for a 3-set input (A, B, C). We only consider the intersections of (AB, AC, BC), ABC is not considered.
+ Individual weight is satisfied first. So when there's no solution, the intersection areas may not be proportional to their weights.
+ If the weight of AB is larger than min(wight(A), weight(B)), it is normalized to min(wight(A), weight(B)).
+ Negative weight value is normalized to 0.

