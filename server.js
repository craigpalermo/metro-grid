var express = require("express");
var request = require("request");
var app = express();

// config variables
var wmataApiUrl = "https://api.wmata.com/StationPrediction.svc/json/GetPrediction/All",
    apiKey = "69f3f1d6d41c41289c0b2f125dbdcbc1"; 


// app config
app.use(express.static(__dirname + '/build'));


// makes request for prediction times to wmata api and returns
// the json response
app.get("/GetPrediction", function (req, res) {
    var options = {
        url: wmataApiUrl,
        headers: {
            "api_key": apiKey
        }
    };

    request(options, function (error, response, body) {
        if (!error && response.statusCode === 200) {
            res.send(body);
        } else {
            console.log(body);
        }
    });
});


// returns home page
app.get("/", function (req, res) {
    res.send("index.html");
});


// start listening server
var server = app.listen(3000, function () {
    var host = server.address().address;
    var port = server.address().port;

    console.log('Server listening at http://%s:%s', host, port);
});
