# Technical Exercise - Sr. Developer

As a candidate you have 72 hours to provide, in the programming language of your choice, a solution that meets the criteria below.  If after 72 hours, for any reason, your solution is not complete, still send over the partial code with comments or some notes explaining what you managed to do.

The same exercise is being given as part of any openings for software development roles. However, for a senior role, we add some requirements:

- Solution should be built as to allow validating the business logic via Unit Tests.
- Modeling of the solution should allow for usage within different output environment (e.g. producing report directly on the console vs reporting via PDF). It is expected to implement only one such output environment as part of the exercise.
- Modeling of the solution should allow for data to be obtained from different sources (e.g. web service vs file). It is expected to implement only one such source as part of this exercise.

The main objective of this exercise is to create discussion points for the technical interview. So don’t feel the need to spend sleepless nights to deliver a complete, perfect, working solution!

---

Jeff owns many vessels. He’d like you to analyze planned routes for his vessels to produce a report.
The report will return for each vessel:

- Average speed in km/h
- Total distance travelled in km

If there is an intersection between two vessels’ route:

- Name of the two vessels on the intersecting routes
- Coordinates of the intersection
- Estimated time each vessel will pass through the intersection

If there is an intersection between two vessels’ route and both vessels pass through the intersection within 1 hour of each other:

- Warning should be provided

For example, if two vessels intersect and the estimated times are 8:20 and 9:10, a warning should be provided. However, if the estimated times had been 8:20 and 9:35, no warning should be provided.

This [diagram](example_plot.png) displays, as an example, vessels 1 and 3 intersecting somewhere between 08:50 and 09:06 for Vessel 1 and between 08:49 and 09:14 for Vessel 3. Vessel 2 will never intersect with the others.

Assumptions:

- Assume the world is a Cartesian plane of infinite size
- Coordinates provided are in kilometers
- No need to load data in your application, you can hardcode it
- Complex UI is not expected, console output is sufficient
- Be prepared to discuss and explain the components of your solution and their interaction using a whiteboard

Tips:

- Take into account as many of the edge-cases you can think of
- Code naturally! Don’t try commenting every line or over-engineering your code
- The sample data used to create the above diagram is provided in JSON format in test/TestData.json
- It is also provided as an escaped string for languages such as C# and Java in test/TestData.txt

