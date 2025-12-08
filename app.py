import _thread as thread
import http.server
import os
import subprocess
import time

from watchdog.events import FileSystemEvent, FileSystemEventHandler
from watchdog.observers import Observer

# ---

proc = subprocess.run(["nix", "build"])

if proc.returncode != 0:
    raise Exception("`nix build` returned a non-zero exit code")

# ---

ready = False


class Server(http.server.ThreadingHTTPServer):
    def finish_request(self, request, client_address):
        self.RequestHandlerClass(request, client_address, self, directory="result")


class Handler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if ready:
            http.server.SimpleHTTPRequestHandler.do_GET(self)
        else:
            self.wfile.write(b"building")

    def end_headers(self):
        self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        self.send_header("Pragma", "no-cache")
        self.send_header("Expires", "0")

        http.server.SimpleHTTPRequestHandler.end_headers(self)


def start_server():
    http.server.test(ServerClass=Server, HandlerClass=Handler, port=3080)


thread.start_new_thread(start_server, ())

# ---


class EventHandler(FileSystemEventHandler):
    def __init__(self):
        self.mark_clean()

    def on_created(self, _event: FileSystemEvent):
        self.mark_dirty()

    def on_deleted(self, _event: FileSystemEvent):
        self.mark_dirty()

    def on_modified(self, _event: FileSystemEvent):
        self.mark_dirty()

    def on_moved(self, _event: FileSystemEvent):
        self.mark_dirty()

    def mark_clean(self):
        global ready

        self.dirty = True
        ready = False

    def mark_dirty(self):
        global ready

        self.dirty = True
        ready = False


event_handler = EventHandler()

observer = Observer()
observer.schedule(event_handler, "src", recursive=True)
observer.start()

try:
    while True:
        time.sleep(1)

        if event_handler.dirty:
            event_handler.dirty = False
            proc = subprocess.run(["nix", "build"])
            ready = True
finally:
    observer.stop()
    observer.join()
