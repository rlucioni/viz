# Mike Bostock's margin convention
margin = 
    top:    20, 
    bottom: 20, 
    left:   20, 
    right:  20

canvasWidth = 1225 - margin.left - margin.right
canvasHeight = 600 - margin.top - margin.bottom

svg = d3.select("#vis").append("svg")
    .attr("width", canvasWidth + margin.left + margin.right)
    .attr("height", canvasHeight + margin.top + margin.top)
    .append("g")
    .attr("transform", "translate(#{margin.left}, #{margin.top})")

boundingBox =
    x: 120,
    y: 0,
    width: canvasWidth - 225,
    height: canvasHeight - 50

FORCED_COLORS =
    "MEA": "#377eb8",
    "ORO": "#ffed6f",
    "SNL": "#e41a1c",
    "LUS": "#e41a1c",
    "NML": "#f16913",
    "BER": "#ffd92f",
    "CLE": "#54278f",
    "SHA": "#fcc5c0"

IGNORE = ["dates"]
# For adding space between labels and axes
labelPadding = 
    "small": 7,
    "large": 19
# String tacked onto reservoir IDs to increase color variety
EXTENSION = "qwert"
# California Department of Water Resources created July 1956
TRUNCATE_DATE = "07/1957"

# Taken from http://en.wikipedia.org/wiki/Acre-foot
CUBIC_METERS_FACTOR = 1233.4892384681

parseDate = d3.time.format("%m/%Y").parse

stringToHex = (str) ->
    for reservoir of FORCED_COLORS
        if str[..2] == reservoir
            return FORCED_COLORS[reservoir]

    # convert to hexatridecimal
    hexatridecimal = parseInt(str, 36)
    # exponentiate and trim off beginning and end
    trimmed = hexatridecimal.toExponential().slice(2, -5)
    # convert to decimal
    decimal = parseInt(trimmed, 10)
    # truncate to range between 0 and 16777215 (0xFFFFFF)
    truncated = decimal & 0xFFFFFF
    # write the number in hexadecimal and convert to uppercase
    hexadecimal = truncated.toString(16).toUpperCase()
    # guarantee that final number is 6 digits, and append hash symbol
    code = "##{('000000' + hexadecimal).slice(-6)}"

    return code

xScale = d3.time.scale().range([0, boundingBox.width])
yScale = d3.scale.linear().range([boundingBox.height, 0])
popScale = d3.scale.linear().range([boundingBox.height, 0])

xAxis = d3.svg.axis().scale(xScale).orient("bottom")
yAxis = d3.svg.axis().scale(yScale).orient("left")
popAxis = d3.svg.axis().scale(popScale).orient("right")

stack = d3.layout.stack()
    .offset("zero")
    # To create a streamgraph, use wiggle offset instead of zero
    # .offset("wiggle")
    .order("inside-out")
    .values((d) -> d.values)
    .x((d) -> d.date)
    .y((d) -> d.storage)

area = d3.svg.area()
    .interpolate("linear")
    .x((d) -> xScale(d.date))
    .y0((d) -> yScale(d.y0))
    .y1((d) -> yScale(d.y0 + d.y))

line = d3.svg.line()
    .interpolate("linear")
    .x((d) -> xScale(d.date))
    .y((d) -> popScale(d.population))

drawLineGraph = (dataset, dates, popData) ->
    layers = stack(dataset)

    xScale.domain(d3.extent(dates))
    
    storages = []
    for record in dataset
        for value in record.values
            storage = value.y0 + value.y
            if storage not in storages
                storages.push(storage)

    yScale.domain([0, d3.max(storages)])
    popScale.domain([0, d3.max(popData, (d) -> d.population)])

    frame = svg.append("g")
        .attr("transform", "translate(#{boundingBox.x}, #{boundingBox.y})")

    frame.append("g").attr("class", "x axis")
        .attr("transform", "translate(0, #{boundingBox.height})")
        .call(xAxis)

    frame.append("g").attr("class", "y axis")
        .call(yAxis)

    frame.append("g").attr("class", "pop axis")
        .attr("transform", "translate(#{boundingBox.width}, 0)")
        .call(popAxis)

    areas = frame.selectAll(".area")
        .data(layers)
        .enter()
        .append("path")
        .attr("class", "area")
        .attr("d", (d) -> area(d.values))
        .style("fill", (d) -> stringToHex(d.key + EXTENSION))

    line = frame.append("path")
        .datum(popData)
        .attr("class", "pop line")
        .attr("d", line)

    frame.append("text")
        .attr("class", "y label")
        .attr("text-anchor", "end")
        .attr("y", labelPadding.small)
        .attr("dy", ".75em")
        .attr("transform", "rotate(-90)")
        .text("Storage (m³)")

    frame.append("text")
        .attr("class", "pop label")
        .attr("text-anchor", "end")
        .attr("y", boundingBox.width - labelPadding.large)
        .attr("dy", ".75em")
        .attr("transform", "rotate(-90)")
        .text("Population")

    areas.on("mouseover", (d) ->
        console.log d.key
    )

d3.json("monthly-reservoir-storage.json", (data) ->
    dates = []
    for date in data.dates
        dates.push(parseDate(date))

    dataset = []
    for reservoir, values of data
        if reservoir not in IGNORE
            records = {"key": reservoir, "values": []}
            for value in values
                storage = value.storage
                if storage == "--"
                    continue
                else
                    storage = Math.round(+storage * CUBIC_METERS_FACTOR)

                date = parseDate(value.date)
                records.values.push({"date": date, "storage": storage})

            dataset.push(records)

    times = []
    for date in dates
        times.push(date.getTime())

    # Use interpolation to fill in missing values for each reservoir
    for record in dataset
        reservoir = record.key
        # Compile lists of dates and storages from this reservoir
        localTimes = []
        localStorages = []
        for point in record.values
            localTimes.push(point.date.getTime())
            localStorages.push(point.storage)

        interpolator = d3.scale.linear()
            .domain(localTimes)
            .range(localStorages)

        interpolatedData = []
        # Only consider years between the years for which this reservoir has data
        relevantTimes = times[times.indexOf(localTimes[0])..times.indexOf(localTimes[localTimes.length - 1])]
        for time in relevantTimes
            storage = Math.round(interpolator(time))
            interpolatedData.push({"date": new Date(time), "storage": storage})

        record.values = interpolatedData

    truncatedDates = []
    for date in dates
        if date.getTime() >= parseDate(TRUNCATE_DATE).getTime()
            truncatedDates.push(date)
    dates = truncatedDates

    filledDataset = []
    for record in dataset
        filledRecord = {"key": record.key, "values": []}
        for date in dates
            found = false
            for value in record.values
                if value.date.getTime() == date.getTime()
                    filledRecord.values.push(value)
                    found = true
                    break
                if value.date.getTime() > date.getTime()
                    break
            if not found
                filledRecord.values.push({"date": date, "storage": 0})
            
        filledDataset.push(filledRecord)

    
    d3.csv("ca-population.csv", (popDataRaw) ->
        popData = []
        for row in popDataRaw
            popData.push({"date": parseDate(row.date), "population": +row.population})
        drawLineGraph(filledDataset, dates, popData)
    )
)
