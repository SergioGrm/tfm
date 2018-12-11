import shlex, subprocess
import json

class App:

    def __init__(self):
        print ("Init...")

    def run_curl(self, fid):
        cmd = """curl -k 'https://138.100.77.240/share.cgi'
                -H 'Accept: */*'
                -H 'Accept-Language: en-US,en;q=0.5'
                --compressed
                -H 'Referer: https://138.100.77.240/share.cgi?ssid=FID&fid=FID'
                -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8'
                -H 'X-Requested-With: XMLHttpRequest'
                -H 'Connection: keep-alive'
                --data 'func=get_list&ssid=FID&sort=natural&dir=ASC&ep='"""
        command = cmd.replace("FID", fid)
        args = shlex.split(command) # command split by spaces
        p = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.PIPE) # call curl
        std_tuple = p.communicate() # Result are type bytes in a tuple: (stdoutdata, stderrdata)
        data_json = std_tuple[0].decode("utf8").replace("'", '"') # convert into string
        data = json.loads(data_json) # json parse
        # Finally this is the epoch and can be used to update if distinct from the one on disk
        epoch = data.get("datas")[0].get("epochmt")
        print( epoch )


app = App()

app.run_curl("0ja446E")

print("Exiting...")
