# Mike Bostock's margin convention
margin = 
    top:    20, 
    bottom: 20, 
    left:   20, 
    right:  20

canvasWidth = 1100 - margin.left - margin.right
canvasHeight = 600 - margin.top - margin.bottom

svg = d3.select("#vis").append("svg")
    .attr("width", canvasWidth + margin.left + margin.right)
    .attr("height", canvasHeight + margin.top + margin.top)
    .append("g")
    .attr("transform", "translate(#{margin.left}, #{margin.top})")

boundingBox =
    x: 100,
    y: 0,
    width: canvasWidth - 100,
    height: canvasHeight - 50

# For adding space between labels and axes
labelPadding = 7

brewerBlue = "#1f78b4"

parseDate = d3.time.format("%m/%Y").parse

xScale = d3.time.scale().range([0, boundingBox.width])
yScale = d3.scale.linear().range([boundingBox.height, 0])

xAxis = d3.svg.axis().scale(xScale).orient("bottom")
yAxis = d3.svg.axis().scale(yScale).orient("left")

line = d3.svg.line()
    .interpolate("linear")
    .x((d) -> xScale(d.date))
    .y((d) -> yScale(d.storage))

drawLineGraph = (dataset, dates, storages) ->
    xScale.domain(d3.extent(dates))
    yScale.domain([0, d3.max(storages)])

    frame = svg.append("g")
        .attr("transform", "translate(#{boundingBox.x}, #{boundingBox.y})")

    frame.append("g").attr("class", "x axis")
        .attr("transform", "translate(0, #{boundingBox.height})")
        .call(xAxis)

    frame.append("g").attr("class", "y axis")
        .call(yAxis)

    frame.append("text")
        .attr("class", "x label")
        .attr("text-anchor", "end")
        .attr("x", boundingBox.width)
        .attr("y", boundingBox.height - labelPadding)
        .text("Date")

    frame.append("text")
        .attr("class", "y label")
        .attr("text-anchor", "end")
        .attr("y", labelPadding)
        .attr("dy", ".75em")
        .attr("transform", "rotate(-90)")
        .text("Storage")

    for station, values of dataset
        frame.append("path")
            .datum(values)
            .attr("class", "line")
            .attr("d", line)
            .style("stroke", brewerBlue)
            
        # frame.selectAll(".point.#{station}")
        #     .data((values))
        #     .enter()
        #     .append("circle")
        #     .attr("class", "point #{station}")
        #     .attr("cx", (d) -> xScale(d.date))
        #     .attr("cy", (d) -> yScale(d.storage))
        #     .attr("r", 3)
        #     .style("stroke", brewerBlue)

d3.json("monthly-reservoir-storage.json", (data) ->
    dates = []
    for date in data.dates
        dates.push(parseDate(date))

    dataset = {}
    storages = []
    for station, values of data
        if station != "dates"
            dataset[station] = []
            for value in values
                storage = value.storage
                if storage == "--"
                    continue
                else
                    storage = Math.round(+storage)

                date = parseDate(value.date)
                
                dataset[station].push({"date": date, "storage": storage})

                if storage not in storages
                    storages.push(storage)

    drawLineGraph(dataset, dates, storages)
)
