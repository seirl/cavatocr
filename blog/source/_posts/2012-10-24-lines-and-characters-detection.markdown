---
layout: post
title: "Lines and characters detection"
date: 2012-10-24 01:32
comments: true
categories:
author: Paul Hervot
---

The final step before truly recognize the characters is to find them. This is
the third sort of detection so far in the process (the first one being skew
detection, and the second one the noise)

What are we working on in this part ? The picture has been loaded, rotated so
the text is straight, it then ran through various filters so it is now composed
only of pure black and white pixels, and we can expect it to be free of unwanted
noises.

## Lines

First, let's find text lines. To do this we need a vertical histogram of the
image, it is a simple list representing the number of black pixels in each pixel
line and it is computed linear time.

With this histogram, we make blocks of continuous non-empty lines. As
each text line is separated by a few rows of white pixels, they usually split
extremely well.

For exemple in the following text picture:
![Detection exemple -- original](http://dettorer.net/ocr/lorem.png)

Our program recognize all the lines like this:
![Line detection exemple -- line 1](http://dettorer.net/ocr/lorem_line1.bmp)
![Line detection exemple -- line 2](http://dettorer.net/ocr/lorem_line2.bmp)
![Line detection exemple -- line 3](http://dettorer.net/ocr/lorem_line3.bmp)

## Characters

Detecting characters rely essentially on the same principle. This time we
compute the horizontal histogram of each line, then recreate blocks of
continuous non-empty columns.

For exemple the following line:
![Characters detection exemple -- line 1](http://dettorer.net/ocr/lorem_line1.bmp)

Gives the following characters:

![Characters detection exemple -- line 1](http://dettorer.net/ocr/lorem_char1.bmp)
![Characters detection exemple -- line 2](http://dettorer.net/ocr/lorem_char2.bmp)
![Characters detection exemple -- line 3](http://dettorer.net/ocr/lorem_char3.bmp)
![Characters detection exemple -- line 4](http://dettorer.net/ocr/lorem_char4.bmp)
![Characters detection exemple -- line 5](http://dettorer.net/ocr/lorem_char5.bmp)
![Characters detection exemple -- line 6](http://dettorer.net/ocr/lorem_char6.bmp)
![Characters detection exemple -- line 7](http://dettorer.net/ocr/lorem_char7.bmp)
![Characters detection exemple -- line 8](http://dettorer.net/ocr/lorem_char8.bmp)
![Characters detection exemple -- line 9](http://dettorer.net/ocr/lorem_char9.bmp)
![Characters detection exemple -- line 10](http://dettorer.net/ocr/lorem_char10.bmp)
![Characters detection exemple -- line 11](http://dettorer.net/ocr/lorem_char11.bmp)
![Characters detection exemple -- line 12](http://dettorer.net/ocr/lorem_char12.bmp)
![Characters detection exemple -- line 13](http://dettorer.net/ocr/lorem_char13.bmp)
![Characters detection exemple -- line 14](http://dettorer.net/ocr/lorem_char14.bmp)
and so on…

## Thresholding

Sometimes, characters are so close to each others that there is no empty columns
between them.

A naive solution is to define what is an "empty line", our first choice was to
let a column with a few black pixel be empty anyway, this number being relative
to the size of the picture.

In the previous exemple, this threshold is set to 3, let's see what happen if we
increase or decrease this threshold.

With a threshold of 4 in this line, we sometimes get "two in one" characters
like this:

![Characters detection exemple -- char merge](http://dettorer.net/ocr/lorem_char_merge.bmp)

And with a threshold of 2, some characters are truncated like this n:

![Characters detection exemple -- char strip 1](http://dettorer.net/ocr/lorem_char_strip1.bmp)
![Characters detection exemple -- char strip 2](http://dettorer.net/ocr/lorem_char_strip2.bmp)

## Future improvements

At this point, we can think of two improvement axes for this module:

### Improve the thresholding

Though it works well, the current thresholding is very naive. An idea would be
to take count of distance between black pixels. This way we could increase the
number of autorized black pixel in an "empty line" and detect correctly this
kind of pattern as two different letters:

![Characters detection exemple -- char merge 2](http://dettorer.net/ocr/lorem_char_merge.bmp)

but still see this one as one single character:

![Characters detection exemple -- line 14](http://dettorer.net/ocr/lorem_char24.bmp)

The next (and a bit more complicated improvement) will be to detect continuous
lines in a smarter way, keep track of the usual character width, or even use the
neural network to sort out those particular cases.

### Detect text zones

The only important issue of our detection block module is that it easily get
fooled by picture like this one:

![Text zone improvement -- typical exemple](http://www.schmanck.de/text.jpg)

Our algorithm cannot see the lines next to the decorated 'H' as it make all the
lines non-empty.

The obvious solution is to detect _where_ the text is, isolate it in boxes and
apply the other algorithms in these boxes only.
