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
    x: 120,
    y: 0,
    width: canvasWidth - 100,
    height: canvasHeight - 50

# For adding space between labels and axes
LABEL_PADDING = 7

EXTENSION = "penis"
BREWER_BLUE = "#1f78b4"

# Taken from http://en.wikipedia.org/wiki/Acre-foot
CUBIC_METERS_FACTOR = 1233.4892384681

parseDate = d3.time.format("%m/%Y").parse

stringToHex = (str) ->
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

xAxis = d3.svg.axis().scale(xScale).orient("bottom")
yAxis = d3.svg.axis().scale(yScale).orient("left")

stack = d3.layout.stack()
    .offset("zero")
    # .offset("wiggle")
    .values((d) -> d.values)
    .x((d) -> d.date)
    .y((d) -> d.storage)

area = d3.svg.area()
    .interpolate("linear")
    # .interpolate("cardinal")
    .x((d) -> xScale(d.date))
    .y0((d) -> yScale(d.y0))
    .y1((d) -> yScale(d.y0 + d.y))

drawLineGraph = (dataset, dates) ->
    layers = stack(dataset)

    xScale.domain(d3.extent(dates))
    
    storages = []
    for record in dataset
        for value in record.values
            storage = value.y0 + value.y
            if storage not in storages
                storages.push(storage)

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
        .attr("y", boundingBox.height - LABEL_PADDING)
        .text("Date")

    frame.append("text")
        .attr("class", "y label")
        .attr("text-anchor", "end")
        .attr("y", LABEL_PADDING)
        .attr("dy", ".75em")
        .attr("transform", "rotate(-90)")
        .text("Storage (m³)")

    frame.selectAll(".area")
        .data(layers)
        .enter()
        .append("path")
        .attr("class", "area")
        .attr("d", (d) -> 
       
            area(d.values))
        .style("fill", (d) -> stringToHex(d.key + EXTENSION))

d3.json("monthly-reservoir-storage.json", (data) ->
    dates = []
    for date in data.dates
        dates.push(parseDate(date))

    dataset = []
    # There are 191 stations
    for station, values of data
        if station != "dates"
       
            records = {"key": station, "values": []}
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

    # Use interpolation to fill in missing values for each station
    for record in dataset
        station = record.key
   
        # Compile lists of dates and storages from this station
        localTimes = []
        localStorages = []
        for point in record.values
            localTimes.push(point.date.getTime())
            localStorages.push(point.storage)

        interpolator = d3.scale.linear()
            .domain(localTimes)
            .range(localStorages)

        interpolatedData = []
        # Only consider years between the years for which this station has data
        relevantTimes = times[times.indexOf(localTimes[0])..times.indexOf(localTimes[localTimes.length - 1])]
        for time in relevantTimes
            storage = Math.round(interpolator(time))

            interpolatedData.push({"date": new Date(time), "storage": storage})

        record.values = interpolatedData

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

    drawLineGraph(filledDataset, dates)
)
