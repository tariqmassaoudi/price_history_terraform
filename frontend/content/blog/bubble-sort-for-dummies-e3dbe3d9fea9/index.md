---
title: "Bubble sort for dummies"
date: "2018-07-29T22:40:32.169Z"
description: We’ll have fun exploring one of the most simple sorting algorithms!
tag: datascience
---

![](https://miro.medium.com/max/646/1*xBNaUDWTVnNIvMTrpS00yQ.png)

We’ll have fun exploring one of the most simple sorting algorithms! Bubble sort

# Do we really need sorting algorithms?

Humans are indeed an intelligent specie.We crave on organizing every aspect of our life.In modern times digital life has become as influential as the real one. The solution to organize this online mess is through the use of sorting algorithms. These pieces of coded logic are literally everywhere on the internet. You want to check the latest post on your favorite blog? Well just press the button to sort them by new. You want to find out the cheapest toothbrush on an E-commerce website? Just sort them by price !

The most important aspect about a sorting algorithm is its speed, no one want to wait decades to get his emails sorted! Fortunately today’s computers are really fast but still only the fastest sorting algorithms are practically used. In this post we will talk about the slowest one. This algorithm is a the best introduction to sorting because of its simplicity but its never used in practice.

# Bubble Sort intuition:

> Tell me and I forget, teach me and I may remember, involve me and I learn.

One of the best ways to learn an algorithm is to find it out yourself. So in this section we’ll try to invent bubble sort! Are you ready to make some bubbles?

You have an initial unordered list of numbers. The objective is to sort them! You can perform 2 simple actions. Comparing 2 elements of the list and swapping them. Can you come up with a simple algorithm to sort the list only using those 2 actions?

![](https://miro.medium.com/max/700/1*0KdjgvLQe9GPiFaaNmtZhA.png)

get a sheet of paper and think it out , it’s worth it !

# How to Bubble Sort?

Hope you had fun inventing algorithms! If you’re lucky you have already came up with bubble sort !

Bubble sort is comparison based, you basically compare each element with the next one . If the current element is  **smaller**  than the next element you  **swap**  them if not you do not swap and go to the next element.

When you reach the end of the array you go back to the first element and  **repeat the process.** Stop when the array is sorted !

![](https://miro.medium.com/max/700/1*UNPQJvW5wsVocu4NrO5cmA.png)

Bubble sort on the example array

You could ask yourself. Well how many repetitions should I perform? It turns out that the maximum needed is (**length of the array -1**) for our example if the array we had to do 2 repetitions , if the array was completely disordered we would have to do 3!

# Bubble sort in code:

Finally here’s an implementation of bubble sort in code.
```
def bubbleSort(arr):
#get the length of the array
n = len(arr)
# Traverse through all the elements of the array
for i in range(n):
for j in range(0, n-1):
# if the current element is larger than the next one swap
if arr[j] > arr[j+1] :
#this is the python shorcut for swapping
arr[j], arr[j+1] = arr[j+1], arr[j]
```
# How fast is bubble sort?

Well as expected it turns out that bubble sort is really slow compared to the more optimized algorithms. In computer science to find out how fast is an algorithm we use the big O notation. Basically it measures how much steps does an algorithm takes in the  **worst case scenario.** Bubble sort checks all the elements in the array which has a length of let’s say  **n,**and repeats this for  **n-1**  times in the worst case scenario so the total steps needed is  **n² -n .**

For large numbers n² is actually much bigger than n “you can test it out using a calculator” so we could ignore the n and say that bubble sort has a complexity of O(**n²**).

The best algorithms most used algorithms are quicksort and mergesort these can sort in O(n*log(n)) . These will always outperform bubble sort.

To check this you can calculate n² and n*log(n) let’s try that:
```
if we choose n=10
n²=100      and     n*log(n)=10
now for n=1000
n²=1000000   and n*log(n)=3000
```

In this post we learned how bubble sort works . It might be a snail in terms of speed but it’s essential to understand to tackle the more complex algorithms!

I hope this post helped you to sort your bubbles !