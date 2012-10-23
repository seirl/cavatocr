---
layout: post
title: "Rotation and first draft of skew detection"
date: 2012-10-23 02:30
comments: true
categories: 
author: Antoine Pietri
---

One of the main part of our OCR is the *skew detection*. If the image is
inclinated, the OCR have to detect the text skew angle and rotate the image
with this right angle.

# Rotation

Due to performances issues, we decided to code our own rotation first. This is
a brief description of the algorithm:

First, we have to calculate the dimensions of the rotated image, which are
given by the following formula (found with basic trigonometry) :

$$
\left\{\begin{matrix}w = (wo cos(\alpha) + ho sin(\alpha))
\\h = (ho cos(\alpha) + wo sin(\alpha))
\end{matrix}\right
$$

Then, for each pixel of the newly created image, we get the corresponding pixel
in the original picture with this formula :

$$
\left\{\begin{matrix}
xo =
(cos(\alpha) \times (x - x\_{center})
(sin(\alpha) \times (y - y\_{center})
+ x\_{center} \\
yo =
(- sin(\alpha) \times (x - x\_{center})
(cos(\alpha) \times (y - y\_{center})
+ y\_{center}
$$

If the obtained coordinates are in the original image bounds, we set the pixel
of the new image like the one with these coordinates in the original image.

# Skew Detection

Todo.
