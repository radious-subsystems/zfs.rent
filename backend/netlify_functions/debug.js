exports.handler = function (event, context) {
  console.log(event);

  return {
    statusCode: 200,
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify(event)
  };
}
