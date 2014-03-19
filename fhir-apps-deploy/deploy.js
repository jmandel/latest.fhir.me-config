var fs = require("fs");
var port = process.env['PORT'] || 8001
var key = process.env['KEY'] || "123";
var express = require("express");

var app = express();
app.use(app.router);

app.all("/fhir-deploy/"+key, function(request, response){
    deploy(function(err){
       response.send("Deployed. Err: " + err);
    });
});

app.listen(port);

var child_process = require('child_process');
var cmd = "/bin/bash update-fhir.sh"
var parts = cmd.split(/\s+/g);

function deploy(cb){
var p = child_process.spawn(parts[0], parts.slice(1));
p.stdout.on('data', function(d){
   console.log(d.toString());
});
p.on('exit', function(code){
var err = null;
if (code) {
    console.log("Finished with errors: " + code);
} else {
    console.log("Finished without errors.");
}
cb(err);
});
};
