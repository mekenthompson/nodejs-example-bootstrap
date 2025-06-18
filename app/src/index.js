const express = require('express');
const app = express();
const port = process.env.PORT || 3000;

app.get('/', (_req, res) => {
  res.json({message: 'Hello, Buildkite!'});
});

app.listen(port, () => console.log(`App listening on port ${port}`));
module.exports = app;
