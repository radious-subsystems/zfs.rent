const {pg_netlify_functions_log} = require("./lib/helper.js"); 

exports.handler = async function (event, context) {
  await pg_netlify_functions_log(event, context);
  console.log(event);

  return {
    statusCode: 200,
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify(event)
  };
}
