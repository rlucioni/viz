## Informal Presentation of Past Work and Projects ##

### Setup ###

1. Turn off notifications (do not disturb). Close Gmail!
2. Set up presentation
3. Start server for US housing trends piece, go to localhost:8000/code/recovery.html. WILL NOT WORK WITHOUT INTERNET ACCESS.

### Notes ###

Hi guys, thanks for having me.
- I'm a graduating Harvard senior studying computer science and government.
- I was born in Peru to an American mom, and speak fluent Spanish. My home for the last 13 years or so has been near Seattle, on an island called Bainbridge.
- I like tell short stories by organizing information, and I'm interested in using data visualization to make complex information accessible and useful.

This is really a recent occupation of mine, and I want to begin today by telling you a quick story about how I got into it. 
- It started for me in a data science course I took last year taught by Hanspeter Pfister. 
- One of our last assignments in that class dealt with performing statistical analysis on the way US Senators have voted in the 2013 session of the 113th Congress. 
- We were asked to do things like compute centrality scores for Senators, calculate an all-pairs shortest paths metric for determing how bipartisan or close to the opposite party each Senator was, and to identify Senate leaders by using a variant of the PageRank algorithm to see who tended to sponsor the most bills. 
- It was a great problem set, and I had a lot of fun with it.

However, something we didn't spend a lot of time on in that assigment was getting a good look at what the underlying graph representation we were working with actually looked like. 
- The statistics we were coming up with were cool, but some part of me really wanted to see it to believe it, and see how things had changed over the last several years.
- Now, this is a quote from Ben Fry, taken from his book Visualizing Data: "Everything looks like a graph, but almost nothing should ever be drawn as one...Graphs have a tendency of making a data set look sophisticated and important, without having solved the problem of enlightening the viewer."
- I agree with this sentiment, but having finished the assignment early, I decided to try visualizing the underlying graph representation we were working with anyway, purely out of curiosity. It was exploratory, which is an acceptable use of a graph, similar to what you guys did when developing the Connected China piece.
- Working with Senate roll call data taken from GovTrack, a Python module called NetworkX, and an open-source graph visualization tool called Gephi, I ended up with 25 graphs, one for each session of Congress that GovTrack had data for, going back to the 1989 session of the 101st Congress (SHOW graphs).

In each graph, each edge (u, v) is assigned weight equal to the number of times Senator u and Senator v voted the same way, either Yea or Nay. 
- For the sake of clarity, I filtered out edges with weight less than 100; these lighter edges generally indicate agreement on procedural votes. 
- The clusters you see in each graph are the result of using Gephi’s Force Atlas layout, which applies a force-directed algorithm to the graph and causes those nodes connected by heavier edges to be pulled together more tightly. 
- A nice side-effect of using this physics-based model is that more bipartisan senators are pushed closer to the center of the graph, near the party divide, while less bipartisan senators are repelled outwards toward the perimeter of the graph, furthest from the party divide.

I was pretty stunned when I realized that this collection of graphs was one of those exceptions Ben left room for in his explanation.
- I was really excited, and after sharing them with a few friends, I posted these on Reddit. This was all in the same night. 
- By the time the assignment itself was actually due a week later, they had been picked up by Yahoo's home page and The Huffington Post, I'd gotten a congratulatory email from Ben Shneiderman at the University of Maryland, had been contacted by a professor at ETH Zurich who wanted to use them in a book and an executive at Sal. Oppenheim (a private bank based in Germany) who wanted to use them in a presentation, had be featured in a segment on MSNBC's Hardball, and I was due to be printed in The Economist. 
- I also got a nice bit of Reddit karma, which as those of you on Reddit know, never hurts.

(SHOW Economist live chart) This is a short animated clip showing all 25 images which The Economist put together to accompany their coverage of it in the magazine and in their blog.
- There's definitely some oscillation, but there appears to be a general trend towards polarization between senators over time.
- As the narrator mentions, there's something visceral about the "pulling apart" of political parties you see here, and it seems to represent what a lot of people feel in their gut about the country's political situation.

The point of this story is to show you where my excitement about this field has its roots. 
- I realized that this was an extraordinarily powerful way to communicate with people, a really good way of putting information in context, and I started to see my code as a storytelling device.

In the time since, I've tried to develop my abilites by working on a handful of other projects.
- I'd like to briefly share three of them with you, to show you how my approach has changed.

The first piece I'd like to show you (please don't judge me) is about the change in marijuana prices in the US (SHOW choropleth maps). 
- This is admittedly not too complicated - I made this while I was still using only Python to do my work and it was my first experiment with choropleth maps. 
- I made and published it on January 1, the day Colorado becomes the first state in the country to allow the sale and use of marijuana for recreational purposes. 
- In light of that, I was curious about how the price of marijuana had changed nationally over the last few years. 
- So, using transaction data collected anonymously by a website called priceofweed.com, I put together this series of 12 choropleth maps. According to my data source, the prices shown here most likely correspond to bulk purchases. 
- I meant for this to accompany a blog post on my website explaining how prices for high quality marijuana appear to be consistently lowest closer to the West Coast, and have dropped considerably since 2010, but how prices for medium and low quality marijuana appear to be lowest in the South and Southwest. 
- A week after I made this, The Washington Post used it as the focus of an article on the cost of marijuana in the US, which was pretty exciting for me.

The second piece I'd like to show you is about California's water supply (SHOW graph). 
- In the time between this piece and the last one I showed you, I'd started using JavaScript by way of CoffeeScript and D3 to do my work, in addition to Python. I really liked the flexibility they afforded me. 
- To make this stacked area graph, I scraped every end-of-month reservoir storage measurement provided by the California Department of Water Resources for each of California’s 191 reservoirs since 1957 (that's about 122,000 data points), and then used D3 to build the graph.
- The layers are colored by hashing each reservoir’s unique 3-letter identifier to a hex color code. This approach was inspired by work Fernanda Viegas and Martin Wattenberg did on their piece "History Flow," in which they visualize Wikipedia edits over time. They used the technique to distinguish different editors.
- I also used data from the US Census, by way of Google's Public Data Explorer, to plot California’s population really lightly over the area graph. I don't like two-axis graphs, but I thought this one was pretty compelling. Observing drastic declines in the state’s water supply is eye-opening in its own regard, but comparing the state’s population to the water supply during each of these droughts takes it to another level. 
- There's potential to easily turn this into something similar to the Fathom's Fortune 500 piece, showing how a significant number of data points can be easily viewed and navigated. Each of the layers already has the name of the reservoir associated with it, and logs the name each time it's moused over. However, I opted to go with a static representation.
- Turning this into a streamgraph is also easy - I only need to change one line. However, I thought having axes and a zero baseline was more clear.
- I'm pretty proud of this piece, and it seems The Economist liked it too - they ended up publishing "Parched," a modified version of it, at the end of April.

This is a good moment to quickly segue into talking about my involvement at The Economist.
- Telling short stories with information like this started as a hobby for me, and I now work on a freelance basis with the data editor at The Economist, Kenn Cukier, who's drawn me in to help lead a bit of a culture shift in the way they do their data visualization, both internally, online, and in print. 
- In a nutshell, I'm working with Kenn, the editor, to help ease the organization into the idea that you don't need to have a preconceived notion of what the data will show you before you work with it.
- I do this by showing their research and graphics departments my process behind things like the California water graph, which they then use as a basis for their own renditions of my work, like Parched.
- In particular, the idea of presenting all data at hand without feeling the need to process it and show just a subset or aggregate has resonated with them.
- Their cultural resistance to this, what you could call "n=all" approach, is an artifact of a time when it was cumbersome and complicated to work with data or to graphically depict it.
    - You can still see it in their gray "Other" layer, which makes sense since it's hard to translate thin slivers to print
- These limits no longer exist to the same extent, but the approach and attitude at The Economist hasn't sufficiently changed to reflect this. 
- They have a conservative culture when it comes to adopting new techniques, and they've struggled with the idea of creating exploratory visualizations which don't require a preconceived notion of what the data will show.
- So, I try to give them examples to show that the eye can quickly spot patterns and outliers that aggregate data can often struggle to show. 
- That pattern might be the basis of a story or a more interesting, in-depth piece which explores a narrative which would otherwise have remained hidden.

The last piece I'd like to share with you is interactive, unlike the last two static pieces I've shown. It's about US housing trends over the last 3 years (SHOW website). 
- As I'm sure you all know, the conversation on the US housing market over the last several years has focused on its recovery from the 2008 crisis. However, I noticed that the discussion often relies on a couple of raw statistics and rudimentary visualizations, and as a result of that struggles to communicate effectively with readers. 
- It can make it hard for audiences, even those who follow the news closely, to put the situation in context. 
- In an attempt to help fill this communication gap, I made this with some help from my girlfriend, partly as a final project for Hanspeter Pfister's data visualization class, CS 171, and partly on commission by The Economist to develop an interactive piece for them to display on their website.
- The focus isn't on states but instead on more granular counties, which I feel tells a more interesting story.
- The narrative here isn't currently as direct as in my pieces on Senate voting patterns or California's water supply. It's more of a "choose your own adventure" story, but a powerful one at that.
- [DEMO zooming, add county to graph, timeslice changing with slider, parallel coordinates brushing, and metric switching]
- You can, for example, use it to find ski resorts in Colorado (Aspen) and Wyoming (Jackson Hole). 
- I like using the parallel coordinates plot to find counties where homes are priced in a certain range; watch them move out to the coasts as I reveal more expensive counties. 
- List prices are largely cyclical, but the median price reduction has been steadily dropping, the implication being that sale prices have been increasing. To some, that would indicate an improving housing market.

So, that's some of what I've been able to do over the course of the last 7 months or so. 
- Telling short stories like this is what I do for fun, and although I'm only just starting out in this field, I want so badly want to be able to do it professionally. 
- I've been curious about Fathom ever since Fernanda Viégas and Martin Wattenberg over at Google mentioned the studio to me a few months ago. A friend at edX, Carlos Rocha, who worked with Ben at the Media Lab, also mentioned Fathom to me.
- James (Grady) and Mark's (Schifferli) talk at Harvard is what got me to work up the courage to come talk to you guys, so thank you to them for that.

I'll wrap up by saying that working with organizations like The Economist is great, but I think Fathom has a lot to offer in terms of opportunities for both fun and professional growth that I'm just not going to find at legacy print operations.
- Just to give you my full perspective, I'm currently slated to work as a product manager at edX. 
- I've had a great time at edX over the last year, where I interned last summer and where I've been working part-time since. But I want something more now. I want to be pumped about what I'm doing every day, and I want it to align more closely with my personal interests.
- From what I've been told and from what I've seen, too, Fathom seems to fit that bill perfectly. 
- You guys are clearly great at what you do, and I would love to pitch in and learn from you all.

That's all I've got - thanks for your time. Any questions?

### Extra Credit ###

This is a picture I took from about 100,000 feet (30 kilometers), also known as the stratosphere.
- I led a small team of friends which sent a hamburger into the stratosphere and filmed the entire journey, on the way up and on the way down. 
- We used a 600 gram weather balloon, 120 cubic feet of helium, a GoPro camera, an HTC Rezound for cheap GPS, a parachute, and a styrofoam cooler for storing the electronics.
- We were sponsored by Boston-area hamburger chain b.good. In less than two weeks, we created the company’s most highly-viewed advertisement using less than $500.
- (GPS cutoff at 60,000 feet)
- This was parodied by Jay Leno on The Tonight Show, featured on the Yahoo! front page, and showed up in way more major news outlets than it should have.

### Questions ###

1. Can you tell me about Jonathan Feinberg's involvement here? I know he's leading development on Processing.py, but I thought he worked at Google?
2. Does Nike's discontinuation of the FuelBand affect Fathom?
3. Do you have time to work on your own projects at Fathom?
4. What's the general process of working with a client like, and how long do client projects tend to last? How do you decide who works on what, and how many projects do you tend to have going at the same time? Do you need to travel often?

### Miscellaneous Notes ###

Cool Ben Fry pieces: Deprocess, All Streets, Salary vs. Performance, Fortune 500 (ability to go through 80-90k points and get a sense of what's in there)
    James Grady's Rocky piece

process: start with software sketch
modern storytelling: focusing on a strong narrative thread can help make data more human and relatable

"Recovery" - still developing my ability to come up with pithy, one word names for my projects :P

US Senate voting patterns
    typically I try to make my work digestible and directly usable for folks, but I felt this piece communicated its message in the most compelling way if presented it all - the visible, emergent pattern is what i wanted to draw attention to

most of my experience is with static pieces, but I've started experimenting with interactivity as well

I initially used Python for my work, but I now also use JavaScript by way of CoffeeScript and D3 for the visual side (Python for information processing)
    I don't have experienece with Processing, but I've heard great things, in particular from Jonathan Feinberg (Processing.py)

my work with senate voting patterns made a big impression on me
    i'm addicted to pulling meaningful stories out large and complicated data sets

show off website - R logo in particular
    it's a home for the work I'm most proud of
    created when I realized the voting relationships project was exploding on Reddit - I got really carried away with the logo
    there's a handful of smaller projects that didn't make it here (fuck counts - similar to James Grady's Rocky Morphology, but less in-depth)
