Welcome to the Source and Claim Identifier - a demo of what you can do with our API!

You can combine the different algorithms provided by our API to create new
services and integrate them into your platform.

In this demo, we combined [upload](http://infolis.gesis.org/infolink/api) and
[execute](http://infolis.gesis.org/infolink/api) with the algorithms
[TextExtractor]
(https://github.com/infolis/infolis-web/wiki/API-calls-to-algorithms#textextractor)
and ReportedSpeechTagger.
This enables us to provide a lightweight service to upload pdf or txt files and generate
[EntityLink]
(http://infolis.gesis.org/infolink/api/entityLink)s to sources and claims.


If you like to play around with this demo, here's a [demo text file](https://git.gesis.org/bolandka/Infolis-experimental/blob/claimsAndSources/src/test/resources/examples/sourcesAndClaims.txt) that you can use for uploading.
