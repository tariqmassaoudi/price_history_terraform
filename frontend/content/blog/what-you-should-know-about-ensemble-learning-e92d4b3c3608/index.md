---
title: "What You Should Know About Ensemble Learning"
date: "2020-09-27T22:40:32.169Z"
description: The wisdom of the crowds for machines
tag: Machine Learning
---

The wisdom of the crowds for machines

![Photo by [Markus Spiske](https://unsplash.com/@markusspiske?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/8736/0*HroBikMnYnFLNQvU)*Photo by [Markus Spiske](https://unsplash.com/@markusspiske?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)*

## Introduction:

You want to organize a movie night with your friends and you’re looking for the perfect movie, you search on Netflix and you stumble upon one that caught your attention. To decide if the movie is worth watching or not you have multiple options.

Option A: Go ask your brother who has already watched the movie.

Option B: Go to IMDB check the rating & read multiple hopefully spoiler free reviews.

You’ll obviously go with option B since the risk of getting a biased opinion is less if you get multiple points of view as opposed of a single opinion from your brother. This is the idea and motivation behind ensemble methods. It’s the wisdom of crowds! Now let’s dive into a more technical definition of ensemble learning.

![Photo by [Arian Darvishi](https://unsplash.com/@arianismmm?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/11060/0*rfHWRmxY_Yz4OuMI)*Photo by [Arian Darvishi](https://unsplash.com/@arianismmm?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)*

## What is ensemble learning:

According to scholarpedia:
> Ensemble learning is the process by which multiple models, such as classifiers or experts, are strategically generated and combined to solve a particular computational intelligence problem.

Which means taking the generating multiple models and taking their opinion smart ways such as to get the best prediction possible. In theory, an ensemble model will always outperform a single model. For this to effectively work the individual models constructing an ensemble should be different, it’s no point taking the collective opinion if all individual opinions are the same. We can differentiate our models by using different algorithms, changing the hyper parameters, or training them on different parts of our dataset.

## How do we ensemble learn (techniques):

### Bagging:

Stands for “*bootstrap aggregating” and it’s one of the simplest and most intuitive techniques to understand. In bagging we will be using the same algorithm while training on different subset of the data. To get these subsets we use a technique called **bootstrapping:***

![Basic bootstrapping illustration, Image by Author](https://cdn-images-1.medium.com/max/2000/1*MGZ9rfKx2dSRI-K7IYPCCg.png)*Basic bootstrapping illustration, Image by Author*

As you can see **Apple** is repeated 2 times. In practice we often choose a smaller size for the bootstrapped datasets. After creating some bootstrapped datasets we will a model on each then combine them to make an ensemble model, this is called **aggregation**.** **For classification problems the class with the most votes is the prediction and for regression problems we average the output of our models.

### Boosting:

While bagging can be done in parallel (just train all your models at the same time), boosting is an iterative process. Like bagging we will be using the same algorithm, but we won’t be bootstrapping the data and training all the models at the same time. Boosting is sequential which means train models one by one and the performance of the previous model will impact how we select the training dataset for the next model, more precisely each new model will try to correct mistakes made by its predecessor

![The basic workings of boosting, Image by Author](https://cdn-images-1.medium.com/max/2000/1*392-uo0h6JbiCixcbHIHyQ.png)*The basic workings of boosting, Image by Author*

Popular algorithms that implement boosting are **AdaBoost** and **Gradient Boosting.**

### Stacking:

This one is simple, we will be using different algorithms and just combining their predictions.

![Basic workings of Stacking, Image by Author](https://cdn-images-1.medium.com/max/2000/1*012oLlKPCVpgqNI-nOQGMQ.png)*Basic workings of Stacking, Image by Author*

## Why should you ensemble learn?

As intuition and practice confirms ensemble methods yield more accurate results and when used wisely are more resilient to overfitting thus, they are widely used in Kaggle competitions. One drawback is that they require a lot more time to train.

## Summary

Ensemble learning is turning multiple weak models to one strong model “together we are stronger”. Multiple techniques have been developed to accomplish this such as bagging, boosting and stacking. An ensemble model is always more accurate than a single model and can generalise better.

I hope you’ve got a basic idea behind ensemble models. Now it’s time to implement then into your projects!

Thanks for reading! ❤

Follow me for more informative data science content.