#!/usr/bin/env python3

from http.server import HTTPServer, SimpleHTTPRequestHandler
from pathlib import Path
import subprocess
import ssl

def main():
    file_path = Path(__file__).parent / "server.pem"

    if not file_path.exists():
        subprocess.getoutput("yes '' | openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes")

    port = 4443

    httpd = HTTPServer(("localhost", port), SimpleHTTPRequestHandler)
    ssl_context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    ssl_context.load_cert_chain(file_path)
    httpd.socket = ssl_context.wrap_socket(
        httpd.socket,
        server_side=True,
    )

    print(f"Serving on https://localhost:{port}")
    httpd.serve_forever()

if __name__ == "__main__":
    main()
