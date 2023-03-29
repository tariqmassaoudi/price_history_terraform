# -*- coding: utf-8 -*-

import requests
import json
import sys
get_price_history_endpoint = sys.argv[1]
get_product_details_endpoint = sys.argv[4]
get_top_products_endpoint = sys.argv[3]
get_kpi_endpoint = sys.argv[2]
def test_api_endpoint(url, data):
    """
    Tests an API endpoint that uses a POST request and takes body parameters.
    
    Args:
        url (str): The URL of the API endpoint.
        data (dict): The data to be sent in the request body.        
    Returns:
        bool: True if the test passed, False otherwise.
    """
    # convert the data to JSON format
    json_data = json.dumps(data)

    # define the headers for the request
    headers = {
        'Content-Type': 'application/json'
    }

    # make the POST request
    response = requests.post(url, data=json_data, headers=headers)

    # check if the response status code is OK (200)
    if response.status_code != 200:
        return False

    # check if the response content type is JSON
    if response.headers['Content-Type'] != 'application/json':
        return False

    # check if the response data contains the expected result
    # if response.json() != expected_result:
    #     return False

    # if all checks passed, return True
    return True



# define the URLs, data, and expected results for the endpoints you want to test
endpoints = [
    {
        'url': get_price_history_endpoint,
        'data': {
            'prod_id': 'test'
        }
    },
    {
        'url': get_product_details_endpoint,
        'data': {
            'prod_id': 'test'
        }
    },
    {
        'url': get_top_products_endpoint,
        'data': {
            'category': 'test'
        }
    },
    {
        'url': get_kpi_endpoint,
        'data': {
        }
    }
    # add more endpoints here
]

# test each endpoint and print the results
for endpoint in endpoints:
    result = test_api_endpoint(endpoint['url'], endpoint['data'])
    if result:
        print("Endpoint: " + endpoint['url'] +" passed the test \u2705".encode('utf-8').decode('cp1252'))

    else:
        print("Endpoint: " +endpoint['url'] +" failed the test ❌")