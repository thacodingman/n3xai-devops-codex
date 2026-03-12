#!/bin/bash

echo "Installing MCP generator..."

GEN=/opt/n3xai/mcp-generator

mkdir -p $GEN

cat <<'EOF' > $GEN/create-mcp-server
#!/bin/bash

read -p "Server name: " NAME

BASE="/root/mcp/servers/$NAME"

mkdir -p $BASE

cat <<PY > $BASE/server.py
import sys
import json
import logging

logging.basicConfig(
    filename="/root/mcp/logs/${NAME}.log",
    level=logging.INFO
)

def handle(req):

    cmd = req.get("command")

    if cmd == "ping":
        return {"status":"ok"}

    return {"error":"unknown command"}

def main():

    for line in sys.stdin:

        req=json.loads(line)

        res=handle(req)

        print(json.dumps(res), flush=True)

if __name__ == "__main__":
    main()
PY

echo "MCP server created at $BASE"
EOF

chmod +x $GEN/create-mcp-server

ln -s $GEN/create-mcp-server /usr/local/bin/create-mcp-server

echo "Generator installed."