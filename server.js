const corsAnywhere = require("cors-anywhere");

const host = "localhost";
const port = 8080;

corsAnywhere.createServer().listen(port, host, () => {
  console.log(`CORS Anywhere running on ${host}:${port}`);
});
