# Aduu Technical Blog - Based on Will Jekyll Template - [Demo](http://willianjusten.com.br/will-jekyll-template)

## Basic Setup

## Site and User Settings

## Color customization

All color variables are in `src/styl/variable`. To change the main color, just set the new value at `main` assignment. Another colors are for texts and the code background color.

## Creating posts

You can use the `initpost.sh` to create your new posts. Just follow the command:

```
./initpost.sh -c Post Title
```

The new file will be created at `_posts` with this format `date-title.md`.

## Front-matter 

When you create a new post, you need to fill the post information in the front-matter, follow this example:

```
---
layout: post
title: "How to use"
date: 2015-08-03 03:32:44
image: '/assets/img/post-image.png'
description: 'First steps to use this template'
tags:
- jekyll 
- template 
categories:
- I love Jekyll
twitter_text: 'How to install and use this template'
---
```

## Running the blog in local

In order to compile the assets and run Jekyll on local you need to follow those steps:

- Install [NodeJS](https://nodejs.org/)
- Run `npm install` 
- Run `gulp`

## License

This theme is free and open source software, distributed under the The MIT License. So feel free to use this Jekyll theme on your site without linking back to me or using a disclaimer.
