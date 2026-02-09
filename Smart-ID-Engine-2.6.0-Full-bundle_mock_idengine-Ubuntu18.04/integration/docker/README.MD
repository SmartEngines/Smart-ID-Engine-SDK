# IdEngine server

This docker integration (based on the python wrapper of idengine library) and consist of two scripts: 

- `idengine_server.py` placed inside docker container.
- `client.py` - local side.

Both scripts use sockets to interact with each other.
Default endpoint: `127.0.0.1:53000`

## Quick Start

1. Go to `integration/docker` folder
2. Run `docker build -t idengineserver -f <dockerfile> ./../../` to build image.

   > It will compile python wrapper from SDK and create clean docker image for production.
   > `-t` - name of your new docker image.`-f` - name of the docker file.

3. Run `docker run -p 53000:53000 -d idengineserver` to start server container

   > `-p` - ports to expose.
   > `-d` - demonize docker container.
   > `--cpus` - by default, each container’s access to the host machine’s CPU cycles is unlimited. If the host machine has two CPUs and you set --cpus="1.5", the container is guaranteed at most one and a half of the CPUs. <https://docs.docker.com/config/containers/resource_constraints/#configure-the-default-cfs-scheduler>

4. Run client.py `python3 client.py --signature=YOUR_SIGNATURE_HERE --image_path="./../../testdata/eng_1_photo.png" --mask="*"` 

   > `--signature` - find your signature in `doc/readme.html`.
   > `--image_path` - path to image.
   > `--mask=` - document mask. Find your masks in `doc/bundle_reference.json` or  use `*` to see all supported masks in exception result.

5. Check `result` folder for result.

## Idengine_server.py

This file listen for connections and wait for recognition request.

### Server arguments

- `--bundle_dir` - *required* - path to bundle.
- `--lazy` - idengine lazy mode. Not recommended for server.
- `--concur` - Concurrency. All CPU cores enabled by default.
- `--port` - Server port. [default 53000]

### Server methods

- `async def main()` - Create async sockets.
- `def initEngine()` - init recognition engine with the bundle from the args.
- `async def startRecognition(inputData)` - create the session settings, recognition session and perform the recognition.
- `def RecognitionResult(recog_result)` - parse the output object from the recognition session and prepare it for sending to the client    
- `async def send_result(result, writer)` - send the recognition result to the client.
- `async def handle_echo(reader, writer)` - handle the connection with the client

### log file

Check `error.log` for server exceptions.

## Client.py

This client send settings object to the server and return recognition result in json file.

Example: `python3 client.py -s=YOUR_SIGNATURE_HERE --image_path="./Smart-ID-Engine/testdata/mrz_passport_2.jpg" -mask "*"`

### Client arguments

- `--mask` - Document mask. [default "*"]
- `--mode` - Engine mode. [default "default"]
- `--signature` - *required*. Licencse key.
- `--image_path` - *required*. Path to local image.
- `--output_path` - Output folder for result. [default "./result"]
- `--forensics` - If you want to check forensics data. This option must be enabled with `"common.currentDate": "DD.MM.YYYY"` in `options`forensics data. [default false]
- `--endpoint` - server ip adress
- `--port` - Port of your server endpoint. [default 53000]
- `--log` - Return last 80 lines from error.log

### Client methods

- `async def save_result(data)` - Create folder and save result as json file
- `async def tcp_client(settings)` - Connect to async sockets. Encode data for transmission and Decode for result. Result will be saved in `result` folder.

### Response example

```json
{
   "error":false,
   "response":{
      "docType":"mrz.mrp",
      "fields":{
         "full_mrz":{
            "name":"full_mrz",
            "value":"P<CANMARTIN<<SARAH<<<08",
            "isAccepted":true,
            "attr":{
               "control_digit_check":"passed"
            }
         },
         "mrz_birth_date":{
            "name":"mrz_birth_date",
            "value":"01.01.1985",
            "isAccepted":true,
            "attr":{
               "control_digit_check":"passed"
            }
         },
         "mrz_gender":{
            "name":"mrz_gender",
            "value":"F",
            "isAccepted":true
         }
      }
   }
}
```

### Exception example

```json
{
   "error":true,
   "desc": "exception description"
}
```
