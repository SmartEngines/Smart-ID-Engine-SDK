import http.server
import http.cookiejar
import io
import socket
import os
import zlib
from http import HTTPStatus

# --- Server setup ---
PORT = 4443
server_address = ('0.0.0.0', PORT)

hostname = socket.gethostname()
local_ip = socket.gethostbyname(hostname)

print(f"Local server running on:")
print(f"http://localhost:{PORT}/samples/idengine_sample_wasm/sample.html")
print(f"http://{local_ip}:{PORT}/samples/idengine_sample_wasm/sample.html\n")

# --- Compression setup ---
COMPRESSIBLE_TYPES = {
    "application/javascript",
    "application/wasm",
    "application/json",
    "application/x-javascript",
    "application/xml",
    "font/eot",
    "font/opentype",
    "image/bmp",
    "image/svg+xml",
    "text/css",
    "text/html",
    "text/javascript",
    "text/plain",
}

def _zlib_producer(fileobj, wbits):
    bufsize = 2 << 17
    compressor = zlib.compressobj(wbits=wbits)
    while chunk := fileobj.read(bufsize):
        yield compressor.compress(chunk)
    yield compressor.flush()

COMPRESSIONS = {
    'gzip': lambda f: _zlib_producer(f, 31),
    'x-gzip': lambda f: _zlib_producer(f, 31),
    'deflate': lambda f: _zlib_producer(f, 15),
}

# --- HTTP Handler ---
class CORSHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    extensions_map = {
        '': 'application/octet-stream',
        '.manifest': 'text/cache-manifest',
        '.html': 'text/html',
        '.png': 'image/png',
        '.jpg': 'image/jpg',
        '.svg': 'image/svg+xml',
        '.css': 'text/css',
        '.js': 'application/javascript',
        '.wasm': 'application/wasm',
        '.json': 'application/json',
        '.xml': 'application/xml',
    }

    def do_GET(self):
        if self.path == '/':
            self.path = 'sample.html'
        super().do_GET()

    def send_head(self):
        path = self.translate_path(self.path)
        if not os.path.exists(path):
            self.send_error(HTTPStatus.NOT_FOUND, "File not found")
            return None

        ctype = self.guess_type(path)
        with open(path, 'rb') as f:
            fs = os.fstat(f.fileno())
            content_length = fs.st_size

            self.send_response(HTTPStatus.OK)
            self.send_header("Content-Type", ctype)

            if ctype not in COMPRESSIBLE_TYPES:
                self.send_header("Content-Length", str(content_length))
                self.end_headers()
                return open(path, 'rb')

            encoding = self._select_compression()
            if encoding:
                self.send_header("Content-Encoding", encoding)
                producer = COMPRESSIONS[encoding]
                self.end_headers()
                return io.BytesIO(b"".join(producer(open(path, 'rb'))))

            self.send_header("Content-Length", str(content_length))
            self.end_headers()
            return open(path, 'rb')

    def _select_compression(self):
        """Determine the best compression method based on Accept-Encoding."""
        accept = self.headers.get("Accept-Encoding", "")
        accepted = {enc.strip().split(";")[0] for enc in accept.split(",")}
        for enc in COMPRESSIONS:
            if enc in accepted or "*" in accepted:
                return enc
        return None

    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Cross-Origin-Opener-Policy', 'same-origin')
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        super().end_headers()


# --- Run server ---
if __name__ == "__main__":
    httpd = http.server.ThreadingHTTPServer(server_address, CORSHTTPRequestHandler)
    print(f"📡 Serving on port {PORT} (HTTP)")
    httpd.serve_forever()