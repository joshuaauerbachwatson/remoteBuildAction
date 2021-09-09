#!/usr/bin/env python
"""Executable Python script for remote building
/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
"""
from __future__ import print_function
from sys import stdin
from sys import stdout
from sys import stderr
from os import fdopen
import sys, os, os.path, json, subprocess
import traceback, logging


def build(env, inp):
    for k in env: print("%s=%s" %(k,env[k]))
    print(inp)
    toBuild = "slice:" + inp["toBuild"]
    cmd = ["nim", "project", "deploy", toBuild, "--verbose"]
    print(cmd)
    p = subprocess.Popen(cmd, stdout=subprocess.PIPE,
           stderr=subprocess.PIPE, env=env)
    print("subprocess created")
    (o, e) = p.communicate()
    print("subprocess finished, rc=%d" %(p.returncode))
    if o:
        if isinstance(o, bytes) and not isinstance(o, str):
            print("decoding stdout")
            o = o.decode('utf-8')
        else:
            print("not decoding stdout")
    else:
        print("stdout is empty")
        if e:
            if isinstance(e, bytes) and not isinstance(e, str):
                print("decoding stderr")
                e = e.decode('utf-8')
            print("contents of stderr:")
            print(ascii(e))
            o = json.dumps({ "error": "remote nim terminated unexpectedly with error: see activation record for details"}) + "\n"
        else:
            print("stderr is empty")
            o = json.dumps({ "error": "remote nim terminated with unexplained error"}) + "\n"
    return o

def main(env, args):
    env["PATH"] = "/opt/java/openjdk/bin:/bin:/usr/bin:/usr/local/bin:/usr/local/go/bin"
    env["OW_COMPILER"] = "/bin/compile"
    env["HOME"] = "/"
    env["WORKDIR"] = os.getcwd()
    print("calling build")
    res = build(env, args)
    print("build returned")
    return res

if __name__ == "__main__":
    env = os.environ
    out = fdopen(3, "wb")
    if os.getenv("__OW_WAIT_FOR_ACK", "") != "":
        out.write(json.dumps({"ok": True}, ensure_ascii=False).encode('utf-8'))
        out.write(b'\n')
        out.flush()
    while True:
        line = stdin.readline()
        if not line: break
        args = json.loads(line)
        payload = {}
        for key in args:
            if key == "value":
                payload = args["value"]
            else:
                env["__OW_%s" % key.upper()]= args[key]
        res = {}
        try:
            res = main(env, payload)
        except Exception as ex:
            print("exception in main")
            print(traceback.format_exc(), file=stderr)
            res = json.dumps({ "error": "exception in main: see activation record for details"}) + "\n"
        out.write(res.encode('utf-8'))
        stdout.flush()
        stderr.flush()
        out.flush()
