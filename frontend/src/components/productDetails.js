import React from "react";

const ProductDetails=({product,price,averagePrice,minPrice,maxPrice,lastPriceChange,fastDelivery,etranger,loading=true})=>{
const {name,img_url,stars,reviewcount,href,brand}=product

if(loading){
    return(         <div className="bg-white p-2 sm:p-4 h-96 rounded-lg shadow-md flex flex-col sm:flex-row gap-10 select-none mb-2 px-2">
    <div className="h-52 sm:h-full sm:w-80 rounded-xl bg-gray-200 animate-pulse" ></div>
    <div className="flex flex-col flex-1 gap-5 sm:p-2">
      <div className="flex flex-1 flex-col gap-3">
        <div className="bg-gray-200 w-full animate-pulse h-14 rounded-2xl" ></div>
        <div className="bg-gray-200 w-1/4 animate-pulse h-3 rounded-2xl" ></div>
        <div className="bg-gray-200 w-full animate-pulse h-14 rounded-2xl" ></div>
        <div className="bg-gray-200 w-1/4 animate-pulse h-3 rounded-2xl" ></div>
        <div className="bg-gray-200 w-1/4 animate-pulse h-3 rounded-2xl" ></div>
        <div className="bg-gray-200 w-1/4 animate-pulse h-3 rounded-2xl" ></div>

      </div>
      <div className="mt-auto flex gap-3">
        <div className="bg-gray-200 w-52 h-10 animate-pulse rounded-full" ></div>

        <div className="bg-gray-200 w-52 h-10 animate-pulse rounded-full ml-auto" ></div>
      </div>
    </div>
</div>)
}else{
    return(
      
            





<div className="min-w-screen font-sans  flex items-top overflow-hidden relative mb-12">
            <div className="w-full max-w-6xl rounded bg-white   mx-auto text-gray-800 relative md:text-left">
                <div className="md:flex items-center -mx-10">
                    <div className="w-full md:w-1/3 px-10 mb-10 md:mb-0">
                        
                            <img src={img_url} className="w-full" alt=""/>
                        
                    </div>
                    <div className="w-full md:w-2/3 px-10">
                        <div className="mb-10">
                            <h1 className="font-bold uppercase text-2xl mb-5">{name}</h1>
                            <div className="flex items-center mb-6">
            {(stars)?  <div className="flex items-center">   <svg aria-hidden="true" className="w-5 h-5 text-yellow-400" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><title>Rating star</title><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"></path></svg>
                <div className="ml-2 text-sm font-bold text-gray-900 "> {stars.split(' ')[0]}</div>
            <span className="w-1 h-1 mx-1.5 bg-gray-500 rounded-full dark:bg-gray-400"></span>
            <div  className="text-sm font-medium text-gray-900">{reviewcount} reviews</div></div>
            :''}
          
            
          
        </div>
        <div className="border border-2 border-green-500 grid grid-cols-2 gap-2 rounded-md py-2 px-8 font-sans mb-8">
                <div className="text-green-600">Lowest Price: <span className="text-black font-bold">{minPrice} DH </span></div>
                <div className="text-red-600">Highest Price : <span className="text-black font-bold">{maxPrice} DH  </span></div>
                <div className="text-blue-600">Average Price : <span className="text-black font-bold">{parseInt(averagePrice)} DH  </span></div>
                <div className="text-purple-600">Last Price Change : <span className="text-black font-bold">{lastPriceChange} </span></div>
                
                </div>
                <ul className="list-none">
          <li>Brand: {brand}</li>
          <li>Jumia Express : {fastDelivery?"Yes": "No"} </li>
          <li>Shipped From: {etranger?"Abroad": "Morocco"} </li>
        </ul>
                </div>
                        <div className="grid grid-cols-2">
                            <div className="inline-block align-bottom ">
                                
                                <span className="font-bold text-5xl leading-none align-baseline">{price} DH</span>
                                
                            </div>
                            <div className="my-auto ml-4">
                                <a href={'https://jumia.ma'+href} target="_blank" rel="noreferrer"  className="lg:px-20 md:px-10 px-10  py-2 font-semibold text-white bg-green-700 rounded-full hover:bg-green-800 " > Buy On Jumia</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
     

       
        
        
        
        )
}

}

export default ProductDetails