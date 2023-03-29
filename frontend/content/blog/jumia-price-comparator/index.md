---
title: "How I Built A Price Tracker For Jumia"
date: "2022-10-11T22:40:32.169Z"
description: An overview on how to build a price tracker and host it for free on AWS
tag: Data Engineering
---


In this article, I’ll share with you how and my thought process on building a Price Tracker app for the African Ecommerce website Jumia and hosting it on AWS for free. This is a quite simple end to end data engineering project with some UX elements. You’ll learn about web scraping, and how to use some of AWS services. You can try the app using this [link](https://www.tariqmassaoudi.com/jumiaapp/)

### **The Context & The Plan:**

A Price Tracker’s main value is to give you the historical price of a certain product so that you can hopefully make your purchasing decision based on data amongst other criteria and minimize the effect of FOMO/discounts that can be in some cases just a form of marketing.

This family of apps exists for all international ecommerce websites, ie : Amazon, Ebay, Alibaba. But it doesn’t exist for Jumia which is so far the main ecommerce player in Africa.

The goal of this project to create a simple price tracker and to be able to host it for free. To achieve the latter I chose to make use of AWS free tier which offers quite generous cloud resources, just enough to bootstrap this kind of project if used efficiently.

Learn more about AWS Free Tier [Here](https://aws.amazon.com/free/)

Jumia has several branches all over Africa, we will be focusing on the Moroccan one. The same can be easily replicated for the rest of the countries since the website we’ll use for scraping is almost identical across countries.

### Technical Architecture:

![](./pictures/architecture.png)

The picture above summarizes the architecture, I chose to spread out and make use of a variety of AWS components which is more optimal for efficiency.

The architecture split into two main sections:

**Scraping/ETL:** This section is responsible for periodically getting the data, transforming it and loading it into a postgres database. I made use of Airflow for scheduling and coordinating tasks written in python and S3 for an extra backup of the data.

**Data Delivery / UX :** In classic web app fashion we have a Front-End UI written in Java Script, Calling a REST API which is in this case powered by AWB Lambda , which interacts with our Postgres database in RDS. Making efficient use of ressources like this is what made it possible to host the project for free.

### Data Model:

![](./pictures/datamodel.png)

The main table called “Prices” holds historical price data, we are also maintaning details about the products tracked in the “products” table and analytics/ recommendations related data “prod_ranking” and “KPI” tables.

### Generating the best deals:

To generate the best deals we are calculating the average price of a particular product and comparing it to it’s actual price today and getting the percent difference, For example in the picture below:

![](https://cdn-images-1.medium.com/max/1000/1*Y3ybuYRFObrUQ_jaUvNGeQ.png)

The product is down 27.62% from it’s average price. To further enhance recommendations we are prioritizing popular products with the highest number of reviews by category.

### Deep Dive Into Scraping:

The first step is to get urls of the categories, the picture below shows from where they are extracted.

![](./pictures/scraping1)

Now each category has multiple pages, we use the page number as a variable to navigate and grab products in each page.

![](./pictures/scraping0)

Below is the full scraping code, it utilizes python’s request module, beautifulsoup to parse html and and tqdm for multithreading which accelerates the task. To learn more about scraping I’d recommend my [article](https://medium.com/analytics-vidhya/every-data-scientist-needs-to-learn-this-4632e3a2e275) or similar content.

`gist:tariqmassaoudi/5152eae7e2b8ba384e9a0279e5b2b43e#scrapeJumia.py`

<!-- <script src="https://gist.github.com/tariqmassaoudi/5152eae7e2b8ba384e9a0279e5b2b43e.js"></script> -->

### Airflow for powerful task scheduling:

As of the official documentation, Airflow is a platform that lets you build and run _workflows_. A workflow is represented as a [DAG](https://airflow.apache.org/docs/apache-airflow/stable/concepts/dags.html) (a Directed Acyclic Graph), and contains individual pieces of work called [Tasks](https://airflow.apache.org/docs/apache-airflow/stable/concepts/tasks.html), arranged with dependencies and data flows taken into account.

A DAG specifies the dependencies between Tasks, and the order in which to execute them and run retries, the Tasks themselves describe what to do, be it fetching data, running analysis, triggering other systems, or more.

One of the main advantages of using airflow is the graphical interface, you can track the progress of your tasks in real time, it has built in retry on failure and integration with most popular databases.

It will also store the execution times and logs which is extremely useful for debugging, below is the DAG used in the project and the main python code used to generate such DAG. To learn more about airflow the [official documentation](https://airflow.apache.org/docs/) is the best place

![](./pictures/airflow.png)
`gist:tariqmassaoudi/eb5d1310e21b9a0d1501067fe702f4d3#jumiaDag.py`

### AWS Lambda a serverless backend:

  

Lambda functions are pretty flexible, in this project it was used as a REST API to lift off the workload from the main EC2 server. It’s easy to get started with, you just choose your prefered language and start a function from scratch or use a container or one of the provided AWS blueprints.

![](./pictures/lambdacreate.png)

Once your function is created you have to set it up for your use case this includes, in my experience setting up “layers” which is basically a way for your function to use external libraries in my case I needed pandas and sqlalchemy, then you have to setup the REST API to be able to call the function from the web, the default settings are fine but you have to enable cors (Cross-Origin Resource Sharing) to be able to call the function from your browser, the [documentation](https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-cors.html) does a good job explaining this.

After the setup you will have a function with layers and an API gateway:

![](./pictures/lambdaoverview.png)

To let the function communicate with your RDS database you will need to connect it to a VPC in the same subnets as your RDS setup and also create a “security group” allowing connection on the postgres port 5432 and assign it to the function:

![](./pictures/lambdavpc.png)

Below is an example of a function that gets product details given a product id or a product url:
`gist:tariqmassaoudi/0c5c7a75923a9124f329ea49c46c2b46#getProduct.py`

### Conclusion:

It was fun working on this project as it’s something that has actual real word usage for the average person. The free tier on AWS is generous with it’s offerings, it’s really good for prototyping compared to competition, as long as you don’t scale past the limits and use it efficiently you can host almost any project.

If you managed to get here Congratulations. Thanks for reading, I hope you’ve enjoyed the article and learned a thing or two from it. For any questions or discussion, feel free to reach out to me on [LinkedIn](https://www.linkedin.com/in/tariqmassaoudi/).