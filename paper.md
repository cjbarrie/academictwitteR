---
title: 'academictwitteR: an R package to access the Twitter Academic Research Product Track v2 API endpoint'
tags:
  - R
  - twitter
  - social media
  - API
authors:
  - name: Christopher Barrie
    orcid: 0000-0002-9156-990X
    affiliation: 1
  - name: Justin Chun-ting Ho
    orcid: 0000-0002-7884-1059
    affiliation: 2
affiliations:
 - name: School of Social and Political Sciences, University of Edinburgh, Scotland, UK
   index: 1
 - name: Centre for European Studies and Comparative Politics, Sciences Po, France
   index: 2
date: 23 April 2021
bibliography: paper.bib
---


# Statement of need

In January, 2021, Twitter announced the "Academic Research Product Track." This provides academic researchers with greatly expanded access to Twitter data. Existing R packages for querying the Twitter API, such as the popular ``rtweet`` package [@rtweet], are yet to introduce functionality to allow users to connect to the new v2 API endpoints with Academic Research Product Track credentials. The ``academictwitteR`` package [@academictwitteR] is built with academic research in mind. It encourages efficient and responsible storage of data, given the likely large amounts of data being collected, as well as a number of shortcut functions to access new v2 API endpoints.

# Summary

The Twitter Application Programming Interface, or API, was first introduced in 2006. It was designed principally with commercial objectives in mind. Over time, however, researchers began to repurpose the Twitter API for academic ends. In January, 2021, [Twitter announced the "Academic Research Product Track"](https://blog.twitter.com/developer/en_us/topics/tools/2021/enabling-the-future-of-academic-research-with-the-twitter-api.html), noting that "[t]oday, academic researchers are one of the largest groups of people using the Twitter API."

Authorization for the Academic Research Product Track provides access to the Twitter v2 API endpoints, introduced in 2020, as well as much improved data access. In summary the Academic Research product track allows the authorized user:

1. Access to the full archive of (as-yet-undeleted) tweets published on Twitter;
2. A higher monthly tweet cap (10m---or 20x what was previously possible with the standard v1.1 API);
3. Ability to access these data with more precise filters permitted by the v2 API.

The ``academictwitteR`` package was designed to encourage academic researchers efficiently and safely to store their data. Data is stored in serialized form as RDS files or as separate JSON files. The former represents the most efficient storage solution for native R data-file formats; the latter helps mitigate loss by storing data as separate JSONs for each pagination token (or up to 500 tweets). Convenience functions are also included to bind tweet and user-level information stored as JSON files.




# References


