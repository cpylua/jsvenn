// Generated by CoffeeScript 1.3.3
(function() {

  window.onload = function() {
    venn("container", {
      cards: [100, 200],
      overlap: 50
    }, 50);
    venn("container", {
      cards: [100, 200],
      overlap: 100
    }, 100);
    venn("container", {
      cards: [100, 200],
      overlap: 200
    });
    venn("container", {
      cards: [100, 200],
      overlap: 1
    });
    return venn("container", {
      cards: [100, 200],
      overlap: 0
    });
  };

}).call(this);
