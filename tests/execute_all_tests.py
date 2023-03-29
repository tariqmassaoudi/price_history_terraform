# -*- coding: utf-8 -*-
import paramiko
from dotenv import load_dotenv
import os
import subprocess

load_dotenv('.env')
# Set the hostname or IP address of the EC2 instance
hostname = os.getenv('ec2host')
pg_host = os.getenv("PGHOST")
pg_db = os.getenv("PGDB")
pg_password = os.getenv("PGPASSWORD")





# Set the username for SSH login
username = 'ec2-user'

# Set the path to the private key file for SSH authentication
key_filename = '../key.pem'

# Create a SSH client object
client = paramiko.SSHClient()

# Automatically add the server's host key
client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
print("Trying to connect to EC2 , please wait ⌛⌛")
# Connect to the EC2 instance

client.connect(hostname=hostname, username=username, key_filename=key_filename)



print("Succesfully connected to EC2 ✅")
# Execute the command on the remote machine
print("Testing connectivity from EC2 to RDS , please wait ⌛⌛")


stdin, stdout, stderr = client.exec_command('python /home/ec2-user/tests/connectivity_test.py '+pg_host+ ' '+pg_db+' '+pg_password)

# Read the output from the command


exit_status = stdout.channel.recv_exit_status()

error_output = stderr.read().decode()
if error_output:
    print("Failed ❌ connecting to RDS postgres Db here's the error")
    print(error_output)
output = stdout.read().decode()
# Print the output
print(output)






print("Testing scraping script ....")

print("Scraping some products, please wait ⌛⌛")

stdin, stdout, stderr = client.exec_command('python /home/ec2-user/scrape_scripts/scrapeJumia.py 5')
# Wait for the script to finish running and get the exit status
exit_status = stdout.channel.recv_exit_status()

error_output = stderr.read().decode()
if error_output:
    print("Error output from script:")
    print(error_output)

# Read the output from the command
output = stdout.read().decode()

# Print the output
print(output)

print("Now trying to update the database, please wait ⌛⌛")




print("Updating products table ,please wait ⌛⌛")

stdin, stdout, stderr = client.exec_command('python /home/ec2-user/scrape_scripts/updateProducts.py ' + pg_host+' '+pg_db+' '+pg_password)
# Wait for the script to finish running and get the exit status
exit_status = stdout.channel.recv_exit_status()

error_output = stderr.read().decode()
if error_output:
    print("Failed ❌ updating products table here's the error")
    print(error_output)

# Read the output from the command
output = stdout.read().decode()

# Print the output
print(output)




print("Updating prices table, please wait ⌛⌛")

stdin, stdout, stderr = client.exec_command('python /home/ec2-user/scrape_scripts/updatePrices.py '+ pg_host+' '+pg_db+' '+pg_password)
# Wait for the script to finish running and get the exit status
exit_status = stdout.channel.recv_exit_status()

error_output = stderr.read().decode()
if error_output:
    print("Failed ❌ updating prices table here's the error")
    print(error_output)

# Read the output from the command
output = stdout.read().decode()

# Print the output
print(output)



print("Updating products ranking table ,please wait ⌛⌛")

stdin, stdout, stderr = client.exec_command('python /home/ec2-user/scrape_scripts/updateProdRanking.py '+ pg_host+' '+pg_db+' '+pg_password)
# Wait for the script to finish running and get the exit status
exit_status = stdout.channel.recv_exit_status()

error_output = stderr.read().decode()
if error_output:
    print("Failed ❌ updating products ranking table here's the error")
    print(error_output)

# Read the output from the command
output = stdout.read().decode()

# Print the output
print(output)


print("Updating KPI  table ,please wait ⌛⌛")

stdin, stdout, stderr = client.exec_command('python /home/ec2-user/scrape_scripts/updateKpi.py ' + pg_host+' '+pg_db+' '+pg_password)
# Wait for the script to finish running and get the exit status
exit_status = stdout.channel.recv_exit_status()

error_output = stderr.read().decode()
if error_output:
    print("Failed ❌ updating KPI table here's the error")
    print(error_output)

# Read the output from the command
output = stdout.read().decode()

# Print the output
print(output)





print("Now testing Lambda API endpoints ,please wait ⌛⌛")

get_price_history_endpoint = os.getenv("endpoint1")
get_kpi_endpoint = os.getenv("endpoint2")
get_top_products_endpoint = os.getenv("endpoint3")
get_product_details_endpoint = os.getenv("endpoint4")

# Execute a command
# Execute the api.py script
result = subprocess.run(['python', 'api_test.py',get_price_history_endpoint,get_kpi_endpoint,get_top_products_endpoint,get_product_details_endpoint], stdout=subprocess.PIPE)

# Print the result
print(result.stdout.decode('utf-8'))















client.close()
