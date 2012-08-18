Area proportional Venn diagram for JavaScript
===================
Inspired by Google Chart API Venn Chart. This is a minimal implementation. It only draws circles with areas proportional to their weights. Data label is not supported.

+ You can customize circle fill color and opacity.
+ Graph height is customizable, however graph width is not. It is calculated on the fly.

Usage
======
**Requires Raphael.js**

    <script type="text/javascript" src="raphael-min.js"></script>
    <script type="text/javascript" src="../lib/venn.js"></script>
      
    venn("container", {cards: [100, 200], overlap: 50});
    venn("container", {cards: [100, 200], overlap: 50}, 100);
    venn("container", {cards: [100, 200], overlap: 50}, 100, {
      fill: {left: "#FF6633", right: "#7FC633"},
      "fill-opacity": {left: 0.8, right: 0.8}
    });

Limitations
==============
+ For 3-set area proportional Venn diagrams, there're weight distrubutions that can not be properly represented using circles if we consider all intersection weights. To simplify implementation, for a 3-set input (A, B, C). We only consider the intersections of (AB, AC, BC), ABC is not considered.
+ If the weight of AB is larger than min(wight(A), weight(B)), it is normalized to min(wight(A), weight(B)).
+ Negative weight value is normalized to 0.

