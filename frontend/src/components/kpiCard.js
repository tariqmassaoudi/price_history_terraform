import React from "react"

const KpiCard = ({name,value,loading=true}) => {
    if(loading){
        return (
            <div className="bg-white  rounded-lg shadow   sm:flex-row gap-5 select-none mb-2 px-2 mb-4 w-full sm:w-1/3 sm:my-8">
           
            <div className="flex flex-col flex-1 gap-5  py-10">
              <div className="flex flex-1 flex-col gap-3">
                <div className="bg-gray-200 w-full animate-pulse h-14 rounded-2xl" ></div>

              </div>
              <div className="mt-auto flex gap-3">
  
        
                <div className="bg-gray-200 w-40 h-12 animate-pulse rounded-full mx-auto" ></div>
              </div>
            </div>
      </div>
        )
    }else{
        return (     <div className="inline-block align-bottom bg-white rounded-lg text-left overflow-hidden shadow transform transition-all mb-4 w-full sm:w-1/3 sm:my-8">
        <div className="bg-white p-5">
            <div className="sm:flex sm:items-center">
                <div className="sm:mt-0 mx-auto">
                    <h3 className="text-sm leading-6 font-medium  h-6 sm:h-14 md:h-12 lg:h-8 text-gray-400 text-center">{name}</h3>
                    <p className="text-3xl font-bold text-black text-center">{value}</p>
                </div>
                
            </div>
        </div>
    </div> );
    }

}
 
export default KpiCard;