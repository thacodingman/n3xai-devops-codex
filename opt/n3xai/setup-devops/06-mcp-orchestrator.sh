#!/bin/bash

echo "Installing MCP orchestrator..."

ORCH=/opt/n3xai/mcp-orchestrator

mkdir -p $ORCH

cat <<'EOF' > $ORCH/orchestrator.py
import os
import subprocess
import time

SERVERS="/root/mcp/servers"
LOG="/root/mcp/logs/orchestrator.log"

processes={}

def discover():

    servers=[]

    for root,dirs,files in os.walk(SERVERS):

        for f in files:

            if f=="server.py":

                servers.append(os.path.join(root,f))

    return servers


def start(server):

    name=server.split("/")[-2]

    print("Starting",name)

    p=subprocess.Popen(
        ["python3",server],
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE
    )

    processes[name]=p


def supervise():

    while True:

        for name,p in list(processes.items()):

            if p.poll() is not None:

                print("Restarting",name)

                start(f"/root/mcp/servers/{name}/server.py")

        time.sleep(5)


def main():

    servers=discover()

    for s in servers:
        start(s)

    supervise()

if __name__=="__main__":
    main()
EOF

chmod +x $ORCH/orchestrator.py

ln -s $ORCH/orchestrator.py /usr/local/bin/mcp-orchestrator

echo "Orchestrator installed."