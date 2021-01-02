exports.handler = function (event, context) {
  let el = event.path.split('/');
  const subPath = el[el.length-1];

  switch (subPath) {
    case 'world':
      const world = require('./world.js');
      return world.handler(event, context);
  }

  return {statusCode: 200, body: '/api/v0/hello'};
}
