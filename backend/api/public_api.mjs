export function init(app) {
  app.get("/v0/status/hvm/1", hypervisor_1_status);
}

function hypervisor_1_status(req, res) {
  res.header("Content-Type", "application/json");
  res.send(JSON.stringify({abc: 1234}));
}
