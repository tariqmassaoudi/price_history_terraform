import React, { useState, useEffect } from "react"

import { Link} from "gatsby"
import Layout from "../components/layout"
import TimeAgo from 'javascript-time-ago'
import en from 'javascript-time-ago/locale/en'
import Seo from '../components/seo'
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  LineController
} from 'chart.js';
import { Line } from 'react-chartjs-2';
import ProductDetails from "../components/productDetails";

import annotationPlugin from 'chartjs-plugin-annotation';
import SearchBar from "../components/searchbar"
import { globalHistory } from '@reach/router'

TimeAgo.addDefaultLocale(en)


ChartJS.register(
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
  Title,
  Tooltip,
  Legend,
  LineController,
  annotationPlugin
);

const apiUrl = process.env.GATSBY_API_URL;

const url_history=apiUrl+"get_price_history"
const url_product=apiUrl+"get_product_details"
// const prod_id='GA204HB0U09TGNAFAMZ'

const Pricehistory = ({ data, location }) => {
  const params = new URLSearchParams(location.search);
  const prod_id = params.get("id") ;
  const href = params.get("href") ;
  let request_body={}
  if (prod_id){
    request_body={"prod_id":prod_id}
  }else{
    request_body={"href":href}
  }

  const [minPrice,setminPrice]=useState(0)
  const [maxPrice,setmaxPrice]=useState(0)
  const [lastPriceChange,setlastPriceChange]=useState("Never")
  const [product,setProduct]=useState({'img_url':null,'name':null,'price':null,'stars':'','reviewcount':null,href:'',brand:null,fastDelivery:null,etranger:null})
  const [averagePrice,setAveragePrice]=useState(0)
  const [latestPrice,setlatestPrice]=useState(0)
  const [loadingDetails,setLoadingDetails]=useState(true)
  const [loadingPriceHistory,setloadingPriceHistory]=useState(true)
  const [request,setRequest]=useState(request_body)

  
const options = {
  responsive: true,
  plugins: {
    legend: {
      position: 'top',
    },
    title: {
      display: false,
      text: 'Price history',
    },
    autocolors: false,
    annotation: {
      annotations: {
        line1: {
          type: 'line',
          yMin: averagePrice,
          yMax: averagePrice,
          borderColor: 'rgb(0, 255, 0)',
          borderWidth: 2,
          borderDash:[5],
          label:{content:"average price", display: true, yAdjust:20}
        }
      }
    }
  },
};

    const [history, setHistory] = useState({
      label:[],
      datasets:[
        {
          label: 'Price History',
          data:[],
          borderColor: 'rgb(53, 162, 235)',
          backgroundColor: 'rgba(53, 162, 235, 0.5)',
        }
      ]
    })
    useEffect(() => {
      

      // declare the async data fetching function
  const fetchHistory = async (url) => {
    // get the data from the api
    const res = await fetch(url,{
              headers: {
                'Content-Type': 'application/json'
              },
              method: "POST",
              body: JSON.stringify(request)
          });
    // convert the data to json
    const resultData = await res.json();

  
    const valuesArr=Object.values(resultData)
    const averagePrice=valuesArr.reduce((a, b) => a + b, 0) / Object.values(resultData).length
    const minPrice=Math.min(...valuesArr)
    const maxPrice=Math.max(...valuesArr)
    const data={}
let temp=Object.entries(resultData).splice(-1)[0][1]
let date=null

const reversedKeys = Object.keys(resultData).reverse();

for (const key of reversedKeys){
  if (resultData[key]!==temp){
    date=new Date(key)
    date.setDate(date.getDate()+1)
    break;
  }
  temp=resultData[key]
}




    for (var key of Object.keys(resultData)) {
            data[new Date(key).toDateString().split(" ").slice(1,3).join(" ")]=resultData[key]
        }


    // set state with the result
              const chartData={
         
            datasets:[
              {
                label: 'Price',
                data:data,
                borderColor: 'rgb(53, 162, 235)',
                backgroundColor: 'rgba(53, 162, 235, 0.5)',
              }
            ]
            
          }
          
    setHistory(chartData)
    setAveragePrice(averagePrice)
    setminPrice(minPrice)
    setmaxPrice(maxPrice)
    setlatestPrice(Object.values(resultData).at(-1))
    const timeAgo = new TimeAgo('en-US')
    setloadingPriceHistory(false)
    setlastPriceChange(timeAgo.format(date) || 'Never')


  }

        // declare the async data fetching function
        const fetchProduct = async (url) => {
          // get the data from the api
          const res = await fetch(url,{
                    headers: {
                      'Content-Type': 'application/json'
                    },
                    method: "POST",
                    body: JSON.stringify(request)
                });
          // convert the data to json
          const resultData = await res.json();
          setProduct(resultData)
          setLoadingDetails(false)
          // setHistory(chartData);
        
      
      
        }

  // call the function
  fetchHistory(url_history)
    // make sure to catch any error
    .catch(console.error);

    fetchProduct(url_product)
    .catch(console.error);


    globalHistory.listen(({action,location}) => {
      
      if(action==='PUSH') {
        const params = new URLSearchParams(location.search);
        const href=params.get("href")
        setRequest({"href":href})
        setLoadingDetails(true)
      }
      
      
    })

}

, [request])
    
 
    return (
      <div>
     
        <Layout location={location} >
        <div className="jumia-wrapper">
          <div className="flex flex-row"></div>
          <div className="grid grid-cols-12 gap-2">
          <Link className="inline-flex col-span-1 my-auto py-2  bg-indigo-500 hover:bg-indigo-600 text-white text-sm font-medium font-sans rounded-md" to="/">
            
            <svg xmlns="http://www.w3.org/2000/svg"  className="w-full  h-5 my-auto" fill="none" viewBox="0 0 24 24" stroke="currentColor">

	  <path strokeLinecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h10a8 8 0 018 8v2M3 10l6 6m-6-6l6-6" />
	</svg>
	{/* <span className="hidden md:font-medium">Back</span> */}
  </Link>
  <div  className="col-span-11">
<SearchBar/>
</div>
</div>
<ProductDetails price={latestPrice} product={product} averagePrice={averagePrice} minPrice={minPrice} maxPrice={maxPrice} lastPriceChange={lastPriceChange} loading={loadingDetails}/>
<div className="border-b-2 border-gray-100 mb-8"></div>

<div className="text-3xl font-bold font-sans">Price History Graph</div>
{loadingPriceHistory?<div className="bg-white p-2 sm:p-4 h-screen rounded-lg shadow-md flex flex-col sm:flex-row gap-10 select-none mb-2 px-2">
    <div className="h-52 sm:h-full w-full rounded-xl bg-gray-200 animate-pulse" ></div>

</div>:<Line options={options} data={history} />}

</div>








      </Layout>
  
  
  
     
      </div>
    
    )
  }
export default Pricehistory
export const Head = () => <Seo title="Price History App" />

