###
container: DOM element or its ID for canvas
weights: area weights, {cards: [100, 200], overlap: 50, labels: ['X', 'Y']}
baseRadius: largest circle radius
opts: drawing options

NOTE: the bigger circle is always drawn on the left
###

g_margin = 2
g_threshold = 0.1
g_fontFamily = "Corbel, 'Lucida Grande', 'Lucida Sans Unicode', 'Lucida Sans', 'DejaVu Sans', 'Bitstream Vera Sans', 'Liberation Sans', Verdana, 'Verdana Ref', sans-serif"
g_fontSize = 11

venn2 = (container, weights, baseRadius = 100, opts) ->
  opts = opts or {
    fill: ["#FF6633", "#7FC633"]   # circle fill color for A, B in order
    "fill-opacity": [0.8, 0.8]     # circle opacities for A, B in order
  }

  height = (baseRadius + g_margin) * 2
  width = height * 2 # canvas width to fit all, it will be shinked
  paper = Raphael container, width, height

  # fix parameter order because radius is sorted in descending order
  labels = weights.labels?[..]
  if weights.cards[0] < weights.cards[1]
    labels?.reverse()
    opts.fill.reverse()
    opts["fill-opacity"].reverse()

  # graph layout
  normalizeWeights weights
  radiuses = calcRadiuses height, weights.cards
  interArea = scaleIntersection weights, Math.max radiuses...
  distance = findDistance radiuses, interArea

  draw2 paper, height, radiuses, distance, opts, labels

###
container: DOM element or its ID for canvas
weights: area weights, {cards: [A, B, C], overlap: [AB, AC, BC], labels:["A", "B", "C"]}
baseRadius: largest circle radius
opts: drawing options

NOTE: the bigger circle is always drawn on the left
###
venn3 = (container, weights, baseRadius = 100, opts) ->
  opts = opts or {
    fill: ["#FF6633", "#7FC633", "#22C6DE"]   # circle fill color for A, B, C in order
    "fill-opacity": [0.8, 0.8, 0.8]           # circle opacities for A, B, C in order
  }

  # make paper size large enough, it will be shinked
  height = 4 * baseRadius + 2 * g_margin
  width = 6 * baseRadius + 2 * g_margin
  paper = Raphael container, width, height

  diameter = baseRadius * 2
  normalizeWeights3 weights
  radiuses = calcRadiuses3 diameter, weights.cards
  interAreas = scaleIntersection3 weights.overlap, baseRadius, Math.max weights.cards...
  distances = findDistance3 radiuses, interAreas
  draw3 paper, radiuses, distances, interAreas, opts, weights.labels



###
helpers for venn2
###

# Calculate the radius so that circle area is proportional to weights 
calcRadiuses = (maxDiameter, cards) ->
  [big, small] = if cards[0] > cards[1] then cards else cards[..].reverse()
  r = maxDiameter / 2.0 - g_margin
  if big > 0 then [r, r * Math.sqrt small / big] else [0, 0]

# fix invalid set size and overlap
normalizeWeights = (weights) ->
  for item, idx in weights.cards
    weights.cards[idx] = 0 if item < 0
  maxOverlap = Math.min weights.cards...
  weights.overlap = maxOverlap if maxOverlap < weights.overlap
  weights.overlap = 0 if weights.overlap < 0

# calculate the intersection area
intersectionArea = (radiuses, angles) ->
  [r1, r2] = radiuses
  [alpha, beta] = angles
  if alpha is Math.PI and beta is Math.PI # one circle is contained in another
    r = Math.min r1, r2
    return Math.PI * Math.pow(r, 2)
  area = (r, angle) -> 0.5 * Math.pow(r, 2) * (angle - Math.sin angle)
  area(r1, alpha) + area(r2, beta)

# distance: the distance between two circle centers
calcAngles = (radiuses, distance) ->
  angle = (r1, r2, d) ->
    sum = r1 + r2 + d
    max = Math.max r1, r2, d
    return Math.PI if max * 2 >= sum # not a triangle
    2 * Math.acos (Math.pow(d, 2) + Math.pow(r1, 2) - Math.pow(r2, 2)) / (2 * r1 * d)
  [r1, r2] = radiuses
  if distance is 0 then [Math.PI, Math.PI] else [angle(r1, r2, distance), angle(r2, r1, distance)]

# Scale intersection weight to graph area
scaleIntersection = (weights, radius) ->
  big = Math.max weights.cards...
  if big is 0 then 0 else Math.PI * Math.pow(radius, 2) * weights.overlap / big

# The left circle is fixed at (0, 0), find the position
# for the right circle so that their intersection area is proportional
# to the weight.
# Bisection is used to find the right position
findDistance = (radiuses, interArea) ->
  [rleft, rright] = radiuses
  [lower, upper] = [rleft - rright, rleft + rright]
  d = (upper + lower) / 2.0
  while true
    angles = calcAngles radiuses, d
    return 0 unless isValidAngles angles # avoid infinite loop
    area = intersectionArea radiuses, angles
    delta = area - interArea
    break if Math.abs(delta) < g_threshold
    if delta < 0 then upper = d else lower = d
    d = (upper + lower) / 2.0
  d   # the distance we found


isNumber = (obj) -> Object.prototype.toString.call(obj) is "[object Number]"
isFiniteNumber = (obj) -> isNumber(obj) and isFinite(obj)

isValidAngles = (angles) ->
  for a in angles
    unless isFiniteNumber(a)
      console.log angles
      return false
  true

# WARNING: ugly drawing code
draw2 = (paper, height, radiuses, distance, opts, labels) ->
  [cxleft, cyleft] = [radiuses[0] + g_margin, radiuses[0] + g_margin]
  [cxright, cyright] = [cxleft + distance, cyleft]
  left = paper.circle cxleft, cyleft, radiuses[0]
  left.attr {
    "stroke-width": 0
    fill: opts.fill[0]
    "fill-opacity": opts["fill-opacity"][0]
  }
  right = paper.circle cxright, cyright, radiuses[1]
  right.attr {
    "stroke-width": 0
    fill: opts.fill[1]
    "fill-opacity": opts["fill-opacity"][1]    
  }

  # draw labels and resize paper
  bbs = [right.getBBox(), left.getBBox()]
  w = Math.max (bb.x2 for bb in bbs)...
  if labels?
    height = 30 if height < 30 # at least 30px high

    tx = w + 10
    ty1 = (height - 23) / 2.0
    ty2 = (height + 3) / 2.0
    r1 = paper.rect tx, ty1, 10, 10
    r2 = paper.rect tx, ty2, 10, 10
    r1.attr {
      "stroke-width": 0
      fill: opts.fill[0]
      "fill-opacity": opts["fill-opacity"][0]
    }
    r2.attr {
      "stroke-width": 0
      fill: opts.fill[1]
      "fill-opacity": opts["fill-opacity"][1]
    }
    t1 = paper.text tx + 13, ty1 + 5, labels[0]
    t2 = paper.text tx + 13, ty2 + 5, labels[1]
    texts = [t1, t2]
    for t in texts
      t.attr {
        "text-anchor": "start"
        "font-family": g_fontFamily
        "font-size": g_fontSize
      }

    # calculate paper size
    bbs = (t.getBBox() for t in texts)
    rightEdges = (bb.x2 for bb in bbs)
    w = Math.max(rightEdges...)
  
  paper.setSize w + g_margin, height


###
Helpers for venn3
###

# normalize 3-set weights
normalizeWeights3 = (weights) ->
  for item, idx in weights.cards
    weights.cards[idx] = 0 if item < 0
  [ab, ac, bc] = weights.overlap
  [a, b, c] = weights.cards
  abMin = Math.min a, b
  acMin = Math.min a, c
  bcMin = Math.min b, c
  ab = if ab < abMin then ab else abMin
  ac = if ac < acMin then ac else acMin
  bc = if bc < bcMin then bc else bcMin
  ab = if ab < 0 then 0 else ab
  ac = if ac < 0 then 0 else ac
  bc = if bc < 0 then 0 else bc
  weights.overlap = [ab, ac, bc]

# calculate the radiuses of circles so that their areas are proportional to weights
calcRadiuses3 = (maxDiameter, cards) ->
  maxWeight = Math.max cards...
  r = maxDiameter / 2.0
  if maxWeight is 0 then [0, 0, 0] else (r * Math.sqrt(weight / maxWeight) for weight in cards)

# scale the intersection areas
scaleIntersection3 = (overlap, maxRadius, maxWeight) ->
  scale = (weight) ->
    if maxWeight is 0 then 0 else Math.PI * Math.pow(maxRadius, 2) * weight / maxWeight
  (scale weight for weight in overlap)

# The biggest circle is fixed at (0, 0), find the position
# so that the intersection area between the biggest and
# each other is proportional to the weight.
# Bisection is used to find the right position
findDistance3 = (radiuses, interAreas) ->
  maxRadius = Math.max radiuses...
  if radiuses[0] == maxRadius
    radiuses2 = [radiuses[0], radiuses[1]]
    area = interAreas[0]
    d1 = findDistance radiuses2, area
    radiuses2 = [radiuses[0], radiuses[2]]
    area = interAreas[1]
    d2 = findDistance radiuses2, area
    {maxIndex: 0, AB: d1, AC: d2}
  else if radiuses[1] == maxRadius
    radiuses2 = [radiuses[1], radiuses[0]]
    area = interAreas[0]
    d1 = findDistance radiuses2, area
    radiuses2 = [radiuses[1], radiuses[2]]
    area = interAreas[2]
    d2 = findDistance radiuses2, area
    {maxIndex: 1, BA: d1, BC: d2}
  else # if radiuses[2] == maxRadius
    radiuses2 = [radiuses[2], radiuses[0]]
    area = interAreas[1]
    d1 = findDistance radiuses2, area
    radiuses2 = [radiuses[2], radiuses[1]]
    area = interAreas[2]
    d2 = findDistance radiuses2, area
    {maxIndex: 2, CA: d1, CB: d2}

findAngle = (r1, r2, d1, d2, area) ->
  # no intersection, ignore the expected area
  return Math.PI if Math.abs(d1 - d2) >= r1 + r2

  # area is larger than maximium possible value
  radiuses = if r1 > r2 then [r1, r2] else [r2, r1]
  angles = calcAngles radiuses, Math.abs(d1 - d2)
  return 0 unless isValidAngles angles
  maxArea = intersectionArea radiuses, angles
  return 0 if maxArea <= area

  # normal case, find a best matching angle
  [lower, upper] = [Math.abs(d1 - d2), r1 + r2]
  d = (upper + lower) / 2.0
  while true
    angles = calcAngles radiuses, d
    return 0 unless isValidAngles angles
    inter = intersectionArea radiuses, angles
    delta = inter - area
    break if Math.abs(delta) < g_threshold
    if delta < 0 then upper = d else lower = d
    d = (upper + lower) / 2.0
  Math.acos (Math.pow(d1, 2) + Math.pow(d2, 2) - Math.pow(d, 2)) / (2 * d1 * d2)

# WARNING: ugly drawing code
draw3 = (paper, radiuses, distances, areas, opts, labels) ->
  console.log radiuses, distances, areas

  # draw the largest one first
  index = distances.maxIndex
  r = radiuses[index]
  cx = cy = 3 * r + g_margin
  c1 = paper.circle cx, cy, r
  c1.attr {
    "stroke-width": 0
    fill: opts.fill[index]
    "fill-opacity": opts["fill-opacity"][index]
  }

  # figure out the second large and smallest one
  second = radiuses[..].sort((a, b) -> if a == b then 0 else if a < b then -1 else 1)[1]
  secondIndex = -1
  for i in [0...3]
    secondIndex = i if radiuses[i] == second and i != index # in case if second equals largest
  thirdIndex = 3 - index - secondIndex
  secondDistance = thirdDistance = thirdArea = null
  switch index
    when 0
      thirdArea = areas[2]
      if secondIndex == 1
        secondDistance = distances.AB
        thirdDistance = distances.AC
      else
        secondDistance = distances.AC
        thirdDistance = distances.AB
    when 1
      thirdArea = areas[1]
      if secondIndex == 0
        secondDistance = distances.BA
        thirdDistance = distances.BC
      else
        secondDistance = distances.BC
        thirdDistance = distances.BA
    when 2
      thirdArea = areas[0]
      if secondIndex == 0
        secondDistance = distances.CA
        thirdDistance = distances.CB
      else
        secondDistance = distances.CB
        thirdDistance = distances.CA

  # draw the second large one
  cx2 = cx + secondDistance
  cy2 = cy
  c2 = paper.circle cx2, cy2, second
  c2.attr {
    "stroke-width": 0
    fill: opts.fill[secondIndex]
    "fill-opacity": opts["fill-opacity"][secondIndex]
  }

  # draw the smallest one, it's a little bit tricky to find the right position
  # the idea is the same as finding the distance between two circles
  angle = findAngle radiuses[secondIndex], radiuses[thirdIndex], secondDistance, thirdDistance, thirdArea
  cx3 = cx + thirdDistance * Math.cos(angle)
  cy3 = cy - thirdDistance * Math.sin(angle)
  c3 = paper.circle cx3, cy3, radiuses[thirdIndex]
  c3.attr {
    "stroke-width": 0
    fill: opts.fill[thirdIndex]
    "fill-opacity": opts["fill-opacity"][thirdIndex]
  }

  # fix paper size
  bbs = [c1.getBBox(), c2.getBBox(), c3.getBBox()]
  [leftEdges, rightEdges] = [(b.x for b in bbs), (b.x2 for b in bbs)]
  [topEdges, bottomEdges] = [(b.y for b in bbs), (b.y2 for b in bbs)]
  w = Math.max(rightEdges...) - Math.min(leftEdges...) + 2 * g_margin
  h = Math.max(bottomEdges...) - Math.min(topEdges...) + 2 * g_margin
  topy = Math.min topEdges...
  topx = Math.min leftEdges...

  for c in [c1, c2, c3]
    c.attr {
      cx: c.attr("cx") - topx + g_margin
      cy: c.attr("cy") - topy + g_margin
    }

  # draw labels and resize paper
  if labels?
    h = 40 if h < 40 # at least 40px high

    # rects with color
    rx = w + 10
    ry1 = (h - 36) / 2.0
    ry2 = (h - 10) / 2.0
    ry3 = (h + 16) / 2.0
    r1 = paper.rect rx, ry1, 10, 10
    r2 = paper.rect rx, ry2, 10, 10
    r3 = paper.rect rx, ry3, 10, 10
    rects = [r1, r2, r3]
    for i in [0...3]
      rects[i].attr {
        "stroke-width": 0
        fill: opts.fill[i]
        "fill-opacity": opts["fill-opacity"][i]
      }

    # labels
    t1 = paper.text rx + 13, ry1 + 5, labels[0]
    t2 = paper.text rx + 13, ry2 + 5, labels[1]
    t3 = paper.text rx + 13, ry3 + 5, labels[2]
    texts = [t1, t2, t3]
    for t in texts
      t.attr {
        "text-anchor": "start"
        "font-family": g_fontFamily
        "font-size": g_fontSize
      }

    # calculate paper size
    bbs = (t.getBBox() for t in texts)
    rightEdges = (bb.x2 for bb in bbs)
    w = Math.max(rightEdges...) + g_margin
  
  paper.setSize w, h
  

# export venn
root = exports ? this
root.venn2 = venn2
root.venn3 = venn3
