---
layout: post
title: "Skew detection optimization"
date: 2012-12-12 12:12
comments: true
author: Antoine Pietri
categories: 
---

We achieved to optimize our skew detection algorithm which is now a lot more
efficient (with a coefficient of one-hundred in time and 4 in memory).

Our previous algorithm was rotating the image a lot of time, because it could
only trace an histogram with straight lines. The new algorithm keeps the image
as-it, and traces the histogram with different angles.

The power of our skew detection system has been decupled with this
optimization, so be sure to use the last version !
