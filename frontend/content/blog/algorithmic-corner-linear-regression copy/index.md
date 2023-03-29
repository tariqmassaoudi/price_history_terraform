---
title: "Algorithmic corner : Linear regression"
date: "2018-06-08T22:12:03.284Z"
description: How linear regression works by example
tag: webdev
---

# The basics:

In this article we’ll try to uncover how linear regression works. The best way to understand it is through example. Suppose we have the following problem , we are trying to predict a student’s grade given how many times he didn’t attend the class. With enough data points we’ll end up with a graph that looks like this :

![](https://miro.medium.com/max/700/1*gcafDoOHrkd5Xr-qpWS_ew.png)

Doing a linear regression is finding the line that is closest to all the data points, in mathematics the equation of a line is y=ax+b where “a” is the slope and “b” is the intercept. So to find this line we have to find the best “a” and “b” coefficients. But how do we do that, and what does the “best line” means concretely?

# Least square regression:

The best line is one that is closest to all data points , in other terms it’s the line that minimizes the sum of the distances between each point and the fitted line. We can see that visually below:

![](https://miro.medium.com/max/700/1*pXTkGi4y1wPcPfo1i8xVtA.png)

The way to calculate this error is by getting the difference between an observed point and a predicted point (using the line) squaring it and summing this for all data points. Mathematically it looks like :

![](https://miro.medium.com/max/369/1*XiLqraVva35_nHEKMhDrBQ.png)

Using calculus we can easily get the parameters “a” and “b” for the best line.

A good thing about linear regression is that it generalizes easily to problems of higher dimension .Its about adding more terms to the equation and calculating more coefficients. A general model looks like this :

![](https://miro.medium.com/max/700/1*twPf-JqkR_vntaMRvoo5cQ.png)

# Model evaluation: R squared:

How do we determine how well the model fits the data ? One way is to calculate the R² factor.

![](https://miro.medium.com/max/700/1*pwZOTsK4Av51E7-h2KbJww.png)

R-squared is always between 0 and 100%:

-   0% indicates that the model explains none of the variability of the response data around its mean.
-   100% indicates that the model explains all the variability of the response data around its mean.

In simple terms R squared will give a measure on how better our model is than a model fits the data with it’s mean value. Generally higher values or R-squared are more desirable. We can measure R-squared on the data we used for training but that doesn’t reflect on how well the model will perform in real life, so a good idea is to split the data into training and test and calculate R-squared for both. Generally we’ll observe that model performs better on the training data. Another way to access the model’s performance is through the  **root mean squared error**, it tells you how concentrated the data is around the regression line. The lower this error the better the model, we can calculate it with the formula :

![](https://miro.medium.com/max/613/1*JXfaeDWbwurv3vrX3iseSw.png)

# Linear regression in python:

To apply what we learned we’ll be using a machine learning library in python called skLearn , and the dataset we’re gonna use is about automobile data. The problem is to predict an automobile price based on it’s characteristics. The data looks like this :

![](https://miro.medium.com/max/700/1*OLzEqZ8c5gFdH66DJtdoxw.png)

The cleaning part is already done so we’re gonna test the models directly. We’ll start by a simple linear regression model.We’ll be splitting the data into test and train. 80% of the data for training and 20% for testing and we’ll check our R-squared score on the training set.
```
from sklearn.model_selection import train_test_splitX = auto_data.drop('price', axis=1)  
Y = auto_data['price']  
X_train, x_test, Y_train, y_test = train_test_split(X, Y, test_size=0.2, random_state=0)  
from sklearn.linear_model import LinearRegressionlinear_model = LinearRegression()  
linear_model.fit(X_train, Y_train)  
#Checking the scorelinear_model.score(X_train, Y_train)OUT:  
0.96792273709243304
```
We got a really high score on the training set , what about the test set?
```
y_predict = linear_model.predict(x_test)  
%pylab inline  
pylab.rcParams['figure.figsize'] = (15, 6)plt.plot(y_predict, label='Predicted')  
plt.plot(y_test.values, label='Actual')  
plt.ylabel('Price')plt.legend()  
plt.show()
```
![](https://miro.medium.com/max/700/1*q2X7XDIGeiBX8YgXTtvM-A.png)

It doesn’t look that good graphically lets check the score
```
r_squared = linear_model.score(x_test, y_test)  
r_squaredOUT:  
0.63225834161155436
```
We’ve got a low score , this is known in ML terms as over-fitting the model learned the training set so well that it struggling at generalization. So how can remedy this problem. Well there’s another form of regression that attempts to solve this issue and it’s called **Lasso Regression**. Instead of minimizing the sum of the errors it adds a penalty term on the coefficients as to force them to be small. Concretely the algorithm will minimize this :

![](https://miro.medium.com/max/700/1*8c2QXIzRUcV00F39zc4d6w.png)

Where α is a parameter we choose. Let’s try it out with an α of 0.5 :
```
from sklearn.linear_model import Lassolasso_model = Lasso(alpha=0.5, normalize=True)  
lasso_model.fit(X_train, Y_train)  
lasso_model.score(X_train, Y_train)  
OUT:  
0.96510812725275497
```
We’ve got a slightly lower score on the training set. Let’s try the model on the test set:
```
y_predict = lasso_model.predict(x_test)  
%pylab inline  
pylab.rcParams['figure.figsize'] = (15, 6)plt.plot(y_predict, label='Predicted')  
plt.plot(y_test.values, label='Actual')  
plt.ylabel('Price')plt.legend()  
plt.show()
```
![](https://miro.medium.com/max/700/1*3BgNad3wqJKHKstPukDRTg.png)

This time it seems to fit better let’s check the R-squared value:
```
r_square = lasso_model.score(x_test, y_test)  
r_square  
OUT:  
0.887194953444848
```
The R-squared score is way better than the simple linear model. We can further improve the performance by tweaking the α parameter. Finding the best parameters for a model is called hyper-parameter tuning and there’s functions in sklearn that makes it easy to find these.

# Conclusion:

In this article we’ve covered how linear regression works , some ways to access it’s performance ,the over-fitting problem and one solution to overcome it. I hope this was of great use to you, in the next article we’ll tackle another algorithm which is logistics regression.

If you liked this article, be sure to click ❤ below to recommend it and if you have any questions,  **leave a comment**  and I will do my best to answer.