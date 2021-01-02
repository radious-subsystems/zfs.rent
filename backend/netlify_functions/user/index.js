const fs = require("fs");

exports.handler = function (event, context) {
  const parts   = event.path.split('/');
  const subPath = parts[parts.length-1];

  // subpath not implemented --> 404
  if (!fs.existsSync(subPath))
    return {statusCode: 404, body: '/user not implemented'};

  // otherwise, include and execute the subpath
  return (require(`./${subPath}`)).handler(event, context);
}
