exports.handler = function (event, context) {
  return {
    statusCode: 200,
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify({event, context})
  };
}
