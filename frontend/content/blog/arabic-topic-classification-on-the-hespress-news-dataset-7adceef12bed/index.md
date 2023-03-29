---
title: Arabic Topic Classification On The Hespress News Dataset
date: "2020-10-18T23:46:37.121Z"
tag: NLP
description: Using NPL techniques to classify arabic news


---


How to classify Arabic Text the right way

![Photo by [Markus Winkler](https://unsplash.com/@markuswinkler?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)](https://cdn-images-1.medium.com/max/7998/0*-MNlm46aQfTjdCpp)*Photo by [Markus Winkler](https://unsplash.com/@markuswinkler?utm_source=medium&utm_medium=referral) on [Unsplash](https://unsplash.com?utm_source=medium&utm_medium=referral)*

This article is the first in a series where I’ll cover analysis of the Hespress Dataset.

According to “alexa.com” Hespress is ranked 4'th in Morrocco, it’s the biggest news site in the country and the average Moroccan spends around 6 minutes daily on the website.

The Hespress Dataset is a collection of 11K news articles labelled by topic and 300K comments with a score by the users associated to each one of them, think of the scores as likes on a Facebook post. This dataset can be used for news article classification which will be our focus in this article and for sentimental analysis of the Moroccan general opinion. You can download the Dataset using the link below:
[**Hespress**
*Kaggle is the world's largest data science community with powerful tools and resources to help you achieve your data…*www.kaggle.com](https://www.kaggle.com/tariqmassaoudi/hespress)

This article is aimed for people that have a little bit of knowledge about machine learning for example what’s the difference between classification and regression, what’s cross validation. However, I’ll give a brief explanation of the steps pursued for the project.

## **Problem Introduction:**

Fortunately, our dataset contains both the articles and their labels, so we are dealing with a supervised learning problem which will make our life much easier since, if wasn’t the case, we would have to manually label each article or go with an unsupervised approach.

In brief, our goal is to predict the topic of an article given its text. In total we have 11 topics:

* Tamazight (A Moroccan Language) 
* Sport (Sport) 
* Societe (Society) 
* Regions (Regions) 
* Politique (Politics) 
* Orbites (World news) 
* Medias (News from local newspapers) 
* Marocains Du Monde (Moroccans of the world) 
* Faits Divers (Miscellaneous) 
* Economie (Economy) 
* Art Et Culture (Art and culture)



## **Exploratory Data Analysis:**

We’ll be using seaborn for data visualisation and pandas for data manipulation.

Let’s start by loading the data:

Since the data is stored in different files, each file contains data for a specific topic, we’ll have to loop over the topics and concatenate results.

    import pandas as pd
    stories=pd.DataFrame()
    topics["tamazight","sport","societe","regions","politique","orbites","medias","marocains-du-monde","faits-divers","economie","art-et-culture"]

    for topic in topics:
      stories=pd.concat([stories,pd.read_csv("stories_"+topic+".csv")])

    stories.drop(columns=["Unnamed: 0"],axis=1,inplace=True)

Next let’s get a sample from the data:

    stories.sample(5)

![Sample columns from the stories dataset](https://cdn-images-1.medium.com/max/2252/1*_uM4fxYgLH_PrQ_zWbZHcg.png)*Sample columns from the stories dataset*

We can see that we have 5 columns, for this article we are only interested in the story and the topic features.

Now let’s check how much stories we have in each topic, this is extremely important for classification since if we have an **imbalanced dataset **i.e.(we have a lot more datapoints in a topic than the others) our model will be biased and won’t work as well. If we have this problem one common solution is to apply an **under sampling** or **oversampling** method, we won’t go over the details since it’s not in the scope of our article.

    import seaborn as sns
    storiesByTopic=stories.groupby(by="topic").count()["story"]
    sns.barplot(x=storiesByTopic.index,y=storiesByTopic)

![Count of stories by topic](https://cdn-images-1.medium.com/max/2282/1*Tnrx36tYvfFLtTtInoyKCQ.png)*Count of stories by topic*

We can see that we have almost 1000 stories per topic, our dataset is perfectly balanced.

![Source: memegenerator.net](https://cdn-images-1.medium.com/max/2000/0*qA46C2LjmtYma_wb.jpg)*Source: memegenerator.net*

## **Data Cleaning:**

We are dealing with Arabic text data. Our data cleaning process will consist of 2 steps:

**Removing Stop Words**: some words such as “و”, “كيف” have extremely high recurrence in all Arabic texts and provide no meaning that our model can use to predict. Removing them will reduce noise and let our model focus only on relevant words. To do so we will be using a list and looping over all the articles removing all the words that appear in the list.

The stop words list that I used is available on [Github](https://github.com/mohataher/arabic-stop-words/blob/master/list.txt)

    from nltk.tokenize import word_tokenize

    file1 = open('stopwordsarabic.txt', 'r', encoding='utf-8') 
    stopwords_arabic = file1.read().splitlines()+["المغرب","المغربية","المغربي"]

    def removeStopWords(text,stopwords):
        text_tokens = word_tokenize(text)
        return " ".join([word for word in text_tokens if not word in stopwords])

**Removing Punctuation**: For the same reason we’ll be removing punctuation, for this I’ve used a Regex expression.

    from nltk.tokenize import RegexpTokenizer
    def removePunctuation(text):
        tokenizer = RegexpTokenizer(r'\w+')
        return " ".join(tokenizer.tokenize(text))

## **Drawing a WordCloud:**

Let’s have some fun, we’re going to be drawing a Word Cloud off all the stories in our DataSet using the python “**WordCloud**” library

Before doing so there’s some extra steps needed that are specific for Arabic, to learn more about them visit this [link](https://amueller.github.io/word_cloud/auto_examples/arabic.html).

    import arabic_reshaper
    from bidi.algorithm import get_display
    import matplotlib.pyplot as plt
    %matplotlib inline

    def preprocessText(text,stopwords,wordcloud=False):
        noStop=removeStopWords(text,stopwords)
        noPunctuation=removePunctuation(noStop)
        if wordcloud:
            text=arabic_reshaper.reshape(noPunctuation)
            text=get_display(text)
            return text
        return noPunctuation

    drawWordcloud(stories.story,stopwords_arabic)

![Word Cloud of Hespress News Articles](https://cdn-images-1.medium.com/max/2280/1*Uc9cBE2aEXJRMDAuLrFIKA.png)*Word Cloud of Hespress News Articles*

Since this dataset contains recent news articles we see “كورونا” (coronavirus) as a recurring word. There’s also “الامازيغية” which is a major language in Morocco, “محمد” which is the most popular name in Morocco and is also the name of the King of Morocco and “الحكومة” which means the government.

## **Feature engineering:**

Machine learning models are in their essence mathematical equations and can’t understand text, so before running our models we need to transform our text to numbers, there’s multiple approaches to do this let’s discover the 2 most popular ones.

* **Word Count:**

This one is very simple, every columns represents a word from the entire stories corpus, and every row represents a story, the cell values are the frequency in which a word appears in the story!

* ***TF–IDF:***

*TF-IDF stands for “Term Frequency Inverse Document Frequency” it uses a slightly more complicated approach which will penalize common words that occur in multiple documents.*

We will be using TF-IDF since it in most cases it yields better performance!

    from sklearn.feature_extraction.text import TfidfVectorizer

    #Clean the stories 
    stories["storyClean"]=stories["story"].apply(lambda s: preprocessText(s,stopwords_arabic))

    #Vectorize the stories

    vectorizer = TfidfVectorizer()
    X = vectorizer.fit_transform(stories["storyClean"])
    y=stories.topic

## **Modelling:**

We will try the following models:

* Random Forest
* Logistic Regression
* SGDClassifier
* Multinomial Naïve Bayes

We will run the data through each model and use the **accuracy** which is the ratio of correct predictions and total datapoints as our metric, for more accurate results we have used cross validation with 5 folds for our scoring then we will be plotting the results.

    from sklearn.model_selection import train_test_split
    from sklearn.metrics import accuracy_score
    from sklearn.model_selection import cross_val_score
    import numpy as np
    from sklearn.metrics import classification_report
    def testModel(model,X,y):
        X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
        model.fit(X_train,y_train)
        modelName = type(model).__name__
        pred=model.predict(X_test)
        print(modelName)
        print(classification_report(y_test,model.predict(X_test)))
        score=np.mean(cross_val_score(model, X, y, cv=5))
    
        return model,{"model":modelName,"score":score}

![Models accuracy](https://cdn-images-1.medium.com/max/2272/1*0roKplrxJ6UXDwdAmaTxqg.png)*Models accuracy*

Our best model is **SDGClassifier** with an accuracy of 87 %

## **Model Interpretation:**

Now that we got a working model let’s try to understand a bit more what's happening, for that we will be answering two questions:

* What topics does our model struggle with?
* What words are most influential in predicting different topics?

For the first questions we can check the classification report of our best model:

![Classification Report SGDClassifier](https://cdn-images-1.medium.com/max/2000/1*1tZdFEDNUQrnkh171mZ8rw.png)*Classification Report SGDClassifier*

We are predicting “Sport”, “Art”, “Medias”, “Tamazight” with an extremely high accuracy. We are struggling the most with “**orbites**” (world news), “**societe**” (Society) this might be because these two are more general and broad topics.

To answer the second question, we will be using a useful property of logistic regression, we can use the weights as a measure of the importance of the words in each model. “**ELI5**” a python library makes it easy to do that:

![](https://cdn-images-1.medium.com/max/2240/1*N3olha4sCIs5S13IaFlwcQ.png)

![](https://cdn-images-1.medium.com/max/2000/1*GIJSoNquPJn7kyHQBHfy3Q.png)

We can see that most of the words make sense and correspond to the theme of the topic, for example for “Art” the top words are: “Artist”, “Film”,” Culture”, ”Book”.

## **Conclusion:**

In this article, we’ve gone through all the steps required to design a text classification system for Arabic from Data Exploration to Model Interpretation. However, we can still improve our accuracy by tuning the hyperparameters.

In the next article, we’ll try to make sense of the comments on each article using **Sentimental Analysis.**

if you managed to get here Congratulations. Thanks for reading, I hope you’ve enjoyed the article. For personal contact or discussion, feel free to reach out to me on [LinkedIn](https://www.linkedin.com/in/tariqmassaoudi/).
