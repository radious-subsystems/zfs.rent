#!/usr/bin/env -S nim r -d:ssl

import strformat
import strutils
import httpclient
const prefix = "https://zfs.rent/api/v0"

const VERSION        = splitLines(staticRead "./VERSION")[0]
const BUILD_DATE     = staticExec "date"
const GIT_COMMIT_REF = staticExec "git rev-parse --short HEAD"

echo &"zz {VERSION}-{GIT_COMMIT_REF}"
echo &"build date: {BUILD_DATE}\n"

try:
  var client = newHttpClient()
  echo "Requesting daily bandwidth..."
  echo client.getContent(prefix & "/user/bandwidth-daily")
except:
  let e = getCurrentException()
  echo fmt"{e.name} :: {e.msg}"
  quit(QuitFailure)
