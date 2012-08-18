###
container: DOM element or its ID for canvas
weights: area weights, {cards: [100, 200], overlap: 50}
height: canvas height, canvas width two times height
opts: drawing options

NOTE: the bigger circle is always drawn on the left
###
venn = (container, weights, height = 200, opts) ->
  opts = opts or {
    fill: {left: "#FF6633", right: "#7FC633"}   # circle fill color
    "fill-opacity": {left: 0.8, right: 0.8}     # circle opacities
  }
  margin = 2

  # Calculate the radius so that circle area is proportional to weights 
  calcRadiuses = (maxDiameter, cards) ->
    [big, small] = if cards[0] > cards[1] then cards else cards.reverse()
    r = maxDiameter / 2.0 - margin
    [r, r * Math.sqrt small / big]

  # fix overlap
  normalizeWeights = (weights) ->
    maxOverlap = Math.min weights.cards...
    weights.overlap = maxOverlap if maxOverlap < weights.overlap
    weights.overlap = 0 if weights.overlap < 0

  # calculate the intersection area
  intersectionArea = (radiuses, angles) ->
    [r1, r2] = radiuses
    [alpha, beta] = angles
    area = (r, angle) -> 0.5 * Math.pow(r, 2) * (angle - Math.sin angle)
    area(r1, alpha) + area(r2, beta)

  # distance: the distance between two circle centers
  calcAngles = (radiuses, distance) ->
    angle = (r1, r2, d) ->
      2 * Math.acos (Math.pow(d, 2) + Math.pow(r1, 2) - Math.pow(r2, 2)) / (2 * r1 * d)
    [r1, r2] = radiuses
    [angle(r1, r2, distance), angle(r2, r1, distance)]

  # Scale intersection weight to graph area
  scaleIntersection = (weights, radius) ->
    big = Math.max weights.cards...
    Math.PI * Math.pow(radius, 2) * weights.overlap / big

  # The left circle is fixed at (rleft, 0), find the position
  # for the right circle so that their intersection area is proportional
  # to the weight.
  # Bisection is used to find the right position
  findDistance = (radiuses, interArea) ->
    [rleft, rright] = radiuses
    [upper, lower] = [rleft - rright, rleft + rright]
    d = (upper + lower) / 2.0
    while true
      angles = calcAngles radiuses, d
      area = intersectionArea radiuses, angles
      delta = area - interArea
      console.log Math.abs delta
      break if Math.abs(delta) < 0.1
      if delta < 0 then lower = d else upper = d
      d = (upper + lower) / 2.0
    d# the position we found

  draw = (paper, radiuses, distance, opts) ->
    [cxleft, cyleft] = [radiuses[0] + margin, radiuses[0] + margin]
    [cxright, cyright] = [cxleft + distance, cyleft]
    left = paper.circle cxleft, cyleft, radiuses[0]
    left.attr {
      "stroke-width": 0
      fill: opts.fill.left
      "fill-opacity": opts["fill-opacity"].left
    }
    right = paper.circle cxright, cyright, radiuses[1]
    right.attr {
      "stroke-width": 0
      fill: opts.fill.right
      "fill-opacity": opts["fill-opacity"].right      
    }

    # set paper size based on final results
    rbb = right.getBBox()
    w = rbb.x2 + margin
    paper.setSize w, height


  # start drawing
  width = height * 2 # canvas width
  paper = Raphael container, width, height

  normalizeWeights weights
  radiuses = calcRadiuses height, weights.cards
  interArea = scaleIntersection weights, Math.max radiuses...
  distance = findDistance radiuses, interArea
  draw paper, radiuses, distance, opts

# export venn
root = exports ? this
root.venn = venn
